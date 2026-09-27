// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_compliance_case_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductComplianceCaseEnvelope extends ProductComplianceCaseEnvelope {
  @override
  final ProductComplianceCaseEnvelopeData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ProductComplianceCaseEnvelope(
          [void Function(ProductComplianceCaseEnvelopeBuilder)? updates]) =>
      (ProductComplianceCaseEnvelopeBuilder()..update(updates))._build();

  _$ProductComplianceCaseEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProductComplianceCaseEnvelope rebuild(
          void Function(ProductComplianceCaseEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductComplianceCaseEnvelopeBuilder toBuilder() =>
      ProductComplianceCaseEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductComplianceCaseEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ProductComplianceCaseEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProductComplianceCaseEnvelopeBuilder
    implements
        Builder<ProductComplianceCaseEnvelope,
            ProductComplianceCaseEnvelopeBuilder> {
  _$ProductComplianceCaseEnvelope? _$v;

  ProductComplianceCaseEnvelopeDataBuilder? _data;
  ProductComplianceCaseEnvelopeDataBuilder get data =>
      _$this._data ??= ProductComplianceCaseEnvelopeDataBuilder();
  set data(ProductComplianceCaseEnvelopeDataBuilder? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ProductComplianceCaseEnvelopeBuilder() {
    ProductComplianceCaseEnvelope._defaults(this);
  }

  ProductComplianceCaseEnvelopeBuilder get _$this {
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
  void replace(ProductComplianceCaseEnvelope other) {
    _$v = other as _$ProductComplianceCaseEnvelope;
  }

  @override
  void update(void Function(ProductComplianceCaseEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductComplianceCaseEnvelope build() => _build();

  _$ProductComplianceCaseEnvelope _build() {
    _$ProductComplianceCaseEnvelope _$result;
    try {
      _$result = _$v ??
          _$ProductComplianceCaseEnvelope._(
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
            r'ProductComplianceCaseEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
