// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_serviceability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupplierServiceabilityDeliveryEnum
    _$supplierServiceabilityDeliveryEnum_WITHIN_STATED_AREA =
    const SupplierServiceabilityDeliveryEnum._('WITHIN_STATED_AREA');
const SupplierServiceabilityDeliveryEnum
    _$supplierServiceabilityDeliveryEnum_OUTSIDE_STATED_AREA =
    const SupplierServiceabilityDeliveryEnum._('OUTSIDE_STATED_AREA');
const SupplierServiceabilityDeliveryEnum
    _$supplierServiceabilityDeliveryEnum_NOT_OFFERED =
    const SupplierServiceabilityDeliveryEnum._('NOT_OFFERED');

SupplierServiceabilityDeliveryEnum _$supplierServiceabilityDeliveryEnumValueOf(
    String name) {
  switch (name) {
    case 'WITHIN_STATED_AREA':
      return _$supplierServiceabilityDeliveryEnum_WITHIN_STATED_AREA;
    case 'OUTSIDE_STATED_AREA':
      return _$supplierServiceabilityDeliveryEnum_OUTSIDE_STATED_AREA;
    case 'NOT_OFFERED':
      return _$supplierServiceabilityDeliveryEnum_NOT_OFFERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupplierServiceabilityDeliveryEnum>
    _$supplierServiceabilityDeliveryEnumValues = BuiltSet<
        SupplierServiceabilityDeliveryEnum>(const <SupplierServiceabilityDeliveryEnum>[
  _$supplierServiceabilityDeliveryEnum_WITHIN_STATED_AREA,
  _$supplierServiceabilityDeliveryEnum_OUTSIDE_STATED_AREA,
  _$supplierServiceabilityDeliveryEnum_NOT_OFFERED,
]);

const SupplierServiceabilityBasisEnum
    _$supplierServiceabilityBasisEnum_STRAIGHT_LINE_ADVISORY =
    const SupplierServiceabilityBasisEnum._('STRAIGHT_LINE_ADVISORY');

SupplierServiceabilityBasisEnum _$supplierServiceabilityBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'STRAIGHT_LINE_ADVISORY':
      return _$supplierServiceabilityBasisEnum_STRAIGHT_LINE_ADVISORY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupplierServiceabilityBasisEnum>
    _$supplierServiceabilityBasisEnumValues = BuiltSet<
        SupplierServiceabilityBasisEnum>(const <SupplierServiceabilityBasisEnum>[
  _$supplierServiceabilityBasisEnum_STRAIGHT_LINE_ADVISORY,
]);

Serializer<SupplierServiceabilityDeliveryEnum>
    _$supplierServiceabilityDeliveryEnumSerializer =
    _$SupplierServiceabilityDeliveryEnumSerializer();
Serializer<SupplierServiceabilityBasisEnum>
    _$supplierServiceabilityBasisEnumSerializer =
    _$SupplierServiceabilityBasisEnumSerializer();

class _$SupplierServiceabilityDeliveryEnumSerializer
    implements PrimitiveSerializer<SupplierServiceabilityDeliveryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WITHIN_STATED_AREA': 'WITHIN_STATED_AREA',
    'OUTSIDE_STATED_AREA': 'OUTSIDE_STATED_AREA',
    'NOT_OFFERED': 'NOT_OFFERED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WITHIN_STATED_AREA': 'WITHIN_STATED_AREA',
    'OUTSIDE_STATED_AREA': 'OUTSIDE_STATED_AREA',
    'NOT_OFFERED': 'NOT_OFFERED',
  };

  @override
  final Iterable<Type> types = const <Type>[SupplierServiceabilityDeliveryEnum];
  @override
  final String wireName = 'SupplierServiceabilityDeliveryEnum';

  @override
  Object serialize(
          Serializers serializers, SupplierServiceabilityDeliveryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupplierServiceabilityDeliveryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupplierServiceabilityDeliveryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SupplierServiceabilityBasisEnumSerializer
    implements PrimitiveSerializer<SupplierServiceabilityBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STRAIGHT_LINE_ADVISORY': 'STRAIGHT_LINE_ADVISORY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STRAIGHT_LINE_ADVISORY': 'STRAIGHT_LINE_ADVISORY',
  };

  @override
  final Iterable<Type> types = const <Type>[SupplierServiceabilityBasisEnum];
  @override
  final String wireName = 'SupplierServiceabilityBasisEnum';

  @override
  Object serialize(
          Serializers serializers, SupplierServiceabilityBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupplierServiceabilityBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupplierServiceabilityBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SupplierServiceability extends SupplierServiceability {
  @override
  final bool pickupAvailable;
  @override
  final SupplierServiceabilityDeliveryEnum delivery;
  @override
  final int? deliveryMaximumKm;
  @override
  final SupplierServiceabilityBasisEnum basis;

  factory _$SupplierServiceability(
          [void Function(SupplierServiceabilityBuilder)? updates]) =>
      (SupplierServiceabilityBuilder()..update(updates))._build();

  _$SupplierServiceability._(
      {required this.pickupAvailable,
      required this.delivery,
      this.deliveryMaximumKm,
      required this.basis})
      : super._();
  @override
  SupplierServiceability rebuild(
          void Function(SupplierServiceabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupplierServiceabilityBuilder toBuilder() =>
      SupplierServiceabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupplierServiceability &&
        pickupAvailable == other.pickupAvailable &&
        delivery == other.delivery &&
        deliveryMaximumKm == other.deliveryMaximumKm &&
        basis == other.basis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pickupAvailable.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, deliveryMaximumKm.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupplierServiceability')
          ..add('pickupAvailable', pickupAvailable)
          ..add('delivery', delivery)
          ..add('deliveryMaximumKm', deliveryMaximumKm)
          ..add('basis', basis))
        .toString();
  }
}

class SupplierServiceabilityBuilder
    implements Builder<SupplierServiceability, SupplierServiceabilityBuilder> {
  _$SupplierServiceability? _$v;

  bool? _pickupAvailable;
  bool? get pickupAvailable => _$this._pickupAvailable;
  set pickupAvailable(bool? pickupAvailable) =>
      _$this._pickupAvailable = pickupAvailable;

  SupplierServiceabilityDeliveryEnum? _delivery;
  SupplierServiceabilityDeliveryEnum? get delivery => _$this._delivery;
  set delivery(SupplierServiceabilityDeliveryEnum? delivery) =>
      _$this._delivery = delivery;

  int? _deliveryMaximumKm;
  int? get deliveryMaximumKm => _$this._deliveryMaximumKm;
  set deliveryMaximumKm(int? deliveryMaximumKm) =>
      _$this._deliveryMaximumKm = deliveryMaximumKm;

  SupplierServiceabilityBasisEnum? _basis;
  SupplierServiceabilityBasisEnum? get basis => _$this._basis;
  set basis(SupplierServiceabilityBasisEnum? basis) => _$this._basis = basis;

  SupplierServiceabilityBuilder() {
    SupplierServiceability._defaults(this);
  }

  SupplierServiceabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pickupAvailable = $v.pickupAvailable;
      _delivery = $v.delivery;
      _deliveryMaximumKm = $v.deliveryMaximumKm;
      _basis = $v.basis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupplierServiceability other) {
    _$v = other as _$SupplierServiceability;
  }

  @override
  void update(void Function(SupplierServiceabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupplierServiceability build() => _build();

  _$SupplierServiceability _build() {
    final _$result = _$v ??
        _$SupplierServiceability._(
          pickupAvailable: BuiltValueNullFieldError.checkNotNull(
              pickupAvailable, r'SupplierServiceability', 'pickupAvailable'),
          delivery: BuiltValueNullFieldError.checkNotNull(
              delivery, r'SupplierServiceability', 'delivery'),
          deliveryMaximumKm: deliveryMaximumKm,
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'SupplierServiceability', 'basis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
