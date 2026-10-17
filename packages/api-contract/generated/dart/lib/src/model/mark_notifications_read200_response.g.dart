// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_notifications_read200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MarkNotificationsRead200Response
    extends MarkNotificationsRead200Response {
  @override
  final NotificationBulkReadAction data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$MarkNotificationsRead200Response(
          [void Function(MarkNotificationsRead200ResponseBuilder)? updates]) =>
      (MarkNotificationsRead200ResponseBuilder()..update(updates))._build();

  _$MarkNotificationsRead200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  MarkNotificationsRead200Response rebuild(
          void Function(MarkNotificationsRead200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MarkNotificationsRead200ResponseBuilder toBuilder() =>
      MarkNotificationsRead200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarkNotificationsRead200Response &&
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
    return (newBuiltValueToStringHelper(r'MarkNotificationsRead200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class MarkNotificationsRead200ResponseBuilder
    implements
        Builder<MarkNotificationsRead200Response,
            MarkNotificationsRead200ResponseBuilder> {
  _$MarkNotificationsRead200Response? _$v;

  NotificationBulkReadActionBuilder? _data;
  NotificationBulkReadActionBuilder get data =>
      _$this._data ??= NotificationBulkReadActionBuilder();
  set data(NotificationBulkReadActionBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  MarkNotificationsRead200ResponseBuilder() {
    MarkNotificationsRead200Response._defaults(this);
  }

  MarkNotificationsRead200ResponseBuilder get _$this {
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
  void replace(MarkNotificationsRead200Response other) {
    _$v = other as _$MarkNotificationsRead200Response;
  }

  @override
  void update(void Function(MarkNotificationsRead200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MarkNotificationsRead200Response build() => _build();

  _$MarkNotificationsRead200Response _build() {
    _$MarkNotificationsRead200Response _$result;
    try {
      _$result = _$v ??
          _$MarkNotificationsRead200Response._(
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
            r'MarkNotificationsRead200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
