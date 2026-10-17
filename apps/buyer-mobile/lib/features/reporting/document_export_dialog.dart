import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:share_plus/share_plus.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/form_dialog.dart';
import '../../design_system/date_time.dart';
import '../map_discovery/discovery_models.dart';
import '../notifications/notifications_repository.dart';

Future<void> showBuyerDocumentExports({
  required BuildContext context,
  required NotificationsRepository repository,
  required String resourceId,
  required List<api.DocumentExportInputTypeEnum> types,
}) => showBuyerFormDialog<void>(
  context: context,
  builder: (_) => BuyerDocumentExportDialog(
    repository: repository,
    resourceId: resourceId,
    types: types,
  ),
);

class BuyerDocumentExportButton extends StatelessWidget {
  const BuyerDocumentExportButton({
    super.key,
    required this.repository,
    required this.resourceId,
    required this.types,
  });
  final NotificationsRepository repository;
  final String resourceId;
  final List<api.DocumentExportInputTypeEnum> types;
  @override
  Widget build(BuildContext context) => BuyerHeaderIconButton(
    icon: Icons.picture_as_pdf_outlined,
    tooltip: 'Export PDF',
    onPressed: () => showBuyerDocumentExports(
      context: context,
      repository: repository,
      resourceId: resourceId,
      types: types,
    ),
  );
}

class BuyerDocumentExportDialog extends StatefulWidget {
  const BuyerDocumentExportDialog({
    super.key,
    required this.repository,
    required this.resourceId,
    required this.types,
  });
  final NotificationsRepository repository;
  final String resourceId;
  final List<api.DocumentExportInputTypeEnum> types;
  @override
  State<BuyerDocumentExportDialog> createState() =>
      _BuyerDocumentExportDialogState();
}

class _BuyerDocumentExportDialogState extends State<BuyerDocumentExportDialog>
    with WidgetsBindingObserver {
  final _purpose = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _keys = <String, String>{};
  late api.DocumentExportInputTypeEnum _type;
  List<api.DocumentExport> _items = [];
  String? _error, _message;
  bool _busy = false, _loading = false, _more = false;
  int _page = 1, _generation = 0;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _type = widget.types.first;
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _poll?.cancel();
    _purpose.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _poll?.cancel();
    if (state == AppLifecycleState.resumed && !_busy) unawaited(_load());
  }

  String _failure(Object e) => e is DiscoveryFailure
      ? e.message
      : 'This request could not be completed. Check your connection and retry.';
  String _label(String value) => value.toLowerCase().replaceAll('_', ' ');
  bool _expired(api.DocumentExport item) =>
      item.state == 'EXPIRED' ||
      (item.expiresAt != null &&
          (DateTime.tryParse(item.expiresAt!)?.isBefore(DateTime.now()) ??
              false));
  void _schedule() {
    _poll?.cancel();
    if (_error == null &&
        !_busy &&
        _items.any((item) => item.state == 'QUEUED') &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      _poll = Timer(const Duration(seconds: 5), () => unawaited(_load()));
    }
  }

  Future<void> _load([int page = 1]) async {
    if (_loading) return;
    final generation = _generation;
    setState(() => _loading = true);
    try {
      final result = await widget.repository.reports(
        page: page,
        type: _type.name,
        resourceId: widget.resourceId,
        format: 'PDF',
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _items = page == 1 ? result.data.toList() : [..._items, ...result.data];
        _page = page;
        _more = result.meta['has_more']?.value == true;
      });
    } catch (e) {
      if (mounted && generation == _generation) {
        setState(() {
          _error = _failure(e);
          if (e is DiscoveryFailure &&
              [
                DiscoveryFailureKind.forbidden,
                DiscoveryFailureKind.sessionExpired,
              ].contains(e.kind)) {
            _items.clear();
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        _schedule();
      }
    }
  }

  Future<void> _run(Future<void> Function() work) async {
    _poll?.cancel();
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });
    try {
      await work();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _failure(e);
          if (e is DiscoveryFailure &&
              [
                DiscoveryFailureKind.forbidden,
                DiscoveryFailureKind.sessionExpired,
              ].contains(e.kind)) {
            _items.clear();
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _schedule();
      }
    }
  }

  Future<void> _generate() async {
    if (!_form.currentState!.validate()) return;
    await _run(() async {
      final fingerprint = '${_type.name}/${_purpose.text.trim()}';
      final key = _keys.putIfAbsent(fingerprint, widget.repository.newKey);
      final result = await widget.repository.requestReport(
        widget.resourceId,
        _type,
        api.DocumentExportInputFormatEnum.PDF,
        _purpose.text.trim(),
        key,
      );
      _keys.remove(fingerprint);
      if (mounted) {
        setState(
          () => _items = [
            result,
            ..._items.where((item) => item.id != result.id),
          ],
        );
      }
      await _load();
    });
  }

  Future<Uint8List> _bytes(api.DocumentExport item) async {
    final bytes = await widget.repository.download(item.id);
    if (bytes.length < 5 || String.fromCharCodes(bytes.take(5)) != '%PDF-') {
      throw StateError('Invalid PDF');
    }
    return bytes;
  }

  String _filename(api.DocumentExport item) =>
      'materyalph-${item.type.toLowerCase()}-${item.id}.pdf';
  Future<void> _save(api.DocumentExport item) => _run(() async {
    final bytes = await _bytes(item);
    if (!mounted) return;
    final saved = await FilePicker.saveFile(
      fileName: _filename(item),
      bytes: bytes,
      mimeType: 'application/pdf',
      dialogTitle: 'Save PDF',
    );
    if (mounted && saved != null) setState(() => _message = 'PDF saved.');
    await _load();
  });
  Future<void> _share(api.DocumentExport item) => _run(() async {
    final bytes = await _bytes(item);
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'application/pdf')],
        fileNameOverrides: [_filename(item)],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
    await _load();
  });
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Documents & exports',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close documents and exports',
                    onPressed: _busy ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Private PDF snapshots expire after 24 hours. Downloads are recorded. MateryalPH documents are not tax invoices.',
                      ),
                      if (_busy || _loading) const LinearProgressIndicator(),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            _error!,
                            semanticsLabel: 'Error: $_error',
                          ),
                        ),
                      if (_message != null) Text(_message!),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<api.DocumentExportInputTypeEnum>(
                        initialValue: _type,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Document',
                        ),
                        items: widget.types
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(_label(type.name)),
                              ),
                            )
                            .toList(),
                        onChanged: _busy || _loading
                            ? null
                            : (type) {
                                if (type == null) return;
                                _generation++;
                                setState(() {
                                  _type = type;
                                  _items = [];
                                  _error = null;
                                  _more = false;
                                });
                                unawaited(_load());
                              },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _purpose,
                        enabled: !_busy,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          labelText: 'Purpose',
                          hintText: 'Describe why you need this document',
                        ),
                        validator: (value) => (value?.trim().length ?? 0) < 10
                            ? 'Describe your purpose in at least 10 characters.'
                            : null,
                      ),
                      FilledButton(
                        onPressed: _busy ? null : _generate,
                        child: const Text('Generate PDF'),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Recent exports',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: _busy || _loading
                                ? null
                                : () {
                                    setState(() => _error = null);
                                    unawaited(_load());
                                  },
                            child: const Text('Refresh status'),
                          ),
                        ],
                      ),
                      if (!_loading && _items.isEmpty)
                        const Text('No exports for this document yet.'),
                      for (final item in _items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_label(item.type)} · ${_expired(item) ? 'EXPIRED' : item.state}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(item.purpose),
                              Text(
                                'Requested: ${formatManilaIsoDateTime(item.createdAt)}',
                              ),
                              Text(
                                'Expires: ${item.expiresAt == null ? '24 hours after generation' : formatManilaIsoDateTime(item.expiresAt!)}',
                              ),
                              if (item.state == 'QUEUED')
                                const Text(
                                  'Your PDF is generating. Status updates automatically.',
                                ),
                              if (item.state == 'FAILED')
                                const Text(
                                  'Generation failed. Generate a new PDF above to try again.',
                                ),
                              if (_expired(item))
                                const Text(
                                  'This download has expired. Generate a new PDF above.',
                                ),
                              if (item.state == 'READY' && !_expired(item))
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    FilledButton.icon(
                                      onPressed: _busy
                                          ? null
                                          : () => _save(item),
                                      icon: const Icon(Icons.download_outlined),
                                      label: const Text('Download PDF'),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: _busy
                                          ? null
                                          : () => _share(item),
                                      icon: const Icon(Icons.share_outlined),
                                      label: const Text('Share'),
                                    ),
                                  ],
                                ),
                              const Divider(),
                            ],
                          ),
                        ),
                      if (_more)
                        TextButton(
                          onPressed: _busy || _loading
                              ? null
                              : () => _load(_page + 1),
                          child: const Text('Load more exports'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
