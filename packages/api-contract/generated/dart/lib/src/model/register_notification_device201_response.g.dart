// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_notification_device201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterNotificationDevice201Response
    extends RegisterNotificationDevice201Response {
  @override
  final NotificationDeviceResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$RegisterNotificationDevice201Response(
          [void Function(RegisterNotificationDevice201ResponseBuilder)?
              updates]) =>
      (RegisterNotificationDevice201ResponseBuilder()..update(updates))
          ._build();

  _$RegisterNotificationDevice201Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RegisterNotificationDevice201Response rebuild(
          void Function(RegisterNotificationDevice201ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterNotificationDevice201ResponseBuilder toBuilder() =>
      RegisterNotificationDevice201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterNotificationDevice201Response &&
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
            r'RegisterNotificationDevice201Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RegisterNotificationDevice201ResponseBuilder
    implements
        Builder<RegisterNotificationDevice201Response,
            RegisterNotificationDevice201ResponseBuilder> {
  _$RegisterNotificationDevice201Response? _$v;

  NotificationDeviceResultBuilder? _data;
  NotificationDeviceResultBuilder get data =>
      _$this._data ??= NotificationDeviceResultBuilder();
  set data(NotificationDeviceResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  RegisterNotificationDevice201ResponseBuilder() {
    RegisterNotificationDevice201Response._defaults(this);
  }

  RegisterNotificationDevice201ResponseBuilder get _$this {
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
  void replace(RegisterNotificationDevice201Response other) {
    _$v = other as _$RegisterNotificationDevice201Response;
  }

  @override
  void update(
      void Function(RegisterNotificationDevice201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterNotificationDevice201Response build() => _build();

  _$RegisterNotificationDevice201Response _build() {
    _$RegisterNotificationDevice201Response _$result;
    try {
      _$result = _$v ??
          _$RegisterNotificationDevice201Response._(
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
            r'RegisterNotificationDevice201Response',
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
