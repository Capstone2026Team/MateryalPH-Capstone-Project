// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_review_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceReviewSummaryDecisionEnum
    _$complianceReviewSummaryDecisionEnum_APPROVED =
    const ComplianceReviewSummaryDecisionEnum._('APPROVED');
const ComplianceReviewSummaryDecisionEnum
    _$complianceReviewSummaryDecisionEnum_CHANGES_REQUIRED =
    const ComplianceReviewSummaryDecisionEnum._('CHANGES_REQUIRED');
const ComplianceReviewSummaryDecisionEnum
    _$complianceReviewSummaryDecisionEnum_REJECTED =
    const ComplianceReviewSummaryDecisionEnum._('REJECTED');

ComplianceReviewSummaryDecisionEnum
    _$complianceReviewSummaryDecisionEnumValueOf(String name) {
  switch (name) {
    case 'APPROVED':
      return _$complianceReviewSummaryDecisionEnum_APPROVED;
    case 'CHANGES_REQUIRED':
      return _$complianceReviewSummaryDecisionEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$complianceReviewSummaryDecisionEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceReviewSummaryDecisionEnum>
    _$complianceReviewSummaryDecisionEnumValues = BuiltSet<
        ComplianceReviewSummaryDecisionEnum>(const <ComplianceReviewSummaryDecisionEnum>[
  _$complianceReviewSummaryDecisionEnum_APPROVED,
  _$complianceReviewSummaryDecisionEnum_CHANGES_REQUIRED,
  _$complianceReviewSummaryDecisionEnum_REJECTED,
]);

const ComplianceReviewSummarySource_Enum
    _$complianceReviewSummarySourceEnum_ADMIN =
    const ComplianceReviewSummarySource_Enum._('ADMIN');
const ComplianceReviewSummarySource_Enum
    _$complianceReviewSummarySourceEnum_SYSTEM_REGISTER_MATCH =
    const ComplianceReviewSummarySource_Enum._('SYSTEM_REGISTER_MATCH');

ComplianceReviewSummarySource_Enum _$complianceReviewSummarySourceEnumValueOf(
    String name) {
  switch (name) {
    case 'ADMIN':
      return _$complianceReviewSummarySourceEnum_ADMIN;
    case 'SYSTEM_REGISTER_MATCH':
      return _$complianceReviewSummarySourceEnum_SYSTEM_REGISTER_MATCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceReviewSummarySource_Enum>
    _$complianceReviewSummarySourceEnumValues = BuiltSet<
        ComplianceReviewSummarySource_Enum>(const <ComplianceReviewSummarySource_Enum>[
  _$complianceReviewSummarySourceEnum_ADMIN,
  _$complianceReviewSummarySourceEnum_SYSTEM_REGISTER_MATCH,
]);

Serializer<ComplianceReviewSummaryDecisionEnum>
    _$complianceReviewSummaryDecisionEnumSerializer =
    _$ComplianceReviewSummaryDecisionEnumSerializer();
Serializer<ComplianceReviewSummarySource_Enum>
    _$complianceReviewSummarySourceEnumSerializer =
    _$ComplianceReviewSummarySource_EnumSerializer();

class _$ComplianceReviewSummaryDecisionEnumSerializer
    implements PrimitiveSerializer<ComplianceReviewSummaryDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVED': 'APPROVED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVED': 'APPROVED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ComplianceReviewSummaryDecisionEnum
  ];
  @override
  final String wireName = 'ComplianceReviewSummaryDecisionEnum';

  @override
  Object serialize(
          Serializers serializers, ComplianceReviewSummaryDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceReviewSummaryDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceReviewSummaryDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceReviewSummarySource_EnumSerializer
    implements PrimitiveSerializer<ComplianceReviewSummarySource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
    'SYSTEM_REGISTER_MATCH': 'SYSTEM_REGISTER_MATCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
    'SYSTEM_REGISTER_MATCH': 'SYSTEM_REGISTER_MATCH',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceReviewSummarySource_Enum];
  @override
  final String wireName = 'ComplianceReviewSummarySource_Enum';

  @override
  Object serialize(
          Serializers serializers, ComplianceReviewSummarySource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceReviewSummarySource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceReviewSummarySource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceReviewSummary extends ComplianceReviewSummary {
  @override
  final ComplianceReviewSummaryDecisionEnum decision;
  @override
  final String? reason;
  @override
  final String? reviewedAt;
  @override
  final ComplianceReviewSummarySource_Enum source_;

  factory _$ComplianceReviewSummary(
          [void Function(ComplianceReviewSummaryBuilder)? updates]) =>
      (ComplianceReviewSummaryBuilder()..update(updates))._build();

  _$ComplianceReviewSummary._(
      {required this.decision,
      this.reason,
      this.reviewedAt,
      required this.source_})
      : super._();
  @override
  ComplianceReviewSummary rebuild(
          void Function(ComplianceReviewSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceReviewSummaryBuilder toBuilder() =>
      ComplianceReviewSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceReviewSummary &&
        decision == other.decision &&
        reason == other.reason &&
        reviewedAt == other.reviewedAt &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceReviewSummary')
          ..add('decision', decision)
          ..add('reason', reason)
          ..add('reviewedAt', reviewedAt)
          ..add('source_', source_))
        .toString();
  }
}

class ComplianceReviewSummaryBuilder
    implements
        Builder<ComplianceReviewSummary, ComplianceReviewSummaryBuilder> {
  _$ComplianceReviewSummary? _$v;

  ComplianceReviewSummaryDecisionEnum? _decision;
  ComplianceReviewSummaryDecisionEnum? get decision => _$this._decision;
  set decision(ComplianceReviewSummaryDecisionEnum? decision) =>
      _$this._decision = decision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _reviewedAt;
  String? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(String? reviewedAt) => _$this._reviewedAt = reviewedAt;

  ComplianceReviewSummarySource_Enum? _source_;
  ComplianceReviewSummarySource_Enum? get source_ => _$this._source_;
  set source_(ComplianceReviewSummarySource_Enum? source_) =>
      _$this._source_ = source_;

  ComplianceReviewSummaryBuilder() {
    ComplianceReviewSummary._defaults(this);
  }

  ComplianceReviewSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _reason = $v.reason;
      _reviewedAt = $v.reviewedAt;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceReviewSummary other) {
    _$v = other as _$ComplianceReviewSummary;
  }

  @override
  void update(void Function(ComplianceReviewSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceReviewSummary build() => _build();

  _$ComplianceReviewSummary _build() {
    final _$result = _$v ??
        _$ComplianceReviewSummary._(
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'ComplianceReviewSummary', 'decision'),
          reason: reason,
          reviewedAt: reviewedAt,
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'ComplianceReviewSummary', 'source_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
