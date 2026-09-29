// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_fulfillment_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingFulfillmentSummaryDeliveryEnum
    _$listingFulfillmentSummaryDeliveryEnum_WITHIN_STATED_AREA =
    const ListingFulfillmentSummaryDeliveryEnum._('WITHIN_STATED_AREA');
const ListingFulfillmentSummaryDeliveryEnum
    _$listingFulfillmentSummaryDeliveryEnum_OUTSIDE_STATED_AREA =
    const ListingFulfillmentSummaryDeliveryEnum._('OUTSIDE_STATED_AREA');
const ListingFulfillmentSummaryDeliveryEnum
    _$listingFulfillmentSummaryDeliveryEnum_NOT_OFFERED =
    const ListingFulfillmentSummaryDeliveryEnum._('NOT_OFFERED');

ListingFulfillmentSummaryDeliveryEnum
    _$listingFulfillmentSummaryDeliveryEnumValueOf(String name) {
  switch (name) {
    case 'WITHIN_STATED_AREA':
      return _$listingFulfillmentSummaryDeliveryEnum_WITHIN_STATED_AREA;
    case 'OUTSIDE_STATED_AREA':
      return _$listingFulfillmentSummaryDeliveryEnum_OUTSIDE_STATED_AREA;
    case 'NOT_OFFERED':
      return _$listingFulfillmentSummaryDeliveryEnum_NOT_OFFERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingFulfillmentSummaryDeliveryEnum>
    _$listingFulfillmentSummaryDeliveryEnumValues = BuiltSet<
        ListingFulfillmentSummaryDeliveryEnum>(const <ListingFulfillmentSummaryDeliveryEnum>[
  _$listingFulfillmentSummaryDeliveryEnum_WITHIN_STATED_AREA,
  _$listingFulfillmentSummaryDeliveryEnum_OUTSIDE_STATED_AREA,
  _$listingFulfillmentSummaryDeliveryEnum_NOT_OFFERED,
]);

const ListingFulfillmentSummaryBasisEnum
    _$listingFulfillmentSummaryBasisEnum_STRAIGHT_LINE_ADVISORY =
    const ListingFulfillmentSummaryBasisEnum._('STRAIGHT_LINE_ADVISORY');

ListingFulfillmentSummaryBasisEnum _$listingFulfillmentSummaryBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'STRAIGHT_LINE_ADVISORY':
      return _$listingFulfillmentSummaryBasisEnum_STRAIGHT_LINE_ADVISORY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingFulfillmentSummaryBasisEnum>
    _$listingFulfillmentSummaryBasisEnumValues = BuiltSet<
        ListingFulfillmentSummaryBasisEnum>(const <ListingFulfillmentSummaryBasisEnum>[
  _$listingFulfillmentSummaryBasisEnum_STRAIGHT_LINE_ADVISORY,
]);

Serializer<ListingFulfillmentSummaryDeliveryEnum>
    _$listingFulfillmentSummaryDeliveryEnumSerializer =
    _$ListingFulfillmentSummaryDeliveryEnumSerializer();
Serializer<ListingFulfillmentSummaryBasisEnum>
    _$listingFulfillmentSummaryBasisEnumSerializer =
    _$ListingFulfillmentSummaryBasisEnumSerializer();

class _$ListingFulfillmentSummaryDeliveryEnumSerializer
    implements PrimitiveSerializer<ListingFulfillmentSummaryDeliveryEnum> {
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
    ListingFulfillmentSummaryDeliveryEnum
  ];
  @override
  final String wireName = 'ListingFulfillmentSummaryDeliveryEnum';

  @override
  Object serialize(
          Serializers serializers, ListingFulfillmentSummaryDeliveryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingFulfillmentSummaryDeliveryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingFulfillmentSummaryDeliveryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingFulfillmentSummaryBasisEnumSerializer
    implements PrimitiveSerializer<ListingFulfillmentSummaryBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STRAIGHT_LINE_ADVISORY': 'STRAIGHT_LINE_ADVISORY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STRAIGHT_LINE_ADVISORY': 'STRAIGHT_LINE_ADVISORY',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingFulfillmentSummaryBasisEnum];
  @override
  final String wireName = 'ListingFulfillmentSummaryBasisEnum';

  @override
  Object serialize(
          Serializers serializers, ListingFulfillmentSummaryBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingFulfillmentSummaryBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingFulfillmentSummaryBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingFulfillmentSummary extends ListingFulfillmentSummary {
  @override
  final bool pickupAvailable;
  @override
  final ListingFulfillmentSummaryDeliveryEnum delivery;
  @override
  final ListingFulfillmentSummaryBasisEnum basis;

  factory _$ListingFulfillmentSummary(
          [void Function(ListingFulfillmentSummaryBuilder)? updates]) =>
      (ListingFulfillmentSummaryBuilder()..update(updates))._build();

  _$ListingFulfillmentSummary._(
      {required this.pickupAvailable,
      required this.delivery,
      required this.basis})
      : super._();
  @override
  ListingFulfillmentSummary rebuild(
          void Function(ListingFulfillmentSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingFulfillmentSummaryBuilder toBuilder() =>
      ListingFulfillmentSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingFulfillmentSummary &&
        pickupAvailable == other.pickupAvailable &&
        delivery == other.delivery &&
        basis == other.basis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pickupAvailable.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingFulfillmentSummary')
          ..add('pickupAvailable', pickupAvailable)
          ..add('delivery', delivery)
          ..add('basis', basis))
        .toString();
  }
}

class ListingFulfillmentSummaryBuilder
    implements
        Builder<ListingFulfillmentSummary, ListingFulfillmentSummaryBuilder> {
  _$ListingFulfillmentSummary? _$v;

  bool? _pickupAvailable;
  bool? get pickupAvailable => _$this._pickupAvailable;
  set pickupAvailable(bool? pickupAvailable) =>
      _$this._pickupAvailable = pickupAvailable;

  ListingFulfillmentSummaryDeliveryEnum? _delivery;
  ListingFulfillmentSummaryDeliveryEnum? get delivery => _$this._delivery;
  set delivery(ListingFulfillmentSummaryDeliveryEnum? delivery) =>
      _$this._delivery = delivery;

  ListingFulfillmentSummaryBasisEnum? _basis;
  ListingFulfillmentSummaryBasisEnum? get basis => _$this._basis;
  set basis(ListingFulfillmentSummaryBasisEnum? basis) => _$this._basis = basis;

  ListingFulfillmentSummaryBuilder() {
    ListingFulfillmentSummary._defaults(this);
  }

  ListingFulfillmentSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pickupAvailable = $v.pickupAvailable;
      _delivery = $v.delivery;
      _basis = $v.basis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingFulfillmentSummary other) {
    _$v = other as _$ListingFulfillmentSummary;
  }

  @override
  void update(void Function(ListingFulfillmentSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingFulfillmentSummary build() => _build();

  _$ListingFulfillmentSummary _build() {
    final _$result = _$v ??
        _$ListingFulfillmentSummary._(
          pickupAvailable: BuiltValueNullFieldError.checkNotNull(
              pickupAvailable, r'ListingFulfillmentSummary', 'pickupAvailable'),
          delivery: BuiltValueNullFieldError.checkNotNull(
              delivery, r'ListingFulfillmentSummary', 'delivery'),
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'ListingFulfillmentSummary', 'basis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
