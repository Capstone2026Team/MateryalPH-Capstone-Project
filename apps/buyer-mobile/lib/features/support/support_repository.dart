import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';

class SupportUpload {
  const SupportUpload(this.name, this.bytes);
  final String name;
  final Uint8List bytes;
}

abstract interface class SupportRepository {
  Future<api.AccountProfile> profile();
  Future<api.SupportTicketListResponse> list([String? cursor]);
  Future<api.SupportTicket> ticket(String id);
  Future<api.SupportEntryListResponse> entries(String id, [String? cursor]);
  Future<api.SupportReceipt> create({
    required api.SupportCategory category,
    required String subject,
    required String message,
    required String key,
    required List<SupportUpload> files,
    api.SupportReferenceType? referenceType,
    String? reference,
  });
  Future<void> reply(
    String id,
    String message,
    List<SupportUpload> files,
    String key,
  );
  Future<Uint8List> attachment(String id, String fileId);
}

class BuyerSupportRepository implements SupportRepository {
  BuyerSupportRepository(
    api.MateryalphApiClient client,
    Future<void> Function() onExpired,
  ) : _api = client.getSupportApi(),
      _accounts = client.getAccountsApi(),
      _guard = ApiGuard(onExpired);
  final api.SupportApi _api;
  final api.AccountsApi _accounts;
  final ApiGuard _guard;
  static final _portal = api.SupportPortal.buyers;

  @override
  Future<api.AccountProfile> profile() => _guard.call(
    () async => _guard.required(
      (await _accounts.getAccountProfile(accountPortal: 'buyers')).data?.data,
    ),
  );
  @override
  Future<api.SupportTicketListResponse> list([String? cursor]) => _guard.call(
    () async => _guard.required(
      (await _api.listSupportTickets(
        supportPortal: _portal,
        cursor: cursor,
      )).data,
    ),
  );
  @override
  Future<api.SupportTicket> ticket(String id) => _guard.call(
    () async => _guard.required(
      (await _api.getSupportTicket(
        supportPortal: _portal,
        ticketId: id,
      )).data?.data,
    ),
  );
  @override
  Future<api.SupportEntryListResponse> entries(String id, [String? cursor]) =>
      _guard.call(
        () async => _guard.required(
          (await _api.listSupportEntries(
            supportPortal: _portal,
            ticketId: id,
            cursor: cursor,
          )).data,
        ),
      );

  BuiltList<MultipartFile> _files(List<SupportUpload> files) => BuiltList(
    files.map(
      (file) => MultipartFile.fromBytes(file.bytes, filename: file.name),
    ),
  );

  @override
  Future<api.SupportReceipt> create({
    required api.SupportCategory category,
    required String subject,
    required String message,
    required String key,
    required List<SupportUpload> files,
    api.SupportReferenceType? referenceType,
    String? reference,
  }) => _guard.call(
    () async => _guard.required(
      (await _api.createSupportTicket(
        supportPortal: _portal,
        idempotencyKey: key,
        userType: api.SupportUserType.BUYER,
        category: category,
        subject: subject,
        message: message,
        privacyAcknowledged: true,
        referenceType: referenceType,
        reference: reference,
        files: _files(files),
      )).data?.data,
    ),
  );

  @override
  Future<void> reply(
    String id,
    String message,
    List<SupportUpload> files,
    String key,
  ) => _guard.call(() async {
    await _api.replyToSupportTicket(
      supportPortal: _portal,
      ticketId: id,
      idempotencyKey: key,
      message: message,
      files: _files(files),
    );
  });

  @override
  Future<Uint8List> attachment(String id, String fileId) => _guard.call(
    () async => _guard.required(
      (await _api.downloadSupportAttachment(
        supportPortal: _portal,
        ticketId: id,
        fileId: fileId,
      )).data,
    ),
  );
}
