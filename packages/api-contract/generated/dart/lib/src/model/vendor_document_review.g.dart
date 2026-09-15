// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDocumentReviewDecisionEnum
    _$vendorDocumentReviewDecisionEnum_APPROVE =
    const VendorDocumentReviewDecisionEnum._('APPROVE');
const VendorDocumentReviewDecisionEnum
    _$vendorDocumentReviewDecisionEnum_RETURN_FOR_CORRECTION =
    const VendorDocumentReviewDecisionEnum._('RETURN_FOR_CORRECTION');
const VendorDocumentReviewDecisionEnum
    _$vendorDocumentReviewDecisionEnum_REJECT =
    const VendorDocumentReviewDecisionEnum._('REJECT');

VendorDocumentReviewDecisionEnum _$vendorDocumentReviewDecisionEnumValueOf(
    String name) {
  switch (name) {
    case 'APPROVE':
      return _$vendorDocumentReviewDecisionEnum_APPROVE;
    case 'RETURN_FOR_CORRECTION':
      return _$vendorDocumentReviewDecisionEnum_RETURN_FOR_CORRECTION;
    case 'REJECT':
      return _$vendorDocumentReviewDecisionEnum_REJECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDocumentReviewDecisionEnum>
    _$vendorDocumentReviewDecisionEnumValues = BuiltSet<
        VendorDocumentReviewDecisionEnum>(const <VendorDocumentReviewDecisionEnum>[
  _$vendorDocumentReviewDecisionEnum_APPROVE,
  _$vendorDocumentReviewDecisionEnum_RETURN_FOR_CORRECTION,
  _$vendorDocumentReviewDecisionEnum_REJECT,
]);

Serializer<VendorDocumentReviewDecisionEnum>
    _$vendorDocumentReviewDecisionEnumSerializer =
    _$VendorDocumentReviewDecisionEnumSerializer();

class _$VendorDocumentReviewDecisionEnumSerializer
    implements PrimitiveSerializer<VendorDocumentReviewDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVE': 'APPROVE',
    'RETURN_FOR_CORRECTION': 'RETURN_FOR_CORRECTION',
    'REJECT': 'REJECT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVE': 'APPROVE',
    'RETURN_FOR_CORRECTION': 'RETURN_FOR_CORRECTION',
    'REJECT': 'REJECT',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorDocumentReviewDecisionEnum];
  @override
  final String wireName = 'VendorDocumentReviewDecisionEnum';

  @override
  Object serialize(
          Serializers serializers, VendorDocumentReviewDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDocumentReviewDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDocumentReviewDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDocumentReview extends VendorDocumentReview {
  @override
  final int lockVersion;
  @override
  final VendorDocumentReviewDecisionEnum decision;
  @override
  final String? reason;
  @override
  final String? verifiedReference;
  @override
  final String? verifiedIssuedOn;
  @override
  final String? verifiedExpiresOn;
  @override
  final bool verifiedExpiryNotApplicable;
  @override
  final String sourceReference;
  @override
  final String? remarks;
  @override
  final bool immediateRestriction;

  factory _$VendorDocumentReview(
          [void Function(VendorDocumentReviewBuilder)? updates]) =>
      (VendorDocumentReviewBuilder()..update(updates))._build();

  _$VendorDocumentReview._(
      {required this.lockVersion,
      required this.decision,
      this.reason,
      this.verifiedReference,
      this.verifiedIssuedOn,
      this.verifiedExpiresOn,
      required this.verifiedExpiryNotApplicable,
      required this.sourceReference,
      this.remarks,
      required this.immediateRestriction})
      : super._();
  @override
  VendorDocumentReview rebuild(
          void Function(VendorDocumentReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentReviewBuilder toBuilder() =>
      VendorDocumentReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocumentReview &&
        lockVersion == other.lockVersion &&
        decision == other.decision &&
        reason == other.reason &&
        verifiedReference == other.verifiedReference &&
        verifiedIssuedOn == other.verifiedIssuedOn &&
        verifiedExpiresOn == other.verifiedExpiresOn &&
        verifiedExpiryNotApplicable == other.verifiedExpiryNotApplicable &&
        sourceReference == other.sourceReference &&
        remarks == other.remarks &&
        immediateRestriction == other.immediateRestriction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, verifiedReference.hashCode);
    _$hash = $jc(_$hash, verifiedIssuedOn.hashCode);
    _$hash = $jc(_$hash, verifiedExpiresOn.hashCode);
    _$hash = $jc(_$hash, verifiedExpiryNotApplicable.hashCode);
    _$hash = $jc(_$hash, sourceReference.hashCode);
    _$hash = $jc(_$hash, remarks.hashCode);
    _$hash = $jc(_$hash, immediateRestriction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDocumentReview')
          ..add('lockVersion', lockVersion)
          ..add('decision', decision)
          ..add('reason', reason)
          ..add('verifiedReference', verifiedReference)
          ..add('verifiedIssuedOn', verifiedIssuedOn)
          ..add('verifiedExpiresOn', verifiedExpiresOn)
          ..add('verifiedExpiryNotApplicable', verifiedExpiryNotApplicable)
          ..add('sourceReference', sourceReference)
          ..add('remarks', remarks)
          ..add('immediateRestriction', immediateRestriction))
        .toString();
  }
}

class VendorDocumentReviewBuilder
    implements Builder<VendorDocumentReview, VendorDocumentReviewBuilder> {
  _$VendorDocumentReview? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorDocumentReviewDecisionEnum? _decision;
  VendorDocumentReviewDecisionEnum? get decision => _$this._decision;
  set decision(VendorDocumentReviewDecisionEnum? decision) =>
      _$this._decision = decision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _verifiedReference;
  String? get verifiedReference => _$this._verifiedReference;
  set verifiedReference(String? verifiedReference) =>
      _$this._verifiedReference = verifiedReference;

  String? _verifiedIssuedOn;
  String? get verifiedIssuedOn => _$this._verifiedIssuedOn;
  set verifiedIssuedOn(String? verifiedIssuedOn) =>
      _$this._verifiedIssuedOn = verifiedIssuedOn;

  String? _verifiedExpiresOn;
  String? get verifiedExpiresOn => _$this._verifiedExpiresOn;
  set verifiedExpiresOn(String? verifiedExpiresOn) =>
      _$this._verifiedExpiresOn = verifiedExpiresOn;

  bool? _verifiedExpiryNotApplicable;
  bool? get verifiedExpiryNotApplicable => _$this._verifiedExpiryNotApplicable;
  set verifiedExpiryNotApplicable(bool? verifiedExpiryNotApplicable) =>
      _$this._verifiedExpiryNotApplicable = verifiedExpiryNotApplicable;

  String? _sourceReference;
  String? get sourceReference => _$this._sourceReference;
  set sourceReference(String? sourceReference) =>
      _$this._sourceReference = sourceReference;

  String? _remarks;
  String? get remarks => _$this._remarks;
  set remarks(String? remarks) => _$this._remarks = remarks;

  bool? _immediateRestriction;
  bool? get immediateRestriction => _$this._immediateRestriction;
  set immediateRestriction(bool? immediateRestriction) =>
      _$this._immediateRestriction = immediateRestriction;

  VendorDocumentReviewBuilder() {
    VendorDocumentReview._defaults(this);
  }

  VendorDocumentReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _decision = $v.decision;
      _reason = $v.reason;
      _verifiedReference = $v.verifiedReference;
      _verifiedIssuedOn = $v.verifiedIssuedOn;
      _verifiedExpiresOn = $v.verifiedExpiresOn;
      _verifiedExpiryNotApplicable = $v.verifiedExpiryNotApplicable;
      _sourceReference = $v.sourceReference;
      _remarks = $v.remarks;
      _immediateRestriction = $v.immediateRestriction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDocumentReview other) {
    _$v = other as _$VendorDocumentReview;
  }

  @override
  void update(void Function(VendorDocumentReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocumentReview build() => _build();

  _$VendorDocumentReview _build() {
    final _$result = _$v ??
        _$VendorDocumentReview._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorDocumentReview', 'lockVersion'),
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'VendorDocumentReview', 'decision'),
          reason: reason,
          verifiedReference: verifiedReference,
          verifiedIssuedOn: verifiedIssuedOn,
          verifiedExpiresOn: verifiedExpiresOn,
          verifiedExpiryNotApplicable: BuiltValueNullFieldError.checkNotNull(
              verifiedExpiryNotApplicable,
              r'VendorDocumentReview',
              'verifiedExpiryNotApplicable'),
          sourceReference: BuiltValueNullFieldError.checkNotNull(
              sourceReference, r'VendorDocumentReview', 'sourceReference'),
          remarks: remarks,
          immediateRestriction: BuiltValueNullFieldError.checkNotNull(
              immediateRestriction,
              r'VendorDocumentReview',
              'immediateRestriction'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
