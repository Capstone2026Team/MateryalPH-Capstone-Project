// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_notification_device200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RevokeNotificationDevice200Response
    extends RevokeNotificationDevice200Response {
  @override
  final NotificationAction data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$RevokeNotificationDevice200Response(
          [void Function(RevokeNotificationDevice200ResponseBuilder)?
              updates]) =>
      (RevokeNotificationDevice200ResponseBuilder()..update(updates))._build();

  _$RevokeNotificationDevice200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RevokeNotificationDevice200Response rebuild(
          void Function(RevokeNotificationDevice200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RevokeNotificationDevice200ResponseBuilder toBuilder() =>
      RevokeNotificationDevice200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RevokeNotificationDevice200Response &&
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
    return (newBuiltValueToStringHelper(r'RevokeNotificationDevice200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RevokeNotificationDevice200ResponseBuilder
    implements
        Builder<RevokeNotificationDevice200Response,
            RevokeNotificationDevice200ResponseBuilder> {
  _$RevokeNotificationDevice200Response? _$v;

  NotificationActionBuilder? _data;
  NotificationActionBuilder get data =>
      _$this._data ??= NotificationActionBuilder();
  set data(NotificationActionBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  RevokeNotificationDevice200ResponseBuilder() {
    RevokeNotificationDevice200Response._defaults(this);
  }

  RevokeNotificationDevice200ResponseBuilder get _$this {
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
  void replace(RevokeNotificationDevice200Response other) {
    _$v = other as _$RevokeNotificationDevice200Response;
  }

  @override
  void update(
      void Function(RevokeNotificationDevice200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RevokeNotificationDevice200Response build() => _build();

  _$RevokeNotificationDevice200Response _build() {
    _$RevokeNotificationDevice200Response _$result;
    try {
      _$result = _$v ??
          _$RevokeNotificationDevice200Response._(
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
        throw BuiltValueNestedFieldError(r'RevokeNotificationDevice200Response',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
