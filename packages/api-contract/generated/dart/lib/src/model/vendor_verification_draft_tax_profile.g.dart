// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_draft_tax_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorVerificationDraftTaxProfileEntityClassEnum
    _$vendorVerificationDraftTaxProfileEntityClassEnum_INDIVIDUAL =
    const VendorVerificationDraftTaxProfileEntityClassEnum._('INDIVIDUAL');
const VendorVerificationDraftTaxProfileEntityClassEnum
    _$vendorVerificationDraftTaxProfileEntityClassEnum_CORPORATION =
    const VendorVerificationDraftTaxProfileEntityClassEnum._('CORPORATION');
const VendorVerificationDraftTaxProfileEntityClassEnum
    _$vendorVerificationDraftTaxProfileEntityClassEnum_PARTNERSHIP =
    const VendorVerificationDraftTaxProfileEntityClassEnum._('PARTNERSHIP');
const VendorVerificationDraftTaxProfileEntityClassEnum
    _$vendorVerificationDraftTaxProfileEntityClassEnum_COOPERATIVE =
    const VendorVerificationDraftTaxProfileEntityClassEnum._('COOPERATIVE');

VendorVerificationDraftTaxProfileEntityClassEnum
    _$vendorVerificationDraftTaxProfileEntityClassEnumValueOf(String name) {
  switch (name) {
    case 'INDIVIDUAL':
      return _$vendorVerificationDraftTaxProfileEntityClassEnum_INDIVIDUAL;
    case 'CORPORATION':
      return _$vendorVerificationDraftTaxProfileEntityClassEnum_CORPORATION;
    case 'PARTNERSHIP':
      return _$vendorVerificationDraftTaxProfileEntityClassEnum_PARTNERSHIP;
    case 'COOPERATIVE':
      return _$vendorVerificationDraftTaxProfileEntityClassEnum_COOPERATIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVerificationDraftTaxProfileEntityClassEnum>
    _$vendorVerificationDraftTaxProfileEntityClassEnumValues = BuiltSet<
        VendorVerificationDraftTaxProfileEntityClassEnum>(const <VendorVerificationDraftTaxProfileEntityClassEnum>[
  _$vendorVerificationDraftTaxProfileEntityClassEnum_INDIVIDUAL,
  _$vendorVerificationDraftTaxProfileEntityClassEnum_CORPORATION,
  _$vendorVerificationDraftTaxProfileEntityClassEnum_PARTNERSHIP,
  _$vendorVerificationDraftTaxProfileEntityClassEnum_COOPERATIVE,
]);

const VendorVerificationDraftTaxProfileVatCategoryEnum
    _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT =
    const VendorVerificationDraftTaxProfileVatCategoryEnum._('VAT');
const VendorVerificationDraftTaxProfileVatCategoryEnum
    _$vendorVerificationDraftTaxProfileVatCategoryEnum_NON_VAT =
    const VendorVerificationDraftTaxProfileVatCategoryEnum._('NON_VAT');
const VendorVerificationDraftTaxProfileVatCategoryEnum
    _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_ZERO =
    const VendorVerificationDraftTaxProfileVatCategoryEnum._('VAT_ZERO');
const VendorVerificationDraftTaxProfileVatCategoryEnum
    _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_EXEMPT =
    const VendorVerificationDraftTaxProfileVatCategoryEnum._('VAT_EXEMPT');

VendorVerificationDraftTaxProfileVatCategoryEnum
    _$vendorVerificationDraftTaxProfileVatCategoryEnumValueOf(String name) {
  switch (name) {
    case 'VAT':
      return _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT;
    case 'NON_VAT':
      return _$vendorVerificationDraftTaxProfileVatCategoryEnum_NON_VAT;
    case 'VAT_ZERO':
      return _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_ZERO;
    case 'VAT_EXEMPT':
      return _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_EXEMPT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVerificationDraftTaxProfileVatCategoryEnum>
    _$vendorVerificationDraftTaxProfileVatCategoryEnumValues = BuiltSet<
        VendorVerificationDraftTaxProfileVatCategoryEnum>(const <VendorVerificationDraftTaxProfileVatCategoryEnum>[
  _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT,
  _$vendorVerificationDraftTaxProfileVatCategoryEnum_NON_VAT,
  _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_ZERO,
  _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_EXEMPT,
]);

const VendorVerificationDraftTaxProfileWithholdingScenarioEnum
    _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PLATFORM_WITHHOLDER =
    const VendorVerificationDraftTaxProfileWithholdingScenarioEnum._(
        'DEMO_PLATFORM_WITHHOLDER');
const VendorVerificationDraftTaxProfileWithholdingScenarioEnum
    _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PROVIDER_WITHHOLDER =
    const VendorVerificationDraftTaxProfileWithholdingScenarioEnum._(
        'DEMO_PROVIDER_WITHHOLDER');

VendorVerificationDraftTaxProfileWithholdingScenarioEnum
    _$vendorVerificationDraftTaxProfileWithholdingScenarioEnumValueOf(
        String name) {
  switch (name) {
    case 'DEMO_PLATFORM_WITHHOLDER':
      return _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PLATFORM_WITHHOLDER;
    case 'DEMO_PROVIDER_WITHHOLDER':
      return _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PROVIDER_WITHHOLDER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVerificationDraftTaxProfileWithholdingScenarioEnum>
    _$vendorVerificationDraftTaxProfileWithholdingScenarioEnumValues = BuiltSet<
        VendorVerificationDraftTaxProfileWithholdingScenarioEnum>(const <VendorVerificationDraftTaxProfileWithholdingScenarioEnum>[
  _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PLATFORM_WITHHOLDER,
  _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PROVIDER_WITHHOLDER,
]);

Serializer<VendorVerificationDraftTaxProfileEntityClassEnum>
    _$vendorVerificationDraftTaxProfileEntityClassEnumSerializer =
    _$VendorVerificationDraftTaxProfileEntityClassEnumSerializer();
Serializer<VendorVerificationDraftTaxProfileVatCategoryEnum>
    _$vendorVerificationDraftTaxProfileVatCategoryEnumSerializer =
    _$VendorVerificationDraftTaxProfileVatCategoryEnumSerializer();
Serializer<VendorVerificationDraftTaxProfileWithholdingScenarioEnum>
    _$vendorVerificationDraftTaxProfileWithholdingScenarioEnumSerializer =
    _$VendorVerificationDraftTaxProfileWithholdingScenarioEnumSerializer();

class _$VendorVerificationDraftTaxProfileEntityClassEnumSerializer
    implements
        PrimitiveSerializer<VendorVerificationDraftTaxProfileEntityClassEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'CORPORATION': 'CORPORATION',
    'PARTNERSHIP': 'PARTNERSHIP',
    'COOPERATIVE': 'COOPERATIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'CORPORATION': 'CORPORATION',
    'PARTNERSHIP': 'PARTNERSHIP',
    'COOPERATIVE': 'COOPERATIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorVerificationDraftTaxProfileEntityClassEnum
  ];
  @override
  final String wireName = 'VendorVerificationDraftTaxProfileEntityClassEnum';

  @override
  Object serialize(Serializers serializers,
          VendorVerificationDraftTaxProfileEntityClassEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVerificationDraftTaxProfileEntityClassEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVerificationDraftTaxProfileEntityClassEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVerificationDraftTaxProfileVatCategoryEnumSerializer
    implements
        PrimitiveSerializer<VendorVerificationDraftTaxProfileVatCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VAT': 'VAT',
    'NON_VAT': 'NON_VAT',
    'VAT_ZERO': 'VAT_ZERO',
    'VAT_EXEMPT': 'VAT_EXEMPT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VAT': 'VAT',
    'NON_VAT': 'NON_VAT',
    'VAT_ZERO': 'VAT_ZERO',
    'VAT_EXEMPT': 'VAT_EXEMPT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorVerificationDraftTaxProfileVatCategoryEnum
  ];
  @override
  final String wireName = 'VendorVerificationDraftTaxProfileVatCategoryEnum';

  @override
  Object serialize(Serializers serializers,
          VendorVerificationDraftTaxProfileVatCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVerificationDraftTaxProfileVatCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVerificationDraftTaxProfileVatCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVerificationDraftTaxProfileWithholdingScenarioEnumSerializer
    implements
        PrimitiveSerializer<
            VendorVerificationDraftTaxProfileWithholdingScenarioEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEMO_PLATFORM_WITHHOLDER': 'DEMO_PLATFORM_WITHHOLDER',
    'DEMO_PROVIDER_WITHHOLDER': 'DEMO_PROVIDER_WITHHOLDER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEMO_PLATFORM_WITHHOLDER': 'DEMO_PLATFORM_WITHHOLDER',
    'DEMO_PROVIDER_WITHHOLDER': 'DEMO_PROVIDER_WITHHOLDER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorVerificationDraftTaxProfileWithholdingScenarioEnum
  ];
  @override
  final String wireName =
      'VendorVerificationDraftTaxProfileWithholdingScenarioEnum';

  @override
  Object serialize(Serializers serializers,
          VendorVerificationDraftTaxProfileWithholdingScenarioEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVerificationDraftTaxProfileWithholdingScenarioEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVerificationDraftTaxProfileWithholdingScenarioEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVerificationDraftTaxProfile
    extends VendorVerificationDraftTaxProfile {
  @override
  final String? taxpayerKey;
  @override
  final String? tin;
  @override
  final String? branchCode;
  @override
  final String? birCorReference;
  @override
  final VendorVerificationDraftTaxProfileEntityClassEnum? entityClass;
  @override
  final String? registrationCategory;
  @override
  final VendorVerificationDraftTaxProfileVatCategoryEnum? vatCategory;
  @override
  final int? fiscalYearStartMonth;
  @override
  final String? declarationType;
  @override
  final String? thresholdPosition;
  @override
  final Date? submissionDate;
  @override
  final Date? outsidePlatformAsOf;
  @override
  final VendorVerificationDraftTaxProfileWithholdingScenarioEnum?
      withholdingScenario;
  @override
  final bool? taxReliefClaimed;
  @override
  final bool? ownerAttested;

  factory _$VendorVerificationDraftTaxProfile(
          [void Function(VendorVerificationDraftTaxProfileBuilder)? updates]) =>
      (VendorVerificationDraftTaxProfileBuilder()..update(updates))._build();

  _$VendorVerificationDraftTaxProfile._(
      {this.taxpayerKey,
      this.tin,
      this.branchCode,
      this.birCorReference,
      this.entityClass,
      this.registrationCategory,
      this.vatCategory,
      this.fiscalYearStartMonth,
      this.declarationType,
      this.thresholdPosition,
      this.submissionDate,
      this.outsidePlatformAsOf,
      this.withholdingScenario,
      this.taxReliefClaimed,
      this.ownerAttested})
      : super._();
  @override
  VendorVerificationDraftTaxProfile rebuild(
          void Function(VendorVerificationDraftTaxProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationDraftTaxProfileBuilder toBuilder() =>
      VendorVerificationDraftTaxProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationDraftTaxProfile &&
        taxpayerKey == other.taxpayerKey &&
        tin == other.tin &&
        branchCode == other.branchCode &&
        birCorReference == other.birCorReference &&
        entityClass == other.entityClass &&
        registrationCategory == other.registrationCategory &&
        vatCategory == other.vatCategory &&
        fiscalYearStartMonth == other.fiscalYearStartMonth &&
        declarationType == other.declarationType &&
        thresholdPosition == other.thresholdPosition &&
        submissionDate == other.submissionDate &&
        outsidePlatformAsOf == other.outsidePlatformAsOf &&
        withholdingScenario == other.withholdingScenario &&
        taxReliefClaimed == other.taxReliefClaimed &&
        ownerAttested == other.ownerAttested;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, taxpayerKey.hashCode);
    _$hash = $jc(_$hash, tin.hashCode);
    _$hash = $jc(_$hash, branchCode.hashCode);
    _$hash = $jc(_$hash, birCorReference.hashCode);
    _$hash = $jc(_$hash, entityClass.hashCode);
    _$hash = $jc(_$hash, registrationCategory.hashCode);
    _$hash = $jc(_$hash, vatCategory.hashCode);
    _$hash = $jc(_$hash, fiscalYearStartMonth.hashCode);
    _$hash = $jc(_$hash, declarationType.hashCode);
    _$hash = $jc(_$hash, thresholdPosition.hashCode);
    _$hash = $jc(_$hash, submissionDate.hashCode);
    _$hash = $jc(_$hash, outsidePlatformAsOf.hashCode);
    _$hash = $jc(_$hash, withholdingScenario.hashCode);
    _$hash = $jc(_$hash, taxReliefClaimed.hashCode);
    _$hash = $jc(_$hash, ownerAttested.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorVerificationDraftTaxProfile')
          ..add('taxpayerKey', taxpayerKey)
          ..add('tin', tin)
          ..add('branchCode', branchCode)
          ..add('birCorReference', birCorReference)
          ..add('entityClass', entityClass)
          ..add('registrationCategory', registrationCategory)
          ..add('vatCategory', vatCategory)
          ..add('fiscalYearStartMonth', fiscalYearStartMonth)
          ..add('declarationType', declarationType)
          ..add('thresholdPosition', thresholdPosition)
          ..add('submissionDate', submissionDate)
          ..add('outsidePlatformAsOf', outsidePlatformAsOf)
          ..add('withholdingScenario', withholdingScenario)
          ..add('taxReliefClaimed', taxReliefClaimed)
          ..add('ownerAttested', ownerAttested))
        .toString();
  }
}

class VendorVerificationDraftTaxProfileBuilder
    implements
        Builder<VendorVerificationDraftTaxProfile,
            VendorVerificationDraftTaxProfileBuilder> {
  _$VendorVerificationDraftTaxProfile? _$v;

  String? _taxpayerKey;
  String? get taxpayerKey => _$this._taxpayerKey;
  set taxpayerKey(String? taxpayerKey) => _$this._taxpayerKey = taxpayerKey;

  String? _tin;
  String? get tin => _$this._tin;
  set tin(String? tin) => _$this._tin = tin;

  String? _branchCode;
  String? get branchCode => _$this._branchCode;
  set branchCode(String? branchCode) => _$this._branchCode = branchCode;

  String? _birCorReference;
  String? get birCorReference => _$this._birCorReference;
  set birCorReference(String? birCorReference) =>
      _$this._birCorReference = birCorReference;

  VendorVerificationDraftTaxProfileEntityClassEnum? _entityClass;
  VendorVerificationDraftTaxProfileEntityClassEnum? get entityClass =>
      _$this._entityClass;
  set entityClass(
          VendorVerificationDraftTaxProfileEntityClassEnum? entityClass) =>
      _$this._entityClass = entityClass;

  String? _registrationCategory;
  String? get registrationCategory => _$this._registrationCategory;
  set registrationCategory(String? registrationCategory) =>
      _$this._registrationCategory = registrationCategory;

  VendorVerificationDraftTaxProfileVatCategoryEnum? _vatCategory;
  VendorVerificationDraftTaxProfileVatCategoryEnum? get vatCategory =>
      _$this._vatCategory;
  set vatCategory(
          VendorVerificationDraftTaxProfileVatCategoryEnum? vatCategory) =>
      _$this._vatCategory = vatCategory;

  int? _fiscalYearStartMonth;
  int? get fiscalYearStartMonth => _$this._fiscalYearStartMonth;
  set fiscalYearStartMonth(int? fiscalYearStartMonth) =>
      _$this._fiscalYearStartMonth = fiscalYearStartMonth;

  String? _declarationType;
  String? get declarationType => _$this._declarationType;
  set declarationType(String? declarationType) =>
      _$this._declarationType = declarationType;

  String? _thresholdPosition;
  String? get thresholdPosition => _$this._thresholdPosition;
  set thresholdPosition(String? thresholdPosition) =>
      _$this._thresholdPosition = thresholdPosition;

  Date? _submissionDate;
  Date? get submissionDate => _$this._submissionDate;
  set submissionDate(Date? submissionDate) =>
      _$this._submissionDate = submissionDate;

  Date? _outsidePlatformAsOf;
  Date? get outsidePlatformAsOf => _$this._outsidePlatformAsOf;
  set outsidePlatformAsOf(Date? outsidePlatformAsOf) =>
      _$this._outsidePlatformAsOf = outsidePlatformAsOf;

  VendorVerificationDraftTaxProfileWithholdingScenarioEnum?
      _withholdingScenario;
  VendorVerificationDraftTaxProfileWithholdingScenarioEnum?
      get withholdingScenario => _$this._withholdingScenario;
  set withholdingScenario(
          VendorVerificationDraftTaxProfileWithholdingScenarioEnum?
              withholdingScenario) =>
      _$this._withholdingScenario = withholdingScenario;

  bool? _taxReliefClaimed;
  bool? get taxReliefClaimed => _$this._taxReliefClaimed;
  set taxReliefClaimed(bool? taxReliefClaimed) =>
      _$this._taxReliefClaimed = taxReliefClaimed;

  bool? _ownerAttested;
  bool? get ownerAttested => _$this._ownerAttested;
  set ownerAttested(bool? ownerAttested) =>
      _$this._ownerAttested = ownerAttested;

  VendorVerificationDraftTaxProfileBuilder() {
    VendorVerificationDraftTaxProfile._defaults(this);
  }

  VendorVerificationDraftTaxProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _taxpayerKey = $v.taxpayerKey;
      _tin = $v.tin;
      _branchCode = $v.branchCode;
      _birCorReference = $v.birCorReference;
      _entityClass = $v.entityClass;
      _registrationCategory = $v.registrationCategory;
      _vatCategory = $v.vatCategory;
      _fiscalYearStartMonth = $v.fiscalYearStartMonth;
      _declarationType = $v.declarationType;
      _thresholdPosition = $v.thresholdPosition;
      _submissionDate = $v.submissionDate;
      _outsidePlatformAsOf = $v.outsidePlatformAsOf;
      _withholdingScenario = $v.withholdingScenario;
      _taxReliefClaimed = $v.taxReliefClaimed;
      _ownerAttested = $v.ownerAttested;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVerificationDraftTaxProfile other) {
    _$v = other as _$VendorVerificationDraftTaxProfile;
  }

  @override
  void update(
      void Function(VendorVerificationDraftTaxProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationDraftTaxProfile build() => _build();

  _$VendorVerificationDraftTaxProfile _build() {
    final _$result = _$v ??
        _$VendorVerificationDraftTaxProfile._(
          taxpayerKey: taxpayerKey,
          tin: tin,
          branchCode: branchCode,
          birCorReference: birCorReference,
          entityClass: entityClass,
          registrationCategory: registrationCategory,
          vatCategory: vatCategory,
          fiscalYearStartMonth: fiscalYearStartMonth,
          declarationType: declarationType,
          thresholdPosition: thresholdPosition,
          submissionDate: submissionDate,
          outsidePlatformAsOf: outsidePlatformAsOf,
          withholdingScenario: withholdingScenario,
          taxReliefClaimed: taxReliefClaimed,
          ownerAttested: ownerAttested,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
