// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_fulfillment_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectFulfillmentLineStatusEnum
    _$projectFulfillmentLineStatusEnum_FULFILLED =
    const ProjectFulfillmentLineStatusEnum._('FULFILLED');
const ProjectFulfillmentLineStatusEnum
    _$projectFulfillmentLineStatusEnum_PARTIAL =
    const ProjectFulfillmentLineStatusEnum._('PARTIAL');
const ProjectFulfillmentLineStatusEnum
    _$projectFulfillmentLineStatusEnum_UNFULFILLED =
    const ProjectFulfillmentLineStatusEnum._('UNFULFILLED');

ProjectFulfillmentLineStatusEnum _$projectFulfillmentLineStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'FULFILLED':
      return _$projectFulfillmentLineStatusEnum_FULFILLED;
    case 'PARTIAL':
      return _$projectFulfillmentLineStatusEnum_PARTIAL;
    case 'UNFULFILLED':
      return _$projectFulfillmentLineStatusEnum_UNFULFILLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectFulfillmentLineStatusEnum>
    _$projectFulfillmentLineStatusEnumValues = BuiltSet<
        ProjectFulfillmentLineStatusEnum>(const <ProjectFulfillmentLineStatusEnum>[
  _$projectFulfillmentLineStatusEnum_FULFILLED,
  _$projectFulfillmentLineStatusEnum_PARTIAL,
  _$projectFulfillmentLineStatusEnum_UNFULFILLED,
]);

Serializer<ProjectFulfillmentLineStatusEnum>
    _$projectFulfillmentLineStatusEnumSerializer =
    _$ProjectFulfillmentLineStatusEnumSerializer();

class _$ProjectFulfillmentLineStatusEnumSerializer
    implements PrimitiveSerializer<ProjectFulfillmentLineStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULFILLED': 'FULFILLED',
    'PARTIAL': 'PARTIAL',
    'UNFULFILLED': 'UNFULFILLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULFILLED': 'FULFILLED',
    'PARTIAL': 'PARTIAL',
    'UNFULFILLED': 'UNFULFILLED',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectFulfillmentLineStatusEnum];
  @override
  final String wireName = 'ProjectFulfillmentLineStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProjectFulfillmentLineStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectFulfillmentLineStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectFulfillmentLineStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectFulfillmentLine extends ProjectFulfillmentLine {
  @override
  final String lineId;
  @override
  final String name;
  @override
  final String unitCode;
  @override
  final String requiredQuantity;
  @override
  final String vendorQuantity;
  @override
  final String separateQuantity;
  @override
  final String substituteQuantity;
  @override
  final String remainingQuantity;
  @override
  final ProjectFulfillmentLineStatusEnum status;
  @override
  final String? missingReason;

  factory _$ProjectFulfillmentLine(
          [void Function(ProjectFulfillmentLineBuilder)? updates]) =>
      (ProjectFulfillmentLineBuilder()..update(updates))._build();

  _$ProjectFulfillmentLine._(
      {required this.lineId,
      required this.name,
      required this.unitCode,
      required this.requiredQuantity,
      required this.vendorQuantity,
      required this.separateQuantity,
      required this.substituteQuantity,
      required this.remainingQuantity,
      required this.status,
      this.missingReason})
      : super._();
  @override
  ProjectFulfillmentLine rebuild(
          void Function(ProjectFulfillmentLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectFulfillmentLineBuilder toBuilder() =>
      ProjectFulfillmentLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectFulfillmentLine &&
        lineId == other.lineId &&
        name == other.name &&
        unitCode == other.unitCode &&
        requiredQuantity == other.requiredQuantity &&
        vendorQuantity == other.vendorQuantity &&
        separateQuantity == other.separateQuantity &&
        substituteQuantity == other.substituteQuantity &&
        remainingQuantity == other.remainingQuantity &&
        status == other.status &&
        missingReason == other.missingReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lineId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, requiredQuantity.hashCode);
    _$hash = $jc(_$hash, vendorQuantity.hashCode);
    _$hash = $jc(_$hash, separateQuantity.hashCode);
    _$hash = $jc(_$hash, substituteQuantity.hashCode);
    _$hash = $jc(_$hash, remainingQuantity.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, missingReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectFulfillmentLine')
          ..add('lineId', lineId)
          ..add('name', name)
          ..add('unitCode', unitCode)
          ..add('requiredQuantity', requiredQuantity)
          ..add('vendorQuantity', vendorQuantity)
          ..add('separateQuantity', separateQuantity)
          ..add('substituteQuantity', substituteQuantity)
          ..add('remainingQuantity', remainingQuantity)
          ..add('status', status)
          ..add('missingReason', missingReason))
        .toString();
  }
}

class ProjectFulfillmentLineBuilder
    implements Builder<ProjectFulfillmentLine, ProjectFulfillmentLineBuilder> {
  _$ProjectFulfillmentLine? _$v;

  String? _lineId;
  String? get lineId => _$this._lineId;
  set lineId(String? lineId) => _$this._lineId = lineId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _requiredQuantity;
  String? get requiredQuantity => _$this._requiredQuantity;
  set requiredQuantity(String? requiredQuantity) =>
      _$this._requiredQuantity = requiredQuantity;

  String? _vendorQuantity;
  String? get vendorQuantity => _$this._vendorQuantity;
  set vendorQuantity(String? vendorQuantity) =>
      _$this._vendorQuantity = vendorQuantity;

  String? _separateQuantity;
  String? get separateQuantity => _$this._separateQuantity;
  set separateQuantity(String? separateQuantity) =>
      _$this._separateQuantity = separateQuantity;

  String? _substituteQuantity;
  String? get substituteQuantity => _$this._substituteQuantity;
  set substituteQuantity(String? substituteQuantity) =>
      _$this._substituteQuantity = substituteQuantity;

  String? _remainingQuantity;
  String? get remainingQuantity => _$this._remainingQuantity;
  set remainingQuantity(String? remainingQuantity) =>
      _$this._remainingQuantity = remainingQuantity;

  ProjectFulfillmentLineStatusEnum? _status;
  ProjectFulfillmentLineStatusEnum? get status => _$this._status;
  set status(ProjectFulfillmentLineStatusEnum? status) =>
      _$this._status = status;

  String? _missingReason;
  String? get missingReason => _$this._missingReason;
  set missingReason(String? missingReason) =>
      _$this._missingReason = missingReason;

  ProjectFulfillmentLineBuilder() {
    ProjectFulfillmentLine._defaults(this);
  }

  ProjectFulfillmentLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lineId = $v.lineId;
      _name = $v.name;
      _unitCode = $v.unitCode;
      _requiredQuantity = $v.requiredQuantity;
      _vendorQuantity = $v.vendorQuantity;
      _separateQuantity = $v.separateQuantity;
      _substituteQuantity = $v.substituteQuantity;
      _remainingQuantity = $v.remainingQuantity;
      _status = $v.status;
      _missingReason = $v.missingReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectFulfillmentLine other) {
    _$v = other as _$ProjectFulfillmentLine;
  }

  @override
  void update(void Function(ProjectFulfillmentLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectFulfillmentLine build() => _build();

  _$ProjectFulfillmentLine _build() {
    final _$result = _$v ??
        _$ProjectFulfillmentLine._(
          lineId: BuiltValueNullFieldError.checkNotNull(
              lineId, r'ProjectFulfillmentLine', 'lineId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProjectFulfillmentLine', 'name'),
          unitCode: BuiltValueNullFieldError.checkNotNull(
              unitCode, r'ProjectFulfillmentLine', 'unitCode'),
          requiredQuantity: BuiltValueNullFieldError.checkNotNull(
              requiredQuantity, r'ProjectFulfillmentLine', 'requiredQuantity'),
          vendorQuantity: BuiltValueNullFieldError.checkNotNull(
              vendorQuantity, r'ProjectFulfillmentLine', 'vendorQuantity'),
          separateQuantity: BuiltValueNullFieldError.checkNotNull(
              separateQuantity, r'ProjectFulfillmentLine', 'separateQuantity'),
          substituteQuantity: BuiltValueNullFieldError.checkNotNull(
              substituteQuantity,
              r'ProjectFulfillmentLine',
              'substituteQuantity'),
          remainingQuantity: BuiltValueNullFieldError.checkNotNull(
              remainingQuantity,
              r'ProjectFulfillmentLine',
              'remainingQuantity'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProjectFulfillmentLine', 'status'),
          missingReason: missingReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
