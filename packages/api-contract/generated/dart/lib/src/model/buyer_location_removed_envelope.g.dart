// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_removed_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocationRemovedEnvelope extends BuyerLocationRemovedEnvelope {
  @override
  final BuyerLocationRemoved data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerLocationRemovedEnvelope(
          [void Function(BuyerLocationRemovedEnvelopeBuilder)? updates]) =>
      (BuyerLocationRemovedEnvelopeBuilder()..update(updates))._build();

  _$BuyerLocationRemovedEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerLocationRemovedEnvelope rebuild(
          void Function(BuyerLocationRemovedEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationRemovedEnvelopeBuilder toBuilder() =>
      BuyerLocationRemovedEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationRemovedEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerLocationRemovedEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerLocationRemovedEnvelopeBuilder
    implements
        Builder<BuyerLocationRemovedEnvelope,
            BuyerLocationRemovedEnvelopeBuilder> {
  _$BuyerLocationRemovedEnvelope? _$v;

  BuyerLocationRemovedBuilder? _data;
  BuyerLocationRemovedBuilder get data =>
      _$this._data ??= BuyerLocationRemovedBuilder();
  set data(BuyerLocationRemovedBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerLocationRemovedEnvelopeBuilder() {
    BuyerLocationRemovedEnvelope._defaults(this);
  }

  BuyerLocationRemovedEnvelopeBuilder get _$this {
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
  void replace(BuyerLocationRemovedEnvelope other) {
    _$v = other as _$BuyerLocationRemovedEnvelope;
  }

  @override
  void update(void Function(BuyerLocationRemovedEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationRemovedEnvelope build() => _build();

  _$BuyerLocationRemovedEnvelope _build() {
    _$BuyerLocationRemovedEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerLocationRemovedEnvelope._(
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
            r'BuyerLocationRemovedEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
