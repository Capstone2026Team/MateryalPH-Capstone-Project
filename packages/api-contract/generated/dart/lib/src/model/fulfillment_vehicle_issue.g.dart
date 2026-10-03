// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_vehicle_issue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentVehicleIssueCategoryEnum
    _$fulfillmentVehicleIssueCategoryEnum_BREAKDOWN =
    const FulfillmentVehicleIssueCategoryEnum._('BREAKDOWN');
const FulfillmentVehicleIssueCategoryEnum
    _$fulfillmentVehicleIssueCategoryEnum_CAPACITY_SHORTFALL =
    const FulfillmentVehicleIssueCategoryEnum._('CAPACITY_SHORTFALL');
const FulfillmentVehicleIssueCategoryEnum
    _$fulfillmentVehicleIssueCategoryEnum_ACCESS_BLOCKED =
    const FulfillmentVehicleIssueCategoryEnum._('ACCESS_BLOCKED');
const FulfillmentVehicleIssueCategoryEnum
    _$fulfillmentVehicleIssueCategoryEnum_DELAY =
    const FulfillmentVehicleIssueCategoryEnum._('DELAY');
const FulfillmentVehicleIssueCategoryEnum
    _$fulfillmentVehicleIssueCategoryEnum_OTHER =
    const FulfillmentVehicleIssueCategoryEnum._('OTHER');

FulfillmentVehicleIssueCategoryEnum
    _$fulfillmentVehicleIssueCategoryEnumValueOf(String name) {
  switch (name) {
    case 'BREAKDOWN':
      return _$fulfillmentVehicleIssueCategoryEnum_BREAKDOWN;
    case 'CAPACITY_SHORTFALL':
      return _$fulfillmentVehicleIssueCategoryEnum_CAPACITY_SHORTFALL;
    case 'ACCESS_BLOCKED':
      return _$fulfillmentVehicleIssueCategoryEnum_ACCESS_BLOCKED;
    case 'DELAY':
      return _$fulfillmentVehicleIssueCategoryEnum_DELAY;
    case 'OTHER':
      return _$fulfillmentVehicleIssueCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentVehicleIssueCategoryEnum>
    _$fulfillmentVehicleIssueCategoryEnumValues = BuiltSet<
        FulfillmentVehicleIssueCategoryEnum>(const <FulfillmentVehicleIssueCategoryEnum>[
  _$fulfillmentVehicleIssueCategoryEnum_BREAKDOWN,
  _$fulfillmentVehicleIssueCategoryEnum_CAPACITY_SHORTFALL,
  _$fulfillmentVehicleIssueCategoryEnum_ACCESS_BLOCKED,
  _$fulfillmentVehicleIssueCategoryEnum_DELAY,
  _$fulfillmentVehicleIssueCategoryEnum_OTHER,
]);

Serializer<FulfillmentVehicleIssueCategoryEnum>
    _$fulfillmentVehicleIssueCategoryEnumSerializer =
    _$FulfillmentVehicleIssueCategoryEnumSerializer();

class _$FulfillmentVehicleIssueCategoryEnumSerializer
    implements PrimitiveSerializer<FulfillmentVehicleIssueCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BREAKDOWN': 'BREAKDOWN',
    'CAPACITY_SHORTFALL': 'CAPACITY_SHORTFALL',
    'ACCESS_BLOCKED': 'ACCESS_BLOCKED',
    'DELAY': 'DELAY',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BREAKDOWN': 'BREAKDOWN',
    'CAPACITY_SHORTFALL': 'CAPACITY_SHORTFALL',
    'ACCESS_BLOCKED': 'ACCESS_BLOCKED',
    'DELAY': 'DELAY',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FulfillmentVehicleIssueCategoryEnum
  ];
  @override
  final String wireName = 'FulfillmentVehicleIssueCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, FulfillmentVehicleIssueCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentVehicleIssueCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentVehicleIssueCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentVehicleIssue extends FulfillmentVehicleIssue {
  @override
  final FulfillmentVehicleIssueCategoryEnum category;
  @override
  final String description;
  @override
  final DateTime? reportedAt;
  @override
  final String? actorRole;

  factory _$FulfillmentVehicleIssue(
          [void Function(FulfillmentVehicleIssueBuilder)? updates]) =>
      (FulfillmentVehicleIssueBuilder()..update(updates))._build();

  _$FulfillmentVehicleIssue._(
      {required this.category,
      required this.description,
      this.reportedAt,
      this.actorRole})
      : super._();
  @override
  FulfillmentVehicleIssue rebuild(
          void Function(FulfillmentVehicleIssueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentVehicleIssueBuilder toBuilder() =>
      FulfillmentVehicleIssueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentVehicleIssue &&
        category == other.category &&
        description == other.description &&
        reportedAt == other.reportedAt &&
        actorRole == other.actorRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, reportedAt.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentVehicleIssue')
          ..add('category', category)
          ..add('description', description)
          ..add('reportedAt', reportedAt)
          ..add('actorRole', actorRole))
        .toString();
  }
}

class FulfillmentVehicleIssueBuilder
    implements
        Builder<FulfillmentVehicleIssue, FulfillmentVehicleIssueBuilder> {
  _$FulfillmentVehicleIssue? _$v;

  FulfillmentVehicleIssueCategoryEnum? _category;
  FulfillmentVehicleIssueCategoryEnum? get category => _$this._category;
  set category(FulfillmentVehicleIssueCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _reportedAt;
  DateTime? get reportedAt => _$this._reportedAt;
  set reportedAt(DateTime? reportedAt) => _$this._reportedAt = reportedAt;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  FulfillmentVehicleIssueBuilder() {
    FulfillmentVehicleIssue._defaults(this);
  }

  FulfillmentVehicleIssueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _description = $v.description;
      _reportedAt = $v.reportedAt;
      _actorRole = $v.actorRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentVehicleIssue other) {
    _$v = other as _$FulfillmentVehicleIssue;
  }

  @override
  void update(void Function(FulfillmentVehicleIssueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentVehicleIssue build() => _build();

  _$FulfillmentVehicleIssue _build() {
    final _$result = _$v ??
        _$FulfillmentVehicleIssue._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'FulfillmentVehicleIssue', 'category'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'FulfillmentVehicleIssue', 'description'),
          reportedAt: reportedAt,
          actorRole: actorRole,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
