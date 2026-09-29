// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_rating_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductRatingSummary extends ProductRatingSummary {
  @override
  final String? average;
  @override
  final int count;
  @override
  final String label;

  factory _$ProductRatingSummary(
          [void Function(ProductRatingSummaryBuilder)? updates]) =>
      (ProductRatingSummaryBuilder()..update(updates))._build();

  _$ProductRatingSummary._(
      {this.average, required this.count, required this.label})
      : super._();
  @override
  ProductRatingSummary rebuild(
          void Function(ProductRatingSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductRatingSummaryBuilder toBuilder() =>
      ProductRatingSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductRatingSummary &&
        average == other.average &&
        count == other.count &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductRatingSummary')
          ..add('average', average)
          ..add('count', count)
          ..add('label', label))
        .toString();
  }
}

class ProductRatingSummaryBuilder
    implements Builder<ProductRatingSummary, ProductRatingSummaryBuilder> {
  _$ProductRatingSummary? _$v;

  String? _average;
  String? get average => _$this._average;
  set average(String? average) => _$this._average = average;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ProductRatingSummaryBuilder() {
    ProductRatingSummary._defaults(this);
  }

  ProductRatingSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _average = $v.average;
      _count = $v.count;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductRatingSummary other) {
    _$v = other as _$ProductRatingSummary;
  }

  @override
  void update(void Function(ProductRatingSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductRatingSummary build() => _build();

  _$ProductRatingSummary _build() {
    final _$result = _$v ??
        _$ProductRatingSummary._(
          average: average,
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'ProductRatingSummary', 'count'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ProductRatingSummary', 'label'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
