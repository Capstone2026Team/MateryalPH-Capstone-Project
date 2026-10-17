// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_onboarding_snapshot_setup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorOnboardingSnapshotSetupVacationStatusEnum
    _$vendorOnboardingSnapshotSetupVacationStatusEnum_OFF =
    const VendorOnboardingSnapshotSetupVacationStatusEnum._('OFF');
const VendorOnboardingSnapshotSetupVacationStatusEnum
    _$vendorOnboardingSnapshotSetupVacationStatusEnum_SCHEDULED =
    const VendorOnboardingSnapshotSetupVacationStatusEnum._('SCHEDULED');
const VendorOnboardingSnapshotSetupVacationStatusEnum
    _$vendorOnboardingSnapshotSetupVacationStatusEnum_ACTIVE =
    const VendorOnboardingSnapshotSetupVacationStatusEnum._('ACTIVE');

VendorOnboardingSnapshotSetupVacationStatusEnum
    _$vendorOnboardingSnapshotSetupVacationStatusEnumValueOf(String name) {
  switch (name) {
    case 'OFF':
      return _$vendorOnboardingSnapshotSetupVacationStatusEnum_OFF;
    case 'SCHEDULED':
      return _$vendorOnboardingSnapshotSetupVacationStatusEnum_SCHEDULED;
    case 'ACTIVE':
      return _$vendorOnboardingSnapshotSetupVacationStatusEnum_ACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOnboardingSnapshotSetupVacationStatusEnum>
    _$vendorOnboardingSnapshotSetupVacationStatusEnumValues = BuiltSet<
        VendorOnboardingSnapshotSetupVacationStatusEnum>(const <VendorOnboardingSnapshotSetupVacationStatusEnum>[
  _$vendorOnboardingSnapshotSetupVacationStatusEnum_OFF,
  _$vendorOnboardingSnapshotSetupVacationStatusEnum_SCHEDULED,
  _$vendorOnboardingSnapshotSetupVacationStatusEnum_ACTIVE,
]);

Serializer<VendorOnboardingSnapshotSetupVacationStatusEnum>
    _$vendorOnboardingSnapshotSetupVacationStatusEnumSerializer =
    _$VendorOnboardingSnapshotSetupVacationStatusEnumSerializer();

class _$VendorOnboardingSnapshotSetupVacationStatusEnumSerializer
    implements
        PrimitiveSerializer<VendorOnboardingSnapshotSetupVacationStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OFF': 'OFF',
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OFF': 'OFF',
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorOnboardingSnapshotSetupVacationStatusEnum
  ];
  @override
  final String wireName = 'VendorOnboardingSnapshotSetupVacationStatusEnum';

  @override
  Object serialize(Serializers serializers,
          VendorOnboardingSnapshotSetupVacationStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOnboardingSnapshotSetupVacationStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOnboardingSnapshotSetupVacationStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOnboardingSnapshotSetup extends VendorOnboardingSnapshotSetup {
  @override
  final BuiltList<StoreOperatingDay>? operatingSchedule;
  @override
  final VendorDeliverySetup? deliverySetup;
  @override
  final bool? vacationMode;
  @override
  final VendorOnboardingSnapshotSetupVacationStatusEnum? vacationStatus;
  @override
  final String? vacationStartsOn;
  @override
  final String? vacationEndsOn;

  factory _$VendorOnboardingSnapshotSetup(
          [void Function(VendorOnboardingSnapshotSetupBuilder)? updates]) =>
      (VendorOnboardingSnapshotSetupBuilder()..update(updates))._build();

  _$VendorOnboardingSnapshotSetup._(
      {this.operatingSchedule,
      this.deliverySetup,
      this.vacationMode,
      this.vacationStatus,
      this.vacationStartsOn,
      this.vacationEndsOn})
      : super._();
  @override
  VendorOnboardingSnapshotSetup rebuild(
          void Function(VendorOnboardingSnapshotSetupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOnboardingSnapshotSetupBuilder toBuilder() =>
      VendorOnboardingSnapshotSetupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOnboardingSnapshotSetup &&
        operatingSchedule == other.operatingSchedule &&
        deliverySetup == other.deliverySetup &&
        vacationMode == other.vacationMode &&
        vacationStatus == other.vacationStatus &&
        vacationStartsOn == other.vacationStartsOn &&
        vacationEndsOn == other.vacationEndsOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatingSchedule.hashCode);
    _$hash = $jc(_$hash, deliverySetup.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, vacationStatus.hashCode);
    _$hash = $jc(_$hash, vacationStartsOn.hashCode);
    _$hash = $jc(_$hash, vacationEndsOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOnboardingSnapshotSetup')
          ..add('operatingSchedule', operatingSchedule)
          ..add('deliverySetup', deliverySetup)
          ..add('vacationMode', vacationMode)
          ..add('vacationStatus', vacationStatus)
          ..add('vacationStartsOn', vacationStartsOn)
          ..add('vacationEndsOn', vacationEndsOn))
        .toString();
  }
}

class VendorOnboardingSnapshotSetupBuilder
    implements
        Builder<VendorOnboardingSnapshotSetup,
            VendorOnboardingSnapshotSetupBuilder> {
  _$VendorOnboardingSnapshotSetup? _$v;

  ListBuilder<StoreOperatingDay>? _operatingSchedule;
  ListBuilder<StoreOperatingDay> get operatingSchedule =>
      _$this._operatingSchedule ??= ListBuilder<StoreOperatingDay>();
  set operatingSchedule(ListBuilder<StoreOperatingDay>? operatingSchedule) =>
      _$this._operatingSchedule = operatingSchedule;

  VendorDeliverySetupBuilder? _deliverySetup;
  VendorDeliverySetupBuilder get deliverySetup =>
      _$this._deliverySetup ??= VendorDeliverySetupBuilder();
  set deliverySetup(VendorDeliverySetupBuilder? deliverySetup) =>
      _$this._deliverySetup = deliverySetup;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  VendorOnboardingSnapshotSetupVacationStatusEnum? _vacationStatus;
  VendorOnboardingSnapshotSetupVacationStatusEnum? get vacationStatus =>
      _$this._vacationStatus;
  set vacationStatus(
          VendorOnboardingSnapshotSetupVacationStatusEnum? vacationStatus) =>
      _$this._vacationStatus = vacationStatus;

  String? _vacationStartsOn;
  String? get vacationStartsOn => _$this._vacationStartsOn;
  set vacationStartsOn(String? vacationStartsOn) =>
      _$this._vacationStartsOn = vacationStartsOn;

  String? _vacationEndsOn;
  String? get vacationEndsOn => _$this._vacationEndsOn;
  set vacationEndsOn(String? vacationEndsOn) =>
      _$this._vacationEndsOn = vacationEndsOn;

  VendorOnboardingSnapshotSetupBuilder() {
    VendorOnboardingSnapshotSetup._defaults(this);
  }

  VendorOnboardingSnapshotSetupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatingSchedule = $v.operatingSchedule?.toBuilder();
      _deliverySetup = $v.deliverySetup?.toBuilder();
      _vacationMode = $v.vacationMode;
      _vacationStatus = $v.vacationStatus;
      _vacationStartsOn = $v.vacationStartsOn;
      _vacationEndsOn = $v.vacationEndsOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOnboardingSnapshotSetup other) {
    _$v = other as _$VendorOnboardingSnapshotSetup;
  }

  @override
  void update(void Function(VendorOnboardingSnapshotSetupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOnboardingSnapshotSetup build() => _build();

  _$VendorOnboardingSnapshotSetup _build() {
    _$VendorOnboardingSnapshotSetup _$result;
    try {
      _$result = _$v ??
          _$VendorOnboardingSnapshotSetup._(
            operatingSchedule: _operatingSchedule?.build(),
            deliverySetup: _deliverySetup?.build(),
            vacationMode: vacationMode,
            vacationStatus: vacationStatus,
            vacationStartsOn: vacationStartsOn,
            vacationEndsOn: vacationEndsOn,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operatingSchedule';
        _operatingSchedule?.build();
        _$failedField = 'deliverySetup';
        _deliverySetup?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOnboardingSnapshotSetup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
