// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_compliance_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProductComplianceDecisionDecisionEnum
    _$productComplianceDecisionDecisionEnum_APPROVED =
    const ProductComplianceDecisionDecisionEnum._('APPROVED');
const ProductComplianceDecisionDecisionEnum
    _$productComplianceDecisionDecisionEnum_CHANGES_REQUIRED =
    const ProductComplianceDecisionDecisionEnum._('CHANGES_REQUIRED');
const ProductComplianceDecisionDecisionEnum
    _$productComplianceDecisionDecisionEnum_REJECTED =
    const ProductComplianceDecisionDecisionEnum._('REJECTED');

ProductComplianceDecisionDecisionEnum
    _$productComplianceDecisionDecisionEnumValueOf(String name) {
  switch (name) {
    case 'APPROVED':
      return _$productComplianceDecisionDecisionEnum_APPROVED;
    case 'CHANGES_REQUIRED':
      return _$productComplianceDecisionDecisionEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$productComplianceDecisionDecisionEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProductComplianceDecisionDecisionEnum>
    _$productComplianceDecisionDecisionEnumValues = BuiltSet<
        ProductComplianceDecisionDecisionEnum>(const <ProductComplianceDecisionDecisionEnum>[
  _$productComplianceDecisionDecisionEnum_APPROVED,
  _$productComplianceDecisionDecisionEnum_CHANGES_REQUIRED,
  _$productComplianceDecisionDecisionEnum_REJECTED,
]);

Serializer<ProductComplianceDecisionDecisionEnum>
    _$productComplianceDecisionDecisionEnumSerializer =
    _$ProductComplianceDecisionDecisionEnumSerializer();

class _$ProductComplianceDecisionDecisionEnumSerializer
    implements PrimitiveSerializer<ProductComplianceDecisionDecisionEnum> {
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
    ProductComplianceDecisionDecisionEnum
  ];
  @override
  final String wireName = 'ProductComplianceDecisionDecisionEnum';

  @override
  Object serialize(
          Serializers serializers, ProductComplianceDecisionDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProductComplianceDecisionDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProductComplianceDecisionDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProductComplianceDecision extends ProductComplianceDecision {
  @override
  final ProductComplianceDecisionDecisionEnum decision;
  @override
  final int lockVersion;
  @override
  final String? reason;
  @override
  final String? remarks;
  @override
  final String? sourceReference;

  factory _$ProductComplianceDecision(
          [void Function(ProductComplianceDecisionBuilder)? updates]) =>
      (ProductComplianceDecisionBuilder()..update(updates))._build();

  _$ProductComplianceDecision._(
      {required this.decision,
      required this.lockVersion,
      this.reason,
      this.remarks,
      this.sourceReference})
      : super._();
  @override
  ProductComplianceDecision rebuild(
          void Function(ProductComplianceDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductComplianceDecisionBuilder toBuilder() =>
      ProductComplianceDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductComplianceDecision &&
        decision == other.decision &&
        lockVersion == other.lockVersion &&
        reason == other.reason &&
        remarks == other.remarks &&
        sourceReference == other.sourceReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, remarks.hashCode);
    _$hash = $jc(_$hash, sourceReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductComplianceDecision')
          ..add('decision', decision)
          ..add('lockVersion', lockVersion)
          ..add('reason', reason)
          ..add('remarks', remarks)
          ..add('sourceReference', sourceReference))
        .toString();
  }
}

class ProductComplianceDecisionBuilder
    implements
        Builder<ProductComplianceDecision, ProductComplianceDecisionBuilder> {
  _$ProductComplianceDecision? _$v;

  ProductComplianceDecisionDecisionEnum? _decision;
  ProductComplianceDecisionDecisionEnum? get decision => _$this._decision;
  set decision(ProductComplianceDecisionDecisionEnum? decision) =>
      _$this._decision = decision;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _remarks;
  String? get remarks => _$this._remarks;
  set remarks(String? remarks) => _$this._remarks = remarks;

  String? _sourceReference;
  String? get sourceReference => _$this._sourceReference;
  set sourceReference(String? sourceReference) =>
      _$this._sourceReference = sourceReference;

  ProductComplianceDecisionBuilder() {
    ProductComplianceDecision._defaults(this);
  }

  ProductComplianceDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _remarks = $v.remarks;
      _sourceReference = $v.sourceReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductComplianceDecision other) {
    _$v = other as _$ProductComplianceDecision;
  }

  @override
  void update(void Function(ProductComplianceDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductComplianceDecision build() => _build();

  _$ProductComplianceDecision _build() {
    final _$result = _$v ??
        _$ProductComplianceDecision._(
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'ProductComplianceDecision', 'decision'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProductComplianceDecision', 'lockVersion'),
          reason: reason,
          remarks: remarks,
          sourceReference: sourceReference,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
