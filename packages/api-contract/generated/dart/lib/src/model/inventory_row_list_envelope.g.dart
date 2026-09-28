// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_row_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryRowListEnvelope extends InventoryRowListEnvelope {
  @override
  final BuiltList<InventoryRow> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$InventoryRowListEnvelope(
          [void Function(InventoryRowListEnvelopeBuilder)? updates]) =>
      (InventoryRowListEnvelopeBuilder()..update(updates))._build();

  _$InventoryRowListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  InventoryRowListEnvelope rebuild(
          void Function(InventoryRowListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryRowListEnvelopeBuilder toBuilder() =>
      InventoryRowListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryRowListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'InventoryRowListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class InventoryRowListEnvelopeBuilder
    implements
        Builder<InventoryRowListEnvelope, InventoryRowListEnvelopeBuilder> {
  _$InventoryRowListEnvelope? _$v;

  ListBuilder<InventoryRow>? _data;
  ListBuilder<InventoryRow> get data =>
      _$this._data ??= ListBuilder<InventoryRow>();
  set data(ListBuilder<InventoryRow>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  InventoryRowListEnvelopeBuilder() {
    InventoryRowListEnvelope._defaults(this);
  }

  InventoryRowListEnvelopeBuilder get _$this {
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
  void replace(InventoryRowListEnvelope other) {
    _$v = other as _$InventoryRowListEnvelope;
  }

  @override
  void update(void Function(InventoryRowListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryRowListEnvelope build() => _build();

  _$InventoryRowListEnvelope _build() {
    _$InventoryRowListEnvelope _$result;
    try {
      _$result = _$v ??
          _$InventoryRowListEnvelope._(
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
            r'InventoryRowListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
