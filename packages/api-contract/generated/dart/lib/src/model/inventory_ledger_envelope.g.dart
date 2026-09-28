// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_ledger_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryLedgerEnvelope extends InventoryLedgerEnvelope {
  @override
  final BuiltList<InventoryRow> data;
  @override
  final InventoryLedgerMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$InventoryLedgerEnvelope(
          [void Function(InventoryLedgerEnvelopeBuilder)? updates]) =>
      (InventoryLedgerEnvelopeBuilder()..update(updates))._build();

  _$InventoryLedgerEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  InventoryLedgerEnvelope rebuild(
          void Function(InventoryLedgerEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLedgerEnvelopeBuilder toBuilder() =>
      InventoryLedgerEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLedgerEnvelope &&
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
    return (newBuiltValueToStringHelper(r'InventoryLedgerEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class InventoryLedgerEnvelopeBuilder
    implements
        Builder<InventoryLedgerEnvelope, InventoryLedgerEnvelopeBuilder> {
  _$InventoryLedgerEnvelope? _$v;

  ListBuilder<InventoryRow>? _data;
  ListBuilder<InventoryRow> get data =>
      _$this._data ??= ListBuilder<InventoryRow>();
  set data(ListBuilder<InventoryRow>? data) => _$this._data = data;

  InventoryLedgerMetaBuilder? _meta;
  InventoryLedgerMetaBuilder get meta =>
      _$this._meta ??= InventoryLedgerMetaBuilder();
  set meta(InventoryLedgerMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  InventoryLedgerEnvelopeBuilder() {
    InventoryLedgerEnvelope._defaults(this);
  }

  InventoryLedgerEnvelopeBuilder get _$this {
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
  void replace(InventoryLedgerEnvelope other) {
    _$v = other as _$InventoryLedgerEnvelope;
  }

  @override
  void update(void Function(InventoryLedgerEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLedgerEnvelope build() => _build();

  _$InventoryLedgerEnvelope _build() {
    _$InventoryLedgerEnvelope _$result;
    try {
      _$result = _$v ??
          _$InventoryLedgerEnvelope._(
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
            r'InventoryLedgerEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
