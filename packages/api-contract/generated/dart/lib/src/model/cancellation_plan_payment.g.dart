// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_plan_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancellationPlanPayment extends CancellationPlanPayment {
  @override
  final String paymentId;
  @override
  final String purpose;
  @override
  final String? channelCode;
  @override
  final String? channelName;
  @override
  final int capturedCentavos;
  @override
  final int priorAllocatedCentavos;
  @override
  final int retainedCentavos;
  @override
  final int refundCentavos;
  @override
  final int principalCentavos;
  @override
  final int processingFeeCentavos;
  @override
  final bool cappedByPriorRefunds;
  @override
  final BuiltMap<String, JsonObject?> allocation;

  factory _$CancellationPlanPayment(
          [void Function(CancellationPlanPaymentBuilder)? updates]) =>
      (CancellationPlanPaymentBuilder()..update(updates))._build();

  _$CancellationPlanPayment._(
      {required this.paymentId,
      required this.purpose,
      this.channelCode,
      this.channelName,
      required this.capturedCentavos,
      required this.priorAllocatedCentavos,
      required this.retainedCentavos,
      required this.refundCentavos,
      required this.principalCentavos,
      required this.processingFeeCentavos,
      required this.cappedByPriorRefunds,
      required this.allocation})
      : super._();
  @override
  CancellationPlanPayment rebuild(
          void Function(CancellationPlanPaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationPlanPaymentBuilder toBuilder() =>
      CancellationPlanPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationPlanPayment &&
        paymentId == other.paymentId &&
        purpose == other.purpose &&
        channelCode == other.channelCode &&
        channelName == other.channelName &&
        capturedCentavos == other.capturedCentavos &&
        priorAllocatedCentavos == other.priorAllocatedCentavos &&
        retainedCentavos == other.retainedCentavos &&
        refundCentavos == other.refundCentavos &&
        principalCentavos == other.principalCentavos &&
        processingFeeCentavos == other.processingFeeCentavos &&
        cappedByPriorRefunds == other.cappedByPriorRefunds &&
        allocation == other.allocation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, channelCode.hashCode);
    _$hash = $jc(_$hash, channelName.hashCode);
    _$hash = $jc(_$hash, capturedCentavos.hashCode);
    _$hash = $jc(_$hash, priorAllocatedCentavos.hashCode);
    _$hash = $jc(_$hash, retainedCentavos.hashCode);
    _$hash = $jc(_$hash, refundCentavos.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jc(_$hash, processingFeeCentavos.hashCode);
    _$hash = $jc(_$hash, cappedByPriorRefunds.hashCode);
    _$hash = $jc(_$hash, allocation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationPlanPayment')
          ..add('paymentId', paymentId)
          ..add('purpose', purpose)
          ..add('channelCode', channelCode)
          ..add('channelName', channelName)
          ..add('capturedCentavos', capturedCentavos)
          ..add('priorAllocatedCentavos', priorAllocatedCentavos)
          ..add('retainedCentavos', retainedCentavos)
          ..add('refundCentavos', refundCentavos)
          ..add('principalCentavos', principalCentavos)
          ..add('processingFeeCentavos', processingFeeCentavos)
          ..add('cappedByPriorRefunds', cappedByPriorRefunds)
          ..add('allocation', allocation))
        .toString();
  }
}

class CancellationPlanPaymentBuilder
    implements
        Builder<CancellationPlanPayment, CancellationPlanPaymentBuilder> {
  _$CancellationPlanPayment? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  String? _channelCode;
  String? get channelCode => _$this._channelCode;
  set channelCode(String? channelCode) => _$this._channelCode = channelCode;

  String? _channelName;
  String? get channelName => _$this._channelName;
  set channelName(String? channelName) => _$this._channelName = channelName;

  int? _capturedCentavos;
  int? get capturedCentavos => _$this._capturedCentavos;
  set capturedCentavos(int? capturedCentavos) =>
      _$this._capturedCentavos = capturedCentavos;

  int? _priorAllocatedCentavos;
  int? get priorAllocatedCentavos => _$this._priorAllocatedCentavos;
  set priorAllocatedCentavos(int? priorAllocatedCentavos) =>
      _$this._priorAllocatedCentavos = priorAllocatedCentavos;

  int? _retainedCentavos;
  int? get retainedCentavos => _$this._retainedCentavos;
  set retainedCentavos(int? retainedCentavos) =>
      _$this._retainedCentavos = retainedCentavos;

  int? _refundCentavos;
  int? get refundCentavos => _$this._refundCentavos;
  set refundCentavos(int? refundCentavos) =>
      _$this._refundCentavos = refundCentavos;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  int? _processingFeeCentavos;
  int? get processingFeeCentavos => _$this._processingFeeCentavos;
  set processingFeeCentavos(int? processingFeeCentavos) =>
      _$this._processingFeeCentavos = processingFeeCentavos;

  bool? _cappedByPriorRefunds;
  bool? get cappedByPriorRefunds => _$this._cappedByPriorRefunds;
  set cappedByPriorRefunds(bool? cappedByPriorRefunds) =>
      _$this._cappedByPriorRefunds = cappedByPriorRefunds;

  MapBuilder<String, JsonObject?>? _allocation;
  MapBuilder<String, JsonObject?> get allocation =>
      _$this._allocation ??= MapBuilder<String, JsonObject?>();
  set allocation(MapBuilder<String, JsonObject?>? allocation) =>
      _$this._allocation = allocation;

  CancellationPlanPaymentBuilder() {
    CancellationPlanPayment._defaults(this);
  }

  CancellationPlanPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _purpose = $v.purpose;
      _channelCode = $v.channelCode;
      _channelName = $v.channelName;
      _capturedCentavos = $v.capturedCentavos;
      _priorAllocatedCentavos = $v.priorAllocatedCentavos;
      _retainedCentavos = $v.retainedCentavos;
      _refundCentavos = $v.refundCentavos;
      _principalCentavos = $v.principalCentavos;
      _processingFeeCentavos = $v.processingFeeCentavos;
      _cappedByPriorRefunds = $v.cappedByPriorRefunds;
      _allocation = $v.allocation.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationPlanPayment other) {
    _$v = other as _$CancellationPlanPayment;
  }

  @override
  void update(void Function(CancellationPlanPaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationPlanPayment build() => _build();

  _$CancellationPlanPayment _build() {
    _$CancellationPlanPayment _$result;
    try {
      _$result = _$v ??
          _$CancellationPlanPayment._(
            paymentId: BuiltValueNullFieldError.checkNotNull(
                paymentId, r'CancellationPlanPayment', 'paymentId'),
            purpose: BuiltValueNullFieldError.checkNotNull(
                purpose, r'CancellationPlanPayment', 'purpose'),
            channelCode: channelCode,
            channelName: channelName,
            capturedCentavos: BuiltValueNullFieldError.checkNotNull(
                capturedCentavos,
                r'CancellationPlanPayment',
                'capturedCentavos'),
            priorAllocatedCentavos: BuiltValueNullFieldError.checkNotNull(
                priorAllocatedCentavos,
                r'CancellationPlanPayment',
                'priorAllocatedCentavos'),
            retainedCentavos: BuiltValueNullFieldError.checkNotNull(
                retainedCentavos,
                r'CancellationPlanPayment',
                'retainedCentavos'),
            refundCentavos: BuiltValueNullFieldError.checkNotNull(
                refundCentavos, r'CancellationPlanPayment', 'refundCentavos'),
            principalCentavos: BuiltValueNullFieldError.checkNotNull(
                principalCentavos,
                r'CancellationPlanPayment',
                'principalCentavos'),
            processingFeeCentavos: BuiltValueNullFieldError.checkNotNull(
                processingFeeCentavos,
                r'CancellationPlanPayment',
                'processingFeeCentavos'),
            cappedByPriorRefunds: BuiltValueNullFieldError.checkNotNull(
                cappedByPriorRefunds,
                r'CancellationPlanPayment',
                'cappedByPriorRefunds'),
            allocation: allocation.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allocation';
        allocation.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CancellationPlanPayment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
