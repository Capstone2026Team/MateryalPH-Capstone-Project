// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_business_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorBusinessReviewDecisionEnum
    _$vendorBusinessReviewDecisionEnum_APPROVE =
    const VendorBusinessReviewDecisionEnum._('APPROVE');
const VendorBusinessReviewDecisionEnum
    _$vendorBusinessReviewDecisionEnum_RETURN_FOR_CORRECTION =
    const VendorBusinessReviewDecisionEnum._('RETURN_FOR_CORRECTION');
const VendorBusinessReviewDecisionEnum
    _$vendorBusinessReviewDecisionEnum_REJECT =
    const VendorBusinessReviewDecisionEnum._('REJECT');

VendorBusinessReviewDecisionEnum _$vendorBusinessReviewDecisionEnumValueOf(
    String name) {
  switch (name) {
    case 'APPROVE':
      return _$vendorBusinessReviewDecisionEnum_APPROVE;
    case 'RETURN_FOR_CORRECTION':
      return _$vendorBusinessReviewDecisionEnum_RETURN_FOR_CORRECTION;
    case 'REJECT':
      return _$vendorBusinessReviewDecisionEnum_REJECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorBusinessReviewDecisionEnum>
    _$vendorBusinessReviewDecisionEnumValues = BuiltSet<
        VendorBusinessReviewDecisionEnum>(const <VendorBusinessReviewDecisionEnum>[
  _$vendorBusinessReviewDecisionEnum_APPROVE,
  _$vendorBusinessReviewDecisionEnum_RETURN_FOR_CORRECTION,
  _$vendorBusinessReviewDecisionEnum_REJECT,
]);

Serializer<VendorBusinessReviewDecisionEnum>
    _$vendorBusinessReviewDecisionEnumSerializer =
    _$VendorBusinessReviewDecisionEnumSerializer();

class _$VendorBusinessReviewDecisionEnumSerializer
    implements PrimitiveSerializer<VendorBusinessReviewDecisionEnum> {
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
  final Iterable<Type> types = const <Type>[VendorBusinessReviewDecisionEnum];
  @override
  final String wireName = 'VendorBusinessReviewDecisionEnum';

  @override
  Object serialize(
          Serializers serializers, VendorBusinessReviewDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorBusinessReviewDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorBusinessReviewDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorBusinessReview extends VendorBusinessReview {
  @override
  final int lockVersion;
  @override
  final VendorBusinessReviewDecisionEnum decision;
  @override
  final String? reason;
  @override
  final bool? regulatoryEvidenceRequired;
  @override
  final String? regulatoryReviewBasis;

  factory _$VendorBusinessReview(
          [void Function(VendorBusinessReviewBuilder)? updates]) =>
      (VendorBusinessReviewBuilder()..update(updates))._build();

  _$VendorBusinessReview._(
      {required this.lockVersion,
      required this.decision,
      this.reason,
      this.regulatoryEvidenceRequired,
      this.regulatoryReviewBasis})
      : super._();
  @override
  VendorBusinessReview rebuild(
          void Function(VendorBusinessReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBusinessReviewBuilder toBuilder() =>
      VendorBusinessReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBusinessReview &&
        lockVersion == other.lockVersion &&
        decision == other.decision &&
        reason == other.reason &&
        regulatoryEvidenceRequired == other.regulatoryEvidenceRequired &&
        regulatoryReviewBasis == other.regulatoryReviewBasis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, regulatoryEvidenceRequired.hashCode);
    _$hash = $jc(_$hash, regulatoryReviewBasis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorBusinessReview')
          ..add('lockVersion', lockVersion)
          ..add('decision', decision)
          ..add('reason', reason)
          ..add('regulatoryEvidenceRequired', regulatoryEvidenceRequired)
          ..add('regulatoryReviewBasis', regulatoryReviewBasis))
        .toString();
  }
}

class VendorBusinessReviewBuilder
    implements Builder<VendorBusinessReview, VendorBusinessReviewBuilder> {
  _$VendorBusinessReview? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorBusinessReviewDecisionEnum? _decision;
  VendorBusinessReviewDecisionEnum? get decision => _$this._decision;
  set decision(VendorBusinessReviewDecisionEnum? decision) =>
      _$this._decision = decision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _regulatoryEvidenceRequired;
  bool? get regulatoryEvidenceRequired => _$this._regulatoryEvidenceRequired;
  set regulatoryEvidenceRequired(bool? regulatoryEvidenceRequired) =>
      _$this._regulatoryEvidenceRequired = regulatoryEvidenceRequired;

  String? _regulatoryReviewBasis;
  String? get regulatoryReviewBasis => _$this._regulatoryReviewBasis;
  set regulatoryReviewBasis(String? regulatoryReviewBasis) =>
      _$this._regulatoryReviewBasis = regulatoryReviewBasis;

  VendorBusinessReviewBuilder() {
    VendorBusinessReview._defaults(this);
  }

  VendorBusinessReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _decision = $v.decision;
      _reason = $v.reason;
      _regulatoryEvidenceRequired = $v.regulatoryEvidenceRequired;
      _regulatoryReviewBasis = $v.regulatoryReviewBasis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorBusinessReview other) {
    _$v = other as _$VendorBusinessReview;
  }

  @override
  void update(void Function(VendorBusinessReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBusinessReview build() => _build();

  _$VendorBusinessReview _build() {
    final _$result = _$v ??
        _$VendorBusinessReview._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorBusinessReview', 'lockVersion'),
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'VendorBusinessReview', 'decision'),
          reason: reason,
          regulatoryEvidenceRequired: regulatoryEvidenceRequired,
          regulatoryReviewBasis: regulatoryReviewBasis,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
