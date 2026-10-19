// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_commission_assessment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorCommissionAssessmentStateEnum
    _$vendorCommissionAssessmentStateEnum_ESTIMATED =
    const VendorCommissionAssessmentStateEnum._('ESTIMATED');
const VendorCommissionAssessmentStateEnum
    _$vendorCommissionAssessmentStateEnum_EARNED =
    const VendorCommissionAssessmentStateEnum._('EARNED');
const VendorCommissionAssessmentStateEnum
    _$vendorCommissionAssessmentStateEnum_CANCELLED =
    const VendorCommissionAssessmentStateEnum._('CANCELLED');

VendorCommissionAssessmentStateEnum
    _$vendorCommissionAssessmentStateEnumValueOf(String name) {
  switch (name) {
    case 'ESTIMATED':
      return _$vendorCommissionAssessmentStateEnum_ESTIMATED;
    case 'EARNED':
      return _$vendorCommissionAssessmentStateEnum_EARNED;
    case 'CANCELLED':
      return _$vendorCommissionAssessmentStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorCommissionAssessmentStateEnum>
    _$vendorCommissionAssessmentStateEnumValues = BuiltSet<
        VendorCommissionAssessmentStateEnum>(const <VendorCommissionAssessmentStateEnum>[
  _$vendorCommissionAssessmentStateEnum_ESTIMATED,
  _$vendorCommissionAssessmentStateEnum_EARNED,
  _$vendorCommissionAssessmentStateEnum_CANCELLED,
]);

Serializer<VendorCommissionAssessmentStateEnum>
    _$vendorCommissionAssessmentStateEnumSerializer =
    _$VendorCommissionAssessmentStateEnumSerializer();

class _$VendorCommissionAssessmentStateEnumSerializer
    implements PrimitiveSerializer<VendorCommissionAssessmentStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ESTIMATED': 'ESTIMATED',
    'EARNED': 'EARNED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ESTIMATED': 'ESTIMATED',
    'EARNED': 'EARNED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorCommissionAssessmentStateEnum
  ];
  @override
  final String wireName = 'VendorCommissionAssessmentStateEnum';

  @override
  Object serialize(
          Serializers serializers, VendorCommissionAssessmentStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorCommissionAssessmentStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorCommissionAssessmentStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorCommissionAssessment extends VendorCommissionAssessment {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final VendorCommissionAssessmentStateEnum state;
  @override
  final int commissionBasisCentavos;
  @override
  final int commissionBasisPoints;
  @override
  final int estimatedCentavos;
  @override
  final int earnedCentavos;
  @override
  final int creditedCentavos;
  @override
  final int netCentavos;
  @override
  final bool disputeHold;
  @override
  final DateTime? earnedAt;

  factory _$VendorCommissionAssessment(
          [void Function(VendorCommissionAssessmentBuilder)? updates]) =>
      (VendorCommissionAssessmentBuilder()..update(updates))._build();

  _$VendorCommissionAssessment._(
      {required this.id,
      required this.orderReference,
      required this.state,
      required this.commissionBasisCentavos,
      required this.commissionBasisPoints,
      required this.estimatedCentavos,
      required this.earnedCentavos,
      required this.creditedCentavos,
      required this.netCentavos,
      required this.disputeHold,
      this.earnedAt})
      : super._();
  @override
  VendorCommissionAssessment rebuild(
          void Function(VendorCommissionAssessmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCommissionAssessmentBuilder toBuilder() =>
      VendorCommissionAssessmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCommissionAssessment &&
        id == other.id &&
        orderReference == other.orderReference &&
        state == other.state &&
        commissionBasisCentavos == other.commissionBasisCentavos &&
        commissionBasisPoints == other.commissionBasisPoints &&
        estimatedCentavos == other.estimatedCentavos &&
        earnedCentavos == other.earnedCentavos &&
        creditedCentavos == other.creditedCentavos &&
        netCentavos == other.netCentavos &&
        disputeHold == other.disputeHold &&
        earnedAt == other.earnedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, commissionBasisCentavos.hashCode);
    _$hash = $jc(_$hash, commissionBasisPoints.hashCode);
    _$hash = $jc(_$hash, estimatedCentavos.hashCode);
    _$hash = $jc(_$hash, earnedCentavos.hashCode);
    _$hash = $jc(_$hash, creditedCentavos.hashCode);
    _$hash = $jc(_$hash, netCentavos.hashCode);
    _$hash = $jc(_$hash, disputeHold.hashCode);
    _$hash = $jc(_$hash, earnedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCommissionAssessment')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('state', state)
          ..add('commissionBasisCentavos', commissionBasisCentavos)
          ..add('commissionBasisPoints', commissionBasisPoints)
          ..add('estimatedCentavos', estimatedCentavos)
          ..add('earnedCentavos', earnedCentavos)
          ..add('creditedCentavos', creditedCentavos)
          ..add('netCentavos', netCentavos)
          ..add('disputeHold', disputeHold)
          ..add('earnedAt', earnedAt))
        .toString();
  }
}

class VendorCommissionAssessmentBuilder
    implements
        Builder<VendorCommissionAssessment, VendorCommissionAssessmentBuilder> {
  _$VendorCommissionAssessment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  VendorCommissionAssessmentStateEnum? _state;
  VendorCommissionAssessmentStateEnum? get state => _$this._state;
  set state(VendorCommissionAssessmentStateEnum? state) =>
      _$this._state = state;

  int? _commissionBasisCentavos;
  int? get commissionBasisCentavos => _$this._commissionBasisCentavos;
  set commissionBasisCentavos(int? commissionBasisCentavos) =>
      _$this._commissionBasisCentavos = commissionBasisCentavos;

  int? _commissionBasisPoints;
  int? get commissionBasisPoints => _$this._commissionBasisPoints;
  set commissionBasisPoints(int? commissionBasisPoints) =>
      _$this._commissionBasisPoints = commissionBasisPoints;

  int? _estimatedCentavos;
  int? get estimatedCentavos => _$this._estimatedCentavos;
  set estimatedCentavos(int? estimatedCentavos) =>
      _$this._estimatedCentavos = estimatedCentavos;

  int? _earnedCentavos;
  int? get earnedCentavos => _$this._earnedCentavos;
  set earnedCentavos(int? earnedCentavos) =>
      _$this._earnedCentavos = earnedCentavos;

  int? _creditedCentavos;
  int? get creditedCentavos => _$this._creditedCentavos;
  set creditedCentavos(int? creditedCentavos) =>
      _$this._creditedCentavos = creditedCentavos;

  int? _netCentavos;
  int? get netCentavos => _$this._netCentavos;
  set netCentavos(int? netCentavos) => _$this._netCentavos = netCentavos;

  bool? _disputeHold;
  bool? get disputeHold => _$this._disputeHold;
  set disputeHold(bool? disputeHold) => _$this._disputeHold = disputeHold;

  DateTime? _earnedAt;
  DateTime? get earnedAt => _$this._earnedAt;
  set earnedAt(DateTime? earnedAt) => _$this._earnedAt = earnedAt;

  VendorCommissionAssessmentBuilder() {
    VendorCommissionAssessment._defaults(this);
  }

  VendorCommissionAssessmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _state = $v.state;
      _commissionBasisCentavos = $v.commissionBasisCentavos;
      _commissionBasisPoints = $v.commissionBasisPoints;
      _estimatedCentavos = $v.estimatedCentavos;
      _earnedCentavos = $v.earnedCentavos;
      _creditedCentavos = $v.creditedCentavos;
      _netCentavos = $v.netCentavos;
      _disputeHold = $v.disputeHold;
      _earnedAt = $v.earnedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCommissionAssessment other) {
    _$v = other as _$VendorCommissionAssessment;
  }

  @override
  void update(void Function(VendorCommissionAssessmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCommissionAssessment build() => _build();

  _$VendorCommissionAssessment _build() {
    final _$result = _$v ??
        _$VendorCommissionAssessment._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorCommissionAssessment', 'id'),
          orderReference: BuiltValueNullFieldError.checkNotNull(
              orderReference, r'VendorCommissionAssessment', 'orderReference'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'VendorCommissionAssessment', 'state'),
          commissionBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              commissionBasisCentavos,
              r'VendorCommissionAssessment',
              'commissionBasisCentavos'),
          commissionBasisPoints: BuiltValueNullFieldError.checkNotNull(
              commissionBasisPoints,
              r'VendorCommissionAssessment',
              'commissionBasisPoints'),
          estimatedCentavos: BuiltValueNullFieldError.checkNotNull(
              estimatedCentavos,
              r'VendorCommissionAssessment',
              'estimatedCentavos'),
          earnedCentavos: BuiltValueNullFieldError.checkNotNull(
              earnedCentavos, r'VendorCommissionAssessment', 'earnedCentavos'),
          creditedCentavos: BuiltValueNullFieldError.checkNotNull(
              creditedCentavos,
              r'VendorCommissionAssessment',
              'creditedCentavos'),
          netCentavos: BuiltValueNullFieldError.checkNotNull(
              netCentavos, r'VendorCommissionAssessment', 'netCentavos'),
          disputeHold: BuiltValueNullFieldError.checkNotNull(
              disputeHold, r'VendorCommissionAssessment', 'disputeHold'),
          earnedAt: earnedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
