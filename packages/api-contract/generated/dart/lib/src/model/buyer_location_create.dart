//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_location_kind.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_location_create.g.dart';

/// BuyerLocationCreate
///
/// Properties:
/// * [resolutionToken]
/// * [label]
/// * [locationKind]
/// * [makePrimary]
/// * [contactName]
/// * [contactPhoneE164]
/// * [siteInstructions]
/// * [addressLine]
@BuiltValue()
abstract class BuyerLocationCreate implements Built<BuyerLocationCreate, BuyerLocationCreateBuilder> {
  @BuiltValueField(wireName: r'resolution_token')
  String get resolutionToken;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'location_kind')
  BuyerLocationKind? get locationKind;
  // enum locationKindEnum {  DELIVERY,  BUSINESS,  PROJECT_SITE,  PICKUP_REFERENCE,  OTHER,  };

  @BuiltValueField(wireName: r'make_primary')
  bool? get makePrimary;

  @BuiltValueField(wireName: r'contact_name')
  String? get contactName;

  @BuiltValueField(wireName: r'contact_phone_e164')
  String? get contactPhoneE164;

  @BuiltValueField(wireName: r'site_instructions')
  String? get siteInstructions;

  @BuiltValueField(wireName: r'address_line')
  String? get addressLine;

  BuyerLocationCreate._();

  factory BuyerLocationCreate([void updates(BuyerLocationCreateBuilder b)]) = _$BuyerLocationCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerLocationCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerLocationCreate> get serializer => _$BuyerLocationCreateSerializer();
}

class _$BuyerLocationCreateSerializer implements PrimitiveSerializer<BuyerLocationCreate> {
  @override
  final Iterable<Type> types = const [BuyerLocationCreate, _$BuyerLocationCreate];

  @override
  final String wireName = r'BuyerLocationCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerLocationCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'resolution_token';
    yield serializers.serialize(
      object.resolutionToken,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    if (object.locationKind != null) {
      yield r'location_kind';
      yield serializers.serialize(
        object.locationKind,
        specifiedType: const FullType(BuyerLocationKind),
      );
    }
    if (object.makePrimary != null) {
      yield r'make_primary';
      yield serializers.serialize(
        object.makePrimary,
        specifiedType: const FullType(bool),
      );
    }
    if (object.contactName != null) {
      yield r'contact_name';
      yield serializers.serialize(
        object.contactName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.contactPhoneE164 != null) {
      yield r'contact_phone_e164';
      yield serializers.serialize(
        object.contactPhoneE164,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.siteInstructions != null) {
      yield r'site_instructions';
      yield serializers.serialize(
        object.siteInstructions,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.addressLine != null) {
      yield r'address_line';
      yield serializers.serialize(
        object.addressLine,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerLocationCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerLocationCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'resolution_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resolutionToken = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'location_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerLocationKind),
          ) as BuyerLocationKind?;
          if (valueDes == null) continue;
          result.locationKind = valueDes;
          break;
        case r'make_primary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.makePrimary = valueDes;
          break;
        case r'contact_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactName = valueDes;
          break;
        case r'contact_phone_e164':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactPhoneE164 = valueDes;
          break;
        case r'site_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.siteInstructions = valueDes;
          break;
        case r'address_line':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.addressLine = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerLocationCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerLocationCreateBuilder();
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


