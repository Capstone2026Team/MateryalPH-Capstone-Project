// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryPlanGroupStatusEnum
    _$deliveryPlanGroupStatusEnum_CANDIDATES_AVAILABLE =
    const DeliveryPlanGroupStatusEnum._('CANDIDATES_AVAILABLE');
const DeliveryPlanGroupStatusEnum
    _$deliveryPlanGroupStatusEnum_MANUAL_REVIEW_REQUIRED =
    const DeliveryPlanGroupStatusEnum._('MANUAL_REVIEW_REQUIRED');
const DeliveryPlanGroupStatusEnum
    _$deliveryPlanGroupStatusEnum_NO_ELIGIBLE_VEHICLE =
    const DeliveryPlanGroupStatusEnum._('NO_ELIGIBLE_VEHICLE');

DeliveryPlanGroupStatusEnum _$deliveryPlanGroupStatusEnumValueOf(String name) {
  switch (name) {
    case 'CANDIDATES_AVAILABLE':
      return _$deliveryPlanGroupStatusEnum_CANDIDATES_AVAILABLE;
    case 'MANUAL_REVIEW_REQUIRED':
      return _$deliveryPlanGroupStatusEnum_MANUAL_REVIEW_REQUIRED;
    case 'NO_ELIGIBLE_VEHICLE':
      return _$deliveryPlanGroupStatusEnum_NO_ELIGIBLE_VEHICLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPlanGroupStatusEnum>
    _$deliveryPlanGroupStatusEnumValues =
    BuiltSet<DeliveryPlanGroupStatusEnum>(const <DeliveryPlanGroupStatusEnum>[
  _$deliveryPlanGroupStatusEnum_CANDIDATES_AVAILABLE,
  _$deliveryPlanGroupStatusEnum_MANUAL_REVIEW_REQUIRED,
  _$deliveryPlanGroupStatusEnum_NO_ELIGIBLE_VEHICLE,
]);

Serializer<DeliveryPlanGroupStatusEnum>
    _$deliveryPlanGroupStatusEnumSerializer =
    _$DeliveryPlanGroupStatusEnumSerializer();

class _$DeliveryPlanGroupStatusEnumSerializer
    implements PrimitiveSerializer<DeliveryPlanGroupStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CANDIDATES_AVAILABLE': 'CANDIDATES_AVAILABLE',
    'MANUAL_REVIEW_REQUIRED': 'MANUAL_REVIEW_REQUIRED',
    'NO_ELIGIBLE_VEHICLE': 'NO_ELIGIBLE_VEHICLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CANDIDATES_AVAILABLE': 'CANDIDATES_AVAILABLE',
    'MANUAL_REVIEW_REQUIRED': 'MANUAL_REVIEW_REQUIRED',
    'NO_ELIGIBLE_VEHICLE': 'NO_ELIGIBLE_VEHICLE',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPlanGroupStatusEnum];
  @override
  final String wireName = 'DeliveryPlanGroupStatusEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPlanGroupStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPlanGroupStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPlanGroupStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPlanGroup extends DeliveryPlanGroup {
  @override
  final String key;
  @override
  final String label;
  @override
  final DeliveryPlanGroupStatusEnum status;
  @override
  final BuiltList<String> manualReviewReasons;
  @override
  final BuiltList<DeliveryPlanVehicle> candidates;

  factory _$DeliveryPlanGroup(
          [void Function(DeliveryPlanGroupBuilder)? updates]) =>
      (DeliveryPlanGroupBuilder()..update(updates))._build();

  _$DeliveryPlanGroup._(
      {required this.key,
      required this.label,
      required this.status,
      required this.manualReviewReasons,
      required this.candidates})
      : super._();
  @override
  DeliveryPlanGroup rebuild(void Function(DeliveryPlanGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanGroupBuilder toBuilder() =>
      DeliveryPlanGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanGroup &&
        key == other.key &&
        label == other.label &&
        status == other.status &&
        manualReviewReasons == other.manualReviewReasons &&
        candidates == other.candidates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, manualReviewReasons.hashCode);
    _$hash = $jc(_$hash, candidates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlanGroup')
          ..add('key', key)
          ..add('label', label)
          ..add('status', status)
          ..add('manualReviewReasons', manualReviewReasons)
          ..add('candidates', candidates))
        .toString();
  }
}

class DeliveryPlanGroupBuilder
    implements Builder<DeliveryPlanGroup, DeliveryPlanGroupBuilder> {
  _$DeliveryPlanGroup? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  DeliveryPlanGroupStatusEnum? _status;
  DeliveryPlanGroupStatusEnum? get status => _$this._status;
  set status(DeliveryPlanGroupStatusEnum? status) => _$this._status = status;

  ListBuilder<String>? _manualReviewReasons;
  ListBuilder<String> get manualReviewReasons =>
      _$this._manualReviewReasons ??= ListBuilder<String>();
  set manualReviewReasons(ListBuilder<String>? manualReviewReasons) =>
      _$this._manualReviewReasons = manualReviewReasons;

  ListBuilder<DeliveryPlanVehicle>? _candidates;
  ListBuilder<DeliveryPlanVehicle> get candidates =>
      _$this._candidates ??= ListBuilder<DeliveryPlanVehicle>();
  set candidates(ListBuilder<DeliveryPlanVehicle>? candidates) =>
      _$this._candidates = candidates;

  DeliveryPlanGroupBuilder() {
    DeliveryPlanGroup._defaults(this);
  }

  DeliveryPlanGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _status = $v.status;
      _manualReviewReasons = $v.manualReviewReasons.toBuilder();
      _candidates = $v.candidates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlanGroup other) {
    _$v = other as _$DeliveryPlanGroup;
  }

  @override
  void update(void Function(DeliveryPlanGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanGroup build() => _build();

  _$DeliveryPlanGroup _build() {
    _$DeliveryPlanGroup _$result;
    try {
      _$result = _$v ??
          _$DeliveryPlanGroup._(
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'DeliveryPlanGroup', 'key'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'DeliveryPlanGroup', 'label'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DeliveryPlanGroup', 'status'),
            manualReviewReasons: manualReviewReasons.build(),
            candidates: candidates.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manualReviewReasons';
        manualReviewReasons.build();
        _$failedField = 'candidates';
        candidates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryPlanGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
