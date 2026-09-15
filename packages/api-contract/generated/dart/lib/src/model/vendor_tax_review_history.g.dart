// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tax_review_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTaxReviewHistoryEnvironmentEnum
    _$vendorTaxReviewHistoryEnvironmentEnum_TEST =
    const VendorTaxReviewHistoryEnvironmentEnum._('TEST');

VendorTaxReviewHistoryEnvironmentEnum
    _$vendorTaxReviewHistoryEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$vendorTaxReviewHistoryEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTaxReviewHistoryEnvironmentEnum>
    _$vendorTaxReviewHistoryEnvironmentEnumValues = BuiltSet<
        VendorTaxReviewHistoryEnvironmentEnum>(const <VendorTaxReviewHistoryEnvironmentEnum>[
  _$vendorTaxReviewHistoryEnvironmentEnum_TEST,
]);

Serializer<VendorTaxReviewHistoryEnvironmentEnum>
    _$vendorTaxReviewHistoryEnvironmentEnumSerializer =
    _$VendorTaxReviewHistoryEnvironmentEnumSerializer();

class _$VendorTaxReviewHistoryEnvironmentEnumSerializer
    implements PrimitiveSerializer<VendorTaxReviewHistoryEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTaxReviewHistoryEnvironmentEnum
  ];
  @override
  final String wireName = 'VendorTaxReviewHistoryEnvironmentEnum';

  @override
  Object serialize(
          Serializers serializers, VendorTaxReviewHistoryEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTaxReviewHistoryEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTaxReviewHistoryEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTaxReviewHistory extends VendorTaxReviewHistory {
  @override
  final String id;
  @override
  final String decision;
  @override
  final String? reason;
  @override
  final String approvalScope;
  @override
  final VendorTaxReviewHistoryEnvironmentEnum environment;
  @override
  final String createdAt;

  factory _$VendorTaxReviewHistory(
          [void Function(VendorTaxReviewHistoryBuilder)? updates]) =>
      (VendorTaxReviewHistoryBuilder()..update(updates))._build();

  _$VendorTaxReviewHistory._(
      {required this.id,
      required this.decision,
      this.reason,
      required this.approvalScope,
      required this.environment,
      required this.createdAt})
      : super._();
  @override
  VendorTaxReviewHistory rebuild(
          void Function(VendorTaxReviewHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTaxReviewHistoryBuilder toBuilder() =>
      VendorTaxReviewHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTaxReviewHistory &&
        id == other.id &&
        decision == other.decision &&
        reason == other.reason &&
        approvalScope == other.approvalScope &&
        environment == other.environment &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, approvalScope.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTaxReviewHistory')
          ..add('id', id)
          ..add('decision', decision)
          ..add('reason', reason)
          ..add('approvalScope', approvalScope)
          ..add('environment', environment)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class VendorTaxReviewHistoryBuilder
    implements Builder<VendorTaxReviewHistory, VendorTaxReviewHistoryBuilder> {
  _$VendorTaxReviewHistory? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _decision;
  String? get decision => _$this._decision;
  set decision(String? decision) => _$this._decision = decision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _approvalScope;
  String? get approvalScope => _$this._approvalScope;
  set approvalScope(String? approvalScope) =>
      _$this._approvalScope = approvalScope;

  VendorTaxReviewHistoryEnvironmentEnum? _environment;
  VendorTaxReviewHistoryEnvironmentEnum? get environment => _$this._environment;
  set environment(VendorTaxReviewHistoryEnvironmentEnum? environment) =>
      _$this._environment = environment;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  VendorTaxReviewHistoryBuilder() {
    VendorTaxReviewHistory._defaults(this);
  }

  VendorTaxReviewHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _decision = $v.decision;
      _reason = $v.reason;
      _approvalScope = $v.approvalScope;
      _environment = $v.environment;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTaxReviewHistory other) {
    _$v = other as _$VendorTaxReviewHistory;
  }

  @override
  void update(void Function(VendorTaxReviewHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTaxReviewHistory build() => _build();

  _$VendorTaxReviewHistory _build() {
    final _$result = _$v ??
        _$VendorTaxReviewHistory._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorTaxReviewHistory', 'id'),
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'VendorTaxReviewHistory', 'decision'),
          reason: reason,
          approvalScope: BuiltValueNullFieldError.checkNotNull(
              approvalScope, r'VendorTaxReviewHistory', 'approvalScope'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'VendorTaxReviewHistory', 'environment'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'VendorTaxReviewHistory', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
