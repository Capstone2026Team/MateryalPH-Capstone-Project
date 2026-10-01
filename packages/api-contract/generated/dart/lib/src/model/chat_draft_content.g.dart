// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_draft_content.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatDraftContentFulfillmentMethodEnum
    _$chatDraftContentFulfillmentMethodEnum_PICKUP =
    const ChatDraftContentFulfillmentMethodEnum._('PICKUP');
const ChatDraftContentFulfillmentMethodEnum
    _$chatDraftContentFulfillmentMethodEnum_DELIVERY =
    const ChatDraftContentFulfillmentMethodEnum._('DELIVERY');

ChatDraftContentFulfillmentMethodEnum
    _$chatDraftContentFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$chatDraftContentFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$chatDraftContentFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatDraftContentFulfillmentMethodEnum>
    _$chatDraftContentFulfillmentMethodEnumValues = BuiltSet<
        ChatDraftContentFulfillmentMethodEnum>(const <ChatDraftContentFulfillmentMethodEnum>[
  _$chatDraftContentFulfillmentMethodEnum_PICKUP,
  _$chatDraftContentFulfillmentMethodEnum_DELIVERY,
]);

const ChatDraftContentPaymentMethodEnum
    _$chatDraftContentPaymentMethodEnum_ONLINE =
    const ChatDraftContentPaymentMethodEnum._('ONLINE');

ChatDraftContentPaymentMethodEnum _$chatDraftContentPaymentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$chatDraftContentPaymentMethodEnum_ONLINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatDraftContentPaymentMethodEnum>
    _$chatDraftContentPaymentMethodEnumValues = BuiltSet<
        ChatDraftContentPaymentMethodEnum>(const <ChatDraftContentPaymentMethodEnum>[
  _$chatDraftContentPaymentMethodEnum_ONLINE,
]);

Serializer<ChatDraftContentFulfillmentMethodEnum>
    _$chatDraftContentFulfillmentMethodEnumSerializer =
    _$ChatDraftContentFulfillmentMethodEnumSerializer();
Serializer<ChatDraftContentPaymentMethodEnum>
    _$chatDraftContentPaymentMethodEnumSerializer =
    _$ChatDraftContentPaymentMethodEnumSerializer();

class _$ChatDraftContentFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<ChatDraftContentFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ChatDraftContentFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ChatDraftContentFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, ChatDraftContentFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatDraftContentFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatDraftContentFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatDraftContentPaymentMethodEnumSerializer
    implements PrimitiveSerializer<ChatDraftContentPaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatDraftContentPaymentMethodEnum];
  @override
  final String wireName = 'ChatDraftContentPaymentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, ChatDraftContentPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatDraftContentPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatDraftContentPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatDraftContent extends ChatDraftContent {
  @override
  final BuiltList<ChatDraftLine> lines;
  @override
  final ChatDraftContentFulfillmentMethodEnum fulfillmentMethod;
  @override
  final ChatDraftContentPaymentMethodEnum paymentMethod;
  @override
  final String fulfillmentDate;
  @override
  final int? deadlineHours;
  @override
  final int? vendorDiscountCentavos;
  @override
  final BuiltMap<String, JsonObject?>? delivery;
  @override
  final BuiltMap<String, JsonObject?>? nrpc;

  factory _$ChatDraftContent(
          [void Function(ChatDraftContentBuilder)? updates]) =>
      (ChatDraftContentBuilder()..update(updates))._build();

  _$ChatDraftContent._(
      {required this.lines,
      required this.fulfillmentMethod,
      required this.paymentMethod,
      required this.fulfillmentDate,
      this.deadlineHours,
      this.vendorDiscountCentavos,
      this.delivery,
      this.nrpc})
      : super._();
  @override
  ChatDraftContent rebuild(void Function(ChatDraftContentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDraftContentBuilder toBuilder() =>
      ChatDraftContentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDraftContent &&
        lines == other.lines &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod &&
        fulfillmentDate == other.fulfillmentDate &&
        deadlineHours == other.deadlineHours &&
        vendorDiscountCentavos == other.vendorDiscountCentavos &&
        delivery == other.delivery &&
        nrpc == other.nrpc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, fulfillmentDate.hashCode);
    _$hash = $jc(_$hash, deadlineHours.hashCode);
    _$hash = $jc(_$hash, vendorDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, nrpc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDraftContent')
          ..add('lines', lines)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod)
          ..add('fulfillmentDate', fulfillmentDate)
          ..add('deadlineHours', deadlineHours)
          ..add('vendorDiscountCentavos', vendorDiscountCentavos)
          ..add('delivery', delivery)
          ..add('nrpc', nrpc))
        .toString();
  }
}

class ChatDraftContentBuilder
    implements Builder<ChatDraftContent, ChatDraftContentBuilder> {
  _$ChatDraftContent? _$v;

  ListBuilder<ChatDraftLine>? _lines;
  ListBuilder<ChatDraftLine> get lines =>
      _$this._lines ??= ListBuilder<ChatDraftLine>();
  set lines(ListBuilder<ChatDraftLine>? lines) => _$this._lines = lines;

  ChatDraftContentFulfillmentMethodEnum? _fulfillmentMethod;
  ChatDraftContentFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          ChatDraftContentFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ChatDraftContentPaymentMethodEnum? _paymentMethod;
  ChatDraftContentPaymentMethodEnum? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(ChatDraftContentPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _fulfillmentDate;
  String? get fulfillmentDate => _$this._fulfillmentDate;
  set fulfillmentDate(String? fulfillmentDate) =>
      _$this._fulfillmentDate = fulfillmentDate;

  int? _deadlineHours;
  int? get deadlineHours => _$this._deadlineHours;
  set deadlineHours(int? deadlineHours) =>
      _$this._deadlineHours = deadlineHours;

  int? _vendorDiscountCentavos;
  int? get vendorDiscountCentavos => _$this._vendorDiscountCentavos;
  set vendorDiscountCentavos(int? vendorDiscountCentavos) =>
      _$this._vendorDiscountCentavos = vendorDiscountCentavos;

  MapBuilder<String, JsonObject?>? _delivery;
  MapBuilder<String, JsonObject?> get delivery =>
      _$this._delivery ??= MapBuilder<String, JsonObject?>();
  set delivery(MapBuilder<String, JsonObject?>? delivery) =>
      _$this._delivery = delivery;

  MapBuilder<String, JsonObject?>? _nrpc;
  MapBuilder<String, JsonObject?> get nrpc =>
      _$this._nrpc ??= MapBuilder<String, JsonObject?>();
  set nrpc(MapBuilder<String, JsonObject?>? nrpc) => _$this._nrpc = nrpc;

  ChatDraftContentBuilder() {
    ChatDraftContent._defaults(this);
  }

  ChatDraftContentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _fulfillmentDate = $v.fulfillmentDate;
      _deadlineHours = $v.deadlineHours;
      _vendorDiscountCentavos = $v.vendorDiscountCentavos;
      _delivery = $v.delivery?.toBuilder();
      _nrpc = $v.nrpc?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDraftContent other) {
    _$v = other as _$ChatDraftContent;
  }

  @override
  void update(void Function(ChatDraftContentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDraftContent build() => _build();

  _$ChatDraftContent _build() {
    _$ChatDraftContent _$result;
    try {
      _$result = _$v ??
          _$ChatDraftContent._(
            lines: lines.build(),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod, r'ChatDraftContent', 'fulfillmentMethod'),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'ChatDraftContent', 'paymentMethod'),
            fulfillmentDate: BuiltValueNullFieldError.checkNotNull(
                fulfillmentDate, r'ChatDraftContent', 'fulfillmentDate'),
            deadlineHours: deadlineHours,
            vendorDiscountCentavos: vendorDiscountCentavos,
            delivery: _delivery?.build(),
            nrpc: _nrpc?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'delivery';
        _delivery?.build();
        _$failedField = 'nrpc';
        _nrpc?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatDraftContent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
