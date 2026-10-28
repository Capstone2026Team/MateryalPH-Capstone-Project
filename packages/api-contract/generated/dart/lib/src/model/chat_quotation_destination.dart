//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_destination.g.dart';

/// Item-Based Vendor proposal, subject to Buyer review and acceptance. Omit address IDs to use the location shared in the inquiry. Work Package destinations stay locked.
///
/// Properties:
/// * [intendedAddress]
/// * [alternateAddress]
/// * [intendedAddressId]
/// * [alternateAddressId]
/// * [heavyVehicleRestriction]
/// * [accessInstructions]
@BuiltValue()
abstract class ChatQuotationDestination implements Built<ChatQuotationDestination, ChatQuotationDestinationBuilder> {
  @BuiltValueField(wireName: r'intended_address')
  String? get intendedAddress;

  @BuiltValueField(wireName: r'alternate_address')
  String? get alternateAddress;

  @BuiltValueField(wireName: r'intended_address_id')
  String? get intendedAddressId;

  @BuiltValueField(wireName: r'alternate_address_id')
  String? get alternateAddressId;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  ChatQuotationDestinationHeavyVehicleRestrictionEnum? get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  UNANSWERED,  NO,  YES,  };

  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  ChatQuotationDestination._();

  factory ChatQuotationDestination([void updates(ChatQuotationDestinationBuilder b)]) = _$ChatQuotationDestination;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationDestinationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationDestination> get serializer => _$ChatQuotationDestinationSerializer();
}

class _$ChatQuotationDestinationSerializer implements PrimitiveSerializer<ChatQuotationDestination> {
  @override
  final Iterable<Type> types = const [ChatQuotationDestination, _$ChatQuotationDestination];

  @override
  final String wireName = r'ChatQuotationDestination';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.intendedAddress != null) {
      yield r'intended_address';
      yield serializers.serialize(
        object.intendedAddress,
        specifiedType: const FullType(String),
      );
    }
    if (object.alternateAddress != null) {
      yield r'alternate_address';
      yield serializers.serialize(
        object.alternateAddress,
        specifiedType: const FullType(String),
      );
    }
    if (object.intendedAddressId != null) {
      yield r'intended_address_id';
      yield serializers.serialize(
        object.intendedAddressId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.alternateAddressId != null) {
      yield r'alternate_address_id';
      yield serializers.serialize(
        object.alternateAddressId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.heavyVehicleRestriction != null) {
      yield r'heavy_vehicle_restriction';
      yield serializers.serialize(
        object.heavyVehicleRestriction,
        specifiedType: const FullType(ChatQuotationDestinationHeavyVehicleRestrictionEnum),
      );
    }
    if (object.accessInstructions != null) {
      yield r'access_instructions';
      yield serializers.serialize(
        object.accessInstructions,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationDestinationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'intended_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.intendedAddress = valueDes;
          break;
        case r'alternate_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateAddress = valueDes;
          break;
        case r'intended_address_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.intendedAddressId = valueDes;
          break;
        case r'alternate_address_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateAddressId = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChatQuotationDestinationHeavyVehicleRestrictionEnum),
          ) as ChatQuotationDestinationHeavyVehicleRestrictionEnum?;
          if (valueDes == null) continue;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationDestination deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationDestinationBuilder();
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


class ChatQuotationDestinationHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNANSWERED')
  static const ChatQuotationDestinationHeavyVehicleRestrictionEnum UNANSWERED = _$chatQuotationDestinationHeavyVehicleRestrictionEnum_UNANSWERED;
  @BuiltValueEnumConst(wireName: r'NO')
  static const ChatQuotationDestinationHeavyVehicleRestrictionEnum NO = _$chatQuotationDestinationHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const ChatQuotationDestinationHeavyVehicleRestrictionEnum YES = _$chatQuotationDestinationHeavyVehicleRestrictionEnum_YES;

  static Serializer<ChatQuotationDestinationHeavyVehicleRestrictionEnum> get serializer => _$chatQuotationDestinationHeavyVehicleRestrictionEnumSerializer;

  const ChatQuotationDestinationHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<ChatQuotationDestinationHeavyVehicleRestrictionEnum> get values => _$chatQuotationDestinationHeavyVehicleRestrictionEnumValues;
  static ChatQuotationDestinationHeavyVehicleRestrictionEnum valueOf(String name) => _$chatQuotationDestinationHeavyVehicleRestrictionEnumValueOf(name);
}

