// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessed_online_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssessedOnlinePayment extends AssessedOnlinePayment {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final DateTime assessedAt;
  @override
  final int grossBasisCentavos;
  @override
  final int rateBasisPoints;
  @override
  final int withheldCentavos;
  @override
  final int assessedPaymentCentavos;
  @override
  final int deliveryCentavos;
  @override
  final int materialVatCentavos;
  @override
  final int paymentPrincipalCentavos;
  @override
  final int buyerProcessingFeesCentavos;
  @override
  final int collectionsCentavos;

  factory _$AssessedOnlinePayment(
          [void Function(AssessedOnlinePaymentBuilder)? updates]) =>
      (AssessedOnlinePaymentBuilder()..update(updates))._build();

  _$AssessedOnlinePayment._(
      {required this.id,
      required this.orderReference,
      required this.assessedAt,
      required this.grossBasisCentavos,
      required this.rateBasisPoints,
      required this.withheldCentavos,
      required this.assessedPaymentCentavos,
      required this.deliveryCentavos,
      required this.materialVatCentavos,
      required this.paymentPrincipalCentavos,
      required this.buyerProcessingFeesCentavos,
      required this.collectionsCentavos})
      : super._();
  @override
  AssessedOnlinePayment rebuild(
          void Function(AssessedOnlinePaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssessedOnlinePaymentBuilder toBuilder() =>
      AssessedOnlinePaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssessedOnlinePayment &&
        id == other.id &&
        orderReference == other.orderReference &&
        assessedAt == other.assessedAt &&
        grossBasisCentavos == other.grossBasisCentavos &&
        rateBasisPoints == other.rateBasisPoints &&
        withheldCentavos == other.withheldCentavos &&
        assessedPaymentCentavos == other.assessedPaymentCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        materialVatCentavos == other.materialVatCentavos &&
        paymentPrincipalCentavos == other.paymentPrincipalCentavos &&
        buyerProcessingFeesCentavos == other.buyerProcessingFeesCentavos &&
        collectionsCentavos == other.collectionsCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, assessedAt.hashCode);
    _$hash = $jc(_$hash, grossBasisCentavos.hashCode);
    _$hash = $jc(_$hash, rateBasisPoints.hashCode);
    _$hash = $jc(_$hash, withheldCentavos.hashCode);
    _$hash = $jc(_$hash, assessedPaymentCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, materialVatCentavos.hashCode);
    _$hash = $jc(_$hash, paymentPrincipalCentavos.hashCode);
    _$hash = $jc(_$hash, buyerProcessingFeesCentavos.hashCode);
    _$hash = $jc(_$hash, collectionsCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssessedOnlinePayment')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('assessedAt', assessedAt)
          ..add('grossBasisCentavos', grossBasisCentavos)
          ..add('rateBasisPoints', rateBasisPoints)
          ..add('withheldCentavos', withheldCentavos)
          ..add('assessedPaymentCentavos', assessedPaymentCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('materialVatCentavos', materialVatCentavos)
          ..add('paymentPrincipalCentavos', paymentPrincipalCentavos)
          ..add('buyerProcessingFeesCentavos', buyerProcessingFeesCentavos)
          ..add('collectionsCentavos', collectionsCentavos))
        .toString();
  }
}

class AssessedOnlinePaymentBuilder
    implements Builder<AssessedOnlinePayment, AssessedOnlinePaymentBuilder> {
  _$AssessedOnlinePayment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  DateTime? _assessedAt;
  DateTime? get assessedAt => _$this._assessedAt;
  set assessedAt(DateTime? assessedAt) => _$this._assessedAt = assessedAt;

  int? _grossBasisCentavos;
  int? get grossBasisCentavos => _$this._grossBasisCentavos;
  set grossBasisCentavos(int? grossBasisCentavos) =>
      _$this._grossBasisCentavos = grossBasisCentavos;

  int? _rateBasisPoints;
  int? get rateBasisPoints => _$this._rateBasisPoints;
  set rateBasisPoints(int? rateBasisPoints) =>
      _$this._rateBasisPoints = rateBasisPoints;

  int? _withheldCentavos;
  int? get withheldCentavos => _$this._withheldCentavos;
  set withheldCentavos(int? withheldCentavos) =>
      _$this._withheldCentavos = withheldCentavos;

  int? _assessedPaymentCentavos;
  int? get assessedPaymentCentavos => _$this._assessedPaymentCentavos;
  set assessedPaymentCentavos(int? assessedPaymentCentavos) =>
      _$this._assessedPaymentCentavos = assessedPaymentCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _materialVatCentavos;
  int? get materialVatCentavos => _$this._materialVatCentavos;
  set materialVatCentavos(int? materialVatCentavos) =>
      _$this._materialVatCentavos = materialVatCentavos;

  int? _paymentPrincipalCentavos;
  int? get paymentPrincipalCentavos => _$this._paymentPrincipalCentavos;
  set paymentPrincipalCentavos(int? paymentPrincipalCentavos) =>
      _$this._paymentPrincipalCentavos = paymentPrincipalCentavos;

  int? _buyerProcessingFeesCentavos;
  int? get buyerProcessingFeesCentavos => _$this._buyerProcessingFeesCentavos;
  set buyerProcessingFeesCentavos(int? buyerProcessingFeesCentavos) =>
      _$this._buyerProcessingFeesCentavos = buyerProcessingFeesCentavos;

  int? _collectionsCentavos;
  int? get collectionsCentavos => _$this._collectionsCentavos;
  set collectionsCentavos(int? collectionsCentavos) =>
      _$this._collectionsCentavos = collectionsCentavos;

  AssessedOnlinePaymentBuilder() {
    AssessedOnlinePayment._defaults(this);
  }

  AssessedOnlinePaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _assessedAt = $v.assessedAt;
      _grossBasisCentavos = $v.grossBasisCentavos;
      _rateBasisPoints = $v.rateBasisPoints;
      _withheldCentavos = $v.withheldCentavos;
      _assessedPaymentCentavos = $v.assessedPaymentCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _materialVatCentavos = $v.materialVatCentavos;
      _paymentPrincipalCentavos = $v.paymentPrincipalCentavos;
      _buyerProcessingFeesCentavos = $v.buyerProcessingFeesCentavos;
      _collectionsCentavos = $v.collectionsCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssessedOnlinePayment other) {
    _$v = other as _$AssessedOnlinePayment;
  }

  @override
  void update(void Function(AssessedOnlinePaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssessedOnlinePayment build() => _build();

  _$AssessedOnlinePayment _build() {
    final _$result = _$v ??
        _$AssessedOnlinePayment._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AssessedOnlinePayment', 'id'),
          orderReference: BuiltValueNullFieldError.checkNotNull(
              orderReference, r'AssessedOnlinePayment', 'orderReference'),
          assessedAt: BuiltValueNullFieldError.checkNotNull(
              assessedAt, r'AssessedOnlinePayment', 'assessedAt'),
          grossBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              grossBasisCentavos,
              r'AssessedOnlinePayment',
              'grossBasisCentavos'),
          rateBasisPoints: BuiltValueNullFieldError.checkNotNull(
              rateBasisPoints, r'AssessedOnlinePayment', 'rateBasisPoints'),
          withheldCentavos: BuiltValueNullFieldError.checkNotNull(
              withheldCentavos, r'AssessedOnlinePayment', 'withheldCentavos'),
          assessedPaymentCentavos: BuiltValueNullFieldError.checkNotNull(
              assessedPaymentCentavos,
              r'AssessedOnlinePayment',
              'assessedPaymentCentavos'),
          deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              deliveryCentavos, r'AssessedOnlinePayment', 'deliveryCentavos'),
          materialVatCentavos: BuiltValueNullFieldError.checkNotNull(
              materialVatCentavos,
              r'AssessedOnlinePayment',
              'materialVatCentavos'),
          paymentPrincipalCentavos: BuiltValueNullFieldError.checkNotNull(
              paymentPrincipalCentavos,
              r'AssessedOnlinePayment',
              'paymentPrincipalCentavos'),
          buyerProcessingFeesCentavos: BuiltValueNullFieldError.checkNotNull(
              buyerProcessingFeesCentavos,
              r'AssessedOnlinePayment',
              'buyerProcessingFeesCentavos'),
          collectionsCentavos: BuiltValueNullFieldError.checkNotNull(
              collectionsCentavos,
              r'AssessedOnlinePayment',
              'collectionsCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
