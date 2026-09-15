// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_row_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorVerificationRowListEnvelope
    extends VendorVerificationRowListEnvelope {
  @override
  final BuiltList<VendorVerificationRow> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorVerificationRowListEnvelope(
          [void Function(VendorVerificationRowListEnvelopeBuilder)? updates]) =>
      (VendorVerificationRowListEnvelopeBuilder()..update(updates))._build();

  _$VendorVerificationRowListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorVerificationRowListEnvelope rebuild(
          void Function(VendorVerificationRowListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationRowListEnvelopeBuilder toBuilder() =>
      VendorVerificationRowListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationRowListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorVerificationRowListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorVerificationRowListEnvelopeBuilder
    implements
        Builder<VendorVerificationRowListEnvelope,
            VendorVerificationRowListEnvelopeBuilder> {
  _$VendorVerificationRowListEnvelope? _$v;

  ListBuilder<VendorVerificationRow>? _data;
  ListBuilder<VendorVerificationRow> get data =>
      _$this._data ??= ListBuilder<VendorVerificationRow>();
  set data(ListBuilder<VendorVerificationRow>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorVerificationRowListEnvelopeBuilder() {
    VendorVerificationRowListEnvelope._defaults(this);
  }

  VendorVerificationRowListEnvelopeBuilder get _$this {
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
  void replace(VendorVerificationRowListEnvelope other) {
    _$v = other as _$VendorVerificationRowListEnvelope;
  }

  @override
  void update(
      void Function(VendorVerificationRowListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationRowListEnvelope build() => _build();

  _$VendorVerificationRowListEnvelope _build() {
    _$VendorVerificationRowListEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorVerificationRowListEnvelope._(
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
            r'VendorVerificationRowListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
