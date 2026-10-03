// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CartEnvelope extends CartEnvelope {
  @override
  final Cart data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$CartEnvelope([void Function(CartEnvelopeBuilder)? updates]) =>
      (CartEnvelopeBuilder()..update(updates))._build();

  _$CartEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CartEnvelope rebuild(void Function(CartEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartEnvelopeBuilder toBuilder() => CartEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CartEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CartEnvelopeBuilder
    implements Builder<CartEnvelope, CartEnvelopeBuilder> {
  _$CartEnvelope? _$v;

  CartBuilder? _data;
  CartBuilder get data => _$this._data ??= CartBuilder();
  set data(CartBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  CartEnvelopeBuilder() {
    CartEnvelope._defaults(this);
  }

  CartEnvelopeBuilder get _$this {
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
  void replace(CartEnvelope other) {
    _$v = other as _$CartEnvelope;
  }

  @override
  void update(void Function(CartEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartEnvelope build() => _build();

  _$CartEnvelope _build() {
    _$CartEnvelope _$result;
    try {
      _$result = _$v ??
          _$CartEnvelope._(
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
            r'CartEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
