//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/stock_confirmation_schedule.dart';
import 'package:materyalph_api_client/src/model/listing_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stale_listing.g.dart';

/// StaleListing
///
/// Properties:
/// * [listingId]
/// * [listingName]
/// * [listingStatus]
/// * [confirmation]
@BuiltValue()
abstract class StaleListing implements Built<StaleListing, StaleListingBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'listing_name')
  String get listingName;

  @BuiltValueField(wireName: r'listing_status')
  ListingStatus get listingStatus;
  // enum listingStatusEnum {  DRAFT,  PENDING_COMPLIANCE,  PENDING_ADMIN_REVIEW,  ACTIVE,  INACTIVE,  TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED,  REJECTED,  };

  @BuiltValueField(wireName: r'confirmation')
  StockConfirmationSchedule get confirmation;

  StaleListing._();

  factory StaleListing([void updates(StaleListingBuilder b)]) = _$StaleListing;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StaleListingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StaleListing> get serializer => _$StaleListingSerializer();
}

class _$StaleListingSerializer implements PrimitiveSerializer<StaleListing> {
  @override
  final Iterable<Type> types = const [StaleListing, _$StaleListing];

  @override
  final String wireName = r'StaleListing';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StaleListing object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'listing_name';
    yield serializers.serialize(
      object.listingName,
      specifiedType: const FullType(String),
    );
    yield r'listing_status';
    yield serializers.serialize(
      object.listingStatus,
      specifiedType: const FullType(ListingStatus),
    );
    yield r'confirmation';
    yield serializers.serialize(
      object.confirmation,
      specifiedType: const FullType(StockConfirmationSchedule),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StaleListing object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StaleListingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'listing_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingName = valueDes;
          break;
        case r'listing_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingStatus),
          ) as ListingStatus;
          result.listingStatus = valueDes;
          break;
        case r'confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StockConfirmationSchedule),
          ) as StockConfirmationSchedule;
          result.confirmation.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StaleListing deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StaleListingBuilder();
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


