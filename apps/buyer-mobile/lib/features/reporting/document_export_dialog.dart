import '../../design_system/components/async_state.dart';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../design_system/components/buyer_app_bar.dart';
import '../map_discovery/discovery_models.dart';
import '../notifications/notifications_repository.dart';

String _documentLabel(api.DocumentExportInputTypeEnum type) {
  final text = type.name.toLowerCase().replaceAll('_', ' ');
  return '${text[0].toUpperCase()}${text.substring(1)}';
}

/// Downloads issued order documents or requests a contextual project report.
class BuyerDocumentExportButton extends StatefulWidget {
  const BuyerDocumentExportButton({
    super.key,
    required this.repository,
    required this.resourceId,
    required this.types,
    this.label,
  });

  final String? label;
  final NotificationsRepository repository;
  final String resourceId;
  final List<api.DocumentExportInputTypeEnum> types;

  @override
  State<BuyerDocumentExportButton> createState() =>
      _BuyerDocumentExportButtonState();
}

class _BuyerDocumentExportButtonState extends State<BuyerDocumentExportButton> {
  final _keys = <api.DocumentExportInputTypeEnum, String>{};
  final _requested = <api.DocumentExportInputTypeEnum, api.DocumentExport>{};
  api.DocumentExportInputTypeEnum? _busy;
  int _generation = 0;
  int? _accessVersion;
  Timer? _poll;
  Completer<void>? _waiting;

  void _stopWaiting() {
    _poll?.cancel();
    final waiting = _waiting;
    if (waiting != null && !waiting.isCompleted) waiting.complete();
    _waiting = null;
  }

  @override
  void didUpdateWidget(covariant BuyerDocumentExportButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.resourceId != widget.resourceId ||
        !listEquals(oldWidget.types, widget.types)) {
      _generation++;
      _stopWaiting();
      _busy = null;
      _keys.clear();
      _requested.clear();
    }
  }

  @override
  void dispose() {
    _generation++;
    _stopWaiting();
    super.dispose();
  }

  Future<void> _wait() {
    final waiting = Completer<void>();
    _waiting = waiting;
    _poll = Timer(const Duration(seconds: 5), () {
      if (!waiting.isCompleted) waiting.complete();
      if (identical(_waiting, waiting)) _waiting = null;
    });
    return waiting.future;
  }

  void _notice(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _savePdf(
    Uint8List bytes,
    String filename,
    bool Function() isCurrent,
  ) async {
    if (!isCurrent()) return false;
    if (bytes.length < 5 || String.fromCharCodes(bytes.take(5)) != '%PDF-') {
      throw const _ExportFailure(
        'The PDF could not be verified. Try downloading it again.',
      );
    }
    final saved = await FilePicker.saveFile(
      fileName: filename,
      bytes: bytes,
      mimeType: 'application/pdf',
      dialogTitle: 'Save PDF',
    );
    return saved != null;
  }

  Future<void> _downloadIssuedOrderDocument(
    api.DocumentExportInputTypeEnum type,
    bool Function() isCurrent,
  ) async {
    final orderId = widget.resourceId;
    final repository = widget.repository;
    for (var attempt = 0; attempt < 60 && isCurrent(); attempt++) {
      final documents = await repository.orderDocuments(orderId);
      if (!isCurrent()) return;
      final matches = documents.where(
        (document) => document.kind.name == type.name,
      );
      final document = matches.isEmpty ? null : matches.first;
      if (document?.availability == 'READY' && document?.downloadUrl != null) {
        final bytes = await repository.downloadOrderDocument(
          orderId,
          type.name,
        );
        final saved = await _savePdf(
          bytes,
          'materyalph-${type.name.toLowerCase()}-$orderId.pdf',
          isCurrent,
        );
        if (isCurrent()) {
          _notice(
            saved
                ? 'PDF saved.'
                : 'Save cancelled. Tap Download to save this PDF.',
          );
        }
        return;
      }
      if (document?.availability != 'QUEUED') {
        throw _ExportFailure(
          document?.availability == 'AFTER_ACCEPTANCE'
              ? 'The Purchase Order will be available after the final order is accepted.'
              : 'This document is currently unavailable. Refresh its status or contact support.',
        );
      }
      await _wait();
    }
    if (isCurrent()) {
      _notice(
        'The document is still being prepared. Try downloading it again shortly.',
      );
    }
  }

  Future<void> _download(api.DocumentExportInputTypeEnum type) async {
    if (_busy != null) return;
    final generation = _generation;
    final repository = widget.repository;
    final accessVersion = repository.inbox.accessVersion;
    if (_accessVersion != accessVersion) {
      _keys.clear();
      _requested.clear();
      _accessVersion = accessVersion;
    }
    bool isCurrent() =>
        mounted &&
        generation == _generation &&
        repository.inbox.accessVersion == accessVersion;
    setState(() => _busy = type);
    _notice('Preparing ${_documentLabel(type).toLowerCase()} PDF…');
    try {
      if (type == api.DocumentExportInputTypeEnum.PURCHASE_ORDER) {
        await _downloadIssuedOrderDocument(type, isCurrent);
        return;
      }
      final key = _keys.putIfAbsent(type, repository.newKey);
      var item =
          _requested[type] ??
          await repository.requestReport(
            widget.resourceId,
            type,
            api.DocumentExportInputFormatEnum.PDF,
            '${_documentLabel(type)} PDF export from buyer record.',
            key,
          );
      if (!isCurrent()) return;
      _requested[type] = item;
      for (var attempt = 0; attempt <= 60 && isCurrent(); attempt++) {
        if (item.state == 'READY') {
          final expiry = DateTime.tryParse(item.expiresAt ?? '');
          if (expiry != null && !expiry.isAfter(DateTime.now())) {
            throw const _ExportFailure(
              'This export has expired. Try exporting a new copy.',
            );
          }
          final bytes = await repository.download(item.id);
          if (!isCurrent()) return;
          final saved = await _savePdf(
            bytes,
            'materyalph-${item.type.toLowerCase()}-${item.id}.pdf',
            isCurrent,
          );
          if (!isCurrent()) return;
          if (saved) {
            _keys.remove(type);
            _requested.remove(type);
          }
          _notice(
            !saved
                ? 'Save cancelled. Tap Export to save this PDF.'
                : 'PDF saved.',
          );
          return;
        }
        if (item.state != 'QUEUED') {
          throw _ExportFailure(
            item.state == 'REVOKED'
                ? 'Access to this export has been revoked.'
                : 'This export could not be generated. Try exporting a new copy.',
          );
        }
        if (attempt == 60) break;
        if (attempt > 0) await _wait();
        if (!isCurrent()) return;
        var page = 1;
        api.DocumentExport? found;
        do {
          final result = await repository.reports(
            page: page,
            type: type.name,
            resourceId: widget.resourceId,
            format: 'PDF',
          );
          if (!isCurrent()) return;
          for (final candidate in result.data) {
            if (candidate.id == item.id) {
              found = candidate;
              break;
            }
          }
          if (found != null || result.meta['has_more']?.value != true) break;
          page++;
        } while (isCurrent());
        if (found == null) {
          throw const _ExportFailure(
            'This export is no longer available to your account.',
          );
        }
        item = found;
        _requested[type] = item;
      }
      if (isCurrent()) {
        _notice(
          'The export is still generating. Tap Export again to continue the download.',
        );
      }
    } catch (error) {
      if (!isCurrent()) return;
      if (error is _ExportFailure ||
          (error is DiscoveryFailure &&
              [
                'EXPORT_EXPIRED',
                'EXPORT_FILE_UNAVAILABLE',
                'EXPORT_ACCESS_REVOKED',
              ].contains(error.code))) {
        _keys.remove(type);
        _requested.remove(type);
      }
      _notice(
        error is DiscoveryFailure
            ? error.message
            : error is _ExportFailure
            ? error.message
            : 'This download could not be completed. Check your connection and retry.',
      );
    } finally {
      if (mounted && generation == _generation) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      for (final type in widget.types)
        widget.label == null
            ? _busy == type
                  ? const SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: BuyerLoadingIndicator(
                            strokeWidth: 2,
                            semanticsLabel: 'Preparing PDF download',
                          ),
                        ),
                      ),
                    )
                  : BuyerHeaderIconButton(
                      icon:
                          type == api.DocumentExportInputTypeEnum.BUDGET_REPORT
                          ? Icons.table_chart_outlined
                          : Icons.picture_as_pdf_outlined,
                      tooltip:
                          'Export ${_documentLabel(type).toLowerCase()} PDF',
                      onPressed: _busy == null ? () => _download(type) : null,
                    )
            : OutlinedButton.icon(
                icon: const Icon(Icons.download_outlined),
                label: Text(
                  _busy == type
                      ? 'Preparing download…'
                      : widget.types.length == 1
                      ? widget.label!
                      : '${_documentLabel(type)} PDF',
                ),
                onPressed: _busy == null ? () => _download(type) : null,
              ),
    ];
    return widget.label == null
        ? Row(mainAxisSize: MainAxisSize.min, children: actions)
        : Wrap(spacing: 8, runSpacing: 8, children: actions);
  }
}

class _ExportFailure implements Exception {
  const _ExportFailure(this.message);
  final String message;
}
