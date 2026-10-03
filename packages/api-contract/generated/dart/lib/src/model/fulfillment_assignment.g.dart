// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_assignment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentAssignmentRoleEnum
    _$fulfillmentAssignmentRoleEnum_FULFILLMENT =
    const FulfillmentAssignmentRoleEnum._('FULFILLMENT');

FulfillmentAssignmentRoleEnum _$fulfillmentAssignmentRoleEnumValueOf(
    String name) {
  switch (name) {
    case 'FULFILLMENT':
      return _$fulfillmentAssignmentRoleEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentAssignmentRoleEnum>
    _$fulfillmentAssignmentRoleEnumValues = BuiltSet<
        FulfillmentAssignmentRoleEnum>(const <FulfillmentAssignmentRoleEnum>[
  _$fulfillmentAssignmentRoleEnum_FULFILLMENT,
]);

Serializer<FulfillmentAssignmentRoleEnum>
    _$fulfillmentAssignmentRoleEnumSerializer =
    _$FulfillmentAssignmentRoleEnumSerializer();

class _$FulfillmentAssignmentRoleEnumSerializer
    implements PrimitiveSerializer<FulfillmentAssignmentRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULFILLMENT': 'FULFILLMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULFILLMENT': 'FULFILLMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentAssignmentRoleEnum];
  @override
  final String wireName = 'FulfillmentAssignmentRoleEnum';

  @override
  Object serialize(
          Serializers serializers, FulfillmentAssignmentRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentAssignmentRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentAssignmentRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentAssignment extends FulfillmentAssignment {
  @override
  final String displayName;
  @override
  final FulfillmentAssignmentRoleEnum role;
  @override
  final DateTime? assignedAt;
  @override
  final int? userId;

  factory _$FulfillmentAssignment(
          [void Function(FulfillmentAssignmentBuilder)? updates]) =>
      (FulfillmentAssignmentBuilder()..update(updates))._build();

  _$FulfillmentAssignment._(
      {required this.displayName,
      required this.role,
      this.assignedAt,
      this.userId})
      : super._();
  @override
  FulfillmentAssignment rebuild(
          void Function(FulfillmentAssignmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentAssignmentBuilder toBuilder() =>
      FulfillmentAssignmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentAssignment &&
        displayName == other.displayName &&
        role == other.role &&
        assignedAt == other.assignedAt &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, assignedAt.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentAssignment')
          ..add('displayName', displayName)
          ..add('role', role)
          ..add('assignedAt', assignedAt)
          ..add('userId', userId))
        .toString();
  }
}

class FulfillmentAssignmentBuilder
    implements Builder<FulfillmentAssignment, FulfillmentAssignmentBuilder> {
  _$FulfillmentAssignment? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  FulfillmentAssignmentRoleEnum? _role;
  FulfillmentAssignmentRoleEnum? get role => _$this._role;
  set role(FulfillmentAssignmentRoleEnum? role) => _$this._role = role;

  DateTime? _assignedAt;
  DateTime? get assignedAt => _$this._assignedAt;
  set assignedAt(DateTime? assignedAt) => _$this._assignedAt = assignedAt;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  FulfillmentAssignmentBuilder() {
    FulfillmentAssignment._defaults(this);
  }

  FulfillmentAssignmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _role = $v.role;
      _assignedAt = $v.assignedAt;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentAssignment other) {
    _$v = other as _$FulfillmentAssignment;
  }

  @override
  void update(void Function(FulfillmentAssignmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentAssignment build() => _build();

  _$FulfillmentAssignment _build() {
    final _$result = _$v ??
        _$FulfillmentAssignment._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'FulfillmentAssignment', 'displayName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'FulfillmentAssignment', 'role'),
          assignedAt: assignedAt,
          userId: userId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
