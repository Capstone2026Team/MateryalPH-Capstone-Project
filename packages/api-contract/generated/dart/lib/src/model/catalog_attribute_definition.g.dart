// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_attribute_definition.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogAttributeDefinitionValueTypeEnum
    _$catalogAttributeDefinitionValueTypeEnum_TEXT =
    const CatalogAttributeDefinitionValueTypeEnum._('TEXT');
const CatalogAttributeDefinitionValueTypeEnum
    _$catalogAttributeDefinitionValueTypeEnum_NUMBER =
    const CatalogAttributeDefinitionValueTypeEnum._('NUMBER');
const CatalogAttributeDefinitionValueTypeEnum
    _$catalogAttributeDefinitionValueTypeEnum_ENUM =
    const CatalogAttributeDefinitionValueTypeEnum._('ENUM');

CatalogAttributeDefinitionValueTypeEnum
    _$catalogAttributeDefinitionValueTypeEnumValueOf(String name) {
  switch (name) {
    case 'TEXT':
      return _$catalogAttributeDefinitionValueTypeEnum_TEXT;
    case 'NUMBER':
      return _$catalogAttributeDefinitionValueTypeEnum_NUMBER;
    case 'ENUM':
      return _$catalogAttributeDefinitionValueTypeEnum_ENUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogAttributeDefinitionValueTypeEnum>
    _$catalogAttributeDefinitionValueTypeEnumValues = BuiltSet<
        CatalogAttributeDefinitionValueTypeEnum>(const <CatalogAttributeDefinitionValueTypeEnum>[
  _$catalogAttributeDefinitionValueTypeEnum_TEXT,
  _$catalogAttributeDefinitionValueTypeEnum_NUMBER,
  _$catalogAttributeDefinitionValueTypeEnum_ENUM,
]);

Serializer<CatalogAttributeDefinitionValueTypeEnum>
    _$catalogAttributeDefinitionValueTypeEnumSerializer =
    _$CatalogAttributeDefinitionValueTypeEnumSerializer();

class _$CatalogAttributeDefinitionValueTypeEnumSerializer
    implements PrimitiveSerializer<CatalogAttributeDefinitionValueTypeEnum> {
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
    CatalogAttributeDefinitionValueTypeEnum
  ];
  @override
  final String wireName = 'CatalogAttributeDefinitionValueTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CatalogAttributeDefinitionValueTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogAttributeDefinitionValueTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogAttributeDefinitionValueTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogAttributeDefinition extends CatalogAttributeDefinition {
  @override
  final String id;
  @override
  final String materialCategoryId;
  @override
  final String code;
  @override
  final String label;
  @override
  final CatalogAttributeDefinitionValueTypeEnum valueType;
  @override
  final bool required_;
  @override
  final BuiltList<String>? allowedValues;
  @override
  final String? unitCode;
  @override
  final bool comparabilityKey;

  factory _$CatalogAttributeDefinition(
          [void Function(CatalogAttributeDefinitionBuilder)? updates]) =>
      (CatalogAttributeDefinitionBuilder()..update(updates))._build();

  _$CatalogAttributeDefinition._(
      {required this.id,
      required this.materialCategoryId,
      required this.code,
      required this.label,
      required this.valueType,
      required this.required_,
      this.allowedValues,
      this.unitCode,
      required this.comparabilityKey})
      : super._();
  @override
  CatalogAttributeDefinition rebuild(
          void Function(CatalogAttributeDefinitionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogAttributeDefinitionBuilder toBuilder() =>
      CatalogAttributeDefinitionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogAttributeDefinition &&
        id == other.id &&
        materialCategoryId == other.materialCategoryId &&
        code == other.code &&
        label == other.label &&
        valueType == other.valueType &&
        required_ == other.required_ &&
        allowedValues == other.allowedValues &&
        unitCode == other.unitCode &&
        comparabilityKey == other.comparabilityKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, materialCategoryId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, valueType.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jc(_$hash, allowedValues.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, comparabilityKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogAttributeDefinition')
          ..add('id', id)
          ..add('materialCategoryId', materialCategoryId)
          ..add('code', code)
          ..add('label', label)
          ..add('valueType', valueType)
          ..add('required_', required_)
          ..add('allowedValues', allowedValues)
          ..add('unitCode', unitCode)
          ..add('comparabilityKey', comparabilityKey))
        .toString();
  }
}

class CatalogAttributeDefinitionBuilder
    implements
        Builder<CatalogAttributeDefinition, CatalogAttributeDefinitionBuilder> {
  _$CatalogAttributeDefinition? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _materialCategoryId;
  String? get materialCategoryId => _$this._materialCategoryId;
  set materialCategoryId(String? materialCategoryId) =>
      _$this._materialCategoryId = materialCategoryId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  CatalogAttributeDefinitionValueTypeEnum? _valueType;
  CatalogAttributeDefinitionValueTypeEnum? get valueType => _$this._valueType;
  set valueType(CatalogAttributeDefinitionValueTypeEnum? valueType) =>
      _$this._valueType = valueType;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  ListBuilder<String>? _allowedValues;
  ListBuilder<String> get allowedValues =>
      _$this._allowedValues ??= ListBuilder<String>();
  set allowedValues(ListBuilder<String>? allowedValues) =>
      _$this._allowedValues = allowedValues;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  bool? _comparabilityKey;
  bool? get comparabilityKey => _$this._comparabilityKey;
  set comparabilityKey(bool? comparabilityKey) =>
      _$this._comparabilityKey = comparabilityKey;

  CatalogAttributeDefinitionBuilder() {
    CatalogAttributeDefinition._defaults(this);
  }

  CatalogAttributeDefinitionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _materialCategoryId = $v.materialCategoryId;
      _code = $v.code;
      _label = $v.label;
      _valueType = $v.valueType;
      _required_ = $v.required_;
      _allowedValues = $v.allowedValues?.toBuilder();
      _unitCode = $v.unitCode;
      _comparabilityKey = $v.comparabilityKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogAttributeDefinition other) {
    _$v = other as _$CatalogAttributeDefinition;
  }

  @override
  void update(void Function(CatalogAttributeDefinitionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogAttributeDefinition build() => _build();

  _$CatalogAttributeDefinition _build() {
    _$CatalogAttributeDefinition _$result;
    try {
      _$result = _$v ??
          _$CatalogAttributeDefinition._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CatalogAttributeDefinition', 'id'),
            materialCategoryId: BuiltValueNullFieldError.checkNotNull(
                materialCategoryId,
                r'CatalogAttributeDefinition',
                'materialCategoryId'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'CatalogAttributeDefinition', 'code'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'CatalogAttributeDefinition', 'label'),
            valueType: BuiltValueNullFieldError.checkNotNull(
                valueType, r'CatalogAttributeDefinition', 'valueType'),
            required_: BuiltValueNullFieldError.checkNotNull(
                required_, r'CatalogAttributeDefinition', 'required_'),
            allowedValues: _allowedValues?.build(),
            unitCode: unitCode,
            comparabilityKey: BuiltValueNullFieldError.checkNotNull(
                comparabilityKey,
                r'CatalogAttributeDefinition',
                'comparabilityKey'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allowedValues';
        _allowedValues?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogAttributeDefinition', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
