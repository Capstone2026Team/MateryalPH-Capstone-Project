// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_onboarding_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorOnboardingStepLevelEnum _$vendorOnboardingStepLevelEnum_REQUIRED =
    const VendorOnboardingStepLevelEnum._('REQUIRED');
const VendorOnboardingStepLevelEnum _$vendorOnboardingStepLevelEnum_OPTIONAL =
    const VendorOnboardingStepLevelEnum._('OPTIONAL');
const VendorOnboardingStepLevelEnum
    _$vendorOnboardingStepLevelEnum_CONDITIONALLY_REQUIRED =
    const VendorOnboardingStepLevelEnum._('CONDITIONALLY_REQUIRED');

VendorOnboardingStepLevelEnum _$vendorOnboardingStepLevelEnumValueOf(
    String name) {
  switch (name) {
    case 'REQUIRED':
      return _$vendorOnboardingStepLevelEnum_REQUIRED;
    case 'OPTIONAL':
      return _$vendorOnboardingStepLevelEnum_OPTIONAL;
    case 'CONDITIONALLY_REQUIRED':
      return _$vendorOnboardingStepLevelEnum_CONDITIONALLY_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOnboardingStepLevelEnum>
    _$vendorOnboardingStepLevelEnumValues = BuiltSet<
        VendorOnboardingStepLevelEnum>(const <VendorOnboardingStepLevelEnum>[
  _$vendorOnboardingStepLevelEnum_REQUIRED,
  _$vendorOnboardingStepLevelEnum_OPTIONAL,
  _$vendorOnboardingStepLevelEnum_CONDITIONALLY_REQUIRED,
]);

const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_NOT_STARTED =
    const VendorOnboardingStepStatusEnum._('NOT_STARTED');
const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_IN_PROGRESS =
    const VendorOnboardingStepStatusEnum._('IN_PROGRESS');
const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_SUBMITTED =
    const VendorOnboardingStepStatusEnum._('SUBMITTED');
const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_PENDING_VERIFICATION =
    const VendorOnboardingStepStatusEnum._('PENDING_VERIFICATION');
const VendorOnboardingStepStatusEnum _$vendorOnboardingStepStatusEnum_APPROVED =
    const VendorOnboardingStepStatusEnum._('APPROVED');
const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_CHANGES_REQUIRED =
    const VendorOnboardingStepStatusEnum._('CHANGES_REQUIRED');
const VendorOnboardingStepStatusEnum _$vendorOnboardingStepStatusEnum_REJECTED =
    const VendorOnboardingStepStatusEnum._('REJECTED');
const VendorOnboardingStepStatusEnum _$vendorOnboardingStepStatusEnum_EXPIRED =
    const VendorOnboardingStepStatusEnum._('EXPIRED');
const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_NOT_APPLICABLE =
    const VendorOnboardingStepStatusEnum._('NOT_APPLICABLE');
const VendorOnboardingStepStatusEnum
    _$vendorOnboardingStepStatusEnum_COMPLETED =
    const VendorOnboardingStepStatusEnum._('COMPLETED');

VendorOnboardingStepStatusEnum _$vendorOnboardingStepStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'NOT_STARTED':
      return _$vendorOnboardingStepStatusEnum_NOT_STARTED;
    case 'IN_PROGRESS':
      return _$vendorOnboardingStepStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$vendorOnboardingStepStatusEnum_SUBMITTED;
    case 'PENDING_VERIFICATION':
      return _$vendorOnboardingStepStatusEnum_PENDING_VERIFICATION;
    case 'APPROVED':
      return _$vendorOnboardingStepStatusEnum_APPROVED;
    case 'CHANGES_REQUIRED':
      return _$vendorOnboardingStepStatusEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$vendorOnboardingStepStatusEnum_REJECTED;
    case 'EXPIRED':
      return _$vendorOnboardingStepStatusEnum_EXPIRED;
    case 'NOT_APPLICABLE':
      return _$vendorOnboardingStepStatusEnum_NOT_APPLICABLE;
    case 'COMPLETED':
      return _$vendorOnboardingStepStatusEnum_COMPLETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOnboardingStepStatusEnum>
    _$vendorOnboardingStepStatusEnumValues = BuiltSet<
        VendorOnboardingStepStatusEnum>(const <VendorOnboardingStepStatusEnum>[
  _$vendorOnboardingStepStatusEnum_NOT_STARTED,
  _$vendorOnboardingStepStatusEnum_IN_PROGRESS,
  _$vendorOnboardingStepStatusEnum_SUBMITTED,
  _$vendorOnboardingStepStatusEnum_PENDING_VERIFICATION,
  _$vendorOnboardingStepStatusEnum_APPROVED,
  _$vendorOnboardingStepStatusEnum_CHANGES_REQUIRED,
  _$vendorOnboardingStepStatusEnum_REJECTED,
  _$vendorOnboardingStepStatusEnum_EXPIRED,
  _$vendorOnboardingStepStatusEnum_NOT_APPLICABLE,
  _$vendorOnboardingStepStatusEnum_COMPLETED,
]);

Serializer<VendorOnboardingStepLevelEnum>
    _$vendorOnboardingStepLevelEnumSerializer =
    _$VendorOnboardingStepLevelEnumSerializer();
Serializer<VendorOnboardingStepStatusEnum>
    _$vendorOnboardingStepStatusEnumSerializer =
    _$VendorOnboardingStepStatusEnumSerializer();

class _$VendorOnboardingStepLevelEnumSerializer
    implements PrimitiveSerializer<VendorOnboardingStepLevelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUIRED': 'REQUIRED',
    'OPTIONAL': 'OPTIONAL',
    'CONDITIONALLY_REQUIRED': 'CONDITIONALLY_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUIRED': 'REQUIRED',
    'OPTIONAL': 'OPTIONAL',
    'CONDITIONALLY_REQUIRED': 'CONDITIONALLY_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorOnboardingStepLevelEnum];
  @override
  final String wireName = 'VendorOnboardingStepLevelEnum';

  @override
  Object serialize(
          Serializers serializers, VendorOnboardingStepLevelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOnboardingStepLevelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOnboardingStepLevelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOnboardingStepStatusEnumSerializer
    implements PrimitiveSerializer<VendorOnboardingStepStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'COMPLETED': 'COMPLETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'COMPLETED': 'COMPLETED',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorOnboardingStepStatusEnum];
  @override
  final String wireName = 'VendorOnboardingStepStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorOnboardingStepStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOnboardingStepStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOnboardingStepStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOnboardingStep extends VendorOnboardingStep {
  @override
  final String id;
  @override
  final String key;
  @override
  final String label;
  @override
  final VendorOnboardingStepLevelEnum level;
  @override
  final VendorOnboardingStepStatusEnum status;
  @override
  final String? reason;
  @override
  final int lockVersion;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? reviewedAt;

  factory _$VendorOnboardingStep(
          [void Function(VendorOnboardingStepBuilder)? updates]) =>
      (VendorOnboardingStepBuilder()..update(updates))._build();

  _$VendorOnboardingStep._(
      {required this.id,
      required this.key,
      required this.label,
      required this.level,
      required this.status,
      this.reason,
      required this.lockVersion,
      this.submittedAt,
      this.reviewedAt})
      : super._();
  @override
  VendorOnboardingStep rebuild(
          void Function(VendorOnboardingStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOnboardingStepBuilder toBuilder() =>
      VendorOnboardingStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOnboardingStep &&
        id == other.id &&
        key == other.key &&
        label == other.label &&
        level == other.level &&
        status == other.status &&
        reason == other.reason &&
        lockVersion == other.lockVersion &&
        submittedAt == other.submittedAt &&
        reviewedAt == other.reviewedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOnboardingStep')
          ..add('id', id)
          ..add('key', key)
          ..add('label', label)
          ..add('level', level)
          ..add('status', status)
          ..add('reason', reason)
          ..add('lockVersion', lockVersion)
          ..add('submittedAt', submittedAt)
          ..add('reviewedAt', reviewedAt))
        .toString();
  }
}

class VendorOnboardingStepBuilder
    implements Builder<VendorOnboardingStep, VendorOnboardingStepBuilder> {
  _$VendorOnboardingStep? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  VendorOnboardingStepLevelEnum? _level;
  VendorOnboardingStepLevelEnum? get level => _$this._level;
  set level(VendorOnboardingStepLevelEnum? level) => _$this._level = level;

  VendorOnboardingStepStatusEnum? _status;
  VendorOnboardingStepStatusEnum? get status => _$this._status;
  set status(VendorOnboardingStepStatusEnum? status) => _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  VendorOnboardingStepBuilder() {
    VendorOnboardingStep._defaults(this);
  }

  VendorOnboardingStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _key = $v.key;
      _label = $v.label;
      _level = $v.level;
      _status = $v.status;
      _reason = $v.reason;
      _lockVersion = $v.lockVersion;
      _submittedAt = $v.submittedAt;
      _reviewedAt = $v.reviewedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOnboardingStep other) {
    _$v = other as _$VendorOnboardingStep;
  }

  @override
  void update(void Function(VendorOnboardingStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOnboardingStep build() => _build();

  _$VendorOnboardingStep _build() {
    final _$result = _$v ??
        _$VendorOnboardingStep._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorOnboardingStep', 'id'),
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'VendorOnboardingStep', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'VendorOnboardingStep', 'label'),
          level: BuiltValueNullFieldError.checkNotNull(
              level, r'VendorOnboardingStep', 'level'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorOnboardingStep', 'status'),
          reason: reason,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorOnboardingStep', 'lockVersion'),
          submittedAt: submittedAt,
          reviewedAt: reviewedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
