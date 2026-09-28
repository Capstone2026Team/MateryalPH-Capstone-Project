//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_location_resolve_request.g.dart';

/// BuyerLocationResolveRequest
///
/// Properties:
/// * [mode]
/// * [latitude]
/// * [longitude]
/// * [addressLine]
/// * [barangay]
/// * [cityMunicipality]
/// * [province]
/// * [postalCode]
/// * [cityCode]
/// * [barangayCode]
@BuiltValue()
abstract class BuyerLocationResolveRequest implements Built<BuyerLocationResolveRequest, BuyerLocationResolveRequestBuilder> {
  @BuiltValueField(wireName: r'mode')
  BuyerLocationResolveRequestModeEnum get mode;
  // enum modeEnum {  PIN,  DEVICE,  ADDRESS,  };

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'address_line')
  String? get addressLine;

  @BuiltValueField(wireName: r'barangay')
  String? get barangay;

  @BuiltValueField(wireName: r'city_municipality')
  String? get cityMunicipality;

  @BuiltValueField(wireName: r'province')
  String? get province;

  @BuiltValueField(wireName: r'postal_code')
  String? get postalCode;

  @BuiltValueField(wireName: r'city_code')
  String? get cityCode;

  @BuiltValueField(wireName: r'barangay_code')
  String? get barangayCode;

  BuyerLocationResolveRequest._();

  factory BuyerLocationResolveRequest([void updates(BuyerLocationResolveRequestBuilder b)]) = _$BuyerLocationResolveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerLocationResolveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerLocationResolveRequest> get serializer => _$BuyerLocationResolveRequestSerializer();
}

class _$BuyerLocationResolveRequestSerializer implements PrimitiveSerializer<BuyerLocationResolveRequest> {
  @override
  final Iterable<Type> types = const [BuyerLocationResolveRequest, _$BuyerLocationResolveRequest];

  @override
  final String wireName = r'BuyerLocationResolveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerLocationResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(BuyerLocationResolveRequestModeEnum),
    );
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.addressLine != null) {
      yield r'address_line';
      yield serializers.serialize(
        object.addressLine,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.barangay != null) {
      yield r'barangay';
      yield serializers.serialize(
        object.barangay,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cityMunicipality != null) {
      yield r'city_municipality';
      yield serializers.serialize(
        object.cityMunicipality,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.province != null) {
      yield r'province';
      yield serializers.serialize(
        object.province,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.postalCode != null) {
      yield r'postal_code';
      yield serializers.serialize(
        object.postalCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cityCode != null) {
      yield r'city_code';
      yield serializers.serialize(
        object.cityCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.barangayCode != null) {
      yield r'barangay_code';
      yield serializers.serialize(
        object.barangayCode,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerLocationResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerLocationResolveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerLocationResolveRequestModeEnum),
          ) as BuyerLocationResolveRequestModeEnum;
          result.mode = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'address_line':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.addressLine = valueDes;
          break;
        case r'barangay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.barangay = valueDes;
          break;
        case r'city_municipality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityMunicipality = valueDes;
          break;
        case r'province':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.province = valueDes;
          break;
        case r'postal_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.postalCode = valueDes;
          break;
        case r'city_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityCode = valueDes;
          break;
        case r'barangay_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.barangayCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerLocationResolveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerLocationResolveRequestBuilder();
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


class BuyerLocationResolveRequestModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PIN')
  static const BuyerLocationResolveRequestModeEnum PIN = _$buyerLocationResolveRequestModeEnum_PIN;
  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const BuyerLocationResolveRequestModeEnum DEVICE = _$buyerLocationResolveRequestModeEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'ADDRESS')
  static const BuyerLocationResolveRequestModeEnum ADDRESS = _$buyerLocationResolveRequestModeEnum_ADDRESS;

  static Serializer<BuyerLocationResolveRequestModeEnum> get serializer => _$buyerLocationResolveRequestModeEnumSerializer;

  const BuyerLocationResolveRequestModeEnum._(String name): super(name);

  static BuiltSet<BuyerLocationResolveRequestModeEnum> get values => _$buyerLocationResolveRequestModeEnumValues;
  static BuyerLocationResolveRequestModeEnum valueOf(String name) => _$buyerLocationResolveRequestModeEnumValueOf(name);
}

