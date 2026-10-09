// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_notification_unread_count200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetNotificationUnreadCount200Response
    extends GetNotificationUnreadCount200Response {
  @override
  final NotificationUnreadCount data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GetNotificationUnreadCount200Response(
          [void Function(GetNotificationUnreadCount200ResponseBuilder)?
              updates]) =>
      (GetNotificationUnreadCount200ResponseBuilder()..update(updates))
          ._build();

  _$GetNotificationUnreadCount200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GetNotificationUnreadCount200Response rebuild(
          void Function(GetNotificationUnreadCount200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetNotificationUnreadCount200ResponseBuilder toBuilder() =>
      GetNotificationUnreadCount200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetNotificationUnreadCount200Response &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GetNotificationUnreadCount200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GetNotificationUnreadCount200ResponseBuilder
    implements
        Builder<GetNotificationUnreadCount200Response,
            GetNotificationUnreadCount200ResponseBuilder> {
  _$GetNotificationUnreadCount200Response? _$v;

  NotificationUnreadCountBuilder? _data;
  NotificationUnreadCountBuilder get data =>
      _$this._data ??= NotificationUnreadCountBuilder();
  set data(NotificationUnreadCountBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GetNotificationUnreadCount200ResponseBuilder() {
    GetNotificationUnreadCount200Response._defaults(this);
  }

  GetNotificationUnreadCount200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetNotificationUnreadCount200Response other) {
    _$v = other as _$GetNotificationUnreadCount200Response;
  }

  @override
  void update(
      void Function(GetNotificationUnreadCount200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetNotificationUnreadCount200Response build() => _build();

  _$GetNotificationUnreadCount200Response _build() {
    _$GetNotificationUnreadCount200Response _$result;
    try {
      _$result = _$v ??
          _$GetNotificationUnreadCount200Response._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetNotificationUnreadCount200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
