// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CancellationPlanCauseEnum _$cancellationPlanCauseEnum_BUYER =
    const CancellationPlanCauseEnum._('BUYER');
const CancellationPlanCauseEnum _$cancellationPlanCauseEnum_VENDOR =
    const CancellationPlanCauseEnum._('VENDOR');

CancellationPlanCauseEnum _$cancellationPlanCauseEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$cancellationPlanCauseEnum_BUYER;
    case 'VENDOR':
      return _$cancellationPlanCauseEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationPlanCauseEnum> _$cancellationPlanCauseEnumValues =
    BuiltSet<CancellationPlanCauseEnum>(const <CancellationPlanCauseEnum>[
  _$cancellationPlanCauseEnum_BUYER,
  _$cancellationPlanCauseEnum_VENDOR,
]);

const CancellationPlanExcludesEnum
    _$cancellationPlanExcludesEnum_VENDOR_COMMISSION =
    const CancellationPlanExcludesEnum._('VENDOR_COMMISSION');
const CancellationPlanExcludesEnum
    _$cancellationPlanExcludesEnum_MERCHANT_WITHHOLDING =
    const CancellationPlanExcludesEnum._('MERCHANT_WITHHOLDING');
const CancellationPlanExcludesEnum
    _$cancellationPlanExcludesEnum_PROVIDER_SETTLEMENT_DEDUCTIONS =
    const CancellationPlanExcludesEnum._('PROVIDER_SETTLEMENT_DEDUCTIONS');

CancellationPlanExcludesEnum _$cancellationPlanExcludesEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_COMMISSION':
      return _$cancellationPlanExcludesEnum_VENDOR_COMMISSION;
    case 'MERCHANT_WITHHOLDING':
      return _$cancellationPlanExcludesEnum_MERCHANT_WITHHOLDING;
    case 'PROVIDER_SETTLEMENT_DEDUCTIONS':
      return _$cancellationPlanExcludesEnum_PROVIDER_SETTLEMENT_DEDUCTIONS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationPlanExcludesEnum>
    _$cancellationPlanExcludesEnumValues =
    BuiltSet<CancellationPlanExcludesEnum>(const <CancellationPlanExcludesEnum>[
  _$cancellationPlanExcludesEnum_VENDOR_COMMISSION,
  _$cancellationPlanExcludesEnum_MERCHANT_WITHHOLDING,
  _$cancellationPlanExcludesEnum_PROVIDER_SETTLEMENT_DEDUCTIONS,
]);

Serializer<CancellationPlanCauseEnum> _$cancellationPlanCauseEnumSerializer =
    _$CancellationPlanCauseEnumSerializer();
Serializer<CancellationPlanExcludesEnum>
    _$cancellationPlanExcludesEnumSerializer =
    _$CancellationPlanExcludesEnumSerializer();

class _$CancellationPlanCauseEnumSerializer
    implements PrimitiveSerializer<CancellationPlanCauseEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[CancellationPlanCauseEnum];
  @override
  final String wireName = 'CancellationPlanCauseEnum';

  @override
  Object serialize(Serializers serializers, CancellationPlanCauseEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationPlanCauseEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationPlanCauseEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationPlanExcludesEnumSerializer
    implements PrimitiveSerializer<CancellationPlanExcludesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_COMMISSION': 'VENDOR_COMMISSION',
    'MERCHANT_WITHHOLDING': 'MERCHANT_WITHHOLDING',
    'PROVIDER_SETTLEMENT_DEDUCTIONS': 'PROVIDER_SETTLEMENT_DEDUCTIONS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_COMMISSION': 'VENDOR_COMMISSION',
    'MERCHANT_WITHHOLDING': 'MERCHANT_WITHHOLDING',
    'PROVIDER_SETTLEMENT_DEDUCTIONS': 'PROVIDER_SETTLEMENT_DEDUCTIONS',
  };

  @override
  final Iterable<Type> types = const <Type>[CancellationPlanExcludesEnum];
  @override
  final String wireName = 'CancellationPlanExcludesEnum';

  @override
  Object serialize(Serializers serializers, CancellationPlanExcludesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationPlanExcludesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationPlanExcludesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationPlan extends CancellationPlan {
  @override
  final CancellationPlanCauseEnum cause;
  @override
  final int nrpcRetainedCentavos;
  @override
  final int nrpcAcceptedCentavos;
  @override
  final BuiltList<CancellationPlanPayment> online;
  @override
  final int onlineRefundTotalCentavos;
  @override
  final int cashReimbursementCentavos;
  @override
  final int releasedUnpaidCentavos;
  @override
  final int paidTotalCentavos;
  @override
  final BuiltList<CancellationPlanExcludesEnum> excludes;

  factory _$CancellationPlan(
          [void Function(CancellationPlanBuilder)? updates]) =>
      (CancellationPlanBuilder()..update(updates))._build();

  _$CancellationPlan._(
      {required this.cause,
      required this.nrpcRetainedCentavos,
      required this.nrpcAcceptedCentavos,
      required this.online,
      required this.onlineRefundTotalCentavos,
      required this.cashReimbursementCentavos,
      required this.releasedUnpaidCentavos,
      required this.paidTotalCentavos,
      required this.excludes})
      : super._();
  @override
  CancellationPlan rebuild(void Function(CancellationPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationPlanBuilder toBuilder() =>
      CancellationPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationPlan &&
        cause == other.cause &&
        nrpcRetainedCentavos == other.nrpcRetainedCentavos &&
        nrpcAcceptedCentavos == other.nrpcAcceptedCentavos &&
        online == other.online &&
        onlineRefundTotalCentavos == other.onlineRefundTotalCentavos &&
        cashReimbursementCentavos == other.cashReimbursementCentavos &&
        releasedUnpaidCentavos == other.releasedUnpaidCentavos &&
        paidTotalCentavos == other.paidTotalCentavos &&
        excludes == other.excludes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cause.hashCode);
    _$hash = $jc(_$hash, nrpcRetainedCentavos.hashCode);
    _$hash = $jc(_$hash, nrpcAcceptedCentavos.hashCode);
    _$hash = $jc(_$hash, online.hashCode);
    _$hash = $jc(_$hash, onlineRefundTotalCentavos.hashCode);
    _$hash = $jc(_$hash, cashReimbursementCentavos.hashCode);
    _$hash = $jc(_$hash, releasedUnpaidCentavos.hashCode);
    _$hash = $jc(_$hash, paidTotalCentavos.hashCode);
    _$hash = $jc(_$hash, excludes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationPlan')
          ..add('cause', cause)
          ..add('nrpcRetainedCentavos', nrpcRetainedCentavos)
          ..add('nrpcAcceptedCentavos', nrpcAcceptedCentavos)
          ..add('online', online)
          ..add('onlineRefundTotalCentavos', onlineRefundTotalCentavos)
          ..add('cashReimbursementCentavos', cashReimbursementCentavos)
          ..add('releasedUnpaidCentavos', releasedUnpaidCentavos)
          ..add('paidTotalCentavos', paidTotalCentavos)
          ..add('excludes', excludes))
        .toString();
  }
}

class CancellationPlanBuilder
    implements Builder<CancellationPlan, CancellationPlanBuilder> {
  _$CancellationPlan? _$v;

  CancellationPlanCauseEnum? _cause;
  CancellationPlanCauseEnum? get cause => _$this._cause;
  set cause(CancellationPlanCauseEnum? cause) => _$this._cause = cause;

  int? _nrpcRetainedCentavos;
  int? get nrpcRetainedCentavos => _$this._nrpcRetainedCentavos;
  set nrpcRetainedCentavos(int? nrpcRetainedCentavos) =>
      _$this._nrpcRetainedCentavos = nrpcRetainedCentavos;

  int? _nrpcAcceptedCentavos;
  int? get nrpcAcceptedCentavos => _$this._nrpcAcceptedCentavos;
  set nrpcAcceptedCentavos(int? nrpcAcceptedCentavos) =>
      _$this._nrpcAcceptedCentavos = nrpcAcceptedCentavos;

  ListBuilder<CancellationPlanPayment>? _online;
  ListBuilder<CancellationPlanPayment> get online =>
      _$this._online ??= ListBuilder<CancellationPlanPayment>();
  set online(ListBuilder<CancellationPlanPayment>? online) =>
      _$this._online = online;

  int? _onlineRefundTotalCentavos;
  int? get onlineRefundTotalCentavos => _$this._onlineRefundTotalCentavos;
  set onlineRefundTotalCentavos(int? onlineRefundTotalCentavos) =>
      _$this._onlineRefundTotalCentavos = onlineRefundTotalCentavos;

  int? _cashReimbursementCentavos;
  int? get cashReimbursementCentavos => _$this._cashReimbursementCentavos;
  set cashReimbursementCentavos(int? cashReimbursementCentavos) =>
      _$this._cashReimbursementCentavos = cashReimbursementCentavos;

  int? _releasedUnpaidCentavos;
  int? get releasedUnpaidCentavos => _$this._releasedUnpaidCentavos;
  set releasedUnpaidCentavos(int? releasedUnpaidCentavos) =>
      _$this._releasedUnpaidCentavos = releasedUnpaidCentavos;

  int? _paidTotalCentavos;
  int? get paidTotalCentavos => _$this._paidTotalCentavos;
  set paidTotalCentavos(int? paidTotalCentavos) =>
      _$this._paidTotalCentavos = paidTotalCentavos;

  ListBuilder<CancellationPlanExcludesEnum>? _excludes;
  ListBuilder<CancellationPlanExcludesEnum> get excludes =>
      _$this._excludes ??= ListBuilder<CancellationPlanExcludesEnum>();
  set excludes(ListBuilder<CancellationPlanExcludesEnum>? excludes) =>
      _$this._excludes = excludes;

  CancellationPlanBuilder() {
    CancellationPlan._defaults(this);
  }

  CancellationPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cause = $v.cause;
      _nrpcRetainedCentavos = $v.nrpcRetainedCentavos;
      _nrpcAcceptedCentavos = $v.nrpcAcceptedCentavos;
      _online = $v.online.toBuilder();
      _onlineRefundTotalCentavos = $v.onlineRefundTotalCentavos;
      _cashReimbursementCentavos = $v.cashReimbursementCentavos;
      _releasedUnpaidCentavos = $v.releasedUnpaidCentavos;
      _paidTotalCentavos = $v.paidTotalCentavos;
      _excludes = $v.excludes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationPlan other) {
    _$v = other as _$CancellationPlan;
  }

  @override
  void update(void Function(CancellationPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationPlan build() => _build();

  _$CancellationPlan _build() {
    _$CancellationPlan _$result;
    try {
      _$result = _$v ??
          _$CancellationPlan._(
            cause: BuiltValueNullFieldError.checkNotNull(
                cause, r'CancellationPlan', 'cause'),
            nrpcRetainedCentavos: BuiltValueNullFieldError.checkNotNull(
                nrpcRetainedCentavos,
                r'CancellationPlan',
                'nrpcRetainedCentavos'),
            nrpcAcceptedCentavos: BuiltValueNullFieldError.checkNotNull(
                nrpcAcceptedCentavos,
                r'CancellationPlan',
                'nrpcAcceptedCentavos'),
            online: online.build(),
            onlineRefundTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                onlineRefundTotalCentavos,
                r'CancellationPlan',
                'onlineRefundTotalCentavos'),
            cashReimbursementCentavos: BuiltValueNullFieldError.checkNotNull(
                cashReimbursementCentavos,
                r'CancellationPlan',
                'cashReimbursementCentavos'),
            releasedUnpaidCentavos: BuiltValueNullFieldError.checkNotNull(
                releasedUnpaidCentavos,
                r'CancellationPlan',
                'releasedUnpaidCentavos'),
            paidTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                paidTotalCentavos, r'CancellationPlan', 'paidTotalCentavos'),
            excludes: excludes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'online';
        online.build();

        _$failedField = 'excludes';
        excludes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CancellationPlan', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
