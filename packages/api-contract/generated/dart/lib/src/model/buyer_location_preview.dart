//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/address_components.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/psgc_resolution.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_location_preview.g.dart';

/// BuyerLocationPreview
///
/// Properties:
/// * [formattedAddress]
/// * [latitude]
/// * [longitude]
/// * [source_]
/// * [providerStatus]
/// * [components]
/// * [psgc]
/// * [resolutionToken] - Opaque, Buyer-bound and valid for 30 minutes.
/// * [expiresAt]
@BuiltValue()
abstract class BuyerLocationPreview implements Built<BuyerLocationPreview, BuyerLocationPreviewBuilder> {
  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  @BuiltValueField(wireName: r'latitude')
  double get latitude;

  @BuiltValueField(wireName: r'longitude')
  double get longitude;

  @BuiltValueField(wireName: r'source')
  BuyerLocationPreviewSource_Enum get source_;
  // enum source_Enum {  DEVICE,  MAP_PIN,  ADDRESS_SEARCH,  };

  @BuiltValueField(wireName: r'provider_status')
  BuyerLocationPreviewProviderStatusEnum get providerStatus;
  // enum providerStatusEnum {  AVAILABLE,  UNAVAILABLE,  NOT_FOUND,  };

  @BuiltValueField(wireName: r'components')
  AddressComponents get components;

  @BuiltValueField(wireName: r'psgc')
  PsgcResolution get psgc;

  /// Opaque, Buyer-bound and valid for 30 minutes.
  @BuiltValueField(wireName: r'resolution_token')
  String get resolutionToken;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  BuyerLocationPreview._();

  factory BuyerLocationPreview([void updates(BuyerLocationPreviewBuilder b)]) = _$BuyerLocationPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerLocationPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerLocationPreview> get serializer => _$BuyerLocationPreviewSerializer();
}

class _$BuyerLocationPreviewSerializer implements PrimitiveSerializer<BuyerLocationPreview> {
  @override
  final Iterable<Type> types = const [BuyerLocationPreview, _$BuyerLocationPreview];

  @override
  final String wireName = r'BuyerLocationPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerLocationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(double),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(double),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(BuyerLocationPreviewSource_Enum),
    );
    yield r'provider_status';
    yield serializers.serialize(
      object.providerStatus,
      specifiedType: const FullType(BuyerLocationPreviewProviderStatusEnum),
    );
    yield r'components';
    yield serializers.serialize(
      object.components,
      specifiedType: const FullType(AddressComponents),
    );
    yield r'psgc';
    yield serializers.serialize(
      object.psgc,
      specifiedType: const FullType(PsgcResolution),
    );
    yield r'resolution_token';
    yield serializers.serialize(
      object.resolutionToken,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerLocationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerLocationPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formattedAddress = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.longitude = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerLocationPreviewSource_Enum),
          ) as BuyerLocationPreviewSource_Enum;
          result.source_ = valueDes;
          break;
        case r'provider_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerLocationPreviewProviderStatusEnum),
          ) as BuyerLocationPreviewProviderStatusEnum;
          result.providerStatus = valueDes;
          break;
        case r'components':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AddressComponents),
          ) as AddressComponents;
          result.components.replace(valueDes);
          break;
        case r'psgc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PsgcResolution),
          ) as PsgcResolution;
          result.psgc.replace(valueDes);
          break;
        case r'resolution_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resolutionToken = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerLocationPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerLocationPreviewBuilder();
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


class BuyerLocationPreviewSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const BuyerLocationPreviewSource_Enum DEVICE = _$buyerLocationPreviewSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const BuyerLocationPreviewSource_Enum MAP_PIN = _$buyerLocationPreviewSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'ADDRESS_SEARCH')
  static const BuyerLocationPreviewSource_Enum ADDRESS_SEARCH = _$buyerLocationPreviewSourceEnum_ADDRESS_SEARCH;

  static Serializer<BuyerLocationPreviewSource_Enum> get serializer => _$buyerLocationPreviewSourceEnumSerializer;

  const BuyerLocationPreviewSource_Enum._(String name): super(name);

  static BuiltSet<BuyerLocationPreviewSource_Enum> get values => _$buyerLocationPreviewSourceEnumValues;
  static BuyerLocationPreviewSource_Enum valueOf(String name) => _$buyerLocationPreviewSourceEnumValueOf(name);
}

class BuyerLocationPreviewProviderStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const BuyerLocationPreviewProviderStatusEnum AVAILABLE = _$buyerLocationPreviewProviderStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const BuyerLocationPreviewProviderStatusEnum UNAVAILABLE = _$buyerLocationPreviewProviderStatusEnum_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'NOT_FOUND')
  static const BuyerLocationPreviewProviderStatusEnum NOT_FOUND = _$buyerLocationPreviewProviderStatusEnum_NOT_FOUND;

  static Serializer<BuyerLocationPreviewProviderStatusEnum> get serializer => _$buyerLocationPreviewProviderStatusEnumSerializer;

  const BuyerLocationPreviewProviderStatusEnum._(String name): super(name);

  static BuiltSet<BuyerLocationPreviewProviderStatusEnum> get values => _$buyerLocationPreviewProviderStatusEnumValues;
  static BuyerLocationPreviewProviderStatusEnum valueOf(String name) => _$buyerLocationPreviewProviderStatusEnumValueOf(name);
}

