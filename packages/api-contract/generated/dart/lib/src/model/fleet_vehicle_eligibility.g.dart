// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_eligibility.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FleetVehicleEligibilityReasonsEnum
    _$fleetVehicleEligibilityReasonsEnum_DELIVERY_NOT_ENABLED =
    const FleetVehicleEligibilityReasonsEnum._('DELIVERY_NOT_ENABLED');
const FleetVehicleEligibilityReasonsEnum
    _$fleetVehicleEligibilityReasonsEnum_VEHICLE_DISABLED =
    const FleetVehicleEligibilityReasonsEnum._('VEHICLE_DISABLED');
const FleetVehicleEligibilityReasonsEnum
    _$fleetVehicleEligibilityReasonsEnum_VEHICLE_UNAVAILABLE =
    const FleetVehicleEligibilityReasonsEnum._('VEHICLE_UNAVAILABLE');
const FleetVehicleEligibilityReasonsEnum
    _$fleetVehicleEligibilityReasonsEnum_VEHICLE_INCOMPLETE =
    const FleetVehicleEligibilityReasonsEnum._('VEHICLE_INCOMPLETE');
const FleetVehicleEligibilityReasonsEnum
    _$fleetVehicleEligibilityReasonsEnum_IMAGE_MISSING =
    const FleetVehicleEligibilityReasonsEnum._('IMAGE_MISSING');
const FleetVehicleEligibilityReasonsEnum
    _$fleetVehicleEligibilityReasonsEnum_RATE_MISSING =
    const FleetVehicleEligibilityReasonsEnum._('RATE_MISSING');

FleetVehicleEligibilityReasonsEnum _$fleetVehicleEligibilityReasonsEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERY_NOT_ENABLED':
      return _$fleetVehicleEligibilityReasonsEnum_DELIVERY_NOT_ENABLED;
    case 'VEHICLE_DISABLED':
      return _$fleetVehicleEligibilityReasonsEnum_VEHICLE_DISABLED;
    case 'VEHICLE_UNAVAILABLE':
      return _$fleetVehicleEligibilityReasonsEnum_VEHICLE_UNAVAILABLE;
    case 'VEHICLE_INCOMPLETE':
      return _$fleetVehicleEligibilityReasonsEnum_VEHICLE_INCOMPLETE;
    case 'IMAGE_MISSING':
      return _$fleetVehicleEligibilityReasonsEnum_IMAGE_MISSING;
    case 'RATE_MISSING':
      return _$fleetVehicleEligibilityReasonsEnum_RATE_MISSING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleEligibilityReasonsEnum>
    _$fleetVehicleEligibilityReasonsEnumValues = BuiltSet<
        FleetVehicleEligibilityReasonsEnum>(const <FleetVehicleEligibilityReasonsEnum>[
  _$fleetVehicleEligibilityReasonsEnum_DELIVERY_NOT_ENABLED,
  _$fleetVehicleEligibilityReasonsEnum_VEHICLE_DISABLED,
  _$fleetVehicleEligibilityReasonsEnum_VEHICLE_UNAVAILABLE,
  _$fleetVehicleEligibilityReasonsEnum_VEHICLE_INCOMPLETE,
  _$fleetVehicleEligibilityReasonsEnum_IMAGE_MISSING,
  _$fleetVehicleEligibilityReasonsEnum_RATE_MISSING,
]);

Serializer<FleetVehicleEligibilityReasonsEnum>
    _$fleetVehicleEligibilityReasonsEnumSerializer =
    _$FleetVehicleEligibilityReasonsEnumSerializer();

class _$FleetVehicleEligibilityReasonsEnumSerializer
    implements PrimitiveSerializer<FleetVehicleEligibilityReasonsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY_NOT_ENABLED': 'DELIVERY_NOT_ENABLED',
    'VEHICLE_DISABLED': 'VEHICLE_DISABLED',
    'VEHICLE_UNAVAILABLE': 'VEHICLE_UNAVAILABLE',
    'VEHICLE_INCOMPLETE': 'VEHICLE_INCOMPLETE',
    'IMAGE_MISSING': 'IMAGE_MISSING',
    'RATE_MISSING': 'RATE_MISSING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY_NOT_ENABLED': 'DELIVERY_NOT_ENABLED',
    'VEHICLE_DISABLED': 'VEHICLE_DISABLED',
    'VEHICLE_UNAVAILABLE': 'VEHICLE_UNAVAILABLE',
    'VEHICLE_INCOMPLETE': 'VEHICLE_INCOMPLETE',
    'IMAGE_MISSING': 'IMAGE_MISSING',
    'RATE_MISSING': 'RATE_MISSING',
  };

  @override
  final Iterable<Type> types = const <Type>[FleetVehicleEligibilityReasonsEnum];
  @override
  final String wireName = 'FleetVehicleEligibilityReasonsEnum';

  @override
  Object serialize(
          Serializers serializers, FleetVehicleEligibilityReasonsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleEligibilityReasonsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleEligibilityReasonsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicleEligibility extends FleetVehicleEligibility {
  @override
  final bool eligible;
  @override
  final BuiltList<FleetVehicleEligibilityReasonsEnum> reasons;

  factory _$FleetVehicleEligibility(
          [void Function(FleetVehicleEligibilityBuilder)? updates]) =>
      (FleetVehicleEligibilityBuilder()..update(updates))._build();

  _$FleetVehicleEligibility._({required this.eligible, required this.reasons})
      : super._();
  @override
  FleetVehicleEligibility rebuild(
          void Function(FleetVehicleEligibilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleEligibilityBuilder toBuilder() =>
      FleetVehicleEligibilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleEligibility &&
        eligible == other.eligible &&
        reasons == other.reasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, eligible.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleEligibility')
          ..add('eligible', eligible)
          ..add('reasons', reasons))
        .toString();
  }
}

class FleetVehicleEligibilityBuilder
    implements
        Builder<FleetVehicleEligibility, FleetVehicleEligibilityBuilder> {
  _$FleetVehicleEligibility? _$v;

  bool? _eligible;
  bool? get eligible => _$this._eligible;
  set eligible(bool? eligible) => _$this._eligible = eligible;

  ListBuilder<FleetVehicleEligibilityReasonsEnum>? _reasons;
  ListBuilder<FleetVehicleEligibilityReasonsEnum> get reasons =>
      _$this._reasons ??= ListBuilder<FleetVehicleEligibilityReasonsEnum>();
  set reasons(ListBuilder<FleetVehicleEligibilityReasonsEnum>? reasons) =>
      _$this._reasons = reasons;

  FleetVehicleEligibilityBuilder() {
    FleetVehicleEligibility._defaults(this);
  }

  FleetVehicleEligibilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _eligible = $v.eligible;
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleEligibility other) {
    _$v = other as _$FleetVehicleEligibility;
  }

  @override
  void update(void Function(FleetVehicleEligibilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleEligibility build() => _build();

  _$FleetVehicleEligibility _build() {
    _$FleetVehicleEligibility _$result;
    try {
      _$result = _$v ??
          _$FleetVehicleEligibility._(
            eligible: BuiltValueNullFieldError.checkNotNull(
                eligible, r'FleetVehicleEligibility', 'eligible'),
            reasons: reasons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FleetVehicleEligibility', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
