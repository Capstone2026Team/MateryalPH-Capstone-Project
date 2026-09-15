// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_business_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorBusinessEnvelope extends VendorBusinessEnvelope {
  @override
  final VendorBusiness data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorBusinessEnvelope(
          [void Function(VendorBusinessEnvelopeBuilder)? updates]) =>
      (VendorBusinessEnvelopeBuilder()..update(updates))._build();

  _$VendorBusinessEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorBusinessEnvelope rebuild(
          void Function(VendorBusinessEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBusinessEnvelopeBuilder toBuilder() =>
      VendorBusinessEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBusinessEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorBusinessEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorBusinessEnvelopeBuilder
    implements Builder<VendorBusinessEnvelope, VendorBusinessEnvelopeBuilder> {
  _$VendorBusinessEnvelope? _$v;

  VendorBusinessBuilder? _data;
  VendorBusinessBuilder get data => _$this._data ??= VendorBusinessBuilder();
  set data(VendorBusinessBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorBusinessEnvelopeBuilder() {
    VendorBusinessEnvelope._defaults(this);
  }

  VendorBusinessEnvelopeBuilder get _$this {
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
  void replace(VendorBusinessEnvelope other) {
    _$v = other as _$VendorBusinessEnvelope;
  }

  @override
  void update(void Function(VendorBusinessEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBusinessEnvelope build() => _build();

  _$VendorBusinessEnvelope _build() {
    _$VendorBusinessEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorBusinessEnvelope._(
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
            r'VendorBusinessEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
