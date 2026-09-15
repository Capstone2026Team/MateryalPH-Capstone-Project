// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tax_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTaxProfileLegalEffectEnum
    _$vendorTaxProfileLegalEffectEnum_TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL =
    const VendorTaxProfileLegalEffectEnum._(
        'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL');

VendorTaxProfileLegalEffectEnum _$vendorTaxProfileLegalEffectEnumValueOf(
    String name) {
  switch (name) {
    case 'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL':
      return _$vendorTaxProfileLegalEffectEnum_TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTaxProfileLegalEffectEnum>
    _$vendorTaxProfileLegalEffectEnumValues = BuiltSet<
        VendorTaxProfileLegalEffectEnum>(const <VendorTaxProfileLegalEffectEnum>[
  _$vendorTaxProfileLegalEffectEnum_TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL,
]);

Serializer<VendorTaxProfileLegalEffectEnum>
    _$vendorTaxProfileLegalEffectEnumSerializer =
    _$VendorTaxProfileLegalEffectEnumSerializer();

class _$VendorTaxProfileLegalEffectEnumSerializer
    implements PrimitiveSerializer<VendorTaxProfileLegalEffectEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL':
        'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL':
        'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorTaxProfileLegalEffectEnum];
  @override
  final String wireName = 'VendorTaxProfileLegalEffectEnum';

  @override
  Object serialize(
          Serializers serializers, VendorTaxProfileLegalEffectEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTaxProfileLegalEffectEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTaxProfileLegalEffectEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTaxProfile extends VendorTaxProfile {
  @override
  final String? reviewReason;
  @override
  final int lockVersion;
  @override
  final BuiltList<VendorTaxProfileEvidenceVersionsInner> evidenceVersions;
  @override
  final String? profileId;
  @override
  final String? versionId;
  @override
  final int? version;
  @override
  final String status;
  @override
  final String environment;
  @override
  final String evidenceOrigin;
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final String? ownerAttestedAt;
  @override
  final String withholdingTreatment;
  @override
  final BuiltList<VendorTaxVersionHistory> history;
  @override
  final VendorTaxProfileLegalEffectEnum legalEffect;

  factory _$VendorTaxProfile(
          [void Function(VendorTaxProfileBuilder)? updates]) =>
      (VendorTaxProfileBuilder()..update(updates))._build();

  _$VendorTaxProfile._(
      {this.reviewReason,
      required this.lockVersion,
      required this.evidenceVersions,
      this.profileId,
      this.versionId,
      this.version,
      required this.status,
      required this.environment,
      required this.evidenceOrigin,
      required this.data,
      this.ownerAttestedAt,
      required this.withholdingTreatment,
      required this.history,
      required this.legalEffect})
      : super._();
  @override
  VendorTaxProfile rebuild(void Function(VendorTaxProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTaxProfileBuilder toBuilder() =>
      VendorTaxProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTaxProfile &&
        reviewReason == other.reviewReason &&
        lockVersion == other.lockVersion &&
        evidenceVersions == other.evidenceVersions &&
        profileId == other.profileId &&
        versionId == other.versionId &&
        version == other.version &&
        status == other.status &&
        environment == other.environment &&
        evidenceOrigin == other.evidenceOrigin &&
        data == other.data &&
        ownerAttestedAt == other.ownerAttestedAt &&
        withholdingTreatment == other.withholdingTreatment &&
        history == other.history &&
        legalEffect == other.legalEffect;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewReason.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, evidenceVersions.hashCode);
    _$hash = $jc(_$hash, profileId.hashCode);
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, ownerAttestedAt.hashCode);
    _$hash = $jc(_$hash, withholdingTreatment.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, legalEffect.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTaxProfile')
          ..add('reviewReason', reviewReason)
          ..add('lockVersion', lockVersion)
          ..add('evidenceVersions', evidenceVersions)
          ..add('profileId', profileId)
          ..add('versionId', versionId)
          ..add('version', version)
          ..add('status', status)
          ..add('environment', environment)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('data', data)
          ..add('ownerAttestedAt', ownerAttestedAt)
          ..add('withholdingTreatment', withholdingTreatment)
          ..add('history', history)
          ..add('legalEffect', legalEffect))
        .toString();
  }
}

class VendorTaxProfileBuilder
    implements Builder<VendorTaxProfile, VendorTaxProfileBuilder> {
  _$VendorTaxProfile? _$v;

  String? _reviewReason;
  String? get reviewReason => _$this._reviewReason;
  set reviewReason(String? reviewReason) => _$this._reviewReason = reviewReason;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ListBuilder<VendorTaxProfileEvidenceVersionsInner>? _evidenceVersions;
  ListBuilder<VendorTaxProfileEvidenceVersionsInner> get evidenceVersions =>
      _$this._evidenceVersions ??=
          ListBuilder<VendorTaxProfileEvidenceVersionsInner>();
  set evidenceVersions(
          ListBuilder<VendorTaxProfileEvidenceVersionsInner>?
              evidenceVersions) =>
      _$this._evidenceVersions = evidenceVersions;

  String? _profileId;
  String? get profileId => _$this._profileId;
  set profileId(String? profileId) => _$this._profileId = profileId;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _evidenceOrigin;
  String? get evidenceOrigin => _$this._evidenceOrigin;
  set evidenceOrigin(String? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  String? _ownerAttestedAt;
  String? get ownerAttestedAt => _$this._ownerAttestedAt;
  set ownerAttestedAt(String? ownerAttestedAt) =>
      _$this._ownerAttestedAt = ownerAttestedAt;

  String? _withholdingTreatment;
  String? get withholdingTreatment => _$this._withholdingTreatment;
  set withholdingTreatment(String? withholdingTreatment) =>
      _$this._withholdingTreatment = withholdingTreatment;

  ListBuilder<VendorTaxVersionHistory>? _history;
  ListBuilder<VendorTaxVersionHistory> get history =>
      _$this._history ??= ListBuilder<VendorTaxVersionHistory>();
  set history(ListBuilder<VendorTaxVersionHistory>? history) =>
      _$this._history = history;

  VendorTaxProfileLegalEffectEnum? _legalEffect;
  VendorTaxProfileLegalEffectEnum? get legalEffect => _$this._legalEffect;
  set legalEffect(VendorTaxProfileLegalEffectEnum? legalEffect) =>
      _$this._legalEffect = legalEffect;

  VendorTaxProfileBuilder() {
    VendorTaxProfile._defaults(this);
  }

  VendorTaxProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewReason = $v.reviewReason;
      _lockVersion = $v.lockVersion;
      _evidenceVersions = $v.evidenceVersions.toBuilder();
      _profileId = $v.profileId;
      _versionId = $v.versionId;
      _version = $v.version;
      _status = $v.status;
      _environment = $v.environment;
      _evidenceOrigin = $v.evidenceOrigin;
      _data = $v.data.toBuilder();
      _ownerAttestedAt = $v.ownerAttestedAt;
      _withholdingTreatment = $v.withholdingTreatment;
      _history = $v.history.toBuilder();
      _legalEffect = $v.legalEffect;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTaxProfile other) {
    _$v = other as _$VendorTaxProfile;
  }

  @override
  void update(void Function(VendorTaxProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTaxProfile build() => _build();

  _$VendorTaxProfile _build() {
    _$VendorTaxProfile _$result;
    try {
      _$result = _$v ??
          _$VendorTaxProfile._(
            reviewReason: reviewReason,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'VendorTaxProfile', 'lockVersion'),
            evidenceVersions: evidenceVersions.build(),
            profileId: profileId,
            versionId: versionId,
            version: version,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'VendorTaxProfile', 'status'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'VendorTaxProfile', 'environment'),
            evidenceOrigin: BuiltValueNullFieldError.checkNotNull(
                evidenceOrigin, r'VendorTaxProfile', 'evidenceOrigin'),
            data: data.build(),
            ownerAttestedAt: ownerAttestedAt,
            withholdingTreatment: BuiltValueNullFieldError.checkNotNull(
                withholdingTreatment,
                r'VendorTaxProfile',
                'withholdingTreatment'),
            history: history.build(),
            legalEffect: BuiltValueNullFieldError.checkNotNull(
                legalEffect, r'VendorTaxProfile', 'legalEffect'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'evidenceVersions';
        evidenceVersions.build();

        _$failedField = 'data';
        data.build();

        _$failedField = 'history';
        history.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTaxProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
