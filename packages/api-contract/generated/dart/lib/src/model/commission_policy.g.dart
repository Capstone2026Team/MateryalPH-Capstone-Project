// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommissionPolicyStatusEnum _$commissionPolicyStatusEnum_CURRENT =
    const CommissionPolicyStatusEnum._('CURRENT');
const CommissionPolicyStatusEnum _$commissionPolicyStatusEnum_SCHEDULED =
    const CommissionPolicyStatusEnum._('SCHEDULED');
const CommissionPolicyStatusEnum _$commissionPolicyStatusEnum_PREVIOUS =
    const CommissionPolicyStatusEnum._('PREVIOUS');
const CommissionPolicyStatusEnum _$commissionPolicyStatusEnum_SUPERSEDED =
    const CommissionPolicyStatusEnum._('SUPERSEDED');
const CommissionPolicyStatusEnum _$commissionPolicyStatusEnum_CANCELLED =
    const CommissionPolicyStatusEnum._('CANCELLED');

CommissionPolicyStatusEnum _$commissionPolicyStatusEnumValueOf(String name) {
  switch (name) {
    case 'CURRENT':
      return _$commissionPolicyStatusEnum_CURRENT;
    case 'SCHEDULED':
      return _$commissionPolicyStatusEnum_SCHEDULED;
    case 'PREVIOUS':
      return _$commissionPolicyStatusEnum_PREVIOUS;
    case 'SUPERSEDED':
      return _$commissionPolicyStatusEnum_SUPERSEDED;
    case 'CANCELLED':
      return _$commissionPolicyStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionPolicyStatusEnum> _$commissionPolicyStatusEnumValues =
    BuiltSet<CommissionPolicyStatusEnum>(const <CommissionPolicyStatusEnum>[
  _$commissionPolicyStatusEnum_CURRENT,
  _$commissionPolicyStatusEnum_SCHEDULED,
  _$commissionPolicyStatusEnum_PREVIOUS,
  _$commissionPolicyStatusEnum_SUPERSEDED,
  _$commissionPolicyStatusEnum_CANCELLED,
]);

Serializer<CommissionPolicyStatusEnum> _$commissionPolicyStatusEnumSerializer =
    _$CommissionPolicyStatusEnumSerializer();

class _$CommissionPolicyStatusEnumSerializer
    implements PrimitiveSerializer<CommissionPolicyStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CURRENT': 'CURRENT',
    'SCHEDULED': 'SCHEDULED',
    'PREVIOUS': 'PREVIOUS',
    'SUPERSEDED': 'SUPERSEDED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CURRENT': 'CURRENT',
    'SCHEDULED': 'SCHEDULED',
    'PREVIOUS': 'PREVIOUS',
    'SUPERSEDED': 'SUPERSEDED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[CommissionPolicyStatusEnum];
  @override
  final String wireName = 'CommissionPolicyStatusEnum';

  @override
  Object serialize(Serializers serializers, CommissionPolicyStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionPolicyStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionPolicyStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionPolicy extends CommissionPolicy {
  @override
  final String id;
  @override
  final int version;
  @override
  final int commissionBasisPoints;
  @override
  final String rateLabel;
  @override
  final DateTime effectiveFrom;
  @override
  final String? agreementVersionId;
  @override
  final String? reason;
  @override
  final CommissionPolicyStatusEnum status;
  @override
  final int? termsVersion;
  @override
  final String? termsContent;
  @override
  final String? vendorMessage;
  @override
  final int? noticeHours;
  @override
  final String? noticeOverrideReason;
  @override
  final String? publishedBy;
  @override
  final CommissionEmailSummary? delivery;

  factory _$CommissionPolicy(
          [void Function(CommissionPolicyBuilder)? updates]) =>
      (CommissionPolicyBuilder()..update(updates))._build();

  _$CommissionPolicy._(
      {required this.id,
      required this.version,
      required this.commissionBasisPoints,
      required this.rateLabel,
      required this.effectiveFrom,
      this.agreementVersionId,
      this.reason,
      required this.status,
      this.termsVersion,
      this.termsContent,
      this.vendorMessage,
      this.noticeHours,
      this.noticeOverrideReason,
      this.publishedBy,
      this.delivery})
      : super._();
  @override
  CommissionPolicy rebuild(void Function(CommissionPolicyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPolicyBuilder toBuilder() =>
      CommissionPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPolicy &&
        id == other.id &&
        version == other.version &&
        commissionBasisPoints == other.commissionBasisPoints &&
        rateLabel == other.rateLabel &&
        effectiveFrom == other.effectiveFrom &&
        agreementVersionId == other.agreementVersionId &&
        reason == other.reason &&
        status == other.status &&
        termsVersion == other.termsVersion &&
        termsContent == other.termsContent &&
        vendorMessage == other.vendorMessage &&
        noticeHours == other.noticeHours &&
        noticeOverrideReason == other.noticeOverrideReason &&
        publishedBy == other.publishedBy &&
        delivery == other.delivery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, commissionBasisPoints.hashCode);
    _$hash = $jc(_$hash, rateLabel.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, agreementVersionId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, termsVersion.hashCode);
    _$hash = $jc(_$hash, termsContent.hashCode);
    _$hash = $jc(_$hash, vendorMessage.hashCode);
    _$hash = $jc(_$hash, noticeHours.hashCode);
    _$hash = $jc(_$hash, noticeOverrideReason.hashCode);
    _$hash = $jc(_$hash, publishedBy.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPolicy')
          ..add('id', id)
          ..add('version', version)
          ..add('commissionBasisPoints', commissionBasisPoints)
          ..add('rateLabel', rateLabel)
          ..add('effectiveFrom', effectiveFrom)
          ..add('agreementVersionId', agreementVersionId)
          ..add('reason', reason)
          ..add('status', status)
          ..add('termsVersion', termsVersion)
          ..add('termsContent', termsContent)
          ..add('vendorMessage', vendorMessage)
          ..add('noticeHours', noticeHours)
          ..add('noticeOverrideReason', noticeOverrideReason)
          ..add('publishedBy', publishedBy)
          ..add('delivery', delivery))
        .toString();
  }
}

class CommissionPolicyBuilder
    implements Builder<CommissionPolicy, CommissionPolicyBuilder> {
  _$CommissionPolicy? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  int? _commissionBasisPoints;
  int? get commissionBasisPoints => _$this._commissionBasisPoints;
  set commissionBasisPoints(int? commissionBasisPoints) =>
      _$this._commissionBasisPoints = commissionBasisPoints;

  String? _rateLabel;
  String? get rateLabel => _$this._rateLabel;
  set rateLabel(String? rateLabel) => _$this._rateLabel = rateLabel;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  String? _agreementVersionId;
  String? get agreementVersionId => _$this._agreementVersionId;
  set agreementVersionId(String? agreementVersionId) =>
      _$this._agreementVersionId = agreementVersionId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CommissionPolicyStatusEnum? _status;
  CommissionPolicyStatusEnum? get status => _$this._status;
  set status(CommissionPolicyStatusEnum? status) => _$this._status = status;

  int? _termsVersion;
  int? get termsVersion => _$this._termsVersion;
  set termsVersion(int? termsVersion) => _$this._termsVersion = termsVersion;

  String? _termsContent;
  String? get termsContent => _$this._termsContent;
  set termsContent(String? termsContent) => _$this._termsContent = termsContent;

  String? _vendorMessage;
  String? get vendorMessage => _$this._vendorMessage;
  set vendorMessage(String? vendorMessage) =>
      _$this._vendorMessage = vendorMessage;

  int? _noticeHours;
  int? get noticeHours => _$this._noticeHours;
  set noticeHours(int? noticeHours) => _$this._noticeHours = noticeHours;

  String? _noticeOverrideReason;
  String? get noticeOverrideReason => _$this._noticeOverrideReason;
  set noticeOverrideReason(String? noticeOverrideReason) =>
      _$this._noticeOverrideReason = noticeOverrideReason;

  String? _publishedBy;
  String? get publishedBy => _$this._publishedBy;
  set publishedBy(String? publishedBy) => _$this._publishedBy = publishedBy;

  CommissionEmailSummaryBuilder? _delivery;
  CommissionEmailSummaryBuilder get delivery =>
      _$this._delivery ??= CommissionEmailSummaryBuilder();
  set delivery(CommissionEmailSummaryBuilder? delivery) =>
      _$this._delivery = delivery;

  CommissionPolicyBuilder() {
    CommissionPolicy._defaults(this);
  }

  CommissionPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _commissionBasisPoints = $v.commissionBasisPoints;
      _rateLabel = $v.rateLabel;
      _effectiveFrom = $v.effectiveFrom;
      _agreementVersionId = $v.agreementVersionId;
      _reason = $v.reason;
      _status = $v.status;
      _termsVersion = $v.termsVersion;
      _termsContent = $v.termsContent;
      _vendorMessage = $v.vendorMessage;
      _noticeHours = $v.noticeHours;
      _noticeOverrideReason = $v.noticeOverrideReason;
      _publishedBy = $v.publishedBy;
      _delivery = $v.delivery?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionPolicy other) {
    _$v = other as _$CommissionPolicy;
  }

  @override
  void update(void Function(CommissionPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPolicy build() => _build();

  _$CommissionPolicy _build() {
    _$CommissionPolicy _$result;
    try {
      _$result = _$v ??
          _$CommissionPolicy._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CommissionPolicy', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'CommissionPolicy', 'version'),
            commissionBasisPoints: BuiltValueNullFieldError.checkNotNull(
                commissionBasisPoints,
                r'CommissionPolicy',
                'commissionBasisPoints'),
            rateLabel: BuiltValueNullFieldError.checkNotNull(
                rateLabel, r'CommissionPolicy', 'rateLabel'),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
                effectiveFrom, r'CommissionPolicy', 'effectiveFrom'),
            agreementVersionId: agreementVersionId,
            reason: reason,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CommissionPolicy', 'status'),
            termsVersion: termsVersion,
            termsContent: termsContent,
            vendorMessage: vendorMessage,
            noticeHours: noticeHours,
            noticeOverrideReason: noticeOverrideReason,
            publishedBy: publishedBy,
            delivery: _delivery?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'delivery';
        _delivery?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CommissionPolicy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
