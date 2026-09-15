// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tax_version_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTaxVersionHistoryEvidenceOriginEnum
    _$vendorTaxVersionHistoryEvidenceOriginEnum_SAMPLE_DEMO =
    const VendorTaxVersionHistoryEvidenceOriginEnum._('SAMPLE_DEMO');

VendorTaxVersionHistoryEvidenceOriginEnum
    _$vendorTaxVersionHistoryEvidenceOriginEnumValueOf(String name) {
  switch (name) {
    case 'SAMPLE_DEMO':
      return _$vendorTaxVersionHistoryEvidenceOriginEnum_SAMPLE_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTaxVersionHistoryEvidenceOriginEnum>
    _$vendorTaxVersionHistoryEvidenceOriginEnumValues = BuiltSet<
        VendorTaxVersionHistoryEvidenceOriginEnum>(const <VendorTaxVersionHistoryEvidenceOriginEnum>[
  _$vendorTaxVersionHistoryEvidenceOriginEnum_SAMPLE_DEMO,
]);

const VendorTaxVersionHistoryEnvironmentEnum
    _$vendorTaxVersionHistoryEnvironmentEnum_TEST =
    const VendorTaxVersionHistoryEnvironmentEnum._('TEST');

VendorTaxVersionHistoryEnvironmentEnum
    _$vendorTaxVersionHistoryEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$vendorTaxVersionHistoryEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTaxVersionHistoryEnvironmentEnum>
    _$vendorTaxVersionHistoryEnvironmentEnumValues = BuiltSet<
        VendorTaxVersionHistoryEnvironmentEnum>(const <VendorTaxVersionHistoryEnvironmentEnum>[
  _$vendorTaxVersionHistoryEnvironmentEnum_TEST,
]);

Serializer<VendorTaxVersionHistoryEvidenceOriginEnum>
    _$vendorTaxVersionHistoryEvidenceOriginEnumSerializer =
    _$VendorTaxVersionHistoryEvidenceOriginEnumSerializer();
Serializer<VendorTaxVersionHistoryEnvironmentEnum>
    _$vendorTaxVersionHistoryEnvironmentEnumSerializer =
    _$VendorTaxVersionHistoryEnvironmentEnumSerializer();

class _$VendorTaxVersionHistoryEvidenceOriginEnumSerializer
    implements PrimitiveSerializer<VendorTaxVersionHistoryEvidenceOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SAMPLE_DEMO': 'SAMPLE_DEMO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SAMPLE_DEMO': 'SAMPLE_DEMO',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTaxVersionHistoryEvidenceOriginEnum
  ];
  @override
  final String wireName = 'VendorTaxVersionHistoryEvidenceOriginEnum';

  @override
  Object serialize(Serializers serializers,
          VendorTaxVersionHistoryEvidenceOriginEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTaxVersionHistoryEvidenceOriginEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTaxVersionHistoryEvidenceOriginEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTaxVersionHistoryEnvironmentEnumSerializer
    implements PrimitiveSerializer<VendorTaxVersionHistoryEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTaxVersionHistoryEnvironmentEnum
  ];
  @override
  final String wireName = 'VendorTaxVersionHistoryEnvironmentEnum';

  @override
  Object serialize(Serializers serializers,
          VendorTaxVersionHistoryEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTaxVersionHistoryEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTaxVersionHistoryEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTaxVersionHistory extends VendorTaxVersionHistory {
  @override
  final String id;
  @override
  final int version;
  @override
  final VendorTaxVersionHistoryEvidenceOriginEnum evidenceOrigin;
  @override
  final VendorTaxVersionHistoryEnvironmentEnum environment;
  @override
  final String? ownerAttestedAt;
  @override
  final String createdAt;
  @override
  final String status;
  @override
  final BuiltList<VendorTaxReviewHistory> reviews;

  factory _$VendorTaxVersionHistory(
          [void Function(VendorTaxVersionHistoryBuilder)? updates]) =>
      (VendorTaxVersionHistoryBuilder()..update(updates))._build();

  _$VendorTaxVersionHistory._(
      {required this.id,
      required this.version,
      required this.evidenceOrigin,
      required this.environment,
      this.ownerAttestedAt,
      required this.createdAt,
      required this.status,
      required this.reviews})
      : super._();
  @override
  VendorTaxVersionHistory rebuild(
          void Function(VendorTaxVersionHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTaxVersionHistoryBuilder toBuilder() =>
      VendorTaxVersionHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTaxVersionHistory &&
        id == other.id &&
        version == other.version &&
        evidenceOrigin == other.evidenceOrigin &&
        environment == other.environment &&
        ownerAttestedAt == other.ownerAttestedAt &&
        createdAt == other.createdAt &&
        status == other.status &&
        reviews == other.reviews;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, ownerAttestedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reviews.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTaxVersionHistory')
          ..add('id', id)
          ..add('version', version)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('environment', environment)
          ..add('ownerAttestedAt', ownerAttestedAt)
          ..add('createdAt', createdAt)
          ..add('status', status)
          ..add('reviews', reviews))
        .toString();
  }
}

class VendorTaxVersionHistoryBuilder
    implements
        Builder<VendorTaxVersionHistory, VendorTaxVersionHistoryBuilder> {
  _$VendorTaxVersionHistory? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  VendorTaxVersionHistoryEvidenceOriginEnum? _evidenceOrigin;
  VendorTaxVersionHistoryEvidenceOriginEnum? get evidenceOrigin =>
      _$this._evidenceOrigin;
  set evidenceOrigin(
          VendorTaxVersionHistoryEvidenceOriginEnum? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  VendorTaxVersionHistoryEnvironmentEnum? _environment;
  VendorTaxVersionHistoryEnvironmentEnum? get environment =>
      _$this._environment;
  set environment(VendorTaxVersionHistoryEnvironmentEnum? environment) =>
      _$this._environment = environment;

  String? _ownerAttestedAt;
  String? get ownerAttestedAt => _$this._ownerAttestedAt;
  set ownerAttestedAt(String? ownerAttestedAt) =>
      _$this._ownerAttestedAt = ownerAttestedAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  ListBuilder<VendorTaxReviewHistory>? _reviews;
  ListBuilder<VendorTaxReviewHistory> get reviews =>
      _$this._reviews ??= ListBuilder<VendorTaxReviewHistory>();
  set reviews(ListBuilder<VendorTaxReviewHistory>? reviews) =>
      _$this._reviews = reviews;

  VendorTaxVersionHistoryBuilder() {
    VendorTaxVersionHistory._defaults(this);
  }

  VendorTaxVersionHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _evidenceOrigin = $v.evidenceOrigin;
      _environment = $v.environment;
      _ownerAttestedAt = $v.ownerAttestedAt;
      _createdAt = $v.createdAt;
      _status = $v.status;
      _reviews = $v.reviews.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTaxVersionHistory other) {
    _$v = other as _$VendorTaxVersionHistory;
  }

  @override
  void update(void Function(VendorTaxVersionHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTaxVersionHistory build() => _build();

  _$VendorTaxVersionHistory _build() {
    _$VendorTaxVersionHistory _$result;
    try {
      _$result = _$v ??
          _$VendorTaxVersionHistory._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'VendorTaxVersionHistory', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'VendorTaxVersionHistory', 'version'),
            evidenceOrigin: BuiltValueNullFieldError.checkNotNull(
                evidenceOrigin, r'VendorTaxVersionHistory', 'evidenceOrigin'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'VendorTaxVersionHistory', 'environment'),
            ownerAttestedAt: ownerAttestedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'VendorTaxVersionHistory', 'createdAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'VendorTaxVersionHistory', 'status'),
            reviews: reviews.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reviews';
        reviews.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTaxVersionHistory', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
