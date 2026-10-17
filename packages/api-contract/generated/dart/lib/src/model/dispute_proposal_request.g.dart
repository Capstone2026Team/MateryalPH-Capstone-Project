// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_proposal_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeProposalRequestRemedyEnum
    _$disputeProposalRequestRemedyEnum_REPLACEMENT =
    const DisputeProposalRequestRemedyEnum._('REPLACEMENT');
const DisputeProposalRequestRemedyEnum
    _$disputeProposalRequestRemedyEnum_FULL_REFUND =
    const DisputeProposalRequestRemedyEnum._('FULL_REFUND');
const DisputeProposalRequestRemedyEnum
    _$disputeProposalRequestRemedyEnum_PARTIAL_REFUND =
    const DisputeProposalRequestRemedyEnum._('PARTIAL_REFUND');
const DisputeProposalRequestRemedyEnum
    _$disputeProposalRequestRemedyEnum_NO_FURTHER_ACTION =
    const DisputeProposalRequestRemedyEnum._('NO_FURTHER_ACTION');

DisputeProposalRequestRemedyEnum _$disputeProposalRequestRemedyEnumValueOf(
    String name) {
  switch (name) {
    case 'REPLACEMENT':
      return _$disputeProposalRequestRemedyEnum_REPLACEMENT;
    case 'FULL_REFUND':
      return _$disputeProposalRequestRemedyEnum_FULL_REFUND;
    case 'PARTIAL_REFUND':
      return _$disputeProposalRequestRemedyEnum_PARTIAL_REFUND;
    case 'NO_FURTHER_ACTION':
      return _$disputeProposalRequestRemedyEnum_NO_FURTHER_ACTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeProposalRequestRemedyEnum>
    _$disputeProposalRequestRemedyEnumValues = BuiltSet<
        DisputeProposalRequestRemedyEnum>(const <DisputeProposalRequestRemedyEnum>[
  _$disputeProposalRequestRemedyEnum_REPLACEMENT,
  _$disputeProposalRequestRemedyEnum_FULL_REFUND,
  _$disputeProposalRequestRemedyEnum_PARTIAL_REFUND,
  _$disputeProposalRequestRemedyEnum_NO_FURTHER_ACTION,
]);

Serializer<DisputeProposalRequestRemedyEnum>
    _$disputeProposalRequestRemedyEnumSerializer =
    _$DisputeProposalRequestRemedyEnumSerializer();

class _$DisputeProposalRequestRemedyEnumSerializer
    implements PrimitiveSerializer<DisputeProposalRequestRemedyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeProposalRequestRemedyEnum];
  @override
  final String wireName = 'DisputeProposalRequestRemedyEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeProposalRequestRemedyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeProposalRequestRemedyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeProposalRequestRemedyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeProposalRequest extends DisputeProposalRequest {
  @override
  final DisputeProposalRequestRemedyEnum remedy;
  @override
  final int? amountCentavos;
  @override
  final String terms;

  factory _$DisputeProposalRequest(
          [void Function(DisputeProposalRequestBuilder)? updates]) =>
      (DisputeProposalRequestBuilder()..update(updates))._build();

  _$DisputeProposalRequest._(
      {required this.remedy, this.amountCentavos, required this.terms})
      : super._();
  @override
  DisputeProposalRequest rebuild(
          void Function(DisputeProposalRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeProposalRequestBuilder toBuilder() =>
      DisputeProposalRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeProposalRequest &&
        remedy == other.remedy &&
        amountCentavos == other.amountCentavos &&
        terms == other.terms;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, remedy.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, terms.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeProposalRequest')
          ..add('remedy', remedy)
          ..add('amountCentavos', amountCentavos)
          ..add('terms', terms))
        .toString();
  }
}

class DisputeProposalRequestBuilder
    implements Builder<DisputeProposalRequest, DisputeProposalRequestBuilder> {
  _$DisputeProposalRequest? _$v;

  DisputeProposalRequestRemedyEnum? _remedy;
  DisputeProposalRequestRemedyEnum? get remedy => _$this._remedy;
  set remedy(DisputeProposalRequestRemedyEnum? remedy) =>
      _$this._remedy = remedy;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _terms;
  String? get terms => _$this._terms;
  set terms(String? terms) => _$this._terms = terms;

  DisputeProposalRequestBuilder() {
    DisputeProposalRequest._defaults(this);
  }

  DisputeProposalRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _remedy = $v.remedy;
      _amountCentavos = $v.amountCentavos;
      _terms = $v.terms;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeProposalRequest other) {
    _$v = other as _$DisputeProposalRequest;
  }

  @override
  void update(void Function(DisputeProposalRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeProposalRequest build() => _build();

  _$DisputeProposalRequest _build() {
    final _$result = _$v ??
        _$DisputeProposalRequest._(
          remedy: BuiltValueNullFieldError.checkNotNull(
              remedy, r'DisputeProposalRequest', 'remedy'),
          amountCentavos: amountCentavos,
          terms: BuiltValueNullFieldError.checkNotNull(
              terms, r'DisputeProposalRequest', 'terms'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
