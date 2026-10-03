//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_create.g.dart';

/// ChatCreate
///
/// Properties:
/// * [vendorId]
/// * [listingVariantId]
/// * [locationId]
/// * [heavyVehicleRestriction]
/// * [alternateDropOffLocationId]
/// * [accessInstructions]
/// * [contextType]
@BuiltValue()
abstract class ChatCreate implements Built<ChatCreate, ChatCreateBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'listing_variant_id')
  String? get listingVariantId;

  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  String? get heavyVehicleRestriction;

  @BuiltValueField(wireName: r'alternate_drop_off_location_id')
  String? get alternateDropOffLocationId;

  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  @BuiltValueField(wireName: r'context_type')
  ChatCreateContextTypeEnum? get contextType;
  // enum contextTypeEnum {  ITEM_BASED,  PROJECT_BASED,  };

  ChatCreate._();

  factory ChatCreate([void updates(ChatCreateBuilder b)]) = _$ChatCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatCreate> get serializer => _$ChatCreateSerializer();
}

class _$ChatCreateSerializer implements PrimitiveSerializer<ChatCreate> {
  @override
  final Iterable<Type> types = const [ChatCreate, _$ChatCreate];

  @override
  final String wireName = r'ChatCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    if (object.listingVariantId != null) {
      yield r'listing_variant_id';
      yield serializers.serialize(
        object.listingVariantId,
        specifiedType: const FullType(String),
      );
    }
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.heavyVehicleRestriction != null) {
      yield r'heavy_vehicle_restriction';
      yield serializers.serialize(
        object.heavyVehicleRestriction,
        specifiedType: const FullType(String),
      );
    }
    if (object.alternateDropOffLocationId != null) {
      yield r'alternate_drop_off_location_id';
      yield serializers.serialize(
        object.alternateDropOffLocationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.accessInstructions != null) {
      yield r'access_instructions';
      yield serializers.serialize(
        object.accessInstructions,
        specifiedType: const FullType(String),
      );
    }
    if (object.contextType != null) {
      yield r'context_type';
      yield serializers.serialize(
        object.contextType,
        specifiedType: const FullType(ChatCreateContextTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingVariantId = valueDes;
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'alternate_drop_off_location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateDropOffLocationId = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        case r'context_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChatCreateContextTypeEnum),
          ) as ChatCreateContextTypeEnum?;
          if (valueDes == null) continue;
          result.contextType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatCreateBuilder();
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


class ChatCreateContextTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ITEM_BASED')
  static const ChatCreateContextTypeEnum ITEM_BASED = _$chatCreateContextTypeEnum_ITEM_BASED;
  @BuiltValueEnumConst(wireName: r'PROJECT_BASED')
  static const ChatCreateContextTypeEnum PROJECT_BASED = _$chatCreateContextTypeEnum_PROJECT_BASED;

  static Serializer<ChatCreateContextTypeEnum> get serializer => _$chatCreateContextTypeEnumSerializer;

  const ChatCreateContextTypeEnum._(String name): super(name);

  static BuiltSet<ChatCreateContextTypeEnum> get values => _$chatCreateContextTypeEnumValues;
  static ChatCreateContextTypeEnum valueOf(String name) => _$chatCreateContextTypeEnumValueOf(name);
}

