// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_file_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFileEnvelope extends VendorFileEnvelope {
  @override
  final VendorFile data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorFileEnvelope(
          [void Function(VendorFileEnvelopeBuilder)? updates]) =>
      (VendorFileEnvelopeBuilder()..update(updates))._build();

  _$VendorFileEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorFileEnvelope rebuild(
          void Function(VendorFileEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFileEnvelopeBuilder toBuilder() =>
      VendorFileEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFileEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorFileEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorFileEnvelopeBuilder
    implements Builder<VendorFileEnvelope, VendorFileEnvelopeBuilder> {
  _$VendorFileEnvelope? _$v;

  VendorFileBuilder? _data;
  VendorFileBuilder get data => _$this._data ??= VendorFileBuilder();
  set data(VendorFileBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorFileEnvelopeBuilder() {
    VendorFileEnvelope._defaults(this);
  }

  VendorFileEnvelopeBuilder get _$this {
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
  void replace(VendorFileEnvelope other) {
    _$v = other as _$VendorFileEnvelope;
  }

  @override
  void update(void Function(VendorFileEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFileEnvelope build() => _build();

  _$VendorFileEnvelope _build() {
    _$VendorFileEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorFileEnvelope._(
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
            r'VendorFileEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
