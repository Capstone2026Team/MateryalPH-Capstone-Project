// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_profile_recent_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerProfileRecentOrdersInner
    extends DirectoryBuyerProfileRecentOrdersInner {
  @override
  final String id;
  @override
  final String reference;
  @override
  final String orderState;
  @override
  final String paymentState;
  @override
  final String procurementType;
  @override
  final String storeName;
  @override
  final DateTime createdAt;

  factory _$DirectoryBuyerProfileRecentOrdersInner(
          [void Function(DirectoryBuyerProfileRecentOrdersInnerBuilder)?
              updates]) =>
      (DirectoryBuyerProfileRecentOrdersInnerBuilder()..update(updates))
          ._build();

  _$DirectoryBuyerProfileRecentOrdersInner._(
      {required this.id,
      required this.reference,
      required this.orderState,
      required this.paymentState,
      required this.procurementType,
      required this.storeName,
      required this.createdAt})
      : super._();
  @override
  DirectoryBuyerProfileRecentOrdersInner rebuild(
          void Function(DirectoryBuyerProfileRecentOrdersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerProfileRecentOrdersInnerBuilder toBuilder() =>
      DirectoryBuyerProfileRecentOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerProfileRecentOrdersInner &&
        id == other.id &&
        reference == other.reference &&
        orderState == other.orderState &&
        paymentState == other.paymentState &&
        procurementType == other.procurementType &&
        storeName == other.storeName &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, orderState.hashCode);
    _$hash = $jc(_$hash, paymentState.hashCode);
    _$hash = $jc(_$hash, procurementType.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'DirectoryBuyerProfileRecentOrdersInner')
          ..add('id', id)
          ..add('reference', reference)
          ..add('orderState', orderState)
          ..add('paymentState', paymentState)
          ..add('procurementType', procurementType)
          ..add('storeName', storeName)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class DirectoryBuyerProfileRecentOrdersInnerBuilder
    implements
        Builder<DirectoryBuyerProfileRecentOrdersInner,
            DirectoryBuyerProfileRecentOrdersInnerBuilder> {
  _$DirectoryBuyerProfileRecentOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _orderState;
  String? get orderState => _$this._orderState;
  set orderState(String? orderState) => _$this._orderState = orderState;

  String? _paymentState;
  String? get paymentState => _$this._paymentState;
  set paymentState(String? paymentState) => _$this._paymentState = paymentState;

  String? _procurementType;
  String? get procurementType => _$this._procurementType;
  set procurementType(String? procurementType) =>
      _$this._procurementType = procurementType;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DirectoryBuyerProfileRecentOrdersInnerBuilder() {
    DirectoryBuyerProfileRecentOrdersInner._defaults(this);
  }

  DirectoryBuyerProfileRecentOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _orderState = $v.orderState;
      _paymentState = $v.paymentState;
      _procurementType = $v.procurementType;
      _storeName = $v.storeName;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerProfileRecentOrdersInner other) {
    _$v = other as _$DirectoryBuyerProfileRecentOrdersInner;
  }

  @override
  void update(
      void Function(DirectoryBuyerProfileRecentOrdersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerProfileRecentOrdersInner build() => _build();

  _$DirectoryBuyerProfileRecentOrdersInner _build() {
    final _$result = _$v ??
        _$DirectoryBuyerProfileRecentOrdersInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DirectoryBuyerProfileRecentOrdersInner', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(reference,
              r'DirectoryBuyerProfileRecentOrdersInner', 'reference'),
          orderState: BuiltValueNullFieldError.checkNotNull(orderState,
              r'DirectoryBuyerProfileRecentOrdersInner', 'orderState'),
          paymentState: BuiltValueNullFieldError.checkNotNull(paymentState,
              r'DirectoryBuyerProfileRecentOrdersInner', 'paymentState'),
          procurementType: BuiltValueNullFieldError.checkNotNull(
              procurementType,
              r'DirectoryBuyerProfileRecentOrdersInner',
              'procurementType'),
          storeName: BuiltValueNullFieldError.checkNotNull(storeName,
              r'DirectoryBuyerProfileRecentOrdersInner', 'storeName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'DirectoryBuyerProfileRecentOrdersInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
