// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_movement_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryMovementListEnvelope extends InventoryMovementListEnvelope {
  @override
  final BuiltList<InventoryMovement> data;
  @override
  final PageMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$InventoryMovementListEnvelope(
          [void Function(InventoryMovementListEnvelopeBuilder)? updates]) =>
      (InventoryMovementListEnvelopeBuilder()..update(updates))._build();

  _$InventoryMovementListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  InventoryMovementListEnvelope rebuild(
          void Function(InventoryMovementListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryMovementListEnvelopeBuilder toBuilder() =>
      InventoryMovementListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryMovementListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'InventoryMovementListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class InventoryMovementListEnvelopeBuilder
    implements
        Builder<InventoryMovementListEnvelope,
            InventoryMovementListEnvelopeBuilder> {
  _$InventoryMovementListEnvelope? _$v;

  ListBuilder<InventoryMovement>? _data;
  ListBuilder<InventoryMovement> get data =>
      _$this._data ??= ListBuilder<InventoryMovement>();
  set data(ListBuilder<InventoryMovement>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  InventoryMovementListEnvelopeBuilder() {
    InventoryMovementListEnvelope._defaults(this);
  }

  InventoryMovementListEnvelopeBuilder get _$this {
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
  void replace(InventoryMovementListEnvelope other) {
    _$v = other as _$InventoryMovementListEnvelope;
  }

  @override
  void update(void Function(InventoryMovementListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryMovementListEnvelope build() => _build();

  _$InventoryMovementListEnvelope _build() {
    _$InventoryMovementListEnvelope _$result;
    try {
      _$result = _$v ??
          _$InventoryMovementListEnvelope._(
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
            r'InventoryMovementListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
