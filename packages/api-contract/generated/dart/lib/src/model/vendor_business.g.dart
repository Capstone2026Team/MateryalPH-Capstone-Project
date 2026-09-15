// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_business.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_NOT_STARTED =
    const VendorBusinessStatusEnum._('NOT_STARTED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_IN_PROGRESS =
    const VendorBusinessStatusEnum._('IN_PROGRESS');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_SUBMITTED =
    const VendorBusinessStatusEnum._('SUBMITTED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_PENDING_VERIFICATION =
    const VendorBusinessStatusEnum._('PENDING_VERIFICATION');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_APPROVED =
    const VendorBusinessStatusEnum._('APPROVED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_COMPLETED =
    const VendorBusinessStatusEnum._('COMPLETED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_CHANGES_REQUIRED =
    const VendorBusinessStatusEnum._('CHANGES_REQUIRED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_REJECTED =
    const VendorBusinessStatusEnum._('REJECTED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_EXPIRED =
    const VendorBusinessStatusEnum._('EXPIRED');
const VendorBusinessStatusEnum _$vendorBusinessStatusEnum_NOT_APPLICABLE =
    const VendorBusinessStatusEnum._('NOT_APPLICABLE');

VendorBusinessStatusEnum _$vendorBusinessStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_STARTED':
      return _$vendorBusinessStatusEnum_NOT_STARTED;
    case 'IN_PROGRESS':
      return _$vendorBusinessStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$vendorBusinessStatusEnum_SUBMITTED;
    case 'PENDING_VERIFICATION':
      return _$vendorBusinessStatusEnum_PENDING_VERIFICATION;
    case 'APPROVED':
      return _$vendorBusinessStatusEnum_APPROVED;
    case 'COMPLETED':
      return _$vendorBusinessStatusEnum_COMPLETED;
    case 'CHANGES_REQUIRED':
      return _$vendorBusinessStatusEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$vendorBusinessStatusEnum_REJECTED;
    case 'EXPIRED':
      return _$vendorBusinessStatusEnum_EXPIRED;
    case 'NOT_APPLICABLE':
      return _$vendorBusinessStatusEnum_NOT_APPLICABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorBusinessStatusEnum> _$vendorBusinessStatusEnumValues =
    BuiltSet<VendorBusinessStatusEnum>(const <VendorBusinessStatusEnum>[
  _$vendorBusinessStatusEnum_NOT_STARTED,
  _$vendorBusinessStatusEnum_IN_PROGRESS,
  _$vendorBusinessStatusEnum_SUBMITTED,
  _$vendorBusinessStatusEnum_PENDING_VERIFICATION,
  _$vendorBusinessStatusEnum_APPROVED,
  _$vendorBusinessStatusEnum_COMPLETED,
  _$vendorBusinessStatusEnum_CHANGES_REQUIRED,
  _$vendorBusinessStatusEnum_REJECTED,
  _$vendorBusinessStatusEnum_EXPIRED,
  _$vendorBusinessStatusEnum_NOT_APPLICABLE,
]);

Serializer<VendorBusinessStatusEnum> _$vendorBusinessStatusEnumSerializer =
    _$VendorBusinessStatusEnumSerializer();

class _$VendorBusinessStatusEnumSerializer
    implements PrimitiveSerializer<VendorBusinessStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'COMPLETED': 'COMPLETED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'COMPLETED': 'COMPLETED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorBusinessStatusEnum];
  @override
  final String wireName = 'VendorBusinessStatusEnum';

  @override
  Object serialize(Serializers serializers, VendorBusinessStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorBusinessStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorBusinessStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorBusiness extends VendorBusiness {
  @override
  final String? reviewReason;
  @override
  final int lockVersion;
  @override
  final VendorBusinessDraft draft;
  @override
  final VendorBusinessStatusEnum status;
  @override
  final VendorStoreEmailVerification storeEmailVerification;

  factory _$VendorBusiness([void Function(VendorBusinessBuilder)? updates]) =>
      (VendorBusinessBuilder()..update(updates))._build();

  _$VendorBusiness._(
      {this.reviewReason,
      required this.lockVersion,
      required this.draft,
      required this.status,
      required this.storeEmailVerification})
      : super._();
  @override
  VendorBusiness rebuild(void Function(VendorBusinessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBusinessBuilder toBuilder() => VendorBusinessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBusiness &&
        reviewReason == other.reviewReason &&
        lockVersion == other.lockVersion &&
        draft == other.draft &&
        status == other.status &&
        storeEmailVerification == other.storeEmailVerification;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewReason.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, draft.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, storeEmailVerification.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorBusiness')
          ..add('reviewReason', reviewReason)
          ..add('lockVersion', lockVersion)
          ..add('draft', draft)
          ..add('status', status)
          ..add('storeEmailVerification', storeEmailVerification))
        .toString();
  }
}

class VendorBusinessBuilder
    implements Builder<VendorBusiness, VendorBusinessBuilder> {
  _$VendorBusiness? _$v;

  String? _reviewReason;
  String? get reviewReason => _$this._reviewReason;
  set reviewReason(String? reviewReason) => _$this._reviewReason = reviewReason;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorBusinessDraftBuilder? _draft;
  VendorBusinessDraftBuilder get draft =>
      _$this._draft ??= VendorBusinessDraftBuilder();
  set draft(VendorBusinessDraftBuilder? draft) => _$this._draft = draft;

  VendorBusinessStatusEnum? _status;
  VendorBusinessStatusEnum? get status => _$this._status;
  set status(VendorBusinessStatusEnum? status) => _$this._status = status;

  VendorStoreEmailVerificationBuilder? _storeEmailVerification;
  VendorStoreEmailVerificationBuilder get storeEmailVerification =>
      _$this._storeEmailVerification ??= VendorStoreEmailVerificationBuilder();
  set storeEmailVerification(
          VendorStoreEmailVerificationBuilder? storeEmailVerification) =>
      _$this._storeEmailVerification = storeEmailVerification;

  VendorBusinessBuilder() {
    VendorBusiness._defaults(this);
  }

  VendorBusinessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewReason = $v.reviewReason;
      _lockVersion = $v.lockVersion;
      _draft = $v.draft.toBuilder();
      _status = $v.status;
      _storeEmailVerification = $v.storeEmailVerification.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorBusiness other) {
    _$v = other as _$VendorBusiness;
  }

  @override
  void update(void Function(VendorBusinessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBusiness build() => _build();

  _$VendorBusiness _build() {
    _$VendorBusiness _$result;
    try {
      _$result = _$v ??
          _$VendorBusiness._(
            reviewReason: reviewReason,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'VendorBusiness', 'lockVersion'),
            draft: draft.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'VendorBusiness', 'status'),
            storeEmailVerification: storeEmailVerification.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'draft';
        draft.build();

        _$failedField = 'storeEmailVerification';
        storeEmailVerification.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorBusiness', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
