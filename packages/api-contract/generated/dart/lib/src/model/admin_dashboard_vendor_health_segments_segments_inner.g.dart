// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_vendor_health_segments_segments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardVendorHealthSegmentsSegmentsInner
    extends AdminDashboardVendorHealthSegmentsSegmentsInner {
  @override
  final int id;
  @override
  final String label;
  @override
  final int size;
  @override
  final num averageVps;
  @override
  final num averageOhs;
  @override
  final num averageCompletedOrders;

  factory _$AdminDashboardVendorHealthSegmentsSegmentsInner(
          [void Function(
                  AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder)?
              updates]) =>
      (AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminDashboardVendorHealthSegmentsSegmentsInner._(
      {required this.id,
      required this.label,
      required this.size,
      required this.averageVps,
      required this.averageOhs,
      required this.averageCompletedOrders})
      : super._();
  @override
  AdminDashboardVendorHealthSegmentsSegmentsInner rebuild(
          void Function(AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder toBuilder() =>
      AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardVendorHealthSegmentsSegmentsInner &&
        id == other.id &&
        label == other.label &&
        size == other.size &&
        averageVps == other.averageVps &&
        averageOhs == other.averageOhs &&
        averageCompletedOrders == other.averageCompletedOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, averageVps.hashCode);
    _$hash = $jc(_$hash, averageOhs.hashCode);
    _$hash = $jc(_$hash, averageCompletedOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardVendorHealthSegmentsSegmentsInner')
          ..add('id', id)
          ..add('label', label)
          ..add('size', size)
          ..add('averageVps', averageVps)
          ..add('averageOhs', averageOhs)
          ..add('averageCompletedOrders', averageCompletedOrders))
        .toString();
  }
}

class AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder
    implements
        Builder<AdminDashboardVendorHealthSegmentsSegmentsInner,
            AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder> {
  _$AdminDashboardVendorHealthSegmentsSegmentsInner? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  num? _averageVps;
  num? get averageVps => _$this._averageVps;
  set averageVps(num? averageVps) => _$this._averageVps = averageVps;

  num? _averageOhs;
  num? get averageOhs => _$this._averageOhs;
  set averageOhs(num? averageOhs) => _$this._averageOhs = averageOhs;

  num? _averageCompletedOrders;
  num? get averageCompletedOrders => _$this._averageCompletedOrders;
  set averageCompletedOrders(num? averageCompletedOrders) =>
      _$this._averageCompletedOrders = averageCompletedOrders;

  AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder() {
    AdminDashboardVendorHealthSegmentsSegmentsInner._defaults(this);
  }

  AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _size = $v.size;
      _averageVps = $v.averageVps;
      _averageOhs = $v.averageOhs;
      _averageCompletedOrders = $v.averageCompletedOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardVendorHealthSegmentsSegmentsInner other) {
    _$v = other as _$AdminDashboardVendorHealthSegmentsSegmentsInner;
  }

  @override
  void update(
      void Function(AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardVendorHealthSegmentsSegmentsInner build() => _build();

  _$AdminDashboardVendorHealthSegmentsSegmentsInner _build() {
    final _$result = _$v ??
        _$AdminDashboardVendorHealthSegmentsSegmentsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminDashboardVendorHealthSegmentsSegmentsInner', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(label,
              r'AdminDashboardVendorHealthSegmentsSegmentsInner', 'label'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'AdminDashboardVendorHealthSegmentsSegmentsInner', 'size'),
          averageVps: BuiltValueNullFieldError.checkNotNull(averageVps,
              r'AdminDashboardVendorHealthSegmentsSegmentsInner', 'averageVps'),
          averageOhs: BuiltValueNullFieldError.checkNotNull(averageOhs,
              r'AdminDashboardVendorHealthSegmentsSegmentsInner', 'averageOhs'),
          averageCompletedOrders: BuiltValueNullFieldError.checkNotNull(
              averageCompletedOrders,
              r'AdminDashboardVendorHealthSegmentsSegmentsInner',
              'averageCompletedOrders'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
