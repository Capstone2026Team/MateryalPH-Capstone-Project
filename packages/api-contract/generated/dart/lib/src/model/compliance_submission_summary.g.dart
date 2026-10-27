// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_submission_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceSubmissionSummaryStatusEnum
    _$complianceSubmissionSummaryStatusEnum_PENDING_ADMIN_REVIEW =
    const ComplianceSubmissionSummaryStatusEnum._('PENDING_ADMIN_REVIEW');
const ComplianceSubmissionSummaryStatusEnum
    _$complianceSubmissionSummaryStatusEnum_VERIFIED =
    const ComplianceSubmissionSummaryStatusEnum._('VERIFIED');
const ComplianceSubmissionSummaryStatusEnum
    _$complianceSubmissionSummaryStatusEnum_CHANGES_REQUIRED =
    const ComplianceSubmissionSummaryStatusEnum._('CHANGES_REQUIRED');
const ComplianceSubmissionSummaryStatusEnum
    _$complianceSubmissionSummaryStatusEnum_REJECTED =
    const ComplianceSubmissionSummaryStatusEnum._('REJECTED');
const ComplianceSubmissionSummaryStatusEnum
    _$complianceSubmissionSummaryStatusEnum_SUPERSEDED =
    const ComplianceSubmissionSummaryStatusEnum._('SUPERSEDED');

ComplianceSubmissionSummaryStatusEnum
    _$complianceSubmissionSummaryStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING_ADMIN_REVIEW':
      return _$complianceSubmissionSummaryStatusEnum_PENDING_ADMIN_REVIEW;
    case 'VERIFIED':
      return _$complianceSubmissionSummaryStatusEnum_VERIFIED;
    case 'CHANGES_REQUIRED':
      return _$complianceSubmissionSummaryStatusEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$complianceSubmissionSummaryStatusEnum_REJECTED;
    case 'SUPERSEDED':
      return _$complianceSubmissionSummaryStatusEnum_SUPERSEDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceSubmissionSummaryStatusEnum>
    _$complianceSubmissionSummaryStatusEnumValues = BuiltSet<
        ComplianceSubmissionSummaryStatusEnum>(const <ComplianceSubmissionSummaryStatusEnum>[
  _$complianceSubmissionSummaryStatusEnum_PENDING_ADMIN_REVIEW,
  _$complianceSubmissionSummaryStatusEnum_VERIFIED,
  _$complianceSubmissionSummaryStatusEnum_CHANGES_REQUIRED,
  _$complianceSubmissionSummaryStatusEnum_REJECTED,
  _$complianceSubmissionSummaryStatusEnum_SUPERSEDED,
]);

const ComplianceSubmissionSummaryReviewModeEnum
    _$complianceSubmissionSummaryReviewModeEnum_AUTOMATIC =
    const ComplianceSubmissionSummaryReviewModeEnum._('AUTOMATIC');
const ComplianceSubmissionSummaryReviewModeEnum
    _$complianceSubmissionSummaryReviewModeEnum_MANUAL_REVIEW =
    const ComplianceSubmissionSummaryReviewModeEnum._('MANUAL_REVIEW');

ComplianceSubmissionSummaryReviewModeEnum
    _$complianceSubmissionSummaryReviewModeEnumValueOf(String name) {
  switch (name) {
    case 'AUTOMATIC':
      return _$complianceSubmissionSummaryReviewModeEnum_AUTOMATIC;
    case 'MANUAL_REVIEW':
      return _$complianceSubmissionSummaryReviewModeEnum_MANUAL_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceSubmissionSummaryReviewModeEnum>
    _$complianceSubmissionSummaryReviewModeEnumValues = BuiltSet<
        ComplianceSubmissionSummaryReviewModeEnum>(const <ComplianceSubmissionSummaryReviewModeEnum>[
  _$complianceSubmissionSummaryReviewModeEnum_AUTOMATIC,
  _$complianceSubmissionSummaryReviewModeEnum_MANUAL_REVIEW,
]);

Serializer<ComplianceSubmissionSummaryStatusEnum>
    _$complianceSubmissionSummaryStatusEnumSerializer =
    _$ComplianceSubmissionSummaryStatusEnumSerializer();
Serializer<ComplianceSubmissionSummaryReviewModeEnum>
    _$complianceSubmissionSummaryReviewModeEnumSerializer =
    _$ComplianceSubmissionSummaryReviewModeEnumSerializer();

class _$ComplianceSubmissionSummaryStatusEnumSerializer
    implements PrimitiveSerializer<ComplianceSubmissionSummaryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
    'VERIFIED': 'VERIFIED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'SUPERSEDED': 'SUPERSEDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_ADMIN_REVIEW': 'PENDING_ADMIN_REVIEW',
    'VERIFIED': 'VERIFIED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'SUPERSEDED': 'SUPERSEDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ComplianceSubmissionSummaryStatusEnum
  ];
  @override
  final String wireName = 'ComplianceSubmissionSummaryStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ComplianceSubmissionSummaryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceSubmissionSummaryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceSubmissionSummaryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceSubmissionSummaryReviewModeEnumSerializer
    implements PrimitiveSerializer<ComplianceSubmissionSummaryReviewModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUTOMATIC': 'AUTOMATIC',
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUTOMATIC': 'AUTOMATIC',
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ComplianceSubmissionSummaryReviewModeEnum
  ];
  @override
  final String wireName = 'ComplianceSubmissionSummaryReviewModeEnum';

  @override
  Object serialize(Serializers serializers,
          ComplianceSubmissionSummaryReviewModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceSubmissionSummaryReviewModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceSubmissionSummaryReviewModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceSubmissionSummary extends ComplianceSubmissionSummary {
  @override
  final String id;
  @override
  final int version;
  @override
  final CompliancePath path;
  @override
  final ComplianceSubmissionSummaryStatusEnum status;
  @override
  final String? markingType;
  @override
  final String? markingNumber;
  @override
  final ComplianceRegisterRecord? registerRecord;
  @override
  final ComplianceSubmissionSummaryReviewModeEnum? reviewMode;
  @override
  final String? submittedAt;
  @override
  final String? decidedAt;
  @override
  final ComplianceReviewSummary? latestReview;

  factory _$ComplianceSubmissionSummary(
          [void Function(ComplianceSubmissionSummaryBuilder)? updates]) =>
      (ComplianceSubmissionSummaryBuilder()..update(updates))._build();

  _$ComplianceSubmissionSummary._(
      {required this.id,
      required this.version,
      required this.path,
      required this.status,
      this.markingType,
      this.markingNumber,
      this.registerRecord,
      this.reviewMode,
      this.submittedAt,
      this.decidedAt,
      this.latestReview})
      : super._();
  @override
  ComplianceSubmissionSummary rebuild(
          void Function(ComplianceSubmissionSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceSubmissionSummaryBuilder toBuilder() =>
      ComplianceSubmissionSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceSubmissionSummary &&
        id == other.id &&
        version == other.version &&
        path == other.path &&
        status == other.status &&
        markingType == other.markingType &&
        markingNumber == other.markingNumber &&
        registerRecord == other.registerRecord &&
        reviewMode == other.reviewMode &&
        submittedAt == other.submittedAt &&
        decidedAt == other.decidedAt &&
        latestReview == other.latestReview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, markingType.hashCode);
    _$hash = $jc(_$hash, markingNumber.hashCode);
    _$hash = $jc(_$hash, registerRecord.hashCode);
    _$hash = $jc(_$hash, reviewMode.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, latestReview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceSubmissionSummary')
          ..add('id', id)
          ..add('version', version)
          ..add('path', path)
          ..add('status', status)
          ..add('markingType', markingType)
          ..add('markingNumber', markingNumber)
          ..add('registerRecord', registerRecord)
          ..add('reviewMode', reviewMode)
          ..add('submittedAt', submittedAt)
          ..add('decidedAt', decidedAt)
          ..add('latestReview', latestReview))
        .toString();
  }
}

class ComplianceSubmissionSummaryBuilder
    implements
        Builder<ComplianceSubmissionSummary,
            ComplianceSubmissionSummaryBuilder> {
  _$ComplianceSubmissionSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  CompliancePath? _path;
  CompliancePath? get path => _$this._path;
  set path(CompliancePath? path) => _$this._path = path;

  ComplianceSubmissionSummaryStatusEnum? _status;
  ComplianceSubmissionSummaryStatusEnum? get status => _$this._status;
  set status(ComplianceSubmissionSummaryStatusEnum? status) =>
      _$this._status = status;

  String? _markingType;
  String? get markingType => _$this._markingType;
  set markingType(String? markingType) => _$this._markingType = markingType;

  String? _markingNumber;
  String? get markingNumber => _$this._markingNumber;
  set markingNumber(String? markingNumber) =>
      _$this._markingNumber = markingNumber;

  ComplianceRegisterRecordBuilder? _registerRecord;
  ComplianceRegisterRecordBuilder get registerRecord =>
      _$this._registerRecord ??= ComplianceRegisterRecordBuilder();
  set registerRecord(ComplianceRegisterRecordBuilder? registerRecord) =>
      _$this._registerRecord = registerRecord;

  ComplianceSubmissionSummaryReviewModeEnum? _reviewMode;
  ComplianceSubmissionSummaryReviewModeEnum? get reviewMode =>
      _$this._reviewMode;
  set reviewMode(ComplianceSubmissionSummaryReviewModeEnum? reviewMode) =>
      _$this._reviewMode = reviewMode;

  String? _submittedAt;
  String? get submittedAt => _$this._submittedAt;
  set submittedAt(String? submittedAt) => _$this._submittedAt = submittedAt;

  String? _decidedAt;
  String? get decidedAt => _$this._decidedAt;
  set decidedAt(String? decidedAt) => _$this._decidedAt = decidedAt;

  ComplianceReviewSummaryBuilder? _latestReview;
  ComplianceReviewSummaryBuilder get latestReview =>
      _$this._latestReview ??= ComplianceReviewSummaryBuilder();
  set latestReview(ComplianceReviewSummaryBuilder? latestReview) =>
      _$this._latestReview = latestReview;

  ComplianceSubmissionSummaryBuilder() {
    ComplianceSubmissionSummary._defaults(this);
  }

  ComplianceSubmissionSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _path = $v.path;
      _status = $v.status;
      _markingType = $v.markingType;
      _markingNumber = $v.markingNumber;
      _registerRecord = $v.registerRecord?.toBuilder();
      _reviewMode = $v.reviewMode;
      _submittedAt = $v.submittedAt;
      _decidedAt = $v.decidedAt;
      _latestReview = $v.latestReview?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceSubmissionSummary other) {
    _$v = other as _$ComplianceSubmissionSummary;
  }

  @override
  void update(void Function(ComplianceSubmissionSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceSubmissionSummary build() => _build();

  _$ComplianceSubmissionSummary _build() {
    _$ComplianceSubmissionSummary _$result;
    try {
      _$result = _$v ??
          _$ComplianceSubmissionSummary._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ComplianceSubmissionSummary', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ComplianceSubmissionSummary', 'version'),
            path: BuiltValueNullFieldError.checkNotNull(
                path, r'ComplianceSubmissionSummary', 'path'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ComplianceSubmissionSummary', 'status'),
            markingType: markingType,
            markingNumber: markingNumber,
            registerRecord: _registerRecord?.build(),
            reviewMode: reviewMode,
            submittedAt: submittedAt,
            decidedAt: decidedAt,
            latestReview: _latestReview?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'registerRecord';
        _registerRecord?.build();

        _$failedField = 'latestReview';
        _latestReview?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplianceSubmissionSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
