// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_content.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatQuotationContentPriceSourceEnum
    _$chatQuotationContentPriceSourceEnum_PRIVATE_TRANSACTION =
    const ChatQuotationContentPriceSourceEnum._('PRIVATE_TRANSACTION');

ChatQuotationContentPriceSourceEnum
    _$chatQuotationContentPriceSourceEnumValueOf(String name) {
  switch (name) {
    case 'PRIVATE_TRANSACTION':
      return _$chatQuotationContentPriceSourceEnum_PRIVATE_TRANSACTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatQuotationContentPriceSourceEnum>
    _$chatQuotationContentPriceSourceEnumValues = BuiltSet<
        ChatQuotationContentPriceSourceEnum>(const <ChatQuotationContentPriceSourceEnum>[
  _$chatQuotationContentPriceSourceEnum_PRIVATE_TRANSACTION,
]);

Serializer<ChatQuotationContentPriceSourceEnum>
    _$chatQuotationContentPriceSourceEnumSerializer =
    _$ChatQuotationContentPriceSourceEnumSerializer();

class _$ChatQuotationContentPriceSourceEnumSerializer
    implements PrimitiveSerializer<ChatQuotationContentPriceSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRIVATE_TRANSACTION': 'PRIVATE_TRANSACTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRIVATE_TRANSACTION': 'PRIVATE_TRANSACTION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ChatQuotationContentPriceSourceEnum
  ];
  @override
  final String wireName = 'ChatQuotationContentPriceSourceEnum';

  @override
  Object serialize(
          Serializers serializers, ChatQuotationContentPriceSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatQuotationContentPriceSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatQuotationContentPriceSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatQuotationContent extends ChatQuotationContent {
  @override
  final BuiltList<ChatQuotationLine> lines;
  @override
  final ChatQuotationMoney commercial;
  @override
  final String fulfillmentMethod;
  @override
  final String paymentMethod;
  @override
  final String fulfillmentDate;
  @override
  final BuiltMap<String, JsonObject?>? delivery;
  @override
  final BuiltMap<String, JsonObject?>? nrpc;
  @override
  final BuiltList<ChatQuotationChange> changes;
  @override
  final BuiltList<ChatQuotationChange> originalChanges;
  @override
  final ChatQuotationContentPriceSourceEnum priceSource;
  @override
  final String processingFeeStatus;

  factory _$ChatQuotationContent(
          [void Function(ChatQuotationContentBuilder)? updates]) =>
      (ChatQuotationContentBuilder()..update(updates))._build();

  _$ChatQuotationContent._(
      {required this.lines,
      required this.commercial,
      required this.fulfillmentMethod,
      required this.paymentMethod,
      required this.fulfillmentDate,
      this.delivery,
      this.nrpc,
      required this.changes,
      required this.originalChanges,
      required this.priceSource,
      required this.processingFeeStatus})
      : super._();
  @override
  ChatQuotationContent rebuild(
          void Function(ChatQuotationContentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationContentBuilder toBuilder() =>
      ChatQuotationContentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationContent &&
        lines == other.lines &&
        commercial == other.commercial &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod &&
        fulfillmentDate == other.fulfillmentDate &&
        delivery == other.delivery &&
        nrpc == other.nrpc &&
        changes == other.changes &&
        originalChanges == other.originalChanges &&
        priceSource == other.priceSource &&
        processingFeeStatus == other.processingFeeStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, commercial.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, fulfillmentDate.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, nrpc.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, originalChanges.hashCode);
    _$hash = $jc(_$hash, priceSource.hashCode);
    _$hash = $jc(_$hash, processingFeeStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationContent')
          ..add('lines', lines)
          ..add('commercial', commercial)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod)
          ..add('fulfillmentDate', fulfillmentDate)
          ..add('delivery', delivery)
          ..add('nrpc', nrpc)
          ..add('changes', changes)
          ..add('originalChanges', originalChanges)
          ..add('priceSource', priceSource)
          ..add('processingFeeStatus', processingFeeStatus))
        .toString();
  }
}

class ChatQuotationContentBuilder
    implements Builder<ChatQuotationContent, ChatQuotationContentBuilder> {
  _$ChatQuotationContent? _$v;

  ListBuilder<ChatQuotationLine>? _lines;
  ListBuilder<ChatQuotationLine> get lines =>
      _$this._lines ??= ListBuilder<ChatQuotationLine>();
  set lines(ListBuilder<ChatQuotationLine>? lines) => _$this._lines = lines;

  ChatQuotationMoneyBuilder? _commercial;
  ChatQuotationMoneyBuilder get commercial =>
      _$this._commercial ??= ChatQuotationMoneyBuilder();
  set commercial(ChatQuotationMoneyBuilder? commercial) =>
      _$this._commercial = commercial;

  String? _fulfillmentMethod;
  String? get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(String? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  String? _paymentMethod;
  String? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(String? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _fulfillmentDate;
  String? get fulfillmentDate => _$this._fulfillmentDate;
  set fulfillmentDate(String? fulfillmentDate) =>
      _$this._fulfillmentDate = fulfillmentDate;

  MapBuilder<String, JsonObject?>? _delivery;
  MapBuilder<String, JsonObject?> get delivery =>
      _$this._delivery ??= MapBuilder<String, JsonObject?>();
  set delivery(MapBuilder<String, JsonObject?>? delivery) =>
      _$this._delivery = delivery;

  MapBuilder<String, JsonObject?>? _nrpc;
  MapBuilder<String, JsonObject?> get nrpc =>
      _$this._nrpc ??= MapBuilder<String, JsonObject?>();
  set nrpc(MapBuilder<String, JsonObject?>? nrpc) => _$this._nrpc = nrpc;

  ListBuilder<ChatQuotationChange>? _changes;
  ListBuilder<ChatQuotationChange> get changes =>
      _$this._changes ??= ListBuilder<ChatQuotationChange>();
  set changes(ListBuilder<ChatQuotationChange>? changes) =>
      _$this._changes = changes;

  ListBuilder<ChatQuotationChange>? _originalChanges;
  ListBuilder<ChatQuotationChange> get originalChanges =>
      _$this._originalChanges ??= ListBuilder<ChatQuotationChange>();
  set originalChanges(ListBuilder<ChatQuotationChange>? originalChanges) =>
      _$this._originalChanges = originalChanges;

  ChatQuotationContentPriceSourceEnum? _priceSource;
  ChatQuotationContentPriceSourceEnum? get priceSource => _$this._priceSource;
  set priceSource(ChatQuotationContentPriceSourceEnum? priceSource) =>
      _$this._priceSource = priceSource;

  String? _processingFeeStatus;
  String? get processingFeeStatus => _$this._processingFeeStatus;
  set processingFeeStatus(String? processingFeeStatus) =>
      _$this._processingFeeStatus = processingFeeStatus;

  ChatQuotationContentBuilder() {
    ChatQuotationContent._defaults(this);
  }

  ChatQuotationContentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _commercial = $v.commercial.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _fulfillmentDate = $v.fulfillmentDate;
      _delivery = $v.delivery?.toBuilder();
      _nrpc = $v.nrpc?.toBuilder();
      _changes = $v.changes.toBuilder();
      _originalChanges = $v.originalChanges.toBuilder();
      _priceSource = $v.priceSource;
      _processingFeeStatus = $v.processingFeeStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationContent other) {
    _$v = other as _$ChatQuotationContent;
  }

  @override
  void update(void Function(ChatQuotationContentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationContent build() => _build();

  _$ChatQuotationContent _build() {
    _$ChatQuotationContent _$result;
    try {
      _$result = _$v ??
          _$ChatQuotationContent._(
            lines: lines.build(),
            commercial: commercial.build(),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod,
                r'ChatQuotationContent',
                'fulfillmentMethod'),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'ChatQuotationContent', 'paymentMethod'),
            fulfillmentDate: BuiltValueNullFieldError.checkNotNull(
                fulfillmentDate, r'ChatQuotationContent', 'fulfillmentDate'),
            delivery: _delivery?.build(),
            nrpc: _nrpc?.build(),
            changes: changes.build(),
            originalChanges: originalChanges.build(),
            priceSource: BuiltValueNullFieldError.checkNotNull(
                priceSource, r'ChatQuotationContent', 'priceSource'),
            processingFeeStatus: BuiltValueNullFieldError.checkNotNull(
                processingFeeStatus,
                r'ChatQuotationContent',
                'processingFeeStatus'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'commercial';
        commercial.build();

        _$failedField = 'delivery';
        _delivery?.build();
        _$failedField = 'nrpc';
        _nrpc?.build();
        _$failedField = 'changes';
        changes.build();
        _$failedField = 'originalChanges';
        originalChanges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatQuotationContent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
