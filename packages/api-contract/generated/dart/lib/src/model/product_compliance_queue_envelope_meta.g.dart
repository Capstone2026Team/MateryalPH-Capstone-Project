// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_compliance_queue_envelope_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductComplianceQueueEnvelopeMeta
    extends ProductComplianceQueueEnvelopeMeta {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int total;
  @override
  final BuiltMap<String, int> counts;

  factory _$ProductComplianceQueueEnvelopeMeta(
          [void Function(ProductComplianceQueueEnvelopeMetaBuilder)?
              updates]) =>
      (ProductComplianceQueueEnvelopeMetaBuilder()..update(updates))._build();

  _$ProductComplianceQueueEnvelopeMeta._(
      {required this.currentPage,
      required this.lastPage,
      required this.total,
      required this.counts})
      : super._();
  @override
  ProductComplianceQueueEnvelopeMeta rebuild(
          void Function(ProductComplianceQueueEnvelopeMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductComplianceQueueEnvelopeMetaBuilder toBuilder() =>
      ProductComplianceQueueEnvelopeMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductComplianceQueueEnvelopeMeta &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        total == other.total &&
        counts == other.counts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductComplianceQueueEnvelopeMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('total', total)
          ..add('counts', counts))
        .toString();
  }
}

class ProductComplianceQueueEnvelopeMetaBuilder
    implements
        Builder<ProductComplianceQueueEnvelopeMeta,
            ProductComplianceQueueEnvelopeMetaBuilder> {
  _$ProductComplianceQueueEnvelopeMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  ProductComplianceQueueEnvelopeMetaBuilder() {
    ProductComplianceQueueEnvelopeMeta._defaults(this);
  }

  ProductComplianceQueueEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _counts = $v.counts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductComplianceQueueEnvelopeMeta other) {
    _$v = other as _$ProductComplianceQueueEnvelopeMeta;
  }

  @override
  void update(
      void Function(ProductComplianceQueueEnvelopeMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductComplianceQueueEnvelopeMeta build() => _build();

  _$ProductComplianceQueueEnvelopeMeta _build() {
    _$ProductComplianceQueueEnvelopeMeta _$result;
    try {
      _$result = _$v ??
          _$ProductComplianceQueueEnvelopeMeta._(
            currentPage: BuiltValueNullFieldError.checkNotNull(currentPage,
                r'ProductComplianceQueueEnvelopeMeta', 'currentPage'),
            lastPage: BuiltValueNullFieldError.checkNotNull(
                lastPage, r'ProductComplianceQueueEnvelopeMeta', 'lastPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ProductComplianceQueueEnvelopeMeta', 'total'),
            counts: counts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        counts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProductComplianceQueueEnvelopeMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
