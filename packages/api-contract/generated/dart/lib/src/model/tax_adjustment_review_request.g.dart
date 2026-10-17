// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_adjustment_review_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaxAdjustmentReviewRequestDecisionEnum
    _$taxAdjustmentReviewRequestDecisionEnum_APPROVED =
    const TaxAdjustmentReviewRequestDecisionEnum._('APPROVED');
const TaxAdjustmentReviewRequestDecisionEnum
    _$taxAdjustmentReviewRequestDecisionEnum_REJECTED =
    const TaxAdjustmentReviewRequestDecisionEnum._('REJECTED');

TaxAdjustmentReviewRequestDecisionEnum
    _$taxAdjustmentReviewRequestDecisionEnumValueOf(String name) {
  switch (name) {
    case 'APPROVED':
      return _$taxAdjustmentReviewRequestDecisionEnum_APPROVED;
    case 'REJECTED':
      return _$taxAdjustmentReviewRequestDecisionEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxAdjustmentReviewRequestDecisionEnum>
    _$taxAdjustmentReviewRequestDecisionEnumValues = BuiltSet<
        TaxAdjustmentReviewRequestDecisionEnum>(const <TaxAdjustmentReviewRequestDecisionEnum>[
  _$taxAdjustmentReviewRequestDecisionEnum_APPROVED,
  _$taxAdjustmentReviewRequestDecisionEnum_REJECTED,
]);

Serializer<TaxAdjustmentReviewRequestDecisionEnum>
    _$taxAdjustmentReviewRequestDecisionEnumSerializer =
    _$TaxAdjustmentReviewRequestDecisionEnumSerializer();

class _$TaxAdjustmentReviewRequestDecisionEnumSerializer
    implements PrimitiveSerializer<TaxAdjustmentReviewRequestDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TaxAdjustmentReviewRequestDecisionEnum
  ];
  @override
  final String wireName = 'TaxAdjustmentReviewRequestDecisionEnum';

  @override
  Object serialize(Serializers serializers,
          TaxAdjustmentReviewRequestDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxAdjustmentReviewRequestDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxAdjustmentReviewRequestDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxAdjustmentReviewRequest extends TaxAdjustmentReviewRequest {
  @override
  final TaxAdjustmentReviewRequestDecisionEnum decision;
  @override
  final String reason;

  factory _$TaxAdjustmentReviewRequest(
          [void Function(TaxAdjustmentReviewRequestBuilder)? updates]) =>
      (TaxAdjustmentReviewRequestBuilder()..update(updates))._build();

  _$TaxAdjustmentReviewRequest._({required this.decision, required this.reason})
      : super._();
  @override
  TaxAdjustmentReviewRequest rebuild(
          void Function(TaxAdjustmentReviewRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxAdjustmentReviewRequestBuilder toBuilder() =>
      TaxAdjustmentReviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxAdjustmentReviewRequest &&
        decision == other.decision &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxAdjustmentReviewRequest')
          ..add('decision', decision)
          ..add('reason', reason))
        .toString();
  }
}

class TaxAdjustmentReviewRequestBuilder
    implements
        Builder<TaxAdjustmentReviewRequest, TaxAdjustmentReviewRequestBuilder> {
  _$TaxAdjustmentReviewRequest? _$v;

  TaxAdjustmentReviewRequestDecisionEnum? _decision;
  TaxAdjustmentReviewRequestDecisionEnum? get decision => _$this._decision;
  set decision(TaxAdjustmentReviewRequestDecisionEnum? decision) =>
      _$this._decision = decision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  TaxAdjustmentReviewRequestBuilder() {
    TaxAdjustmentReviewRequest._defaults(this);
  }

  TaxAdjustmentReviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxAdjustmentReviewRequest other) {
    _$v = other as _$TaxAdjustmentReviewRequest;
  }

  @override
  void update(void Function(TaxAdjustmentReviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxAdjustmentReviewRequest build() => _build();

  _$TaxAdjustmentReviewRequest _build() {
    final _$result = _$v ??
        _$TaxAdjustmentReviewRequest._(
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'TaxAdjustmentReviewRequest', 'decision'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'TaxAdjustmentReviewRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
