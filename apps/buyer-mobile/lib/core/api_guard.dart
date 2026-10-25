import 'dart:convert';
import 'package:dio/dio.dart';

import '../features/map_discovery/discovery_models.dart';

/// Centralized mapping from `/api/v1` failures to [DiscoveryFailure]: stable error codes, safe
/// messages and details from the canonical `{data, meta, errors}` envelope. Raw exceptions, stack
/// traces and provider payloads never reach the UI. Auth refresh runs before this mapper.
final class ApiGuard {
  const ApiGuard(this._onSessionExpired);

  final Future<void> Function() _onSessionExpired;

  Future<T> call<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DioException catch (error) {
      throw await _failure(error);
    } on DiscoveryFailure {
      rethrow;
    } catch (_) {
      // Malformed or unexpected payloads never surface raw errors or provider details.
      throw const DiscoveryFailure(
        DiscoveryFailureKind.unknown,
        'The server returned an unexpected response. Please retry.',
      );
    }
  }

  T required<T>(T? value) {
    if (value == null) {
      throw const DiscoveryFailure(
        DiscoveryFailureKind.unknown,
        'The server returned an incomplete response. Please retry.',
      );
    }
    return value;
  }

  Future<DiscoveryFailure> _failure(DioException error) async {
    final status = error.response?.statusCode;
    var body = error.response?.data;
    // Binary export requests still return the canonical JSON envelope on failure.
    if (body is List<int> && body.length <= 65536) {
      try {
        body = jsonDecode(utf8.decode(body));
      } catch (_) {
        body = null;
      }
    }
    String? code;
    String? message;
    var details = const <String, Object?>{};
    if (body is Map &&
        body['errors'] is List &&
        (body['errors'] as List).isNotEmpty) {
      final first = (body['errors'] as List).first;
      if (first is Map) {
        code = first['code'] as String?;
        message = first['message'] as String?;
        if (first['details'] is Map) {
          details = Map<String, Object?>.from(first['details'] as Map);
        }
      }
    }
    if (status == null) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        // A timeout is distinct from offline; both retain mutation retry keys.
        return const DiscoveryFailure(
          DiscoveryFailureKind.timeout,
          'The request timed out while waiting for the server. Please retry.',
          code: 'REQUEST_TIMEOUT',
        );
      }
      return const DiscoveryFailure(
        DiscoveryFailureKind.offline,
        'You appear to be offline. Check your connection and retry.',
      );
    }
    if (status == 401) {
      if (error.requestOptions.extra['buyerRetried'] == true) {
        return const DiscoveryFailure(
          DiscoveryFailureKind.forbidden,
          'This request could not be authorized. Please retry.',
        );
      }
      await _onSessionExpired();
      return const DiscoveryFailure(
        DiscoveryFailureKind.sessionExpired,
        'Your session has ended. Sign in again.',
      );
    }
    final kind = switch (status) {
      403 => DiscoveryFailureKind.forbidden,
      404 => DiscoveryFailureKind.notFound,
      409 => DiscoveryFailureKind.conflict,
      422 => DiscoveryFailureKind.validation,
      429 => DiscoveryFailureKind.rateLimited,
      >= 500 => DiscoveryFailureKind.provider,
      _ => DiscoveryFailureKind.unknown,
    };
    return DiscoveryFailure(
      kind,
      message ??
          (kind == DiscoveryFailureKind.rateLimited
              ? 'Too many requests. Wait a moment and retry.'
              : 'Something went wrong. Please retry.'),
      code: code,
      details: details,
    );
  }
}
