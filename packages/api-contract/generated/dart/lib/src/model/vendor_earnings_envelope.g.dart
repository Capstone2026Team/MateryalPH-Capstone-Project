// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsEnvelope extends VendorEarningsEnvelope {
  @override
  final VendorEarnings data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorEarningsEnvelope(
          [void Function(VendorEarningsEnvelopeBuilder)? updates]) =>
      (VendorEarningsEnvelopeBuilder()..update(updates))._build();

  _$VendorEarningsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorEarningsEnvelope rebuild(
          void Function(VendorEarningsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsEnvelopeBuilder toBuilder() =>
      VendorEarningsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorEarningsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorEarningsEnvelopeBuilder
    implements Builder<VendorEarningsEnvelope, VendorEarningsEnvelopeBuilder> {
  _$VendorEarningsEnvelope? _$v;

  VendorEarningsBuilder? _data;
  VendorEarningsBuilder get data => _$this._data ??= VendorEarningsBuilder();
  set data(VendorEarningsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorEarningsEnvelopeBuilder() {
    VendorEarningsEnvelope._defaults(this);
  }

  VendorEarningsEnvelopeBuilder get _$this {
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
  void replace(VendorEarningsEnvelope other) {
    _$v = other as _$VendorEarningsEnvelope;
  }

  @override
  void update(void Function(VendorEarningsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsEnvelope build() => _build();

  _$VendorEarningsEnvelope _build() {
    _$VendorEarningsEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorEarningsEnvelope._(
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
            r'VendorEarningsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
