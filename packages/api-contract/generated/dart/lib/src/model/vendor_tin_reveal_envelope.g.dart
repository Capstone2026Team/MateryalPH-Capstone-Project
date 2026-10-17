// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tin_reveal_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTinRevealEnvelope extends VendorTinRevealEnvelope {
  @override
  final VendorTinReveal data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorTinRevealEnvelope(
          [void Function(VendorTinRevealEnvelopeBuilder)? updates]) =>
      (VendorTinRevealEnvelopeBuilder()..update(updates))._build();

  _$VendorTinRevealEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorTinRevealEnvelope rebuild(
          void Function(VendorTinRevealEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTinRevealEnvelopeBuilder toBuilder() =>
      VendorTinRevealEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTinRevealEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorTinRevealEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorTinRevealEnvelopeBuilder
    implements
        Builder<VendorTinRevealEnvelope, VendorTinRevealEnvelopeBuilder> {
  _$VendorTinRevealEnvelope? _$v;

  VendorTinRevealBuilder? _data;
  VendorTinRevealBuilder get data => _$this._data ??= VendorTinRevealBuilder();
  set data(VendorTinRevealBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorTinRevealEnvelopeBuilder() {
    VendorTinRevealEnvelope._defaults(this);
  }

  VendorTinRevealEnvelopeBuilder get _$this {
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
  void replace(VendorTinRevealEnvelope other) {
    _$v = other as _$VendorTinRevealEnvelope;
  }

  @override
  void update(void Function(VendorTinRevealEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTinRevealEnvelope build() => _build();

  _$VendorTinRevealEnvelope _build() {
    _$VendorTinRevealEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorTinRevealEnvelope._(
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
            r'VendorTinRevealEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
