// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_stock_attention_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDashboardStockAttentionInnerStatusEnum
    _$vendorDashboardStockAttentionInnerStatusEnum_OUT_OF_STOCK =
    const VendorDashboardStockAttentionInnerStatusEnum._('OUT_OF_STOCK');
const VendorDashboardStockAttentionInnerStatusEnum
    _$vendorDashboardStockAttentionInnerStatusEnum_LIMITED_STOCK =
    const VendorDashboardStockAttentionInnerStatusEnum._('LIMITED_STOCK');

VendorDashboardStockAttentionInnerStatusEnum
    _$vendorDashboardStockAttentionInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'OUT_OF_STOCK':
      return _$vendorDashboardStockAttentionInnerStatusEnum_OUT_OF_STOCK;
    case 'LIMITED_STOCK':
      return _$vendorDashboardStockAttentionInnerStatusEnum_LIMITED_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDashboardStockAttentionInnerStatusEnum>
    _$vendorDashboardStockAttentionInnerStatusEnumValues = BuiltSet<
        VendorDashboardStockAttentionInnerStatusEnum>(const <VendorDashboardStockAttentionInnerStatusEnum>[
  _$vendorDashboardStockAttentionInnerStatusEnum_OUT_OF_STOCK,
  _$vendorDashboardStockAttentionInnerStatusEnum_LIMITED_STOCK,
]);

Serializer<VendorDashboardStockAttentionInnerStatusEnum>
    _$vendorDashboardStockAttentionInnerStatusEnumSerializer =
    _$VendorDashboardStockAttentionInnerStatusEnumSerializer();

class _$VendorDashboardStockAttentionInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<VendorDashboardStockAttentionInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorDashboardStockAttentionInnerStatusEnum
  ];
  @override
  final String wireName = 'VendorDashboardStockAttentionInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDashboardStockAttentionInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDashboardStockAttentionInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDashboardStockAttentionInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDashboardStockAttentionInner
    extends VendorDashboardStockAttentionInner {
  @override
  final String name;
  @override
  final String? variant;
  @override
  final String available;
  @override
  final String? reorderLevel;
  @override
  final VendorDashboardStockAttentionInnerStatusEnum status;

  factory _$VendorDashboardStockAttentionInner(
          [void Function(VendorDashboardStockAttentionInnerBuilder)?
              updates]) =>
      (VendorDashboardStockAttentionInnerBuilder()..update(updates))._build();

  _$VendorDashboardStockAttentionInner._(
      {required this.name,
      this.variant,
      required this.available,
      this.reorderLevel,
      required this.status})
      : super._();
  @override
  VendorDashboardStockAttentionInner rebuild(
          void Function(VendorDashboardStockAttentionInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardStockAttentionInnerBuilder toBuilder() =>
      VendorDashboardStockAttentionInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardStockAttentionInner &&
        name == other.name &&
        variant == other.variant &&
        available == other.available &&
        reorderLevel == other.reorderLevel &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, variant.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, reorderLevel.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardStockAttentionInner')
          ..add('name', name)
          ..add('variant', variant)
          ..add('available', available)
          ..add('reorderLevel', reorderLevel)
          ..add('status', status))
        .toString();
  }
}

class VendorDashboardStockAttentionInnerBuilder
    implements
        Builder<VendorDashboardStockAttentionInner,
            VendorDashboardStockAttentionInnerBuilder> {
  _$VendorDashboardStockAttentionInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _variant;
  String? get variant => _$this._variant;
  set variant(String? variant) => _$this._variant = variant;

  String? _available;
  String? get available => _$this._available;
  set available(String? available) => _$this._available = available;

  String? _reorderLevel;
  String? get reorderLevel => _$this._reorderLevel;
  set reorderLevel(String? reorderLevel) => _$this._reorderLevel = reorderLevel;

  VendorDashboardStockAttentionInnerStatusEnum? _status;
  VendorDashboardStockAttentionInnerStatusEnum? get status => _$this._status;
  set status(VendorDashboardStockAttentionInnerStatusEnum? status) =>
      _$this._status = status;

  VendorDashboardStockAttentionInnerBuilder() {
    VendorDashboardStockAttentionInner._defaults(this);
  }

  VendorDashboardStockAttentionInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _variant = $v.variant;
      _available = $v.available;
      _reorderLevel = $v.reorderLevel;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardStockAttentionInner other) {
    _$v = other as _$VendorDashboardStockAttentionInner;
  }

  @override
  void update(
      void Function(VendorDashboardStockAttentionInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardStockAttentionInner build() => _build();

  _$VendorDashboardStockAttentionInner _build() {
    final _$result = _$v ??
        _$VendorDashboardStockAttentionInner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VendorDashboardStockAttentionInner', 'name'),
          variant: variant,
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'VendorDashboardStockAttentionInner', 'available'),
          reorderLevel: reorderLevel,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorDashboardStockAttentionInner', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
