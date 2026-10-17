// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_order_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeOrderRef extends DisputeOrderRef {
  @override
  final String id;
  @override
  final String reference;
  @override
  final String orderState;
  @override
  final String disputeState;
  @override
  final String refundState;
  @override
  final String paymentMethod;

  factory _$DisputeOrderRef([void Function(DisputeOrderRefBuilder)? updates]) =>
      (DisputeOrderRefBuilder()..update(updates))._build();

  _$DisputeOrderRef._(
      {required this.id,
      required this.reference,
      required this.orderState,
      required this.disputeState,
      required this.refundState,
      required this.paymentMethod})
      : super._();
  @override
  DisputeOrderRef rebuild(void Function(DisputeOrderRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeOrderRefBuilder toBuilder() => DisputeOrderRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeOrderRef &&
        id == other.id &&
        reference == other.reference &&
        orderState == other.orderState &&
        disputeState == other.disputeState &&
        refundState == other.refundState &&
        paymentMethod == other.paymentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, orderState.hashCode);
    _$hash = $jc(_$hash, disputeState.hashCode);
    _$hash = $jc(_$hash, refundState.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeOrderRef')
          ..add('id', id)
          ..add('reference', reference)
          ..add('orderState', orderState)
          ..add('disputeState', disputeState)
          ..add('refundState', refundState)
          ..add('paymentMethod', paymentMethod))
        .toString();
  }
}

class DisputeOrderRefBuilder
    implements Builder<DisputeOrderRef, DisputeOrderRefBuilder> {
  _$DisputeOrderRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _orderState;
  String? get orderState => _$this._orderState;
  set orderState(String? orderState) => _$this._orderState = orderState;

  String? _disputeState;
  String? get disputeState => _$this._disputeState;
  set disputeState(String? disputeState) => _$this._disputeState = disputeState;

  String? _refundState;
  String? get refundState => _$this._refundState;
  set refundState(String? refundState) => _$this._refundState = refundState;

  String? _paymentMethod;
  String? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(String? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  DisputeOrderRefBuilder() {
    DisputeOrderRef._defaults(this);
  }

  DisputeOrderRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _orderState = $v.orderState;
      _disputeState = $v.disputeState;
      _refundState = $v.refundState;
      _paymentMethod = $v.paymentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeOrderRef other) {
    _$v = other as _$DisputeOrderRef;
  }

  @override
  void update(void Function(DisputeOrderRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeOrderRef build() => _build();

  _$DisputeOrderRef _build() {
    final _$result = _$v ??
        _$DisputeOrderRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DisputeOrderRef', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'DisputeOrderRef', 'reference'),
          orderState: BuiltValueNullFieldError.checkNotNull(
              orderState, r'DisputeOrderRef', 'orderState'),
          disputeState: BuiltValueNullFieldError.checkNotNull(
              disputeState, r'DisputeOrderRef', 'disputeState'),
          refundState: BuiltValueNullFieldError.checkNotNull(
              refundState, r'DisputeOrderRef', 'refundState'),
          paymentMethod: BuiltValueNullFieldError.checkNotNull(
              paymentMethod, r'DisputeOrderRef', 'paymentMethod'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
