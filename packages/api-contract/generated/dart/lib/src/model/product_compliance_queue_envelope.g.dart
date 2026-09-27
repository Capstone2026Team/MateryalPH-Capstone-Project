// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_compliance_queue_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductComplianceQueueEnvelope extends ProductComplianceQueueEnvelope {
  @override
  final BuiltList<ProductComplianceQueueItem> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ProductComplianceQueueEnvelope(
          [void Function(ProductComplianceQueueEnvelopeBuilder)? updates]) =>
      (ProductComplianceQueueEnvelopeBuilder()..update(updates))._build();

  _$ProductComplianceQueueEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ProductComplianceQueueEnvelope rebuild(
          void Function(ProductComplianceQueueEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductComplianceQueueEnvelopeBuilder toBuilder() =>
      ProductComplianceQueueEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductComplianceQueueEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ProductComplianceQueueEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ProductComplianceQueueEnvelopeBuilder
    implements
        Builder<ProductComplianceQueueEnvelope,
            ProductComplianceQueueEnvelopeBuilder> {
  _$ProductComplianceQueueEnvelope? _$v;

  ListBuilder<ProductComplianceQueueItem>? _data;
  ListBuilder<ProductComplianceQueueItem> get data =>
      _$this._data ??= ListBuilder<ProductComplianceQueueItem>();
  set data(ListBuilder<ProductComplianceQueueItem>? data) =>
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

  ProductComplianceQueueEnvelopeBuilder() {
    ProductComplianceQueueEnvelope._defaults(this);
  }

  ProductComplianceQueueEnvelopeBuilder get _$this {
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
  void replace(ProductComplianceQueueEnvelope other) {
    _$v = other as _$ProductComplianceQueueEnvelope;
  }

  @override
  void update(void Function(ProductComplianceQueueEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductComplianceQueueEnvelope build() => _build();

  _$ProductComplianceQueueEnvelope _build() {
    _$ProductComplianceQueueEnvelope _$result;
    try {
      _$result = _$v ??
          _$ProductComplianceQueueEnvelope._(
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
            r'ProductComplianceQueueEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
