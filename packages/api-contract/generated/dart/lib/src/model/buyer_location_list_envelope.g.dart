// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocationListEnvelope extends BuyerLocationListEnvelope {
  @override
  final BuiltList<BuyerLocation> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerLocationListEnvelope(
          [void Function(BuyerLocationListEnvelopeBuilder)? updates]) =>
      (BuyerLocationListEnvelopeBuilder()..update(updates))._build();

  _$BuyerLocationListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerLocationListEnvelope rebuild(
          void Function(BuyerLocationListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationListEnvelopeBuilder toBuilder() =>
      BuyerLocationListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerLocationListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerLocationListEnvelopeBuilder
    implements
        Builder<BuyerLocationListEnvelope, BuyerLocationListEnvelopeBuilder> {
  _$BuyerLocationListEnvelope? _$v;

  ListBuilder<BuyerLocation>? _data;
  ListBuilder<BuyerLocation> get data =>
      _$this._data ??= ListBuilder<BuyerLocation>();
  set data(ListBuilder<BuyerLocation>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerLocationListEnvelopeBuilder() {
    BuyerLocationListEnvelope._defaults(this);
  }

  BuyerLocationListEnvelopeBuilder get _$this {
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
  void replace(BuyerLocationListEnvelope other) {
    _$v = other as _$BuyerLocationListEnvelope;
  }

  @override
  void update(void Function(BuyerLocationListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationListEnvelope build() => _build();

  _$BuyerLocationListEnvelope _build() {
    _$BuyerLocationListEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerLocationListEnvelope._(
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
            r'BuyerLocationListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
