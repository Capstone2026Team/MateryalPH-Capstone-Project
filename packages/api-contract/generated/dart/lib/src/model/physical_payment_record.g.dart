// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_payment_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PhysicalPaymentRecordKindEnum
    _$physicalPaymentRecordKindEnum_OBLIGATION_OPENED =
    const PhysicalPaymentRecordKindEnum._('OBLIGATION_OPENED');
const PhysicalPaymentRecordKindEnum _$physicalPaymentRecordKindEnum_COLLECTION =
    const PhysicalPaymentRecordKindEnum._('COLLECTION');
const PhysicalPaymentRecordKindEnum
    _$physicalPaymentRecordKindEnum_ONLINE_BALANCE_CREDIT =
    const PhysicalPaymentRecordKindEnum._('ONLINE_BALANCE_CREDIT');
const PhysicalPaymentRecordKindEnum _$physicalPaymentRecordKindEnum_CORRECTION =
    const PhysicalPaymentRecordKindEnum._('CORRECTION');
const PhysicalPaymentRecordKindEnum
    _$physicalPaymentRecordKindEnum_CANCELLATION_RELEASE =
    const PhysicalPaymentRecordKindEnum._('CANCELLATION_RELEASE');

PhysicalPaymentRecordKindEnum _$physicalPaymentRecordKindEnumValueOf(
    String name) {
  switch (name) {
    case 'OBLIGATION_OPENED':
      return _$physicalPaymentRecordKindEnum_OBLIGATION_OPENED;
    case 'COLLECTION':
      return _$physicalPaymentRecordKindEnum_COLLECTION;
    case 'ONLINE_BALANCE_CREDIT':
      return _$physicalPaymentRecordKindEnum_ONLINE_BALANCE_CREDIT;
    case 'CORRECTION':
      return _$physicalPaymentRecordKindEnum_CORRECTION;
    case 'CANCELLATION_RELEASE':
      return _$physicalPaymentRecordKindEnum_CANCELLATION_RELEASE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PhysicalPaymentRecordKindEnum>
    _$physicalPaymentRecordKindEnumValues = BuiltSet<
        PhysicalPaymentRecordKindEnum>(const <PhysicalPaymentRecordKindEnum>[
  _$physicalPaymentRecordKindEnum_OBLIGATION_OPENED,
  _$physicalPaymentRecordKindEnum_COLLECTION,
  _$physicalPaymentRecordKindEnum_ONLINE_BALANCE_CREDIT,
  _$physicalPaymentRecordKindEnum_CORRECTION,
  _$physicalPaymentRecordKindEnum_CANCELLATION_RELEASE,
]);

const PhysicalPaymentRecordStateEnum _$physicalPaymentRecordStateEnum_UNPAID =
    const PhysicalPaymentRecordStateEnum._('UNPAID');
const PhysicalPaymentRecordStateEnum
    _$physicalPaymentRecordStateEnum_PARTIALLY_RECORDED =
    const PhysicalPaymentRecordStateEnum._('PARTIALLY_RECORDED');
const PhysicalPaymentRecordStateEnum
    _$physicalPaymentRecordStateEnum_PHYSICAL_PAYMENT_RECORDED =
    const PhysicalPaymentRecordStateEnum._('PHYSICAL_PAYMENT_RECORDED');
const PhysicalPaymentRecordStateEnum
    _$physicalPaymentRecordStateEnum_CANCELLED_UNPAID =
    const PhysicalPaymentRecordStateEnum._('CANCELLED_UNPAID');

PhysicalPaymentRecordStateEnum _$physicalPaymentRecordStateEnumValueOf(
    String name) {
  switch (name) {
    case 'UNPAID':
      return _$physicalPaymentRecordStateEnum_UNPAID;
    case 'PARTIALLY_RECORDED':
      return _$physicalPaymentRecordStateEnum_PARTIALLY_RECORDED;
    case 'PHYSICAL_PAYMENT_RECORDED':
      return _$physicalPaymentRecordStateEnum_PHYSICAL_PAYMENT_RECORDED;
    case 'CANCELLED_UNPAID':
      return _$physicalPaymentRecordStateEnum_CANCELLED_UNPAID;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PhysicalPaymentRecordStateEnum>
    _$physicalPaymentRecordStateEnumValues = BuiltSet<
        PhysicalPaymentRecordStateEnum>(const <PhysicalPaymentRecordStateEnum>[
  _$physicalPaymentRecordStateEnum_UNPAID,
  _$physicalPaymentRecordStateEnum_PARTIALLY_RECORDED,
  _$physicalPaymentRecordStateEnum_PHYSICAL_PAYMENT_RECORDED,
  _$physicalPaymentRecordStateEnum_CANCELLED_UNPAID,
]);

const PhysicalPaymentRecordSource_Enum
    _$physicalPaymentRecordSourceEnum_VENDOR_RECORD =
    const PhysicalPaymentRecordSource_Enum._('VENDOR_RECORD');
const PhysicalPaymentRecordSource_Enum
    _$physicalPaymentRecordSourceEnum_VERIFIED_ONLINE_PAYMENT =
    const PhysicalPaymentRecordSource_Enum._('VERIFIED_ONLINE_PAYMENT');
const PhysicalPaymentRecordSource_Enum
    _$physicalPaymentRecordSourceEnum_SYSTEM =
    const PhysicalPaymentRecordSource_Enum._('SYSTEM');

PhysicalPaymentRecordSource_Enum _$physicalPaymentRecordSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_RECORD':
      return _$physicalPaymentRecordSourceEnum_VENDOR_RECORD;
    case 'VERIFIED_ONLINE_PAYMENT':
      return _$physicalPaymentRecordSourceEnum_VERIFIED_ONLINE_PAYMENT;
    case 'SYSTEM':
      return _$physicalPaymentRecordSourceEnum_SYSTEM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PhysicalPaymentRecordSource_Enum>
    _$physicalPaymentRecordSourceEnumValues = BuiltSet<
        PhysicalPaymentRecordSource_Enum>(const <PhysicalPaymentRecordSource_Enum>[
  _$physicalPaymentRecordSourceEnum_VENDOR_RECORD,
  _$physicalPaymentRecordSourceEnum_VERIFIED_ONLINE_PAYMENT,
  _$physicalPaymentRecordSourceEnum_SYSTEM,
]);

Serializer<PhysicalPaymentRecordKindEnum>
    _$physicalPaymentRecordKindEnumSerializer =
    _$PhysicalPaymentRecordKindEnumSerializer();
Serializer<PhysicalPaymentRecordStateEnum>
    _$physicalPaymentRecordStateEnumSerializer =
    _$PhysicalPaymentRecordStateEnumSerializer();
Serializer<PhysicalPaymentRecordSource_Enum>
    _$physicalPaymentRecordSourceEnumSerializer =
    _$PhysicalPaymentRecordSource_EnumSerializer();

class _$PhysicalPaymentRecordKindEnumSerializer
    implements PrimitiveSerializer<PhysicalPaymentRecordKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OBLIGATION_OPENED': 'OBLIGATION_OPENED',
    'COLLECTION': 'COLLECTION',
    'ONLINE_BALANCE_CREDIT': 'ONLINE_BALANCE_CREDIT',
    'CORRECTION': 'CORRECTION',
    'CANCELLATION_RELEASE': 'CANCELLATION_RELEASE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OBLIGATION_OPENED': 'OBLIGATION_OPENED',
    'COLLECTION': 'COLLECTION',
    'ONLINE_BALANCE_CREDIT': 'ONLINE_BALANCE_CREDIT',
    'CORRECTION': 'CORRECTION',
    'CANCELLATION_RELEASE': 'CANCELLATION_RELEASE',
  };

  @override
  final Iterable<Type> types = const <Type>[PhysicalPaymentRecordKindEnum];
  @override
  final String wireName = 'PhysicalPaymentRecordKindEnum';

  @override
  Object serialize(
          Serializers serializers, PhysicalPaymentRecordKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PhysicalPaymentRecordKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PhysicalPaymentRecordKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PhysicalPaymentRecordStateEnumSerializer
    implements PrimitiveSerializer<PhysicalPaymentRecordStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNPAID': 'UNPAID',
    'PARTIALLY_RECORDED': 'PARTIALLY_RECORDED',
    'PHYSICAL_PAYMENT_RECORDED': 'PHYSICAL_PAYMENT_RECORDED',
    'CANCELLED_UNPAID': 'CANCELLED_UNPAID',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNPAID': 'UNPAID',
    'PARTIALLY_RECORDED': 'PARTIALLY_RECORDED',
    'PHYSICAL_PAYMENT_RECORDED': 'PHYSICAL_PAYMENT_RECORDED',
    'CANCELLED_UNPAID': 'CANCELLED_UNPAID',
  };

  @override
  final Iterable<Type> types = const <Type>[PhysicalPaymentRecordStateEnum];
  @override
  final String wireName = 'PhysicalPaymentRecordStateEnum';

  @override
  Object serialize(
          Serializers serializers, PhysicalPaymentRecordStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PhysicalPaymentRecordStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PhysicalPaymentRecordStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PhysicalPaymentRecordSource_EnumSerializer
    implements PrimitiveSerializer<PhysicalPaymentRecordSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_RECORD': 'VENDOR_RECORD',
    'VERIFIED_ONLINE_PAYMENT': 'VERIFIED_ONLINE_PAYMENT',
    'SYSTEM': 'SYSTEM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_RECORD': 'VENDOR_RECORD',
    'VERIFIED_ONLINE_PAYMENT': 'VERIFIED_ONLINE_PAYMENT',
    'SYSTEM': 'SYSTEM',
  };

  @override
  final Iterable<Type> types = const <Type>[PhysicalPaymentRecordSource_Enum];
  @override
  final String wireName = 'PhysicalPaymentRecordSource_Enum';

  @override
  Object serialize(
          Serializers serializers, PhysicalPaymentRecordSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PhysicalPaymentRecordSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PhysicalPaymentRecordSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PhysicalPaymentRecord extends PhysicalPaymentRecord {
  @override
  final String id;
  @override
  final PhysicalPaymentRecordKindEnum kind;
  @override
  final String method;
  @override
  final int amountCentavos;
  @override
  final int remainingCentavos;
  @override
  final PhysicalPaymentRecordStateEnum state;
  @override
  final DateTime recordedAt;
  @override
  final String? recordedRole;
  @override
  final bool hasEvidence;
  @override
  final PhysicalPaymentRecordSource_Enum source_;
  @override
  final DateTime? buyerAcknowledgedAt;

  factory _$PhysicalPaymentRecord(
          [void Function(PhysicalPaymentRecordBuilder)? updates]) =>
      (PhysicalPaymentRecordBuilder()..update(updates))._build();

  _$PhysicalPaymentRecord._(
      {required this.id,
      required this.kind,
      required this.method,
      required this.amountCentavos,
      required this.remainingCentavos,
      required this.state,
      required this.recordedAt,
      this.recordedRole,
      required this.hasEvidence,
      required this.source_,
      this.buyerAcknowledgedAt})
      : super._();
  @override
  PhysicalPaymentRecord rebuild(
          void Function(PhysicalPaymentRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalPaymentRecordBuilder toBuilder() =>
      PhysicalPaymentRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalPaymentRecord &&
        id == other.id &&
        kind == other.kind &&
        method == other.method &&
        amountCentavos == other.amountCentavos &&
        remainingCentavos == other.remainingCentavos &&
        state == other.state &&
        recordedAt == other.recordedAt &&
        recordedRole == other.recordedRole &&
        hasEvidence == other.hasEvidence &&
        source_ == other.source_ &&
        buyerAcknowledgedAt == other.buyerAcknowledgedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, remainingCentavos.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, recordedRole.hashCode);
    _$hash = $jc(_$hash, hasEvidence.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, buyerAcknowledgedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhysicalPaymentRecord')
          ..add('id', id)
          ..add('kind', kind)
          ..add('method', method)
          ..add('amountCentavos', amountCentavos)
          ..add('remainingCentavos', remainingCentavos)
          ..add('state', state)
          ..add('recordedAt', recordedAt)
          ..add('recordedRole', recordedRole)
          ..add('hasEvidence', hasEvidence)
          ..add('source_', source_)
          ..add('buyerAcknowledgedAt', buyerAcknowledgedAt))
        .toString();
  }
}

class PhysicalPaymentRecordBuilder
    implements Builder<PhysicalPaymentRecord, PhysicalPaymentRecordBuilder> {
  _$PhysicalPaymentRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PhysicalPaymentRecordKindEnum? _kind;
  PhysicalPaymentRecordKindEnum? get kind => _$this._kind;
  set kind(PhysicalPaymentRecordKindEnum? kind) => _$this._kind = kind;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _remainingCentavos;
  int? get remainingCentavos => _$this._remainingCentavos;
  set remainingCentavos(int? remainingCentavos) =>
      _$this._remainingCentavos = remainingCentavos;

  PhysicalPaymentRecordStateEnum? _state;
  PhysicalPaymentRecordStateEnum? get state => _$this._state;
  set state(PhysicalPaymentRecordStateEnum? state) => _$this._state = state;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  String? _recordedRole;
  String? get recordedRole => _$this._recordedRole;
  set recordedRole(String? recordedRole) => _$this._recordedRole = recordedRole;

  bool? _hasEvidence;
  bool? get hasEvidence => _$this._hasEvidence;
  set hasEvidence(bool? hasEvidence) => _$this._hasEvidence = hasEvidence;

  PhysicalPaymentRecordSource_Enum? _source_;
  PhysicalPaymentRecordSource_Enum? get source_ => _$this._source_;
  set source_(PhysicalPaymentRecordSource_Enum? source_) =>
      _$this._source_ = source_;

  DateTime? _buyerAcknowledgedAt;
  DateTime? get buyerAcknowledgedAt => _$this._buyerAcknowledgedAt;
  set buyerAcknowledgedAt(DateTime? buyerAcknowledgedAt) =>
      _$this._buyerAcknowledgedAt = buyerAcknowledgedAt;

  PhysicalPaymentRecordBuilder() {
    PhysicalPaymentRecord._defaults(this);
  }

  PhysicalPaymentRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _method = $v.method;
      _amountCentavos = $v.amountCentavos;
      _remainingCentavos = $v.remainingCentavos;
      _state = $v.state;
      _recordedAt = $v.recordedAt;
      _recordedRole = $v.recordedRole;
      _hasEvidence = $v.hasEvidence;
      _source_ = $v.source_;
      _buyerAcknowledgedAt = $v.buyerAcknowledgedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhysicalPaymentRecord other) {
    _$v = other as _$PhysicalPaymentRecord;
  }

  @override
  void update(void Function(PhysicalPaymentRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalPaymentRecord build() => _build();

  _$PhysicalPaymentRecord _build() {
    final _$result = _$v ??
        _$PhysicalPaymentRecord._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PhysicalPaymentRecord', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'PhysicalPaymentRecord', 'kind'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'PhysicalPaymentRecord', 'method'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'PhysicalPaymentRecord', 'amountCentavos'),
          remainingCentavos: BuiltValueNullFieldError.checkNotNull(
              remainingCentavos, r'PhysicalPaymentRecord', 'remainingCentavos'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'PhysicalPaymentRecord', 'state'),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt, r'PhysicalPaymentRecord', 'recordedAt'),
          recordedRole: recordedRole,
          hasEvidence: BuiltValueNullFieldError.checkNotNull(
              hasEvidence, r'PhysicalPaymentRecord', 'hasEvidence'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'PhysicalPaymentRecord', 'source_'),
          buyerAcknowledgedAt: buyerAcknowledgedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
