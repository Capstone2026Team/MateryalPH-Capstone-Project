// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regulated_material_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegulatedMaterialRuleRequiredMarkingEnum
    _$regulatedMaterialRuleRequiredMarkingEnum_PS_MARK =
    const RegulatedMaterialRuleRequiredMarkingEnum._('PS_MARK');
const RegulatedMaterialRuleRequiredMarkingEnum
    _$regulatedMaterialRuleRequiredMarkingEnum_ICC_STICKER =
    const RegulatedMaterialRuleRequiredMarkingEnum._('ICC_STICKER');
const RegulatedMaterialRuleRequiredMarkingEnum
    _$regulatedMaterialRuleRequiredMarkingEnum_PS_OR_ICC =
    const RegulatedMaterialRuleRequiredMarkingEnum._('PS_OR_ICC');

RegulatedMaterialRuleRequiredMarkingEnum
    _$regulatedMaterialRuleRequiredMarkingEnumValueOf(String name) {
  switch (name) {
    case 'PS_MARK':
      return _$regulatedMaterialRuleRequiredMarkingEnum_PS_MARK;
    case 'ICC_STICKER':
      return _$regulatedMaterialRuleRequiredMarkingEnum_ICC_STICKER;
    case 'PS_OR_ICC':
      return _$regulatedMaterialRuleRequiredMarkingEnum_PS_OR_ICC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegulatedMaterialRuleRequiredMarkingEnum>
    _$regulatedMaterialRuleRequiredMarkingEnumValues = BuiltSet<
        RegulatedMaterialRuleRequiredMarkingEnum>(const <RegulatedMaterialRuleRequiredMarkingEnum>[
  _$regulatedMaterialRuleRequiredMarkingEnum_PS_MARK,
  _$regulatedMaterialRuleRequiredMarkingEnum_ICC_STICKER,
  _$regulatedMaterialRuleRequiredMarkingEnum_PS_OR_ICC,
]);

Serializer<RegulatedMaterialRuleRequiredMarkingEnum>
    _$regulatedMaterialRuleRequiredMarkingEnumSerializer =
    _$RegulatedMaterialRuleRequiredMarkingEnumSerializer();

class _$RegulatedMaterialRuleRequiredMarkingEnumSerializer
    implements PrimitiveSerializer<RegulatedMaterialRuleRequiredMarkingEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PS_MARK': 'PS_MARK',
    'ICC_STICKER': 'ICC_STICKER',
    'PS_OR_ICC': 'PS_OR_ICC',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PS_MARK': 'PS_MARK',
    'ICC_STICKER': 'ICC_STICKER',
    'PS_OR_ICC': 'PS_OR_ICC',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RegulatedMaterialRuleRequiredMarkingEnum
  ];
  @override
  final String wireName = 'RegulatedMaterialRuleRequiredMarkingEnum';

  @override
  Object serialize(Serializers serializers,
          RegulatedMaterialRuleRequiredMarkingEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegulatedMaterialRuleRequiredMarkingEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegulatedMaterialRuleRequiredMarkingEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegulatedMaterialRule extends RegulatedMaterialRule {
  @override
  final String id;
  @override
  final int version;
  @override
  final RegulatedMaterialRuleRequiredMarkingEnum requiredMarking;
  @override
  final String? productName;
  @override
  final String? referenceStandard;
  @override
  final String? technicalRegulation;
  @override
  final String? scope;
  @override
  final BuiltList<String> markingRequirements;
  @override
  final String sourceReference;

  factory _$RegulatedMaterialRule(
          [void Function(RegulatedMaterialRuleBuilder)? updates]) =>
      (RegulatedMaterialRuleBuilder()..update(updates))._build();

  _$RegulatedMaterialRule._(
      {required this.id,
      required this.version,
      required this.requiredMarking,
      this.productName,
      this.referenceStandard,
      this.technicalRegulation,
      this.scope,
      required this.markingRequirements,
      required this.sourceReference})
      : super._();
  @override
  RegulatedMaterialRule rebuild(
          void Function(RegulatedMaterialRuleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegulatedMaterialRuleBuilder toBuilder() =>
      RegulatedMaterialRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegulatedMaterialRule &&
        id == other.id &&
        version == other.version &&
        requiredMarking == other.requiredMarking &&
        productName == other.productName &&
        referenceStandard == other.referenceStandard &&
        technicalRegulation == other.technicalRegulation &&
        scope == other.scope &&
        markingRequirements == other.markingRequirements &&
        sourceReference == other.sourceReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, requiredMarking.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, referenceStandard.hashCode);
    _$hash = $jc(_$hash, technicalRegulation.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, markingRequirements.hashCode);
    _$hash = $jc(_$hash, sourceReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegulatedMaterialRule')
          ..add('id', id)
          ..add('version', version)
          ..add('requiredMarking', requiredMarking)
          ..add('productName', productName)
          ..add('referenceStandard', referenceStandard)
          ..add('technicalRegulation', technicalRegulation)
          ..add('scope', scope)
          ..add('markingRequirements', markingRequirements)
          ..add('sourceReference', sourceReference))
        .toString();
  }
}

class RegulatedMaterialRuleBuilder
    implements Builder<RegulatedMaterialRule, RegulatedMaterialRuleBuilder> {
  _$RegulatedMaterialRule? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  RegulatedMaterialRuleRequiredMarkingEnum? _requiredMarking;
  RegulatedMaterialRuleRequiredMarkingEnum? get requiredMarking =>
      _$this._requiredMarking;
  set requiredMarking(
          RegulatedMaterialRuleRequiredMarkingEnum? requiredMarking) =>
      _$this._requiredMarking = requiredMarking;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  String? _referenceStandard;
  String? get referenceStandard => _$this._referenceStandard;
  set referenceStandard(String? referenceStandard) =>
      _$this._referenceStandard = referenceStandard;

  String? _technicalRegulation;
  String? get technicalRegulation => _$this._technicalRegulation;
  set technicalRegulation(String? technicalRegulation) =>
      _$this._technicalRegulation = technicalRegulation;

  String? _scope;
  String? get scope => _$this._scope;
  set scope(String? scope) => _$this._scope = scope;

  ListBuilder<String>? _markingRequirements;
  ListBuilder<String> get markingRequirements =>
      _$this._markingRequirements ??= ListBuilder<String>();
  set markingRequirements(ListBuilder<String>? markingRequirements) =>
      _$this._markingRequirements = markingRequirements;

  String? _sourceReference;
  String? get sourceReference => _$this._sourceReference;
  set sourceReference(String? sourceReference) =>
      _$this._sourceReference = sourceReference;

  RegulatedMaterialRuleBuilder() {
    RegulatedMaterialRule._defaults(this);
  }

  RegulatedMaterialRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _requiredMarking = $v.requiredMarking;
      _productName = $v.productName;
      _referenceStandard = $v.referenceStandard;
      _technicalRegulation = $v.technicalRegulation;
      _scope = $v.scope;
      _markingRequirements = $v.markingRequirements.toBuilder();
      _sourceReference = $v.sourceReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegulatedMaterialRule other) {
    _$v = other as _$RegulatedMaterialRule;
  }

  @override
  void update(void Function(RegulatedMaterialRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegulatedMaterialRule build() => _build();

  _$RegulatedMaterialRule _build() {
    _$RegulatedMaterialRule _$result;
    try {
      _$result = _$v ??
          _$RegulatedMaterialRule._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RegulatedMaterialRule', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'RegulatedMaterialRule', 'version'),
            requiredMarking: BuiltValueNullFieldError.checkNotNull(
                requiredMarking, r'RegulatedMaterialRule', 'requiredMarking'),
            productName: productName,
            referenceStandard: referenceStandard,
            technicalRegulation: technicalRegulation,
            scope: scope,
            markingRequirements: markingRequirements.build(),
            sourceReference: BuiltValueNullFieldError.checkNotNull(
                sourceReference, r'RegulatedMaterialRule', 'sourceReference'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'markingRequirements';
        markingRequirements.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegulatedMaterialRule', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
