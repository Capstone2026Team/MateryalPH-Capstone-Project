// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorReviewDecisionEnum _$vendorReviewDecisionEnum_APPROVE =
    const VendorReviewDecisionEnum._('APPROVE');
const VendorReviewDecisionEnum
    _$vendorReviewDecisionEnum_RETURN_FOR_CORRECTION =
    const VendorReviewDecisionEnum._('RETURN_FOR_CORRECTION');
const VendorReviewDecisionEnum _$vendorReviewDecisionEnum_REJECT =
    const VendorReviewDecisionEnum._('REJECT');

VendorReviewDecisionEnum _$vendorReviewDecisionEnumValueOf(String name) {
  switch (name) {
    case 'APPROVE':
      return _$vendorReviewDecisionEnum_APPROVE;
    case 'RETURN_FOR_CORRECTION':
      return _$vendorReviewDecisionEnum_RETURN_FOR_CORRECTION;
    case 'REJECT':
      return _$vendorReviewDecisionEnum_REJECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorReviewDecisionEnum> _$vendorReviewDecisionEnumValues =
    BuiltSet<VendorReviewDecisionEnum>(const <VendorReviewDecisionEnum>[
  _$vendorReviewDecisionEnum_APPROVE,
  _$vendorReviewDecisionEnum_RETURN_FOR_CORRECTION,
  _$vendorReviewDecisionEnum_REJECT,
]);

Serializer<VendorReviewDecisionEnum> _$vendorReviewDecisionEnumSerializer =
    _$VendorReviewDecisionEnumSerializer();

class _$VendorReviewDecisionEnumSerializer
    implements PrimitiveSerializer<VendorReviewDecisionEnum> {
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
  final Iterable<Type> types = const <Type>[VendorReviewDecisionEnum];
  @override
  final String wireName = 'VendorReviewDecisionEnum';

  @override
  Object serialize(Serializers serializers, VendorReviewDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorReviewDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorReviewDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorReview extends VendorReview {
  @override
  final int lockVersion;
  @override
  final VendorReviewDecisionEnum decision;
  @override
  final String? reason;

  factory _$VendorReview([void Function(VendorReviewBuilder)? updates]) =>
      (VendorReviewBuilder()..update(updates))._build();

  _$VendorReview._(
      {required this.lockVersion, required this.decision, this.reason})
      : super._();
  @override
  VendorReview rebuild(void Function(VendorReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorReviewBuilder toBuilder() => VendorReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorReview &&
        lockVersion == other.lockVersion &&
        decision == other.decision &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorReview')
          ..add('lockVersion', lockVersion)
          ..add('decision', decision)
          ..add('reason', reason))
        .toString();
  }
}

class VendorReviewBuilder
    implements Builder<VendorReview, VendorReviewBuilder> {
  _$VendorReview? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorReviewDecisionEnum? _decision;
  VendorReviewDecisionEnum? get decision => _$this._decision;
  set decision(VendorReviewDecisionEnum? decision) =>
      _$this._decision = decision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  VendorReviewBuilder() {
    VendorReview._defaults(this);
  }

  VendorReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _decision = $v.decision;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorReview other) {
    _$v = other as _$VendorReview;
  }

  @override
  void update(void Function(VendorReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorReview build() => _build();

  _$VendorReview _build() {
    final _$result = _$v ??
        _$VendorReview._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorReview', 'lockVersion'),
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'VendorReview', 'decision'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
