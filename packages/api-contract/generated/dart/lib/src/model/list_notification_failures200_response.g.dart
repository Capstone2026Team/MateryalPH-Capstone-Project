// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_notification_failures200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListNotificationFailures200Response
    extends ListNotificationFailures200Response {
  @override
  final BuiltList<DeliveryFailure> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ListNotificationFailures200Response(
          [void Function(ListNotificationFailures200ResponseBuilder)?
              updates]) =>
      (ListNotificationFailures200ResponseBuilder()..update(updates))._build();

  _$ListNotificationFailures200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ListNotificationFailures200Response rebuild(
          void Function(ListNotificationFailures200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListNotificationFailures200ResponseBuilder toBuilder() =>
      ListNotificationFailures200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListNotificationFailures200Response &&
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
    return (newBuiltValueToStringHelper(r'ListNotificationFailures200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ListNotificationFailures200ResponseBuilder
    implements
        Builder<ListNotificationFailures200Response,
            ListNotificationFailures200ResponseBuilder> {
  _$ListNotificationFailures200Response? _$v;

  ListBuilder<DeliveryFailure>? _data;
  ListBuilder<DeliveryFailure> get data =>
      _$this._data ??= ListBuilder<DeliveryFailure>();
  set data(ListBuilder<DeliveryFailure>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ListNotificationFailures200ResponseBuilder() {
    ListNotificationFailures200Response._defaults(this);
  }

  ListNotificationFailures200ResponseBuilder get _$this {
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
  void replace(ListNotificationFailures200Response other) {
    _$v = other as _$ListNotificationFailures200Response;
  }

  @override
  void update(
      void Function(ListNotificationFailures200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListNotificationFailures200Response build() => _build();

  _$ListNotificationFailures200Response _build() {
    _$ListNotificationFailures200Response _$result;
    try {
      _$result = _$v ??
          _$ListNotificationFailures200Response._(
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
        throw BuiltValueNestedFieldError(r'ListNotificationFailures200Response',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
