// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_submission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceSubmissionConfirmedEnum
    _$complianceSubmissionConfirmedEnum_true_ =
    const ComplianceSubmissionConfirmedEnum._('true_');

ComplianceSubmissionConfirmedEnum _$complianceSubmissionConfirmedEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$complianceSubmissionConfirmedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceSubmissionConfirmedEnum>
    _$complianceSubmissionConfirmedEnumValues = BuiltSet<
        ComplianceSubmissionConfirmedEnum>(const <ComplianceSubmissionConfirmedEnum>[
  _$complianceSubmissionConfirmedEnum_true_,
]);

Serializer<ComplianceSubmissionConfirmedEnum>
    _$complianceSubmissionConfirmedEnumSerializer =
    _$ComplianceSubmissionConfirmedEnumSerializer();

class _$ComplianceSubmissionConfirmedEnumSerializer
    implements PrimitiveSerializer<ComplianceSubmissionConfirmedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceSubmissionConfirmedEnum];
  @override
  final String wireName = 'ComplianceSubmissionConfirmedEnum';

  @override
  Object serialize(
          Serializers serializers, ComplianceSubmissionConfirmedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceSubmissionConfirmedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceSubmissionConfirmedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceSubmission extends ComplianceSubmission {
  @override
  final int listingLockVersion;
  @override
  final CompliancePath path;
  @override
  final BuiltList<String> evidenceIds;
  @override
  final MarkingType markingType;
  @override
  final String certificateNumber;
  @override
  final String? manufacturerName;
  @override
  final String? manufacturerAddress;
  @override
  final String? importerName;
  @override
  final String? importerAddress;
  @override
  final String? countryOfManufacture;
  @override
  final String? brand;
  @override
  final String? batchNumber;
  @override
  final ComplianceSubmissionConfirmedEnum confirmed;

  factory _$ComplianceSubmission(
          [void Function(ComplianceSubmissionBuilder)? updates]) =>
      (ComplianceSubmissionBuilder()..update(updates))._build();

  _$ComplianceSubmission._(
      {required this.listingLockVersion,
      required this.path,
      required this.evidenceIds,
      required this.markingType,
      required this.certificateNumber,
      this.manufacturerName,
      this.manufacturerAddress,
      this.importerName,
      this.importerAddress,
      this.countryOfManufacture,
      this.brand,
      this.batchNumber,
      required this.confirmed})
      : super._();
  @override
  ComplianceSubmission rebuild(
          void Function(ComplianceSubmissionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceSubmissionBuilder toBuilder() =>
      ComplianceSubmissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceSubmission &&
        listingLockVersion == other.listingLockVersion &&
        path == other.path &&
        evidenceIds == other.evidenceIds &&
        markingType == other.markingType &&
        certificateNumber == other.certificateNumber &&
        manufacturerName == other.manufacturerName &&
        manufacturerAddress == other.manufacturerAddress &&
        importerName == other.importerName &&
        importerAddress == other.importerAddress &&
        countryOfManufacture == other.countryOfManufacture &&
        brand == other.brand &&
        batchNumber == other.batchNumber &&
        confirmed == other.confirmed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingLockVersion.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, evidenceIds.hashCode);
    _$hash = $jc(_$hash, markingType.hashCode);
    _$hash = $jc(_$hash, certificateNumber.hashCode);
    _$hash = $jc(_$hash, manufacturerName.hashCode);
    _$hash = $jc(_$hash, manufacturerAddress.hashCode);
    _$hash = $jc(_$hash, importerName.hashCode);
    _$hash = $jc(_$hash, importerAddress.hashCode);
    _$hash = $jc(_$hash, countryOfManufacture.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, batchNumber.hashCode);
    _$hash = $jc(_$hash, confirmed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceSubmission')
          ..add('listingLockVersion', listingLockVersion)
          ..add('path', path)
          ..add('evidenceIds', evidenceIds)
          ..add('markingType', markingType)
          ..add('certificateNumber', certificateNumber)
          ..add('manufacturerName', manufacturerName)
          ..add('manufacturerAddress', manufacturerAddress)
          ..add('importerName', importerName)
          ..add('importerAddress', importerAddress)
          ..add('countryOfManufacture', countryOfManufacture)
          ..add('brand', brand)
          ..add('batchNumber', batchNumber)
          ..add('confirmed', confirmed))
        .toString();
  }
}

class ComplianceSubmissionBuilder
    implements Builder<ComplianceSubmission, ComplianceSubmissionBuilder> {
  _$ComplianceSubmission? _$v;

  int? _listingLockVersion;
  int? get listingLockVersion => _$this._listingLockVersion;
  set listingLockVersion(int? listingLockVersion) =>
      _$this._listingLockVersion = listingLockVersion;

  CompliancePath? _path;
  CompliancePath? get path => _$this._path;
  set path(CompliancePath? path) => _$this._path = path;

  ListBuilder<String>? _evidenceIds;
  ListBuilder<String> get evidenceIds =>
      _$this._evidenceIds ??= ListBuilder<String>();
  set evidenceIds(ListBuilder<String>? evidenceIds) =>
      _$this._evidenceIds = evidenceIds;

  MarkingType? _markingType;
  MarkingType? get markingType => _$this._markingType;
  set markingType(MarkingType? markingType) =>
      _$this._markingType = markingType;

  String? _certificateNumber;
  String? get certificateNumber => _$this._certificateNumber;
  set certificateNumber(String? certificateNumber) =>
      _$this._certificateNumber = certificateNumber;

  String? _manufacturerName;
  String? get manufacturerName => _$this._manufacturerName;
  set manufacturerName(String? manufacturerName) =>
      _$this._manufacturerName = manufacturerName;

  String? _manufacturerAddress;
  String? get manufacturerAddress => _$this._manufacturerAddress;
  set manufacturerAddress(String? manufacturerAddress) =>
      _$this._manufacturerAddress = manufacturerAddress;

  String? _importerName;
  String? get importerName => _$this._importerName;
  set importerName(String? importerName) => _$this._importerName = importerName;

  String? _importerAddress;
  String? get importerAddress => _$this._importerAddress;
  set importerAddress(String? importerAddress) =>
      _$this._importerAddress = importerAddress;

  String? _countryOfManufacture;
  String? get countryOfManufacture => _$this._countryOfManufacture;
  set countryOfManufacture(String? countryOfManufacture) =>
      _$this._countryOfManufacture = countryOfManufacture;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _batchNumber;
  String? get batchNumber => _$this._batchNumber;
  set batchNumber(String? batchNumber) => _$this._batchNumber = batchNumber;

  ComplianceSubmissionConfirmedEnum? _confirmed;
  ComplianceSubmissionConfirmedEnum? get confirmed => _$this._confirmed;
  set confirmed(ComplianceSubmissionConfirmedEnum? confirmed) =>
      _$this._confirmed = confirmed;

  ComplianceSubmissionBuilder() {
    ComplianceSubmission._defaults(this);
  }

  ComplianceSubmissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingLockVersion = $v.listingLockVersion;
      _path = $v.path;
      _evidenceIds = $v.evidenceIds.toBuilder();
      _markingType = $v.markingType;
      _certificateNumber = $v.certificateNumber;
      _manufacturerName = $v.manufacturerName;
      _manufacturerAddress = $v.manufacturerAddress;
      _importerName = $v.importerName;
      _importerAddress = $v.importerAddress;
      _countryOfManufacture = $v.countryOfManufacture;
      _brand = $v.brand;
      _batchNumber = $v.batchNumber;
      _confirmed = $v.confirmed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceSubmission other) {
    _$v = other as _$ComplianceSubmission;
  }

  @override
  void update(void Function(ComplianceSubmissionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceSubmission build() => _build();

  _$ComplianceSubmission _build() {
    _$ComplianceSubmission _$result;
    try {
      _$result = _$v ??
          _$ComplianceSubmission._(
            listingLockVersion: BuiltValueNullFieldError.checkNotNull(
                listingLockVersion,
                r'ComplianceSubmission',
                'listingLockVersion'),
            path: BuiltValueNullFieldError.checkNotNull(
                path, r'ComplianceSubmission', 'path'),
            evidenceIds: evidenceIds.build(),
            markingType: BuiltValueNullFieldError.checkNotNull(
                markingType, r'ComplianceSubmission', 'markingType'),
            certificateNumber: BuiltValueNullFieldError.checkNotNull(
                certificateNumber,
                r'ComplianceSubmission',
                'certificateNumber'),
            manufacturerName: manufacturerName,
            manufacturerAddress: manufacturerAddress,
            importerName: importerName,
            importerAddress: importerAddress,
            countryOfManufacture: countryOfManufacture,
            brand: brand,
            batchNumber: batchNumber,
            confirmed: BuiltValueNullFieldError.checkNotNull(
                confirmed, r'ComplianceSubmission', 'confirmed'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'evidenceIds';
        evidenceIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplianceSubmission', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
