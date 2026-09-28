// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_settings_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventorySettingsEnvelope extends InventorySettingsEnvelope {
  @override
  final InventorySettings data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$InventorySettingsEnvelope(
          [void Function(InventorySettingsEnvelopeBuilder)? updates]) =>
      (InventorySettingsEnvelopeBuilder()..update(updates))._build();

  _$InventorySettingsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  InventorySettingsEnvelope rebuild(
          void Function(InventorySettingsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventorySettingsEnvelopeBuilder toBuilder() =>
      InventorySettingsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventorySettingsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'InventorySettingsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class InventorySettingsEnvelopeBuilder
    implements
        Builder<InventorySettingsEnvelope, InventorySettingsEnvelopeBuilder> {
  _$InventorySettingsEnvelope? _$v;

  InventorySettingsBuilder? _data;
  InventorySettingsBuilder get data =>
      _$this._data ??= InventorySettingsBuilder();
  set data(InventorySettingsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  InventorySettingsEnvelopeBuilder() {
    InventorySettingsEnvelope._defaults(this);
  }

  InventorySettingsEnvelopeBuilder get _$this {
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
  void replace(InventorySettingsEnvelope other) {
    _$v = other as _$InventorySettingsEnvelope;
  }

  @override
  void update(void Function(InventorySettingsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventorySettingsEnvelope build() => _build();

  _$InventorySettingsEnvelope _build() {
    _$InventorySettingsEnvelope _$result;
    try {
      _$result = _$v ??
          _$InventorySettingsEnvelope._(
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
            r'InventorySettingsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
