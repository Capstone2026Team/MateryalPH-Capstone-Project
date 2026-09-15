// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_mutation_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorMutationEnvelope extends VendorMutationEnvelope {
  @override
  final JsonObject? data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorMutationEnvelope(
          [void Function(VendorMutationEnvelopeBuilder)? updates]) =>
      (VendorMutationEnvelopeBuilder()..update(updates))._build();

  _$VendorMutationEnvelope._(
      {this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorMutationEnvelope rebuild(
          void Function(VendorMutationEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorMutationEnvelopeBuilder toBuilder() =>
      VendorMutationEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorMutationEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorMutationEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorMutationEnvelopeBuilder
    implements Builder<VendorMutationEnvelope, VendorMutationEnvelopeBuilder> {
  _$VendorMutationEnvelope? _$v;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorMutationEnvelopeBuilder() {
    VendorMutationEnvelope._defaults(this);
  }

  VendorMutationEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data;
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorMutationEnvelope other) {
    _$v = other as _$VendorMutationEnvelope;
  }

  @override
  void update(void Function(VendorMutationEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorMutationEnvelope build() => _build();

  _$VendorMutationEnvelope _build() {
    _$VendorMutationEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorMutationEnvelope._(
            data: data,
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorMutationEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
