// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderDetailEnvelope extends OrderDetailEnvelope {
  @override
  final OrderDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$OrderDetailEnvelope(
          [void Function(OrderDetailEnvelopeBuilder)? updates]) =>
      (OrderDetailEnvelopeBuilder()..update(updates))._build();

  _$OrderDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  OrderDetailEnvelope rebuild(
          void Function(OrderDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDetailEnvelopeBuilder toBuilder() =>
      OrderDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'OrderDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class OrderDetailEnvelopeBuilder
    implements Builder<OrderDetailEnvelope, OrderDetailEnvelopeBuilder> {
  _$OrderDetailEnvelope? _$v;

  OrderDetailBuilder? _data;
  OrderDetailBuilder get data => _$this._data ??= OrderDetailBuilder();
  set data(OrderDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  OrderDetailEnvelopeBuilder() {
    OrderDetailEnvelope._defaults(this);
  }

  OrderDetailEnvelopeBuilder get _$this {
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
  void replace(OrderDetailEnvelope other) {
    _$v = other as _$OrderDetailEnvelope;
  }

  @override
  void update(void Function(OrderDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDetailEnvelope build() => _build();

  _$OrderDetailEnvelope _build() {
    _$OrderDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$OrderDetailEnvelope._(
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
            r'OrderDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
