// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_detail_fulfillment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingDetailFulfillmentDeliveryEnum
    _$listingDetailFulfillmentDeliveryEnum_WITHIN_STATED_AREA =
    const ListingDetailFulfillmentDeliveryEnum._('WITHIN_STATED_AREA');
const ListingDetailFulfillmentDeliveryEnum
    _$listingDetailFulfillmentDeliveryEnum_OUTSIDE_STATED_AREA =
    const ListingDetailFulfillmentDeliveryEnum._('OUTSIDE_STATED_AREA');
const ListingDetailFulfillmentDeliveryEnum
    _$listingDetailFulfillmentDeliveryEnum_NOT_OFFERED =
    const ListingDetailFulfillmentDeliveryEnum._('NOT_OFFERED');

ListingDetailFulfillmentDeliveryEnum
    _$listingDetailFulfillmentDeliveryEnumValueOf(String name) {
  switch (name) {
    case 'WITHIN_STATED_AREA':
      return _$listingDetailFulfillmentDeliveryEnum_WITHIN_STATED_AREA;
    case 'OUTSIDE_STATED_AREA':
      return _$listingDetailFulfillmentDeliveryEnum_OUTSIDE_STATED_AREA;
    case 'NOT_OFFERED':
      return _$listingDetailFulfillmentDeliveryEnum_NOT_OFFERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingDetailFulfillmentDeliveryEnum>
    _$listingDetailFulfillmentDeliveryEnumValues = BuiltSet<
        ListingDetailFulfillmentDeliveryEnum>(const <ListingDetailFulfillmentDeliveryEnum>[
  _$listingDetailFulfillmentDeliveryEnum_WITHIN_STATED_AREA,
  _$listingDetailFulfillmentDeliveryEnum_OUTSIDE_STATED_AREA,
  _$listingDetailFulfillmentDeliveryEnum_NOT_OFFERED,
]);

const ListingDetailFulfillmentBasisEnum
    _$listingDetailFulfillmentBasisEnum_STRAIGHT_LINE_ADVISORY =
    const ListingDetailFulfillmentBasisEnum._('STRAIGHT_LINE_ADVISORY');

ListingDetailFulfillmentBasisEnum _$listingDetailFulfillmentBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'STRAIGHT_LINE_ADVISORY':
      return _$listingDetailFulfillmentBasisEnum_STRAIGHT_LINE_ADVISORY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingDetailFulfillmentBasisEnum>
    _$listingDetailFulfillmentBasisEnumValues = BuiltSet<
        ListingDetailFulfillmentBasisEnum>(const <ListingDetailFulfillmentBasisEnum>[
  _$listingDetailFulfillmentBasisEnum_STRAIGHT_LINE_ADVISORY,
]);

Serializer<ListingDetailFulfillmentDeliveryEnum>
    _$listingDetailFulfillmentDeliveryEnumSerializer =
    _$ListingDetailFulfillmentDeliveryEnumSerializer();
Serializer<ListingDetailFulfillmentBasisEnum>
    _$listingDetailFulfillmentBasisEnumSerializer =
    _$ListingDetailFulfillmentBasisEnumSerializer();

class _$ListingDetailFulfillmentDeliveryEnumSerializer
    implements PrimitiveSerializer<ListingDetailFulfillmentDeliveryEnum> {
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
  final Iterable<Type> types = const <Type>[
    ListingDetailFulfillmentDeliveryEnum
  ];
  @override
  final String wireName = 'ListingDetailFulfillmentDeliveryEnum';

  @override
  Object serialize(
          Serializers serializers, ListingDetailFulfillmentDeliveryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingDetailFulfillmentDeliveryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingDetailFulfillmentDeliveryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingDetailFulfillmentBasisEnumSerializer
    implements PrimitiveSerializer<ListingDetailFulfillmentBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STRAIGHT_LINE_ADVISORY': 'STRAIGHT_LINE_ADVISORY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STRAIGHT_LINE_ADVISORY': 'STRAIGHT_LINE_ADVISORY',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingDetailFulfillmentBasisEnum];
  @override
  final String wireName = 'ListingDetailFulfillmentBasisEnum';

  @override
  Object serialize(
          Serializers serializers, ListingDetailFulfillmentBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingDetailFulfillmentBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingDetailFulfillmentBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingDetailFulfillment extends ListingDetailFulfillment {
  @override
  final bool pickupAvailable;
  @override
  final ListingDetailFulfillmentDeliveryEnum delivery;
  @override
  final int? deliveryMaximumKm;
  @override
  final ListingDetailFulfillmentBasisEnum basis;
  @override
  final String notice;

  factory _$ListingDetailFulfillment(
          [void Function(ListingDetailFulfillmentBuilder)? updates]) =>
      (ListingDetailFulfillmentBuilder()..update(updates))._build();

  _$ListingDetailFulfillment._(
      {required this.pickupAvailable,
      required this.delivery,
      this.deliveryMaximumKm,
      required this.basis,
      required this.notice})
      : super._();
  @override
  ListingDetailFulfillment rebuild(
          void Function(ListingDetailFulfillmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingDetailFulfillmentBuilder toBuilder() =>
      ListingDetailFulfillmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingDetailFulfillment &&
        pickupAvailable == other.pickupAvailable &&
        delivery == other.delivery &&
        deliveryMaximumKm == other.deliveryMaximumKm &&
        basis == other.basis &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pickupAvailable.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, deliveryMaximumKm.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingDetailFulfillment')
          ..add('pickupAvailable', pickupAvailable)
          ..add('delivery', delivery)
          ..add('deliveryMaximumKm', deliveryMaximumKm)
          ..add('basis', basis)
          ..add('notice', notice))
        .toString();
  }
}

class ListingDetailFulfillmentBuilder
    implements
        Builder<ListingDetailFulfillment, ListingDetailFulfillmentBuilder> {
  _$ListingDetailFulfillment? _$v;

  bool? _pickupAvailable;
  bool? get pickupAvailable => _$this._pickupAvailable;
  set pickupAvailable(bool? pickupAvailable) =>
      _$this._pickupAvailable = pickupAvailable;

  ListingDetailFulfillmentDeliveryEnum? _delivery;
  ListingDetailFulfillmentDeliveryEnum? get delivery => _$this._delivery;
  set delivery(ListingDetailFulfillmentDeliveryEnum? delivery) =>
      _$this._delivery = delivery;

  int? _deliveryMaximumKm;
  int? get deliveryMaximumKm => _$this._deliveryMaximumKm;
  set deliveryMaximumKm(int? deliveryMaximumKm) =>
      _$this._deliveryMaximumKm = deliveryMaximumKm;

  ListingDetailFulfillmentBasisEnum? _basis;
  ListingDetailFulfillmentBasisEnum? get basis => _$this._basis;
  set basis(ListingDetailFulfillmentBasisEnum? basis) => _$this._basis = basis;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  ListingDetailFulfillmentBuilder() {
    ListingDetailFulfillment._defaults(this);
  }

  ListingDetailFulfillmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pickupAvailable = $v.pickupAvailable;
      _delivery = $v.delivery;
      _deliveryMaximumKm = $v.deliveryMaximumKm;
      _basis = $v.basis;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingDetailFulfillment other) {
    _$v = other as _$ListingDetailFulfillment;
  }

  @override
  void update(void Function(ListingDetailFulfillmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingDetailFulfillment build() => _build();

  _$ListingDetailFulfillment _build() {
    final _$result = _$v ??
        _$ListingDetailFulfillment._(
          pickupAvailable: BuiltValueNullFieldError.checkNotNull(
              pickupAvailable, r'ListingDetailFulfillment', 'pickupAvailable'),
          delivery: BuiltValueNullFieldError.checkNotNull(
              delivery, r'ListingDetailFulfillment', 'delivery'),
          deliveryMaximumKm: deliveryMaximumKm,
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'ListingDetailFulfillment', 'basis'),
          notice: BuiltValueNullFieldError.checkNotNull(
              notice, r'ListingDetailFulfillment', 'notice'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
