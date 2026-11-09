import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph/features/reporting/document_export_dialog.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

api.DocumentExport report(String state, {String id = 'export-1'}) =>
    api.DocumentExport(
      (b) => b
        ..id = id
        ..type = 'PURCHASE_ORDER'
        ..format = 'PDF'
        ..state = state
        ..purpose = 'Purchase order PDF export from buyer record.'
        ..createdAt = '2026-11-04T00:00:00Z'
        ..filters.clear()
        ..sourceVersions.clear()
        ..accessRecord.clear(),
    );

class ExportRepository extends NotificationsRepository {
  ExportRepository() : super(api.MateryalphApiClient(dio: Dio()), () async {});

  String state = 'QUEUED';
  final requests =
      <(String, api.DocumentExportInputTypeEnum, String, String)>[];
  final downloads = <String>[];
  final pages = <int>[];
  int orderReads = 0;
  Completer<api.DocumentExport>? pending;
  bool invalid = false;
  bool failRequest = false;

  @override
  String newKey() => 'synthetic-export-key-${requests.length}';

  @override
  Future<api.DocumentExport> requestReport(
    String id,
    api.DocumentExportInputTypeEnum type,
    api.DocumentExportInputFormatEnum format,
    String purpose,
    String key,
  ) async {
    requests.add((id, type, purpose, key));
    if (failRequest) throw StateError('offline');
    return pending == null ? report(state) : pending!.future;
  }

  @override
  Future<api.ListDocumentExports200Response> reports({
    int page = 1,
    String? type,
    String? resourceId,
    String? format,
  }) async {
    pages.add(page);
    return api.ListDocumentExports200Response(
      (b) => b
        ..data.add(report(state))
        ..meta.clear()
        ..errors.clear(),
    );
  }

  @override
  Future<Uint8List> download(String id) async {
    downloads.add(id);
    return Uint8List.fromList(
      (invalid ? '<html>error</html>' : '%PDF-1.7').codeUnits,
    );
  }

  @override
  Future<List<api.PlatformDocumentRef>> orderDocuments(String orderId) async {
    orderReads++;
    return [
      for (final kind in ['PURCHASE_ORDER'])
        api.standardSerializers.deserializeWith(
          api.PlatformDocumentRef.serializer,
          {
            'kind': kind,
            'title': 'MateryalPH document',
            'not_tax_invoice': true,
            'label': 'Not a tax invoice',
            'availability': state,
            'download_url': state == 'READY' ? '/authenticated-download' : null,
          },
        )!,
    ];
  }

  @override
  Future<Uint8List> downloadOrderDocument(String orderId, String kind) =>
      download('$kind/$orderId');
}

class SavePicker extends FilePickerPlatform {
  final filenames = <String>[];
  final data = <Uint8List>[];
  Uri? destination = Uri.parse('file:///synthetic-download.pdf');

  @override
  Future<Uri?> saveFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? dialogTitle,
    String? initialDirectory,
    Function(FilePickerStatus)? onFileSaving,
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    expect(mimeType, 'application/pdf');
    filenames.add(fileName);
    data.add(bytes);
    return destination;
  }
}

void main() {
  late ExportRepository repository;
  late SavePicker picker;
  late FilePickerPlatform originalPicker;

  setUp(() {
    repository = ExportRepository();
    picker = SavePicker();
    originalPicker = FilePickerPlatform.instance;
    FilePickerPlatform.instance = picker;
  });
  tearDown(() {
    repository.dispose();
    FilePickerPlatform.instance = originalPicker;
  });

  Widget host({
    String resourceId = 'order-id',
    List<api.DocumentExportInputTypeEnum> types = const [
      api.DocumentExportInputTypeEnum.PURCHASE_ORDER,
    ],
    String? label,
  }) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        actions: [
          BuyerDocumentExportButton(
            repository: repository,
            resourceId: resourceId,
            types: types,
            label: label,
          ),
        ],
      ),
    ),
  );

  testWidgets(
    'one tap polls and saves the issued PDF without requesting an export',
    (tester) async {
      await tester.pumpWidget(host());
      await tester.tap(find.byTooltip('Export purchase order PDF'));
      await tester.pump();
      expect(repository.requests, isEmpty);
      expect(repository.orderReads, 1);
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(picker.filenames, isEmpty);
      repository.state = 'READY';
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(repository.downloads, ['PURCHASE_ORDER/order-id']);
      expect(picker.filenames, ['materyalph-purchase_order-order-id.pdf']);
      expect(String.fromCharCodes(picker.data.single), '%PDF-1.7');
    },
  );

  testWidgets('each issued document has a direct header action at 320px', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    repository.state = 'READY';
    await tester.pumpWidget(
      host(types: [api.DocumentExportInputTypeEnum.PURCHASE_ORDER]),
    );
    expect(find.byTooltip('Export purchase order PDF'), findsOneWidget);
    expect(find.byTooltip('Export payment confirmation PDF'), findsNothing);
    await tester.tap(find.byTooltip('Export purchase order PDF'));
    await tester.pumpAndSettle();
    expect(repository.requests, isEmpty);
    expect(repository.downloads, ['PURCHASE_ORDER/order-id']);
    expect(picker.filenames, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  for (final state in ['FAILED', 'REVOKED', 'EXPIRED']) {
    testWidgets(
      'project report $state never saves and retry requests a new export',
      (tester) async {
        repository.state = state;
        await tester.pumpWidget(
          host(types: [api.DocumentExportInputTypeEnum.PROJECT_SUMMARY]),
        );
        await tester.tap(find.byTooltip('Export project summary PDF'));
        await tester.pumpAndSettle();
        expect(picker.filenames, isEmpty);
        repository.state = 'READY';
        await tester.tap(find.byTooltip('Export project summary PDF'));
        await tester.pumpAndSettle();
        expect(repository.requests, hasLength(2));
        expect(picker.filenames, hasLength(1));
      },
    );
  }

  testWidgets('invalid PDF bytes never reach the save picker', (tester) async {
    repository.state = 'READY';
    repository.invalid = true;
    await tester.pumpWidget(host());
    await tester.tap(find.byTooltip('Export purchase order PDF'));
    await tester.pumpAndSettle();
    expect(picker.filenames, isEmpty);
    expect(
      find.text('The PDF could not be verified. Try downloading it again.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'cancelled saving downloads the same issued file on the next tap',
    (tester) async {
      repository.state = 'READY';
      picker.destination = null;
      await tester.pumpWidget(host());
      await tester.tap(find.byTooltip('Export purchase order PDF'));
      await tester.pumpAndSettle();
      picker.destination = Uri.parse('file:///synthetic-download.pdf');
      await tester.tap(find.byTooltip('Export purchase order PDF'));
      await tester.pumpAndSettle();
      expect(repository.requests, isEmpty);
      expect(picker.filenames, hasLength(2));
      expect(picker.filenames.first, picker.filenames.last);
    },
  );

  testWidgets('a project report request retry preserves its idempotency key', (
    tester,
  ) async {
    repository.failRequest = true;
    await tester.pumpWidget(
      host(types: [api.DocumentExportInputTypeEnum.PROJECT_SUMMARY]),
    );
    await tester.tap(find.byTooltip('Export project summary PDF'));
    await tester.pumpAndSettle();
    repository.failRequest = false;
    repository.state = 'READY';
    await tester.tap(find.byTooltip('Export project summary PDF'));
    await tester.pumpAndSettle();
    expect(repository.requests, hasLength(2));
    expect(repository.requests[0].$4, repository.requests[1].$4);
    expect(picker.filenames, hasLength(1));
  });

  testWidgets(
    'an unaccepted order never generates a Purchase Order from a download click',
    (tester) async {
      repository.state = 'AFTER_ACCEPTANCE';
      await tester.pumpWidget(
        host(types: [api.DocumentExportInputTypeEnum.PURCHASE_ORDER]),
      );
      await tester.tap(find.byTooltip('Export purchase order PDF'));
      await tester.pumpAndSettle();
      expect(repository.requests, isEmpty);
      expect(repository.downloads, isEmpty);
      expect(picker.filenames, isEmpty);
      expect(
        find.text(
          'The Purchase Order will be available after the final order is accepted.',
        ),
        findsOneWidget,
      );
    },
  );

  for (final change in ['unmount', 'session', 'context']) {
    testWidgets('queued issued document cannot save after $change changes', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      await tester.tap(find.byTooltip('Export purchase order PDF'));
      await tester.pump();
      repository.state = 'READY';
      if (change == 'unmount') await tester.pumpWidget(const SizedBox.shrink());
      if (change == 'session') repository.inbox.setActive(false, clear: true);
      if (change == 'context') {
        await tester.pumpWidget(host(resourceId: 'other-order'));
      }
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(repository.downloads, isEmpty);
      expect(picker.filenames, isEmpty);
    });
  }
}
