// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material_attribute.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectMaterialAttributeValueTypeEnum
    _$projectMaterialAttributeValueTypeEnum_TEXT =
    const ProjectMaterialAttributeValueTypeEnum._('TEXT');
const ProjectMaterialAttributeValueTypeEnum
    _$projectMaterialAttributeValueTypeEnum_NUMBER =
    const ProjectMaterialAttributeValueTypeEnum._('NUMBER');
const ProjectMaterialAttributeValueTypeEnum
    _$projectMaterialAttributeValueTypeEnum_ENUM =
    const ProjectMaterialAttributeValueTypeEnum._('ENUM');

ProjectMaterialAttributeValueTypeEnum
    _$projectMaterialAttributeValueTypeEnumValueOf(String name) {
  switch (name) {
    case 'TEXT':
      return _$projectMaterialAttributeValueTypeEnum_TEXT;
    case 'NUMBER':
      return _$projectMaterialAttributeValueTypeEnum_NUMBER;
    case 'ENUM':
      return _$projectMaterialAttributeValueTypeEnum_ENUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectMaterialAttributeValueTypeEnum>
    _$projectMaterialAttributeValueTypeEnumValues = BuiltSet<
        ProjectMaterialAttributeValueTypeEnum>(const <ProjectMaterialAttributeValueTypeEnum>[
  _$projectMaterialAttributeValueTypeEnum_TEXT,
  _$projectMaterialAttributeValueTypeEnum_NUMBER,
  _$projectMaterialAttributeValueTypeEnum_ENUM,
]);

Serializer<ProjectMaterialAttributeValueTypeEnum>
    _$projectMaterialAttributeValueTypeEnumSerializer =
    _$ProjectMaterialAttributeValueTypeEnumSerializer();

class _$ProjectMaterialAttributeValueTypeEnumSerializer
    implements PrimitiveSerializer<ProjectMaterialAttributeValueTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEXT': 'TEXT',
    'NUMBER': 'NUMBER',
    'ENUM': 'ENUM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEXT': 'TEXT',
    'NUMBER': 'NUMBER',
    'ENUM': 'ENUM',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectMaterialAttributeValueTypeEnum
  ];
  @override
  final String wireName = 'ProjectMaterialAttributeValueTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ProjectMaterialAttributeValueTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectMaterialAttributeValueTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectMaterialAttributeValueTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectMaterialAttribute extends ProjectMaterialAttribute {
  @override
  final String code;
  @override
  final String label;
  @override
  final ProjectMaterialAttributeValueTypeEnum valueType;
  @override
  final BuiltList<String>? allowedValues;
  @override
  final String? unitCode;
  @override
  final BuiltList<String>? offeredValues;

  factory _$ProjectMaterialAttribute(
          [void Function(ProjectMaterialAttributeBuilder)? updates]) =>
      (ProjectMaterialAttributeBuilder()..update(updates))._build();

  _$ProjectMaterialAttribute._(
      {required this.code,
      required this.label,
      required this.valueType,
      this.allowedValues,
      this.unitCode,
      this.offeredValues})
      : super._();
  @override
  ProjectMaterialAttribute rebuild(
          void Function(ProjectMaterialAttributeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectMaterialAttributeBuilder toBuilder() =>
      ProjectMaterialAttributeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectMaterialAttribute &&
        code == other.code &&
        label == other.label &&
        valueType == other.valueType &&
        allowedValues == other.allowedValues &&
        unitCode == other.unitCode &&
        offeredValues == other.offeredValues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, valueType.hashCode);
    _$hash = $jc(_$hash, allowedValues.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, offeredValues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectMaterialAttribute')
          ..add('code', code)
          ..add('label', label)
          ..add('valueType', valueType)
          ..add('allowedValues', allowedValues)
          ..add('unitCode', unitCode)
          ..add('offeredValues', offeredValues))
        .toString();
  }
}

class ProjectMaterialAttributeBuilder
    implements
        Builder<ProjectMaterialAttribute, ProjectMaterialAttributeBuilder> {
  _$ProjectMaterialAttribute? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ProjectMaterialAttributeValueTypeEnum? _valueType;
  ProjectMaterialAttributeValueTypeEnum? get valueType => _$this._valueType;
  set valueType(ProjectMaterialAttributeValueTypeEnum? valueType) =>
      _$this._valueType = valueType;

  ListBuilder<String>? _allowedValues;
  ListBuilder<String> get allowedValues =>
      _$this._allowedValues ??= ListBuilder<String>();
  set allowedValues(ListBuilder<String>? allowedValues) =>
      _$this._allowedValues = allowedValues;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  ListBuilder<String>? _offeredValues;
  ListBuilder<String> get offeredValues =>
      _$this._offeredValues ??= ListBuilder<String>();
  set offeredValues(ListBuilder<String>? offeredValues) =>
      _$this._offeredValues = offeredValues;

  ProjectMaterialAttributeBuilder() {
    ProjectMaterialAttribute._defaults(this);
  }

  ProjectMaterialAttributeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _valueType = $v.valueType;
      _allowedValues = $v.allowedValues?.toBuilder();
      _unitCode = $v.unitCode;
      _offeredValues = $v.offeredValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectMaterialAttribute other) {
    _$v = other as _$ProjectMaterialAttribute;
  }

  @override
  void update(void Function(ProjectMaterialAttributeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectMaterialAttribute build() => _build();

  _$ProjectMaterialAttribute _build() {
    _$ProjectMaterialAttribute _$result;
    try {
      _$result = _$v ??
          _$ProjectMaterialAttribute._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ProjectMaterialAttribute', 'code'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'ProjectMaterialAttribute', 'label'),
            valueType: BuiltValueNullFieldError.checkNotNull(
                valueType, r'ProjectMaterialAttribute', 'valueType'),
            allowedValues: _allowedValues?.build(),
            unitCode: unitCode,
            offeredValues: _offeredValues?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allowedValues';
        _allowedValues?.build();

        _$failedField = 'offeredValues';
        _offeredValues?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectMaterialAttribute', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
