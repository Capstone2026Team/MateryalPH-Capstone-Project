//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_destination_update.g.dart';

/// ChatDestinationUpdate
///
/// Properties:
/// * [locationId]
/// * [heavyVehicleRestriction]
/// * [alternateDropOffLocationId]
/// * [accessInstructions]
/// * [lockVersion]
@BuiltValue()
abstract class ChatDestinationUpdate implements Built<ChatDestinationUpdate, ChatDestinationUpdateBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String get locationId;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  ChatDestinationUpdateHeavyVehicleRestrictionEnum get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  NO,  YES,  };

  @BuiltValueField(wireName: r'alternate_drop_off_location_id')
  String? get alternateDropOffLocationId;

  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  ChatDestinationUpdate._();

  factory ChatDestinationUpdate([void updates(ChatDestinationUpdateBuilder b)]) = _$ChatDestinationUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatDestinationUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatDestinationUpdate> get serializer => _$ChatDestinationUpdateSerializer();
}

class _$ChatDestinationUpdateSerializer implements PrimitiveSerializer<ChatDestinationUpdate> {
  @override
  final Iterable<Type> types = const [ChatDestinationUpdate, _$ChatDestinationUpdate];

  @override
  final String wireName = r'ChatDestinationUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatDestinationUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location_id';
    yield serializers.serialize(
      object.locationId,
      specifiedType: const FullType(String),
    );
    yield r'heavy_vehicle_restriction';
    yield serializers.serialize(
      object.heavyVehicleRestriction,
      specifiedType: const FullType(ChatDestinationUpdateHeavyVehicleRestrictionEnum),
    );
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
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatDestinationUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatDestinationUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locationId = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatDestinationUpdateHeavyVehicleRestrictionEnum),
          ) as ChatDestinationUpdateHeavyVehicleRestrictionEnum;
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatDestinationUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatDestinationUpdateBuilder();
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


class ChatDestinationUpdateHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NO')
  static const ChatDestinationUpdateHeavyVehicleRestrictionEnum NO = _$chatDestinationUpdateHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const ChatDestinationUpdateHeavyVehicleRestrictionEnum YES = _$chatDestinationUpdateHeavyVehicleRestrictionEnum_YES;

  static Serializer<ChatDestinationUpdateHeavyVehicleRestrictionEnum> get serializer => _$chatDestinationUpdateHeavyVehicleRestrictionEnumSerializer;

  const ChatDestinationUpdateHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<ChatDestinationUpdateHeavyVehicleRestrictionEnum> get values => _$chatDestinationUpdateHeavyVehicleRestrictionEnumValues;
  static ChatDestinationUpdateHeavyVehicleRestrictionEnum valueOf(String name) => _$chatDestinationUpdateHeavyVehicleRestrictionEnumValueOf(name);
}

