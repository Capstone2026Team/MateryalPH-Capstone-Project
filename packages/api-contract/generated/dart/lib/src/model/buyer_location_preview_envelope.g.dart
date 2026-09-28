// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_preview_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocationPreviewEnvelope extends BuyerLocationPreviewEnvelope {
  @override
  final BuyerLocationPreview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerLocationPreviewEnvelope(
          [void Function(BuyerLocationPreviewEnvelopeBuilder)? updates]) =>
      (BuyerLocationPreviewEnvelopeBuilder()..update(updates))._build();

  _$BuyerLocationPreviewEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerLocationPreviewEnvelope rebuild(
          void Function(BuyerLocationPreviewEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationPreviewEnvelopeBuilder toBuilder() =>
      BuyerLocationPreviewEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationPreviewEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerLocationPreviewEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerLocationPreviewEnvelopeBuilder
    implements
        Builder<BuyerLocationPreviewEnvelope,
            BuyerLocationPreviewEnvelopeBuilder> {
  _$BuyerLocationPreviewEnvelope? _$v;

  BuyerLocationPreviewBuilder? _data;
  BuyerLocationPreviewBuilder get data =>
      _$this._data ??= BuyerLocationPreviewBuilder();
  set data(BuyerLocationPreviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerLocationPreviewEnvelopeBuilder() {
    BuyerLocationPreviewEnvelope._defaults(this);
  }

  BuyerLocationPreviewEnvelopeBuilder get _$this {
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
  void replace(BuyerLocationPreviewEnvelope other) {
    _$v = other as _$BuyerLocationPreviewEnvelope;
  }

  @override
  void update(void Function(BuyerLocationPreviewEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationPreviewEnvelope build() => _build();

  _$BuyerLocationPreviewEnvelope _build() {
    _$BuyerLocationPreviewEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerLocationPreviewEnvelope._(
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
            r'BuyerLocationPreviewEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
