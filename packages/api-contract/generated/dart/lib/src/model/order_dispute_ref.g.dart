// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dispute_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDisputeRefStatusEnum
    _$orderDisputeRefStatusEnum_OPEN_AWAITING_RESPONSE =
    const OrderDisputeRefStatusEnum._('OPEN_AWAITING_RESPONSE');
const OrderDisputeRefStatusEnum _$orderDisputeRefStatusEnum_MUTUAL_RESOLUTION =
    const OrderDisputeRefStatusEnum._('MUTUAL_RESOLUTION');
const OrderDisputeRefStatusEnum
    _$orderDisputeRefStatusEnum_ESCALATED_ADMIN_REVIEW =
    const OrderDisputeRefStatusEnum._('ESCALATED_ADMIN_REVIEW');
const OrderDisputeRefStatusEnum
    _$orderDisputeRefStatusEnum_AWAITING_CLARIFICATION =
    const OrderDisputeRefStatusEnum._('AWAITING_CLARIFICATION');
const OrderDisputeRefStatusEnum _$orderDisputeRefStatusEnum_DECIDED =
    const OrderDisputeRefStatusEnum._('DECIDED');
const OrderDisputeRefStatusEnum _$orderDisputeRefStatusEnum_APPEAL_OPEN =
    const OrderDisputeRefStatusEnum._('APPEAL_OPEN');
const OrderDisputeRefStatusEnum _$orderDisputeRefStatusEnum_RESOLVED =
    const OrderDisputeRefStatusEnum._('RESOLVED');
const OrderDisputeRefStatusEnum
    _$orderDisputeRefStatusEnum_CLOSED_INCONCLUSIVE =
    const OrderDisputeRefStatusEnum._('CLOSED_INCONCLUSIVE');

OrderDisputeRefStatusEnum _$orderDisputeRefStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN_AWAITING_RESPONSE':
      return _$orderDisputeRefStatusEnum_OPEN_AWAITING_RESPONSE;
    case 'MUTUAL_RESOLUTION':
      return _$orderDisputeRefStatusEnum_MUTUAL_RESOLUTION;
    case 'ESCALATED_ADMIN_REVIEW':
      return _$orderDisputeRefStatusEnum_ESCALATED_ADMIN_REVIEW;
    case 'AWAITING_CLARIFICATION':
      return _$orderDisputeRefStatusEnum_AWAITING_CLARIFICATION;
    case 'DECIDED':
      return _$orderDisputeRefStatusEnum_DECIDED;
    case 'APPEAL_OPEN':
      return _$orderDisputeRefStatusEnum_APPEAL_OPEN;
    case 'RESOLVED':
      return _$orderDisputeRefStatusEnum_RESOLVED;
    case 'CLOSED_INCONCLUSIVE':
      return _$orderDisputeRefStatusEnum_CLOSED_INCONCLUSIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDisputeRefStatusEnum> _$orderDisputeRefStatusEnumValues =
    BuiltSet<OrderDisputeRefStatusEnum>(const <OrderDisputeRefStatusEnum>[
  _$orderDisputeRefStatusEnum_OPEN_AWAITING_RESPONSE,
  _$orderDisputeRefStatusEnum_MUTUAL_RESOLUTION,
  _$orderDisputeRefStatusEnum_ESCALATED_ADMIN_REVIEW,
  _$orderDisputeRefStatusEnum_AWAITING_CLARIFICATION,
  _$orderDisputeRefStatusEnum_DECIDED,
  _$orderDisputeRefStatusEnum_APPEAL_OPEN,
  _$orderDisputeRefStatusEnum_RESOLVED,
  _$orderDisputeRefStatusEnum_CLOSED_INCONCLUSIVE,
]);

const OrderDisputeRefFiledByPartyEnum _$orderDisputeRefFiledByPartyEnum_BUYER =
    const OrderDisputeRefFiledByPartyEnum._('BUYER');
const OrderDisputeRefFiledByPartyEnum _$orderDisputeRefFiledByPartyEnum_VENDOR =
    const OrderDisputeRefFiledByPartyEnum._('VENDOR');

OrderDisputeRefFiledByPartyEnum _$orderDisputeRefFiledByPartyEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$orderDisputeRefFiledByPartyEnum_BUYER;
    case 'VENDOR':
      return _$orderDisputeRefFiledByPartyEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDisputeRefFiledByPartyEnum>
    _$orderDisputeRefFiledByPartyEnumValues = BuiltSet<
        OrderDisputeRefFiledByPartyEnum>(const <OrderDisputeRefFiledByPartyEnum>[
  _$orderDisputeRefFiledByPartyEnum_BUYER,
  _$orderDisputeRefFiledByPartyEnum_VENDOR,
]);

Serializer<OrderDisputeRefStatusEnum> _$orderDisputeRefStatusEnumSerializer =
    _$OrderDisputeRefStatusEnumSerializer();
Serializer<OrderDisputeRefFiledByPartyEnum>
    _$orderDisputeRefFiledByPartyEnumSerializer =
    _$OrderDisputeRefFiledByPartyEnumSerializer();

class _$OrderDisputeRefStatusEnumSerializer
    implements PrimitiveSerializer<OrderDisputeRefStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN_AWAITING_RESPONSE': 'OPEN_AWAITING_RESPONSE',
    'MUTUAL_RESOLUTION': 'MUTUAL_RESOLUTION',
    'ESCALATED_ADMIN_REVIEW': 'ESCALATED_ADMIN_REVIEW',
    'AWAITING_CLARIFICATION': 'AWAITING_CLARIFICATION',
    'DECIDED': 'DECIDED',
    'APPEAL_OPEN': 'APPEAL_OPEN',
    'RESOLVED': 'RESOLVED',
    'CLOSED_INCONCLUSIVE': 'CLOSED_INCONCLUSIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN_AWAITING_RESPONSE': 'OPEN_AWAITING_RESPONSE',
    'MUTUAL_RESOLUTION': 'MUTUAL_RESOLUTION',
    'ESCALATED_ADMIN_REVIEW': 'ESCALATED_ADMIN_REVIEW',
    'AWAITING_CLARIFICATION': 'AWAITING_CLARIFICATION',
    'DECIDED': 'DECIDED',
    'APPEAL_OPEN': 'APPEAL_OPEN',
    'RESOLVED': 'RESOLVED',
    'CLOSED_INCONCLUSIVE': 'CLOSED_INCONCLUSIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDisputeRefStatusEnum];
  @override
  final String wireName = 'OrderDisputeRefStatusEnum';

  @override
  Object serialize(Serializers serializers, OrderDisputeRefStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDisputeRefStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDisputeRefStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDisputeRefFiledByPartyEnumSerializer
    implements PrimitiveSerializer<OrderDisputeRefFiledByPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDisputeRefFiledByPartyEnum];
  @override
  final String wireName = 'OrderDisputeRefFiledByPartyEnum';

  @override
  Object serialize(
          Serializers serializers, OrderDisputeRefFiledByPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDisputeRefFiledByPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDisputeRefFiledByPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDisputeRef extends OrderDisputeRef {
  @override
  final String caseId;
  @override
  final String reference;
  @override
  final OrderDisputeRefStatusEnum status;
  @override
  final OrderDisputeRefFiledByPartyEnum filedByParty;
  @override
  final bool? filingAvailable;
  @override
  final String? filingNote;

  factory _$OrderDisputeRef([void Function(OrderDisputeRefBuilder)? updates]) =>
      (OrderDisputeRefBuilder()..update(updates))._build();

  _$OrderDisputeRef._(
      {required this.caseId,
      required this.reference,
      required this.status,
      required this.filedByParty,
      this.filingAvailable,
      this.filingNote})
      : super._();
  @override
  OrderDisputeRef rebuild(void Function(OrderDisputeRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDisputeRefBuilder toBuilder() => OrderDisputeRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDisputeRef &&
        caseId == other.caseId &&
        reference == other.reference &&
        status == other.status &&
        filedByParty == other.filedByParty &&
        filingAvailable == other.filingAvailable &&
        filingNote == other.filingNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, caseId.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, filedByParty.hashCode);
    _$hash = $jc(_$hash, filingAvailable.hashCode);
    _$hash = $jc(_$hash, filingNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDisputeRef')
          ..add('caseId', caseId)
          ..add('reference', reference)
          ..add('status', status)
          ..add('filedByParty', filedByParty)
          ..add('filingAvailable', filingAvailable)
          ..add('filingNote', filingNote))
        .toString();
  }
}

class OrderDisputeRefBuilder
    implements Builder<OrderDisputeRef, OrderDisputeRefBuilder> {
  _$OrderDisputeRef? _$v;

  String? _caseId;
  String? get caseId => _$this._caseId;
  set caseId(String? caseId) => _$this._caseId = caseId;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  OrderDisputeRefStatusEnum? _status;
  OrderDisputeRefStatusEnum? get status => _$this._status;
  set status(OrderDisputeRefStatusEnum? status) => _$this._status = status;

  OrderDisputeRefFiledByPartyEnum? _filedByParty;
  OrderDisputeRefFiledByPartyEnum? get filedByParty => _$this._filedByParty;
  set filedByParty(OrderDisputeRefFiledByPartyEnum? filedByParty) =>
      _$this._filedByParty = filedByParty;

  bool? _filingAvailable;
  bool? get filingAvailable => _$this._filingAvailable;
  set filingAvailable(bool? filingAvailable) =>
      _$this._filingAvailable = filingAvailable;

  String? _filingNote;
  String? get filingNote => _$this._filingNote;
  set filingNote(String? filingNote) => _$this._filingNote = filingNote;

  OrderDisputeRefBuilder() {
    OrderDisputeRef._defaults(this);
  }

  OrderDisputeRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _caseId = $v.caseId;
      _reference = $v.reference;
      _status = $v.status;
      _filedByParty = $v.filedByParty;
      _filingAvailable = $v.filingAvailable;
      _filingNote = $v.filingNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDisputeRef other) {
    _$v = other as _$OrderDisputeRef;
  }

  @override
  void update(void Function(OrderDisputeRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDisputeRef build() => _build();

  _$OrderDisputeRef _build() {
    final _$result = _$v ??
        _$OrderDisputeRef._(
          caseId: BuiltValueNullFieldError.checkNotNull(
              caseId, r'OrderDisputeRef', 'caseId'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'OrderDisputeRef', 'reference'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'OrderDisputeRef', 'status'),
          filedByParty: BuiltValueNullFieldError.checkNotNull(
              filedByParty, r'OrderDisputeRef', 'filedByParty'),
          filingAvailable: filingAvailable,
          filingNote: filingNote,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
