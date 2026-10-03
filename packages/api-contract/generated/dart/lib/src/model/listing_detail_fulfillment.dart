//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_detail_fulfillment.g.dart';

/// ListingDetailFulfillment
///
/// Properties:
/// * [pickupAvailable]
/// * [delivery]
/// * [deliveryMaximumKm]
/// * [basis]
/// * [notice]
@BuiltValue()
abstract class ListingDetailFulfillment implements Built<ListingDetailFulfillment, ListingDetailFulfillmentBuilder> {
  @BuiltValueField(wireName: r'pickup_available')
  bool get pickupAvailable;

  @BuiltValueField(wireName: r'delivery')
  ListingDetailFulfillmentDeliveryEnum get delivery;
  // enum deliveryEnum {  WITHIN_STATED_AREA,  OUTSIDE_STATED_AREA,  NOT_OFFERED,  };

  @BuiltValueField(wireName: r'delivery_maximum_km')
  int? get deliveryMaximumKm;

  @BuiltValueField(wireName: r'basis')
  ListingDetailFulfillmentBasisEnum get basis;
  // enum basisEnum {  STRAIGHT_LINE_ADVISORY,  };

  @BuiltValueField(wireName: r'notice')
  String get notice;

  ListingDetailFulfillment._();

  factory ListingDetailFulfillment([void updates(ListingDetailFulfillmentBuilder b)]) = _$ListingDetailFulfillment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingDetailFulfillmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingDetailFulfillment> get serializer => _$ListingDetailFulfillmentSerializer();
}

class _$ListingDetailFulfillmentSerializer implements PrimitiveSerializer<ListingDetailFulfillment> {
  @override
  final Iterable<Type> types = const [ListingDetailFulfillment, _$ListingDetailFulfillment];

  @override
  final String wireName = r'ListingDetailFulfillment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingDetailFulfillment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pickup_available';
    yield serializers.serialize(
      object.pickupAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(ListingDetailFulfillmentDeliveryEnum),
    );
    yield r'delivery_maximum_km';
    yield object.deliveryMaximumKm == null ? null : serializers.serialize(
      object.deliveryMaximumKm,
      specifiedType: const FullType.nullable(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(ListingDetailFulfillmentBasisEnum),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingDetailFulfillment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingDetailFulfillmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pickup_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pickupAvailable = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingDetailFulfillmentDeliveryEnum),
          ) as ListingDetailFulfillmentDeliveryEnum;
          result.delivery = valueDes;
          break;
        case r'delivery_maximum_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryMaximumKm = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingDetailFulfillmentBasisEnum),
          ) as ListingDetailFulfillmentBasisEnum;
          result.basis = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingDetailFulfillment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingDetailFulfillmentBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class ListingDetailFulfillmentDeliveryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WITHIN_STATED_AREA')
  static const ListingDetailFulfillmentDeliveryEnum WITHIN_STATED_AREA = _$listingDetailFulfillmentDeliveryEnum_WITHIN_STATED_AREA;
  @BuiltValueEnumConst(wireName: r'OUTSIDE_STATED_AREA')
  static const ListingDetailFulfillmentDeliveryEnum OUTSIDE_STATED_AREA = _$listingDetailFulfillmentDeliveryEnum_OUTSIDE_STATED_AREA;
  @BuiltValueEnumConst(wireName: r'NOT_OFFERED')
  static const ListingDetailFulfillmentDeliveryEnum NOT_OFFERED = _$listingDetailFulfillmentDeliveryEnum_NOT_OFFERED;

  static Serializer<ListingDetailFulfillmentDeliveryEnum> get serializer => _$listingDetailFulfillmentDeliveryEnumSerializer;

  const ListingDetailFulfillmentDeliveryEnum._(String name): super(name);

  static BuiltSet<ListingDetailFulfillmentDeliveryEnum> get values => _$listingDetailFulfillmentDeliveryEnumValues;
  static ListingDetailFulfillmentDeliveryEnum valueOf(String name) => _$listingDetailFulfillmentDeliveryEnumValueOf(name);
}

class ListingDetailFulfillmentBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STRAIGHT_LINE_ADVISORY')
  static const ListingDetailFulfillmentBasisEnum STRAIGHT_LINE_ADVISORY = _$listingDetailFulfillmentBasisEnum_STRAIGHT_LINE_ADVISORY;

  static Serializer<ListingDetailFulfillmentBasisEnum> get serializer => _$listingDetailFulfillmentBasisEnumSerializer;

  const ListingDetailFulfillmentBasisEnum._(String name): super(name);

  static BuiltSet<ListingDetailFulfillmentBasisEnum> get values => _$listingDetailFulfillmentBasisEnumValues;
  static ListingDetailFulfillmentBasisEnum valueOf(String name) => _$listingDetailFulfillmentBasisEnumValueOf(name);
}

