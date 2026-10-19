// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_alternative_page_excluded.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackageAlternativePageExcluded
    extends WorkPackageAlternativePageExcluded {
  @override
  final int outOfStock;
  @override
  final int cannotServeFulfillment;

  factory _$WorkPackageAlternativePageExcluded(
          [void Function(WorkPackageAlternativePageExcludedBuilder)?
              updates]) =>
      (WorkPackageAlternativePageExcludedBuilder()..update(updates))._build();

  _$WorkPackageAlternativePageExcluded._(
      {required this.outOfStock, required this.cannotServeFulfillment})
      : super._();
  @override
  WorkPackageAlternativePageExcluded rebuild(
          void Function(WorkPackageAlternativePageExcludedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageAlternativePageExcludedBuilder toBuilder() =>
      WorkPackageAlternativePageExcludedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageAlternativePageExcluded &&
        outOfStock == other.outOfStock &&
        cannotServeFulfillment == other.cannotServeFulfillment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outOfStock.hashCode);
    _$hash = $jc(_$hash, cannotServeFulfillment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageAlternativePageExcluded')
          ..add('outOfStock', outOfStock)
          ..add('cannotServeFulfillment', cannotServeFulfillment))
        .toString();
  }
}

class WorkPackageAlternativePageExcludedBuilder
    implements
        Builder<WorkPackageAlternativePageExcluded,
            WorkPackageAlternativePageExcludedBuilder> {
  _$WorkPackageAlternativePageExcluded? _$v;

  int? _outOfStock;
  int? get outOfStock => _$this._outOfStock;
  set outOfStock(int? outOfStock) => _$this._outOfStock = outOfStock;

  int? _cannotServeFulfillment;
  int? get cannotServeFulfillment => _$this._cannotServeFulfillment;
  set cannotServeFulfillment(int? cannotServeFulfillment) =>
      _$this._cannotServeFulfillment = cannotServeFulfillment;

  WorkPackageAlternativePageExcludedBuilder() {
    WorkPackageAlternativePageExcluded._defaults(this);
  }

  WorkPackageAlternativePageExcludedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outOfStock = $v.outOfStock;
      _cannotServeFulfillment = $v.cannotServeFulfillment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageAlternativePageExcluded other) {
    _$v = other as _$WorkPackageAlternativePageExcluded;
  }

  @override
  void update(
      void Function(WorkPackageAlternativePageExcludedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageAlternativePageExcluded build() => _build();

  _$WorkPackageAlternativePageExcluded _build() {
    final _$result = _$v ??
        _$WorkPackageAlternativePageExcluded._(
          outOfStock: BuiltValueNullFieldError.checkNotNull(
              outOfStock, r'WorkPackageAlternativePageExcluded', 'outOfStock'),
          cannotServeFulfillment: BuiltValueNullFieldError.checkNotNull(
              cannotServeFulfillment,
              r'WorkPackageAlternativePageExcluded',
              'cannotServeFulfillment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
