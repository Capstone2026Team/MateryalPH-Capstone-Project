// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_finance_reviews_open_reviews_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFinanceReviewsOpenReviewsInner
    extends VendorFinanceReviewsOpenReviewsInner {
  @override
  final String id;
  @override
  final String kind;
  @override
  final String label;
  @override
  final DateTime createdAt;

  factory _$VendorFinanceReviewsOpenReviewsInner(
          [void Function(VendorFinanceReviewsOpenReviewsInnerBuilder)?
              updates]) =>
      (VendorFinanceReviewsOpenReviewsInnerBuilder()..update(updates))._build();

  _$VendorFinanceReviewsOpenReviewsInner._(
      {required this.id,
      required this.kind,
      required this.label,
      required this.createdAt})
      : super._();
  @override
  VendorFinanceReviewsOpenReviewsInner rebuild(
          void Function(VendorFinanceReviewsOpenReviewsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFinanceReviewsOpenReviewsInnerBuilder toBuilder() =>
      VendorFinanceReviewsOpenReviewsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFinanceReviewsOpenReviewsInner &&
        id == other.id &&
        kind == other.kind &&
        label == other.label &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorFinanceReviewsOpenReviewsInner')
          ..add('id', id)
          ..add('kind', kind)
          ..add('label', label)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class VendorFinanceReviewsOpenReviewsInnerBuilder
    implements
        Builder<VendorFinanceReviewsOpenReviewsInner,
            VendorFinanceReviewsOpenReviewsInnerBuilder> {
  _$VendorFinanceReviewsOpenReviewsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  VendorFinanceReviewsOpenReviewsInnerBuilder() {
    VendorFinanceReviewsOpenReviewsInner._defaults(this);
  }

  VendorFinanceReviewsOpenReviewsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _label = $v.label;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorFinanceReviewsOpenReviewsInner other) {
    _$v = other as _$VendorFinanceReviewsOpenReviewsInner;
  }

  @override
  void update(
      void Function(VendorFinanceReviewsOpenReviewsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFinanceReviewsOpenReviewsInner build() => _build();

  _$VendorFinanceReviewsOpenReviewsInner _build() {
    final _$result = _$v ??
        _$VendorFinanceReviewsOpenReviewsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorFinanceReviewsOpenReviewsInner', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'VendorFinanceReviewsOpenReviewsInner', 'kind'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'VendorFinanceReviewsOpenReviewsInner', 'label'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'VendorFinanceReviewsOpenReviewsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
