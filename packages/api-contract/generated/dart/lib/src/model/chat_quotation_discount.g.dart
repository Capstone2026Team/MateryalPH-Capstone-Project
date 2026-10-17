// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_discount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatQuotationDiscountScopeEnum
    _$chatQuotationDiscountScopeEnum_MATERIALS =
    const ChatQuotationDiscountScopeEnum._('MATERIALS');
const ChatQuotationDiscountScopeEnum _$chatQuotationDiscountScopeEnum_DELIVERY =
    const ChatQuotationDiscountScopeEnum._('DELIVERY');

ChatQuotationDiscountScopeEnum _$chatQuotationDiscountScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'MATERIALS':
      return _$chatQuotationDiscountScopeEnum_MATERIALS;
    case 'DELIVERY':
      return _$chatQuotationDiscountScopeEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatQuotationDiscountScopeEnum>
    _$chatQuotationDiscountScopeEnumValues = BuiltSet<
        ChatQuotationDiscountScopeEnum>(const <ChatQuotationDiscountScopeEnum>[
  _$chatQuotationDiscountScopeEnum_MATERIALS,
  _$chatQuotationDiscountScopeEnum_DELIVERY,
]);

Serializer<ChatQuotationDiscountScopeEnum>
    _$chatQuotationDiscountScopeEnumSerializer =
    _$ChatQuotationDiscountScopeEnumSerializer();

class _$ChatQuotationDiscountScopeEnumSerializer
    implements PrimitiveSerializer<ChatQuotationDiscountScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MATERIALS': 'MATERIALS',
    'DELIVERY': 'DELIVERY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MATERIALS': 'MATERIALS',
    'DELIVERY': 'DELIVERY',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatQuotationDiscountScopeEnum];
  @override
  final String wireName = 'ChatQuotationDiscountScopeEnum';

  @override
  Object serialize(
          Serializers serializers, ChatQuotationDiscountScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatQuotationDiscountScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatQuotationDiscountScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatQuotationDiscount extends ChatQuotationDiscount {
  @override
  final ChatQuotationDiscountScopeEnum scope;
  @override
  final String percent;

  factory _$ChatQuotationDiscount(
          [void Function(ChatQuotationDiscountBuilder)? updates]) =>
      (ChatQuotationDiscountBuilder()..update(updates))._build();

  _$ChatQuotationDiscount._({required this.scope, required this.percent})
      : super._();
  @override
  ChatQuotationDiscount rebuild(
          void Function(ChatQuotationDiscountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationDiscountBuilder toBuilder() =>
      ChatQuotationDiscountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationDiscount &&
        scope == other.scope &&
        percent == other.percent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, percent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationDiscount')
          ..add('scope', scope)
          ..add('percent', percent))
        .toString();
  }
}

class ChatQuotationDiscountBuilder
    implements Builder<ChatQuotationDiscount, ChatQuotationDiscountBuilder> {
  _$ChatQuotationDiscount? _$v;

  ChatQuotationDiscountScopeEnum? _scope;
  ChatQuotationDiscountScopeEnum? get scope => _$this._scope;
  set scope(ChatQuotationDiscountScopeEnum? scope) => _$this._scope = scope;

  String? _percent;
  String? get percent => _$this._percent;
  set percent(String? percent) => _$this._percent = percent;

  ChatQuotationDiscountBuilder() {
    ChatQuotationDiscount._defaults(this);
  }

  ChatQuotationDiscountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope;
      _percent = $v.percent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationDiscount other) {
    _$v = other as _$ChatQuotationDiscount;
  }

  @override
  void update(void Function(ChatQuotationDiscountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationDiscount build() => _build();

  _$ChatQuotationDiscount _build() {
    final _$result = _$v ??
        _$ChatQuotationDiscount._(
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'ChatQuotationDiscount', 'scope'),
          percent: BuiltValueNullFieldError.checkNotNull(
              percent, r'ChatQuotationDiscount', 'percent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
