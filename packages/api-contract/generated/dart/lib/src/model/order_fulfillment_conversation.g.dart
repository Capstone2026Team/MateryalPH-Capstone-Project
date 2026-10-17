// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_fulfillment_conversation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderFulfillmentConversation extends OrderFulfillmentConversation {
  @override
  final String conversationId;
  @override
  final bool readOnly;

  factory _$OrderFulfillmentConversation(
          [void Function(OrderFulfillmentConversationBuilder)? updates]) =>
      (OrderFulfillmentConversationBuilder()..update(updates))._build();

  _$OrderFulfillmentConversation._(
      {required this.conversationId, required this.readOnly})
      : super._();
  @override
  OrderFulfillmentConversation rebuild(
          void Function(OrderFulfillmentConversationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderFulfillmentConversationBuilder toBuilder() =>
      OrderFulfillmentConversationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderFulfillmentConversation &&
        conversationId == other.conversationId &&
        readOnly == other.readOnly;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jc(_$hash, readOnly.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderFulfillmentConversation')
          ..add('conversationId', conversationId)
          ..add('readOnly', readOnly))
        .toString();
  }
}

class OrderFulfillmentConversationBuilder
    implements
        Builder<OrderFulfillmentConversation,
            OrderFulfillmentConversationBuilder> {
  _$OrderFulfillmentConversation? _$v;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  bool? _readOnly;
  bool? get readOnly => _$this._readOnly;
  set readOnly(bool? readOnly) => _$this._readOnly = readOnly;

  OrderFulfillmentConversationBuilder() {
    OrderFulfillmentConversation._defaults(this);
  }

  OrderFulfillmentConversationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _conversationId = $v.conversationId;
      _readOnly = $v.readOnly;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderFulfillmentConversation other) {
    _$v = other as _$OrderFulfillmentConversation;
  }

  @override
  void update(void Function(OrderFulfillmentConversationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderFulfillmentConversation build() => _build();

  _$OrderFulfillmentConversation _build() {
    final _$result = _$v ??
        _$OrderFulfillmentConversation._(
          conversationId: BuiltValueNullFieldError.checkNotNull(conversationId,
              r'OrderFulfillmentConversation', 'conversationId'),
          readOnly: BuiltValueNullFieldError.checkNotNull(
              readOnly, r'OrderFulfillmentConversation', 'readOnly'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
