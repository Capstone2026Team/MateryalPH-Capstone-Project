// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_email_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStoreEmailEnvelope extends VendorStoreEmailEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorStoreEmailEnvelope(
          [void Function(VendorStoreEmailEnvelopeBuilder)? updates]) =>
      (VendorStoreEmailEnvelopeBuilder()..update(updates))._build();

  _$VendorStoreEmailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorStoreEmailEnvelope rebuild(
          void Function(VendorStoreEmailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreEmailEnvelopeBuilder toBuilder() =>
      VendorStoreEmailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreEmailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorStoreEmailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorStoreEmailEnvelopeBuilder
    implements
        Builder<VendorStoreEmailEnvelope, VendorStoreEmailEnvelopeBuilder> {
  _$VendorStoreEmailEnvelope? _$v;

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

  VendorStoreEmailEnvelopeBuilder() {
    VendorStoreEmailEnvelope._defaults(this);
  }

  VendorStoreEmailEnvelopeBuilder get _$this {
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
  void replace(VendorStoreEmailEnvelope other) {
    _$v = other as _$VendorStoreEmailEnvelope;
  }

  @override
  void update(void Function(VendorStoreEmailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreEmailEnvelope build() => _build();

  _$VendorStoreEmailEnvelope _build() {
    _$VendorStoreEmailEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorStoreEmailEnvelope._(
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
            r'VendorStoreEmailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
