// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_fulfillment_conversation_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderFulfillmentConversationEnvelope
    extends OrderFulfillmentConversationEnvelope {
  @override
  final OrderFulfillmentConversation data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$OrderFulfillmentConversationEnvelope(
          [void Function(OrderFulfillmentConversationEnvelopeBuilder)?
              updates]) =>
      (OrderFulfillmentConversationEnvelopeBuilder()..update(updates))._build();

  _$OrderFulfillmentConversationEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  OrderFulfillmentConversationEnvelope rebuild(
          void Function(OrderFulfillmentConversationEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderFulfillmentConversationEnvelopeBuilder toBuilder() =>
      OrderFulfillmentConversationEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderFulfillmentConversationEnvelope &&
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
    return (newBuiltValueToStringHelper(r'OrderFulfillmentConversationEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class OrderFulfillmentConversationEnvelopeBuilder
    implements
        Builder<OrderFulfillmentConversationEnvelope,
            OrderFulfillmentConversationEnvelopeBuilder> {
  _$OrderFulfillmentConversationEnvelope? _$v;

  OrderFulfillmentConversationBuilder? _data;
  OrderFulfillmentConversationBuilder get data =>
      _$this._data ??= OrderFulfillmentConversationBuilder();
  set data(OrderFulfillmentConversationBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  OrderFulfillmentConversationEnvelopeBuilder() {
    OrderFulfillmentConversationEnvelope._defaults(this);
  }

  OrderFulfillmentConversationEnvelopeBuilder get _$this {
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
  void replace(OrderFulfillmentConversationEnvelope other) {
    _$v = other as _$OrderFulfillmentConversationEnvelope;
  }

  @override
  void update(
      void Function(OrderFulfillmentConversationEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderFulfillmentConversationEnvelope build() => _build();

  _$OrderFulfillmentConversationEnvelope _build() {
    _$OrderFulfillmentConversationEnvelope _$result;
    try {
      _$result = _$v ??
          _$OrderFulfillmentConversationEnvelope._(
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
            r'OrderFulfillmentConversationEnvelope',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
