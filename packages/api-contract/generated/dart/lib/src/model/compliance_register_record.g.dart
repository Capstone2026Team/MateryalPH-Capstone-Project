// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_register_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceRegisterRecordRegisterKindEnum
    _$complianceRegisterRecordRegisterKindEnum_PS_LICENSE =
    const ComplianceRegisterRecordRegisterKindEnum._('PS_LICENSE');
const ComplianceRegisterRecordRegisterKindEnum
    _$complianceRegisterRecordRegisterKindEnum_ICC_CERTIFICATE =
    const ComplianceRegisterRecordRegisterKindEnum._('ICC_CERTIFICATE');

ComplianceRegisterRecordRegisterKindEnum
    _$complianceRegisterRecordRegisterKindEnumValueOf(String name) {
  switch (name) {
    case 'PS_LICENSE':
      return _$complianceRegisterRecordRegisterKindEnum_PS_LICENSE;
    case 'ICC_CERTIFICATE':
      return _$complianceRegisterRecordRegisterKindEnum_ICC_CERTIFICATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceRegisterRecordRegisterKindEnum>
    _$complianceRegisterRecordRegisterKindEnumValues = BuiltSet<
        ComplianceRegisterRecordRegisterKindEnum>(const <ComplianceRegisterRecordRegisterKindEnum>[
  _$complianceRegisterRecordRegisterKindEnum_PS_LICENSE,
  _$complianceRegisterRecordRegisterKindEnum_ICC_CERTIFICATE,
]);

Serializer<ComplianceRegisterRecordRegisterKindEnum>
    _$complianceRegisterRecordRegisterKindEnumSerializer =
    _$ComplianceRegisterRecordRegisterKindEnumSerializer();

class _$ComplianceRegisterRecordRegisterKindEnumSerializer
    implements PrimitiveSerializer<ComplianceRegisterRecordRegisterKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PS_LICENSE': 'PS_LICENSE',
    'ICC_CERTIFICATE': 'ICC_CERTIFICATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PS_LICENSE': 'PS_LICENSE',
    'ICC_CERTIFICATE': 'ICC_CERTIFICATE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ComplianceRegisterRecordRegisterKindEnum
  ];
  @override
  final String wireName = 'ComplianceRegisterRecordRegisterKindEnum';

  @override
  Object serialize(Serializers serializers,
          ComplianceRegisterRecordRegisterKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceRegisterRecordRegisterKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceRegisterRecordRegisterKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceRegisterRecord extends ComplianceRegisterRecord {
  @override
  final ComplianceRegisterRecordRegisterKindEnum registerKind;
  @override
  final String companyName;
  @override
  final String? productDescription;
  @override
  final String? brand;
  @override
  final String? modelType;
  @override
  final String? referenceStandard;
  @override
  final String? address;
  @override
  final String? origin;
  @override
  final String? licenseNumber;
  @override
  final String? iccCertificateNumber;
  @override
  final String? serialRange;
  @override
  final String? expiresOn;

  factory _$ComplianceRegisterRecord(
          [void Function(ComplianceRegisterRecordBuilder)? updates]) =>
      (ComplianceRegisterRecordBuilder()..update(updates))._build();

  _$ComplianceRegisterRecord._(
      {required this.registerKind,
      required this.companyName,
      this.productDescription,
      this.brand,
      this.modelType,
      this.referenceStandard,
      this.address,
      this.origin,
      this.licenseNumber,
      this.iccCertificateNumber,
      this.serialRange,
      this.expiresOn})
      : super._();
  @override
  ComplianceRegisterRecord rebuild(
          void Function(ComplianceRegisterRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceRegisterRecordBuilder toBuilder() =>
      ComplianceRegisterRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceRegisterRecord &&
        registerKind == other.registerKind &&
        companyName == other.companyName &&
        productDescription == other.productDescription &&
        brand == other.brand &&
        modelType == other.modelType &&
        referenceStandard == other.referenceStandard &&
        address == other.address &&
        origin == other.origin &&
        licenseNumber == other.licenseNumber &&
        iccCertificateNumber == other.iccCertificateNumber &&
        serialRange == other.serialRange &&
        expiresOn == other.expiresOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, registerKind.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, productDescription.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, modelType.hashCode);
    _$hash = $jc(_$hash, referenceStandard.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, licenseNumber.hashCode);
    _$hash = $jc(_$hash, iccCertificateNumber.hashCode);
    _$hash = $jc(_$hash, serialRange.hashCode);
    _$hash = $jc(_$hash, expiresOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceRegisterRecord')
          ..add('registerKind', registerKind)
          ..add('companyName', companyName)
          ..add('productDescription', productDescription)
          ..add('brand', brand)
          ..add('modelType', modelType)
          ..add('referenceStandard', referenceStandard)
          ..add('address', address)
          ..add('origin', origin)
          ..add('licenseNumber', licenseNumber)
          ..add('iccCertificateNumber', iccCertificateNumber)
          ..add('serialRange', serialRange)
          ..add('expiresOn', expiresOn))
        .toString();
  }
}

class ComplianceRegisterRecordBuilder
    implements
        Builder<ComplianceRegisterRecord, ComplianceRegisterRecordBuilder> {
  _$ComplianceRegisterRecord? _$v;

  ComplianceRegisterRecordRegisterKindEnum? _registerKind;
  ComplianceRegisterRecordRegisterKindEnum? get registerKind =>
      _$this._registerKind;
  set registerKind(ComplianceRegisterRecordRegisterKindEnum? registerKind) =>
      _$this._registerKind = registerKind;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _productDescription;
  String? get productDescription => _$this._productDescription;
  set productDescription(String? productDescription) =>
      _$this._productDescription = productDescription;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _modelType;
  String? get modelType => _$this._modelType;
  set modelType(String? modelType) => _$this._modelType = modelType;

  String? _referenceStandard;
  String? get referenceStandard => _$this._referenceStandard;
  set referenceStandard(String? referenceStandard) =>
      _$this._referenceStandard = referenceStandard;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _origin;
  String? get origin => _$this._origin;
  set origin(String? origin) => _$this._origin = origin;

  String? _licenseNumber;
  String? get licenseNumber => _$this._licenseNumber;
  set licenseNumber(String? licenseNumber) =>
      _$this._licenseNumber = licenseNumber;

  String? _iccCertificateNumber;
  String? get iccCertificateNumber => _$this._iccCertificateNumber;
  set iccCertificateNumber(String? iccCertificateNumber) =>
      _$this._iccCertificateNumber = iccCertificateNumber;

  String? _serialRange;
  String? get serialRange => _$this._serialRange;
  set serialRange(String? serialRange) => _$this._serialRange = serialRange;

  String? _expiresOn;
  String? get expiresOn => _$this._expiresOn;
  set expiresOn(String? expiresOn) => _$this._expiresOn = expiresOn;

  ComplianceRegisterRecordBuilder() {
    ComplianceRegisterRecord._defaults(this);
  }

  ComplianceRegisterRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _registerKind = $v.registerKind;
      _companyName = $v.companyName;
      _productDescription = $v.productDescription;
      _brand = $v.brand;
      _modelType = $v.modelType;
      _referenceStandard = $v.referenceStandard;
      _address = $v.address;
      _origin = $v.origin;
      _licenseNumber = $v.licenseNumber;
      _iccCertificateNumber = $v.iccCertificateNumber;
      _serialRange = $v.serialRange;
      _expiresOn = $v.expiresOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceRegisterRecord other) {
    _$v = other as _$ComplianceRegisterRecord;
  }

  @override
  void update(void Function(ComplianceRegisterRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceRegisterRecord build() => _build();

  _$ComplianceRegisterRecord _build() {
    final _$result = _$v ??
        _$ComplianceRegisterRecord._(
          registerKind: BuiltValueNullFieldError.checkNotNull(
              registerKind, r'ComplianceRegisterRecord', 'registerKind'),
          companyName: BuiltValueNullFieldError.checkNotNull(
              companyName, r'ComplianceRegisterRecord', 'companyName'),
          productDescription: productDescription,
          brand: brand,
          modelType: modelType,
          referenceStandard: referenceStandard,
          address: address,
          origin: origin,
          licenseNumber: licenseNumber,
          iccCertificateNumber: iccCertificateNumber,
          serialRange: serialRange,
          expiresOn: expiresOn,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
