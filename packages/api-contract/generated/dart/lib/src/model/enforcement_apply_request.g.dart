// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_apply_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnum_CONTINUE =
    const EnforcementApplyRequestContinuationPlanEnum._('CONTINUE');
const EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnum_MONITORED_FULFILLMENT =
    const EnforcementApplyRequestContinuationPlanEnum._(
        'MONITORED_FULFILLMENT');
const EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnum_CANCELLATION_REVIEW =
    const EnforcementApplyRequestContinuationPlanEnum._('CANCELLATION_REVIEW');
const EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnum_REPLACEMENT =
    const EnforcementApplyRequestContinuationPlanEnum._('REPLACEMENT');
const EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnum_REFUND =
    const EnforcementApplyRequestContinuationPlanEnum._('REFUND');
const EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnum_NO_OPEN_ORDERS =
    const EnforcementApplyRequestContinuationPlanEnum._('NO_OPEN_ORDERS');

EnforcementApplyRequestContinuationPlanEnum
    _$enforcementApplyRequestContinuationPlanEnumValueOf(String name) {
  switch (name) {
    case 'CONTINUE':
      return _$enforcementApplyRequestContinuationPlanEnum_CONTINUE;
    case 'MONITORED_FULFILLMENT':
      return _$enforcementApplyRequestContinuationPlanEnum_MONITORED_FULFILLMENT;
    case 'CANCELLATION_REVIEW':
      return _$enforcementApplyRequestContinuationPlanEnum_CANCELLATION_REVIEW;
    case 'REPLACEMENT':
      return _$enforcementApplyRequestContinuationPlanEnum_REPLACEMENT;
    case 'REFUND':
      return _$enforcementApplyRequestContinuationPlanEnum_REFUND;
    case 'NO_OPEN_ORDERS':
      return _$enforcementApplyRequestContinuationPlanEnum_NO_OPEN_ORDERS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementApplyRequestContinuationPlanEnum>
    _$enforcementApplyRequestContinuationPlanEnumValues = BuiltSet<
        EnforcementApplyRequestContinuationPlanEnum>(const <EnforcementApplyRequestContinuationPlanEnum>[
  _$enforcementApplyRequestContinuationPlanEnum_CONTINUE,
  _$enforcementApplyRequestContinuationPlanEnum_MONITORED_FULFILLMENT,
  _$enforcementApplyRequestContinuationPlanEnum_CANCELLATION_REVIEW,
  _$enforcementApplyRequestContinuationPlanEnum_REPLACEMENT,
  _$enforcementApplyRequestContinuationPlanEnum_REFUND,
  _$enforcementApplyRequestContinuationPlanEnum_NO_OPEN_ORDERS,
]);

Serializer<EnforcementApplyRequestContinuationPlanEnum>
    _$enforcementApplyRequestContinuationPlanEnumSerializer =
    _$EnforcementApplyRequestContinuationPlanEnumSerializer();

class _$EnforcementApplyRequestContinuationPlanEnumSerializer
    implements
        PrimitiveSerializer<EnforcementApplyRequestContinuationPlanEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONTINUE': 'CONTINUE',
    'MONITORED_FULFILLMENT': 'MONITORED_FULFILLMENT',
    'CANCELLATION_REVIEW': 'CANCELLATION_REVIEW',
    'REPLACEMENT': 'REPLACEMENT',
    'REFUND': 'REFUND',
    'NO_OPEN_ORDERS': 'NO_OPEN_ORDERS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONTINUE': 'CONTINUE',
    'MONITORED_FULFILLMENT': 'MONITORED_FULFILLMENT',
    'CANCELLATION_REVIEW': 'CANCELLATION_REVIEW',
    'REPLACEMENT': 'REPLACEMENT',
    'REFUND': 'REFUND',
    'NO_OPEN_ORDERS': 'NO_OPEN_ORDERS',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EnforcementApplyRequestContinuationPlanEnum
  ];
  @override
  final String wireName = 'EnforcementApplyRequestContinuationPlanEnum';

  @override
  Object serialize(Serializers serializers,
          EnforcementApplyRequestContinuationPlanEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementApplyRequestContinuationPlanEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementApplyRequestContinuationPlanEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementApplyRequest extends EnforcementApplyRequest {
  @override
  final EnforcementApplyRequestContinuationPlanEnum continuationPlan;
  @override
  final String? continuationNote;
  @override
  final int lockVersion;
  @override
  final String reason;

  factory _$EnforcementApplyRequest(
          [void Function(EnforcementApplyRequestBuilder)? updates]) =>
      (EnforcementApplyRequestBuilder()..update(updates))._build();

  _$EnforcementApplyRequest._(
      {required this.continuationPlan,
      this.continuationNote,
      required this.lockVersion,
      required this.reason})
      : super._();
  @override
  EnforcementApplyRequest rebuild(
          void Function(EnforcementApplyRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementApplyRequestBuilder toBuilder() =>
      EnforcementApplyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementApplyRequest &&
        continuationPlan == other.continuationPlan &&
        continuationNote == other.continuationNote &&
        lockVersion == other.lockVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, continuationPlan.hashCode);
    _$hash = $jc(_$hash, continuationNote.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementApplyRequest')
          ..add('continuationPlan', continuationPlan)
          ..add('continuationNote', continuationNote)
          ..add('lockVersion', lockVersion)
          ..add('reason', reason))
        .toString();
  }
}

class EnforcementApplyRequestBuilder
    implements
        Builder<EnforcementApplyRequest, EnforcementApplyRequestBuilder> {
  _$EnforcementApplyRequest? _$v;

  EnforcementApplyRequestContinuationPlanEnum? _continuationPlan;
  EnforcementApplyRequestContinuationPlanEnum? get continuationPlan =>
      _$this._continuationPlan;
  set continuationPlan(
          EnforcementApplyRequestContinuationPlanEnum? continuationPlan) =>
      _$this._continuationPlan = continuationPlan;

  String? _continuationNote;
  String? get continuationNote => _$this._continuationNote;
  set continuationNote(String? continuationNote) =>
      _$this._continuationNote = continuationNote;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  EnforcementApplyRequestBuilder() {
    EnforcementApplyRequest._defaults(this);
  }

  EnforcementApplyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _continuationPlan = $v.continuationPlan;
      _continuationNote = $v.continuationNote;
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementApplyRequest other) {
    _$v = other as _$EnforcementApplyRequest;
  }

  @override
  void update(void Function(EnforcementApplyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementApplyRequest build() => _build();

  _$EnforcementApplyRequest _build() {
    final _$result = _$v ??
        _$EnforcementApplyRequest._(
          continuationPlan: BuiltValueNullFieldError.checkNotNull(
              continuationPlan, r'EnforcementApplyRequest', 'continuationPlan'),
          continuationNote: continuationNote,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'EnforcementApplyRequest', 'lockVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'EnforcementApplyRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
