// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_handover_cash.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PhysicalHandoverCashMilestoneEnum
    _$physicalHandoverCashMilestoneEnum_DELIVERED =
    const PhysicalHandoverCashMilestoneEnum._('DELIVERED');
const PhysicalHandoverCashMilestoneEnum
    _$physicalHandoverCashMilestoneEnum_PICKED_UP =
    const PhysicalHandoverCashMilestoneEnum._('PICKED_UP');

PhysicalHandoverCashMilestoneEnum _$physicalHandoverCashMilestoneEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERED':
      return _$physicalHandoverCashMilestoneEnum_DELIVERED;
    case 'PICKED_UP':
      return _$physicalHandoverCashMilestoneEnum_PICKED_UP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PhysicalHandoverCashMilestoneEnum>
    _$physicalHandoverCashMilestoneEnumValues = BuiltSet<
        PhysicalHandoverCashMilestoneEnum>(const <PhysicalHandoverCashMilestoneEnum>[
  _$physicalHandoverCashMilestoneEnum_DELIVERED,
  _$physicalHandoverCashMilestoneEnum_PICKED_UP,
]);

Serializer<PhysicalHandoverCashMilestoneEnum>
    _$physicalHandoverCashMilestoneEnumSerializer =
    _$PhysicalHandoverCashMilestoneEnumSerializer();

class _$PhysicalHandoverCashMilestoneEnumSerializer
    implements PrimitiveSerializer<PhysicalHandoverCashMilestoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERED': 'DELIVERED',
    'PICKED_UP': 'PICKED_UP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERED': 'DELIVERED',
    'PICKED_UP': 'PICKED_UP',
  };

  @override
  final Iterable<Type> types = const <Type>[PhysicalHandoverCashMilestoneEnum];
  @override
  final String wireName = 'PhysicalHandoverCashMilestoneEnum';

  @override
  Object serialize(
          Serializers serializers, PhysicalHandoverCashMilestoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PhysicalHandoverCashMilestoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PhysicalHandoverCashMilestoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PhysicalHandoverCash extends PhysicalHandoverCash {
  @override
  final int reportedCentavos;
  @override
  final int confirmableCentavos;
  @override
  final PhysicalHandoverCashMilestoneEnum milestone;
  @override
  final DateTime reportedAt;
  @override
  final bool hasPhoto;

  factory _$PhysicalHandoverCash(
          [void Function(PhysicalHandoverCashBuilder)? updates]) =>
      (PhysicalHandoverCashBuilder()..update(updates))._build();

  _$PhysicalHandoverCash._(
      {required this.reportedCentavos,
      required this.confirmableCentavos,
      required this.milestone,
      required this.reportedAt,
      required this.hasPhoto})
      : super._();
  @override
  PhysicalHandoverCash rebuild(
          void Function(PhysicalHandoverCashBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalHandoverCashBuilder toBuilder() =>
      PhysicalHandoverCashBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalHandoverCash &&
        reportedCentavos == other.reportedCentavos &&
        confirmableCentavos == other.confirmableCentavos &&
        milestone == other.milestone &&
        reportedAt == other.reportedAt &&
        hasPhoto == other.hasPhoto;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reportedCentavos.hashCode);
    _$hash = $jc(_$hash, confirmableCentavos.hashCode);
    _$hash = $jc(_$hash, milestone.hashCode);
    _$hash = $jc(_$hash, reportedAt.hashCode);
    _$hash = $jc(_$hash, hasPhoto.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhysicalHandoverCash')
          ..add('reportedCentavos', reportedCentavos)
          ..add('confirmableCentavos', confirmableCentavos)
          ..add('milestone', milestone)
          ..add('reportedAt', reportedAt)
          ..add('hasPhoto', hasPhoto))
        .toString();
  }
}

class PhysicalHandoverCashBuilder
    implements Builder<PhysicalHandoverCash, PhysicalHandoverCashBuilder> {
  _$PhysicalHandoverCash? _$v;

  int? _reportedCentavos;
  int? get reportedCentavos => _$this._reportedCentavos;
  set reportedCentavos(int? reportedCentavos) =>
      _$this._reportedCentavos = reportedCentavos;

  int? _confirmableCentavos;
  int? get confirmableCentavos => _$this._confirmableCentavos;
  set confirmableCentavos(int? confirmableCentavos) =>
      _$this._confirmableCentavos = confirmableCentavos;

  PhysicalHandoverCashMilestoneEnum? _milestone;
  PhysicalHandoverCashMilestoneEnum? get milestone => _$this._milestone;
  set milestone(PhysicalHandoverCashMilestoneEnum? milestone) =>
      _$this._milestone = milestone;

  DateTime? _reportedAt;
  DateTime? get reportedAt => _$this._reportedAt;
  set reportedAt(DateTime? reportedAt) => _$this._reportedAt = reportedAt;

  bool? _hasPhoto;
  bool? get hasPhoto => _$this._hasPhoto;
  set hasPhoto(bool? hasPhoto) => _$this._hasPhoto = hasPhoto;

  PhysicalHandoverCashBuilder() {
    PhysicalHandoverCash._defaults(this);
  }

  PhysicalHandoverCashBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reportedCentavos = $v.reportedCentavos;
      _confirmableCentavos = $v.confirmableCentavos;
      _milestone = $v.milestone;
      _reportedAt = $v.reportedAt;
      _hasPhoto = $v.hasPhoto;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhysicalHandoverCash other) {
    _$v = other as _$PhysicalHandoverCash;
  }

  @override
  void update(void Function(PhysicalHandoverCashBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalHandoverCash build() => _build();

  _$PhysicalHandoverCash _build() {
    final _$result = _$v ??
        _$PhysicalHandoverCash._(
          reportedCentavos: BuiltValueNullFieldError.checkNotNull(
              reportedCentavos, r'PhysicalHandoverCash', 'reportedCentavos'),
          confirmableCentavos: BuiltValueNullFieldError.checkNotNull(
              confirmableCentavos,
              r'PhysicalHandoverCash',
              'confirmableCentavos'),
          milestone: BuiltValueNullFieldError.checkNotNull(
              milestone, r'PhysicalHandoverCash', 'milestone'),
          reportedAt: BuiltValueNullFieldError.checkNotNull(
              reportedAt, r'PhysicalHandoverCash', 'reportedAt'),
          hasPhoto: BuiltValueNullFieldError.checkNotNull(
              hasPhoto, r'PhysicalHandoverCash', 'hasPhoto'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
