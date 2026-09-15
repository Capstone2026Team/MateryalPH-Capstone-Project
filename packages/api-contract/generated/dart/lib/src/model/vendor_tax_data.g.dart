// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tax_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTaxDataEntityClassEnum _$vendorTaxDataEntityClassEnum_INDIVIDUAL =
    const VendorTaxDataEntityClassEnum._('INDIVIDUAL');
const VendorTaxDataEntityClassEnum _$vendorTaxDataEntityClassEnum_CORPORATE =
    const VendorTaxDataEntityClassEnum._('CORPORATE');

VendorTaxDataEntityClassEnum _$vendorTaxDataEntityClassEnumValueOf(
    String name) {
  switch (name) {
    case 'INDIVIDUAL':
      return _$vendorTaxDataEntityClassEnum_INDIVIDUAL;
    case 'CORPORATE':
      return _$vendorTaxDataEntityClassEnum_CORPORATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTaxDataEntityClassEnum>
    _$vendorTaxDataEntityClassEnumValues =
    BuiltSet<VendorTaxDataEntityClassEnum>(const <VendorTaxDataEntityClassEnum>[
  _$vendorTaxDataEntityClassEnum_INDIVIDUAL,
  _$vendorTaxDataEntityClassEnum_CORPORATE,
]);

const VendorTaxDataVatCategoryEnum
    _$vendorTaxDataVatCategoryEnum_VAT_REGISTERED =
    const VendorTaxDataVatCategoryEnum._('VAT_REGISTERED');
const VendorTaxDataVatCategoryEnum _$vendorTaxDataVatCategoryEnum_NON_VAT =
    const VendorTaxDataVatCategoryEnum._('NON_VAT');

VendorTaxDataVatCategoryEnum _$vendorTaxDataVatCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'VAT_REGISTERED':
      return _$vendorTaxDataVatCategoryEnum_VAT_REGISTERED;
    case 'NON_VAT':
      return _$vendorTaxDataVatCategoryEnum_NON_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTaxDataVatCategoryEnum>
    _$vendorTaxDataVatCategoryEnumValues =
    BuiltSet<VendorTaxDataVatCategoryEnum>(const <VendorTaxDataVatCategoryEnum>[
  _$vendorTaxDataVatCategoryEnum_VAT_REGISTERED,
  _$vendorTaxDataVatCategoryEnum_NON_VAT,
]);

Serializer<VendorTaxDataEntityClassEnum>
    _$vendorTaxDataEntityClassEnumSerializer =
    _$VendorTaxDataEntityClassEnumSerializer();
Serializer<VendorTaxDataVatCategoryEnum>
    _$vendorTaxDataVatCategoryEnumSerializer =
    _$VendorTaxDataVatCategoryEnumSerializer();

class _$VendorTaxDataEntityClassEnumSerializer
    implements PrimitiveSerializer<VendorTaxDataEntityClassEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'CORPORATE': 'CORPORATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'CORPORATE': 'CORPORATE',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorTaxDataEntityClassEnum];
  @override
  final String wireName = 'VendorTaxDataEntityClassEnum';

  @override
  Object serialize(Serializers serializers, VendorTaxDataEntityClassEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTaxDataEntityClassEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTaxDataEntityClassEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTaxDataVatCategoryEnumSerializer
    implements PrimitiveSerializer<VendorTaxDataVatCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VAT_REGISTERED': 'VAT_REGISTERED',
    'NON_VAT': 'NON_VAT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VAT_REGISTERED': 'VAT_REGISTERED',
    'NON_VAT': 'NON_VAT',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorTaxDataVatCategoryEnum];
  @override
  final String wireName = 'VendorTaxDataVatCategoryEnum';

  @override
  Object serialize(Serializers serializers, VendorTaxDataVatCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTaxDataVatCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTaxDataVatCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTaxData extends VendorTaxData {
  @override
  final String taxpayerKey;
  @override
  final String legalName;
  @override
  final String tradeName;
  @override
  final String tin;
  @override
  final String? branchCode;
  @override
  final VendorTaxDataEntityClassEnum entityClass;
  @override
  final String registrationCategory;
  @override
  final VendorTaxDataVatCategoryEnum vatCategory;
  @override
  final int fiscalYearStartMonth;
  @override
  final String effectiveFrom;
  @override
  final String? effectiveUntil;
  @override
  final String birCorVersionId;
  @override
  final String invoiceMethod;
  @override
  final String invoiceCoverage;
  @override
  final int? priorYearAmountCentavos;
  @override
  final String? priorYearPosition;
  @override
  final int? declarationYear;
  @override
  final String? declarationReceipt;
  @override
  final String? declarationValidFrom;
  @override
  final String? declarationValidUntil;
  @override
  final int? outsidePlatformAmountCentavos;
  @override
  final String? outsidePlatformAsOf;
  @override
  final String? overlapScope;
  @override
  final BuiltList<String>? evidenceVersionIds;

  factory _$VendorTaxData([void Function(VendorTaxDataBuilder)? updates]) =>
      (VendorTaxDataBuilder()..update(updates))._build();

  _$VendorTaxData._(
      {required this.taxpayerKey,
      required this.legalName,
      required this.tradeName,
      required this.tin,
      this.branchCode,
      required this.entityClass,
      required this.registrationCategory,
      required this.vatCategory,
      required this.fiscalYearStartMonth,
      required this.effectiveFrom,
      this.effectiveUntil,
      required this.birCorVersionId,
      required this.invoiceMethod,
      required this.invoiceCoverage,
      this.priorYearAmountCentavos,
      this.priorYearPosition,
      this.declarationYear,
      this.declarationReceipt,
      this.declarationValidFrom,
      this.declarationValidUntil,
      this.outsidePlatformAmountCentavos,
      this.outsidePlatformAsOf,
      this.overlapScope,
      this.evidenceVersionIds})
      : super._();
  @override
  VendorTaxData rebuild(void Function(VendorTaxDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTaxDataBuilder toBuilder() => VendorTaxDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTaxData &&
        taxpayerKey == other.taxpayerKey &&
        legalName == other.legalName &&
        tradeName == other.tradeName &&
        tin == other.tin &&
        branchCode == other.branchCode &&
        entityClass == other.entityClass &&
        registrationCategory == other.registrationCategory &&
        vatCategory == other.vatCategory &&
        fiscalYearStartMonth == other.fiscalYearStartMonth &&
        effectiveFrom == other.effectiveFrom &&
        effectiveUntil == other.effectiveUntil &&
        birCorVersionId == other.birCorVersionId &&
        invoiceMethod == other.invoiceMethod &&
        invoiceCoverage == other.invoiceCoverage &&
        priorYearAmountCentavos == other.priorYearAmountCentavos &&
        priorYearPosition == other.priorYearPosition &&
        declarationYear == other.declarationYear &&
        declarationReceipt == other.declarationReceipt &&
        declarationValidFrom == other.declarationValidFrom &&
        declarationValidUntil == other.declarationValidUntil &&
        outsidePlatformAmountCentavos == other.outsidePlatformAmountCentavos &&
        outsidePlatformAsOf == other.outsidePlatformAsOf &&
        overlapScope == other.overlapScope &&
        evidenceVersionIds == other.evidenceVersionIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, taxpayerKey.hashCode);
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, tradeName.hashCode);
    _$hash = $jc(_$hash, tin.hashCode);
    _$hash = $jc(_$hash, branchCode.hashCode);
    _$hash = $jc(_$hash, entityClass.hashCode);
    _$hash = $jc(_$hash, registrationCategory.hashCode);
    _$hash = $jc(_$hash, vatCategory.hashCode);
    _$hash = $jc(_$hash, fiscalYearStartMonth.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveUntil.hashCode);
    _$hash = $jc(_$hash, birCorVersionId.hashCode);
    _$hash = $jc(_$hash, invoiceMethod.hashCode);
    _$hash = $jc(_$hash, invoiceCoverage.hashCode);
    _$hash = $jc(_$hash, priorYearAmountCentavos.hashCode);
    _$hash = $jc(_$hash, priorYearPosition.hashCode);
    _$hash = $jc(_$hash, declarationYear.hashCode);
    _$hash = $jc(_$hash, declarationReceipt.hashCode);
    _$hash = $jc(_$hash, declarationValidFrom.hashCode);
    _$hash = $jc(_$hash, declarationValidUntil.hashCode);
    _$hash = $jc(_$hash, outsidePlatformAmountCentavos.hashCode);
    _$hash = $jc(_$hash, outsidePlatformAsOf.hashCode);
    _$hash = $jc(_$hash, overlapScope.hashCode);
    _$hash = $jc(_$hash, evidenceVersionIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTaxData')
          ..add('taxpayerKey', taxpayerKey)
          ..add('legalName', legalName)
          ..add('tradeName', tradeName)
          ..add('tin', tin)
          ..add('branchCode', branchCode)
          ..add('entityClass', entityClass)
          ..add('registrationCategory', registrationCategory)
          ..add('vatCategory', vatCategory)
          ..add('fiscalYearStartMonth', fiscalYearStartMonth)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveUntil', effectiveUntil)
          ..add('birCorVersionId', birCorVersionId)
          ..add('invoiceMethod', invoiceMethod)
          ..add('invoiceCoverage', invoiceCoverage)
          ..add('priorYearAmountCentavos', priorYearAmountCentavos)
          ..add('priorYearPosition', priorYearPosition)
          ..add('declarationYear', declarationYear)
          ..add('declarationReceipt', declarationReceipt)
          ..add('declarationValidFrom', declarationValidFrom)
          ..add('declarationValidUntil', declarationValidUntil)
          ..add('outsidePlatformAmountCentavos', outsidePlatformAmountCentavos)
          ..add('outsidePlatformAsOf', outsidePlatformAsOf)
          ..add('overlapScope', overlapScope)
          ..add('evidenceVersionIds', evidenceVersionIds))
        .toString();
  }
}

class VendorTaxDataBuilder
    implements Builder<VendorTaxData, VendorTaxDataBuilder> {
  _$VendorTaxData? _$v;

  String? _taxpayerKey;
  String? get taxpayerKey => _$this._taxpayerKey;
  set taxpayerKey(String? taxpayerKey) => _$this._taxpayerKey = taxpayerKey;

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _tradeName;
  String? get tradeName => _$this._tradeName;
  set tradeName(String? tradeName) => _$this._tradeName = tradeName;

  String? _tin;
  String? get tin => _$this._tin;
  set tin(String? tin) => _$this._tin = tin;

  String? _branchCode;
  String? get branchCode => _$this._branchCode;
  set branchCode(String? branchCode) => _$this._branchCode = branchCode;

  VendorTaxDataEntityClassEnum? _entityClass;
  VendorTaxDataEntityClassEnum? get entityClass => _$this._entityClass;
  set entityClass(VendorTaxDataEntityClassEnum? entityClass) =>
      _$this._entityClass = entityClass;

  String? _registrationCategory;
  String? get registrationCategory => _$this._registrationCategory;
  set registrationCategory(String? registrationCategory) =>
      _$this._registrationCategory = registrationCategory;

  VendorTaxDataVatCategoryEnum? _vatCategory;
  VendorTaxDataVatCategoryEnum? get vatCategory => _$this._vatCategory;
  set vatCategory(VendorTaxDataVatCategoryEnum? vatCategory) =>
      _$this._vatCategory = vatCategory;

  int? _fiscalYearStartMonth;
  int? get fiscalYearStartMonth => _$this._fiscalYearStartMonth;
  set fiscalYearStartMonth(int? fiscalYearStartMonth) =>
      _$this._fiscalYearStartMonth = fiscalYearStartMonth;

  String? _effectiveFrom;
  String? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(String? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  String? _effectiveUntil;
  String? get effectiveUntil => _$this._effectiveUntil;
  set effectiveUntil(String? effectiveUntil) =>
      _$this._effectiveUntil = effectiveUntil;

  String? _birCorVersionId;
  String? get birCorVersionId => _$this._birCorVersionId;
  set birCorVersionId(String? birCorVersionId) =>
      _$this._birCorVersionId = birCorVersionId;

  String? _invoiceMethod;
  String? get invoiceMethod => _$this._invoiceMethod;
  set invoiceMethod(String? invoiceMethod) =>
      _$this._invoiceMethod = invoiceMethod;

  String? _invoiceCoverage;
  String? get invoiceCoverage => _$this._invoiceCoverage;
  set invoiceCoverage(String? invoiceCoverage) =>
      _$this._invoiceCoverage = invoiceCoverage;

  int? _priorYearAmountCentavos;
  int? get priorYearAmountCentavos => _$this._priorYearAmountCentavos;
  set priorYearAmountCentavos(int? priorYearAmountCentavos) =>
      _$this._priorYearAmountCentavos = priorYearAmountCentavos;

  String? _priorYearPosition;
  String? get priorYearPosition => _$this._priorYearPosition;
  set priorYearPosition(String? priorYearPosition) =>
      _$this._priorYearPosition = priorYearPosition;

  int? _declarationYear;
  int? get declarationYear => _$this._declarationYear;
  set declarationYear(int? declarationYear) =>
      _$this._declarationYear = declarationYear;

  String? _declarationReceipt;
  String? get declarationReceipt => _$this._declarationReceipt;
  set declarationReceipt(String? declarationReceipt) =>
      _$this._declarationReceipt = declarationReceipt;

  String? _declarationValidFrom;
  String? get declarationValidFrom => _$this._declarationValidFrom;
  set declarationValidFrom(String? declarationValidFrom) =>
      _$this._declarationValidFrom = declarationValidFrom;

  String? _declarationValidUntil;
  String? get declarationValidUntil => _$this._declarationValidUntil;
  set declarationValidUntil(String? declarationValidUntil) =>
      _$this._declarationValidUntil = declarationValidUntil;

  int? _outsidePlatformAmountCentavos;
  int? get outsidePlatformAmountCentavos =>
      _$this._outsidePlatformAmountCentavos;
  set outsidePlatformAmountCentavos(int? outsidePlatformAmountCentavos) =>
      _$this._outsidePlatformAmountCentavos = outsidePlatformAmountCentavos;

  String? _outsidePlatformAsOf;
  String? get outsidePlatformAsOf => _$this._outsidePlatformAsOf;
  set outsidePlatformAsOf(String? outsidePlatformAsOf) =>
      _$this._outsidePlatformAsOf = outsidePlatformAsOf;

  String? _overlapScope;
  String? get overlapScope => _$this._overlapScope;
  set overlapScope(String? overlapScope) => _$this._overlapScope = overlapScope;

  ListBuilder<String>? _evidenceVersionIds;
  ListBuilder<String> get evidenceVersionIds =>
      _$this._evidenceVersionIds ??= ListBuilder<String>();
  set evidenceVersionIds(ListBuilder<String>? evidenceVersionIds) =>
      _$this._evidenceVersionIds = evidenceVersionIds;

  VendorTaxDataBuilder() {
    VendorTaxData._defaults(this);
  }

  VendorTaxDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _taxpayerKey = $v.taxpayerKey;
      _legalName = $v.legalName;
      _tradeName = $v.tradeName;
      _tin = $v.tin;
      _branchCode = $v.branchCode;
      _entityClass = $v.entityClass;
      _registrationCategory = $v.registrationCategory;
      _vatCategory = $v.vatCategory;
      _fiscalYearStartMonth = $v.fiscalYearStartMonth;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveUntil = $v.effectiveUntil;
      _birCorVersionId = $v.birCorVersionId;
      _invoiceMethod = $v.invoiceMethod;
      _invoiceCoverage = $v.invoiceCoverage;
      _priorYearAmountCentavos = $v.priorYearAmountCentavos;
      _priorYearPosition = $v.priorYearPosition;
      _declarationYear = $v.declarationYear;
      _declarationReceipt = $v.declarationReceipt;
      _declarationValidFrom = $v.declarationValidFrom;
      _declarationValidUntil = $v.declarationValidUntil;
      _outsidePlatformAmountCentavos = $v.outsidePlatformAmountCentavos;
      _outsidePlatformAsOf = $v.outsidePlatformAsOf;
      _overlapScope = $v.overlapScope;
      _evidenceVersionIds = $v.evidenceVersionIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTaxData other) {
    _$v = other as _$VendorTaxData;
  }

  @override
  void update(void Function(VendorTaxDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTaxData build() => _build();

  _$VendorTaxData _build() {
    _$VendorTaxData _$result;
    try {
      _$result = _$v ??
          _$VendorTaxData._(
            taxpayerKey: BuiltValueNullFieldError.checkNotNull(
                taxpayerKey, r'VendorTaxData', 'taxpayerKey'),
            legalName: BuiltValueNullFieldError.checkNotNull(
                legalName, r'VendorTaxData', 'legalName'),
            tradeName: BuiltValueNullFieldError.checkNotNull(
                tradeName, r'VendorTaxData', 'tradeName'),
            tin: BuiltValueNullFieldError.checkNotNull(
                tin, r'VendorTaxData', 'tin'),
            branchCode: branchCode,
            entityClass: BuiltValueNullFieldError.checkNotNull(
                entityClass, r'VendorTaxData', 'entityClass'),
            registrationCategory: BuiltValueNullFieldError.checkNotNull(
                registrationCategory, r'VendorTaxData', 'registrationCategory'),
            vatCategory: BuiltValueNullFieldError.checkNotNull(
                vatCategory, r'VendorTaxData', 'vatCategory'),
            fiscalYearStartMonth: BuiltValueNullFieldError.checkNotNull(
                fiscalYearStartMonth, r'VendorTaxData', 'fiscalYearStartMonth'),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
                effectiveFrom, r'VendorTaxData', 'effectiveFrom'),
            effectiveUntil: effectiveUntil,
            birCorVersionId: BuiltValueNullFieldError.checkNotNull(
                birCorVersionId, r'VendorTaxData', 'birCorVersionId'),
            invoiceMethod: BuiltValueNullFieldError.checkNotNull(
                invoiceMethod, r'VendorTaxData', 'invoiceMethod'),
            invoiceCoverage: BuiltValueNullFieldError.checkNotNull(
                invoiceCoverage, r'VendorTaxData', 'invoiceCoverage'),
            priorYearAmountCentavos: priorYearAmountCentavos,
            priorYearPosition: priorYearPosition,
            declarationYear: declarationYear,
            declarationReceipt: declarationReceipt,
            declarationValidFrom: declarationValidFrom,
            declarationValidUntil: declarationValidUntil,
            outsidePlatformAmountCentavos: outsidePlatformAmountCentavos,
            outsidePlatformAsOf: outsidePlatformAsOf,
            overlapScope: overlapScope,
            evidenceVersionIds: _evidenceVersionIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'evidenceVersionIds';
        _evidenceVersionIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTaxData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
