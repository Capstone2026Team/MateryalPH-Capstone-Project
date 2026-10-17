// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_funnel_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDashboardOrdersFunnelInnerKeyEnum
    _$vendorDashboardOrdersFunnelInnerKeyEnum_INQUIRIES =
    const VendorDashboardOrdersFunnelInnerKeyEnum._('INQUIRIES');
const VendorDashboardOrdersFunnelInnerKeyEnum
    _$vendorDashboardOrdersFunnelInnerKeyEnum_QUOTATIONS =
    const VendorDashboardOrdersFunnelInnerKeyEnum._('QUOTATIONS');
const VendorDashboardOrdersFunnelInnerKeyEnum
    _$vendorDashboardOrdersFunnelInnerKeyEnum_ORDER_REQUESTS =
    const VendorDashboardOrdersFunnelInnerKeyEnum._('ORDER_REQUESTS');
const VendorDashboardOrdersFunnelInnerKeyEnum
    _$vendorDashboardOrdersFunnelInnerKeyEnum_CONFIRMED =
    const VendorDashboardOrdersFunnelInnerKeyEnum._('CONFIRMED');
const VendorDashboardOrdersFunnelInnerKeyEnum
    _$vendorDashboardOrdersFunnelInnerKeyEnum_COMPLETED =
    const VendorDashboardOrdersFunnelInnerKeyEnum._('COMPLETED');

VendorDashboardOrdersFunnelInnerKeyEnum
    _$vendorDashboardOrdersFunnelInnerKeyEnumValueOf(String name) {
  switch (name) {
    case 'INQUIRIES':
      return _$vendorDashboardOrdersFunnelInnerKeyEnum_INQUIRIES;
    case 'QUOTATIONS':
      return _$vendorDashboardOrdersFunnelInnerKeyEnum_QUOTATIONS;
    case 'ORDER_REQUESTS':
      return _$vendorDashboardOrdersFunnelInnerKeyEnum_ORDER_REQUESTS;
    case 'CONFIRMED':
      return _$vendorDashboardOrdersFunnelInnerKeyEnum_CONFIRMED;
    case 'COMPLETED':
      return _$vendorDashboardOrdersFunnelInnerKeyEnum_COMPLETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDashboardOrdersFunnelInnerKeyEnum>
    _$vendorDashboardOrdersFunnelInnerKeyEnumValues = BuiltSet<
        VendorDashboardOrdersFunnelInnerKeyEnum>(const <VendorDashboardOrdersFunnelInnerKeyEnum>[
  _$vendorDashboardOrdersFunnelInnerKeyEnum_INQUIRIES,
  _$vendorDashboardOrdersFunnelInnerKeyEnum_QUOTATIONS,
  _$vendorDashboardOrdersFunnelInnerKeyEnum_ORDER_REQUESTS,
  _$vendorDashboardOrdersFunnelInnerKeyEnum_CONFIRMED,
  _$vendorDashboardOrdersFunnelInnerKeyEnum_COMPLETED,
]);

Serializer<VendorDashboardOrdersFunnelInnerKeyEnum>
    _$vendorDashboardOrdersFunnelInnerKeyEnumSerializer =
    _$VendorDashboardOrdersFunnelInnerKeyEnumSerializer();

class _$VendorDashboardOrdersFunnelInnerKeyEnumSerializer
    implements PrimitiveSerializer<VendorDashboardOrdersFunnelInnerKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INQUIRIES': 'INQUIRIES',
    'QUOTATIONS': 'QUOTATIONS',
    'ORDER_REQUESTS': 'ORDER_REQUESTS',
    'CONFIRMED': 'CONFIRMED',
    'COMPLETED': 'COMPLETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INQUIRIES': 'INQUIRIES',
    'QUOTATIONS': 'QUOTATIONS',
    'ORDER_REQUESTS': 'ORDER_REQUESTS',
    'CONFIRMED': 'CONFIRMED',
    'COMPLETED': 'COMPLETED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorDashboardOrdersFunnelInnerKeyEnum
  ];
  @override
  final String wireName = 'VendorDashboardOrdersFunnelInnerKeyEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDashboardOrdersFunnelInnerKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDashboardOrdersFunnelInnerKeyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDashboardOrdersFunnelInnerKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDashboardOrdersFunnelInner
    extends VendorDashboardOrdersFunnelInner {
  @override
  final VendorDashboardOrdersFunnelInnerKeyEnum key;
  @override
  final String label;
  @override
  final int count;

  factory _$VendorDashboardOrdersFunnelInner(
          [void Function(VendorDashboardOrdersFunnelInnerBuilder)? updates]) =>
      (VendorDashboardOrdersFunnelInnerBuilder()..update(updates))._build();

  _$VendorDashboardOrdersFunnelInner._(
      {required this.key, required this.label, required this.count})
      : super._();
  @override
  VendorDashboardOrdersFunnelInner rebuild(
          void Function(VendorDashboardOrdersFunnelInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersFunnelInnerBuilder toBuilder() =>
      VendorDashboardOrdersFunnelInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersFunnelInner &&
        key == other.key &&
        label == other.label &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersFunnelInner')
          ..add('key', key)
          ..add('label', label)
          ..add('count', count))
        .toString();
  }
}

class VendorDashboardOrdersFunnelInnerBuilder
    implements
        Builder<VendorDashboardOrdersFunnelInner,
            VendorDashboardOrdersFunnelInnerBuilder> {
  _$VendorDashboardOrdersFunnelInner? _$v;

  VendorDashboardOrdersFunnelInnerKeyEnum? _key;
  VendorDashboardOrdersFunnelInnerKeyEnum? get key => _$this._key;
  set key(VendorDashboardOrdersFunnelInnerKeyEnum? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  VendorDashboardOrdersFunnelInnerBuilder() {
    VendorDashboardOrdersFunnelInner._defaults(this);
  }

  VendorDashboardOrdersFunnelInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersFunnelInner other) {
    _$v = other as _$VendorDashboardOrdersFunnelInner;
  }

  @override
  void update(void Function(VendorDashboardOrdersFunnelInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersFunnelInner build() => _build();

  _$VendorDashboardOrdersFunnelInner _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersFunnelInner._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'VendorDashboardOrdersFunnelInner', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'VendorDashboardOrdersFunnelInner', 'label'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'VendorDashboardOrdersFunnelInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
