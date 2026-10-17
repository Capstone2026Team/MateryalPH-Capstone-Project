// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_deletion_blockers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAccountDeletionBlockers extends BuyerAccountDeletionBlockers {
  @override
  final int activeOrders;
  @override
  final int activeDisputes;
  @override
  final int pendingRefunds;

  factory _$BuyerAccountDeletionBlockers(
          [void Function(BuyerAccountDeletionBlockersBuilder)? updates]) =>
      (BuyerAccountDeletionBlockersBuilder()..update(updates))._build();

  _$BuyerAccountDeletionBlockers._(
      {required this.activeOrders,
      required this.activeDisputes,
      required this.pendingRefunds})
      : super._();
  @override
  BuyerAccountDeletionBlockers rebuild(
          void Function(BuyerAccountDeletionBlockersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountDeletionBlockersBuilder toBuilder() =>
      BuyerAccountDeletionBlockersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountDeletionBlockers &&
        activeOrders == other.activeOrders &&
        activeDisputes == other.activeDisputes &&
        pendingRefunds == other.pendingRefunds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, activeOrders.hashCode);
    _$hash = $jc(_$hash, activeDisputes.hashCode);
    _$hash = $jc(_$hash, pendingRefunds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAccountDeletionBlockers')
          ..add('activeOrders', activeOrders)
          ..add('activeDisputes', activeDisputes)
          ..add('pendingRefunds', pendingRefunds))
        .toString();
  }
}

class BuyerAccountDeletionBlockersBuilder
    implements
        Builder<BuyerAccountDeletionBlockers,
            BuyerAccountDeletionBlockersBuilder> {
  _$BuyerAccountDeletionBlockers? _$v;

  int? _activeOrders;
  int? get activeOrders => _$this._activeOrders;
  set activeOrders(int? activeOrders) => _$this._activeOrders = activeOrders;

  int? _activeDisputes;
  int? get activeDisputes => _$this._activeDisputes;
  set activeDisputes(int? activeDisputes) =>
      _$this._activeDisputes = activeDisputes;

  int? _pendingRefunds;
  int? get pendingRefunds => _$this._pendingRefunds;
  set pendingRefunds(int? pendingRefunds) =>
      _$this._pendingRefunds = pendingRefunds;

  BuyerAccountDeletionBlockersBuilder() {
    BuyerAccountDeletionBlockers._defaults(this);
  }

  BuyerAccountDeletionBlockersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activeOrders = $v.activeOrders;
      _activeDisputes = $v.activeDisputes;
      _pendingRefunds = $v.pendingRefunds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAccountDeletionBlockers other) {
    _$v = other as _$BuyerAccountDeletionBlockers;
  }

  @override
  void update(void Function(BuyerAccountDeletionBlockersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountDeletionBlockers build() => _build();

  _$BuyerAccountDeletionBlockers _build() {
    final _$result = _$v ??
        _$BuyerAccountDeletionBlockers._(
          activeOrders: BuiltValueNullFieldError.checkNotNull(
              activeOrders, r'BuyerAccountDeletionBlockers', 'activeOrders'),
          activeDisputes: BuiltValueNullFieldError.checkNotNull(activeDisputes,
              r'BuyerAccountDeletionBlockers', 'activeDisputes'),
          pendingRefunds: BuiltValueNullFieldError.checkNotNull(pendingRefunds,
              r'BuyerAccountDeletionBlockers', 'pendingRefunds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
