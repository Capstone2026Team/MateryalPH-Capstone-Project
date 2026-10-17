// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_access.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsAccess extends VendorProductAnalyticsAccess {
  @override
  final bool salesValue;

  factory _$VendorProductAnalyticsAccess(
          [void Function(VendorProductAnalyticsAccessBuilder)? updates]) =>
      (VendorProductAnalyticsAccessBuilder()..update(updates))._build();

  _$VendorProductAnalyticsAccess._({required this.salesValue}) : super._();
  @override
  VendorProductAnalyticsAccess rebuild(
          void Function(VendorProductAnalyticsAccessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsAccessBuilder toBuilder() =>
      VendorProductAnalyticsAccessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsAccess &&
        salesValue == other.salesValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, salesValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsAccess')
          ..add('salesValue', salesValue))
        .toString();
  }
}

class VendorProductAnalyticsAccessBuilder
    implements
        Builder<VendorProductAnalyticsAccess,
            VendorProductAnalyticsAccessBuilder> {
  _$VendorProductAnalyticsAccess? _$v;

  bool? _salesValue;
  bool? get salesValue => _$this._salesValue;
  set salesValue(bool? salesValue) => _$this._salesValue = salesValue;

  VendorProductAnalyticsAccessBuilder() {
    VendorProductAnalyticsAccess._defaults(this);
  }

  VendorProductAnalyticsAccessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _salesValue = $v.salesValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsAccess other) {
    _$v = other as _$VendorProductAnalyticsAccess;
  }

  @override
  void update(void Function(VendorProductAnalyticsAccessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsAccess build() => _build();

  _$VendorProductAnalyticsAccess _build() {
    final _$result = _$v ??
        _$VendorProductAnalyticsAccess._(
          salesValue: BuiltValueNullFieldError.checkNotNull(
              salesValue, r'VendorProductAnalyticsAccess', 'salesValue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
