//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_fulfillment_summary.g.dart';

/// ListingFulfillmentSummary
///
/// Properties:
/// * [pickupAvailable]
/// * [delivery]
/// * [basis]
@BuiltValue()
abstract class ListingFulfillmentSummary implements Built<ListingFulfillmentSummary, ListingFulfillmentSummaryBuilder> {
  @BuiltValueField(wireName: r'pickup_available')
  bool get pickupAvailable;

  @BuiltValueField(wireName: r'delivery')
  ListingFulfillmentSummaryDeliveryEnum get delivery;
  // enum deliveryEnum {  WITHIN_STATED_AREA,  OUTSIDE_STATED_AREA,  NOT_OFFERED,  };

  @BuiltValueField(wireName: r'basis')
  ListingFulfillmentSummaryBasisEnum get basis;
  // enum basisEnum {  STRAIGHT_LINE_ADVISORY,  };

  ListingFulfillmentSummary._();

  factory ListingFulfillmentSummary([void updates(ListingFulfillmentSummaryBuilder b)]) = _$ListingFulfillmentSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingFulfillmentSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingFulfillmentSummary> get serializer => _$ListingFulfillmentSummarySerializer();
}

class _$ListingFulfillmentSummarySerializer implements PrimitiveSerializer<ListingFulfillmentSummary> {
  @override
  final Iterable<Type> types = const [ListingFulfillmentSummary, _$ListingFulfillmentSummary];

  @override
  final String wireName = r'ListingFulfillmentSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingFulfillmentSummary object, {
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
      specifiedType: const FullType(ListingFulfillmentSummaryDeliveryEnum),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(ListingFulfillmentSummaryBasisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingFulfillmentSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingFulfillmentSummaryBuilder result,
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
            specifiedType: const FullType(ListingFulfillmentSummaryDeliveryEnum),
          ) as ListingFulfillmentSummaryDeliveryEnum;
          result.delivery = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingFulfillmentSummaryBasisEnum),
          ) as ListingFulfillmentSummaryBasisEnum;
          result.basis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingFulfillmentSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingFulfillmentSummaryBuilder();
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


class ListingFulfillmentSummaryDeliveryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WITHIN_STATED_AREA')
  static const ListingFulfillmentSummaryDeliveryEnum WITHIN_STATED_AREA = _$listingFulfillmentSummaryDeliveryEnum_WITHIN_STATED_AREA;
  @BuiltValueEnumConst(wireName: r'OUTSIDE_STATED_AREA')
  static const ListingFulfillmentSummaryDeliveryEnum OUTSIDE_STATED_AREA = _$listingFulfillmentSummaryDeliveryEnum_OUTSIDE_STATED_AREA;
  @BuiltValueEnumConst(wireName: r'NOT_OFFERED')
  static const ListingFulfillmentSummaryDeliveryEnum NOT_OFFERED = _$listingFulfillmentSummaryDeliveryEnum_NOT_OFFERED;

  static Serializer<ListingFulfillmentSummaryDeliveryEnum> get serializer => _$listingFulfillmentSummaryDeliveryEnumSerializer;

  const ListingFulfillmentSummaryDeliveryEnum._(String name): super(name);

  static BuiltSet<ListingFulfillmentSummaryDeliveryEnum> get values => _$listingFulfillmentSummaryDeliveryEnumValues;
  static ListingFulfillmentSummaryDeliveryEnum valueOf(String name) => _$listingFulfillmentSummaryDeliveryEnumValueOf(name);
}

class ListingFulfillmentSummaryBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STRAIGHT_LINE_ADVISORY')
  static const ListingFulfillmentSummaryBasisEnum STRAIGHT_LINE_ADVISORY = _$listingFulfillmentSummaryBasisEnum_STRAIGHT_LINE_ADVISORY;

  static Serializer<ListingFulfillmentSummaryBasisEnum> get serializer => _$listingFulfillmentSummaryBasisEnumSerializer;

  const ListingFulfillmentSummaryBasisEnum._(String name): super(name);

  static BuiltSet<ListingFulfillmentSummaryBasisEnum> get values => _$listingFulfillmentSummaryBasisEnumValues;
  static ListingFulfillmentSummaryBasisEnum valueOf(String name) => _$listingFulfillmentSummaryBasisEnumValueOf(name);
}

