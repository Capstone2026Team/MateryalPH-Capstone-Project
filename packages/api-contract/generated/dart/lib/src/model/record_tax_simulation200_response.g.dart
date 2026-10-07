// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_tax_simulation200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecordTaxSimulation200Response extends RecordTaxSimulation200Response {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$RecordTaxSimulation200Response(
          [void Function(RecordTaxSimulation200ResponseBuilder)? updates]) =>
      (RecordTaxSimulation200ResponseBuilder()..update(updates))._build();

  _$RecordTaxSimulation200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RecordTaxSimulation200Response rebuild(
          void Function(RecordTaxSimulation200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecordTaxSimulation200ResponseBuilder toBuilder() =>
      RecordTaxSimulation200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecordTaxSimulation200Response &&
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
    return (newBuiltValueToStringHelper(r'RecordTaxSimulation200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RecordTaxSimulation200ResponseBuilder
    implements
        Builder<RecordTaxSimulation200Response,
            RecordTaxSimulation200ResponseBuilder> {
  _$RecordTaxSimulation200Response? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  RecordTaxSimulation200ResponseBuilder() {
    RecordTaxSimulation200Response._defaults(this);
  }

  RecordTaxSimulation200ResponseBuilder get _$this {
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
  void replace(RecordTaxSimulation200Response other) {
    _$v = other as _$RecordTaxSimulation200Response;
  }

  @override
  void update(void Function(RecordTaxSimulation200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecordTaxSimulation200Response build() => _build();

  _$RecordTaxSimulation200Response _build() {
    _$RecordTaxSimulation200Response _$result;
    try {
      _$result = _$v ??
          _$RecordTaxSimulation200Response._(
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
            r'RecordTaxSimulation200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
