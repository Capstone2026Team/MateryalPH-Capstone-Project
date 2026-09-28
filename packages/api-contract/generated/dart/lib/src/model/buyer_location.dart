//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/address_components.dart';
import 'package:materyalph_api_client/src/model/psgc_resolution.dart';
import 'package:materyalph_api_client/src/model/buyer_location_kind.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_location.g.dart';

/// BuyerLocation
///
/// Properties:
/// * [id]
/// * [label]
/// * [locationKind]
/// * [isPrimary]
/// * [formattedAddress]
/// * [latitude]
/// * [longitude]
/// * [source_]
/// * [addressVersion]
/// * [components]
/// * [psgc]
/// * [contactName]
/// * [contactPhoneE164]
/// * [siteInstructions] - Owner-only; shown to a Vendor only when a later order or authorized inquiry needs it.
/// * [lockVersion]
/// * [updatedAt]
@BuiltValue()
abstract class BuyerLocation implements Built<BuyerLocation, BuyerLocationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'location_kind')
  BuyerLocationKind get locationKind;
  // enum locationKindEnum {  DELIVERY,  BUSINESS,  PROJECT_SITE,  PICKUP_REFERENCE,  OTHER,  };

  @BuiltValueField(wireName: r'is_primary')
  bool get isPrimary;

  @BuiltValueField(wireName: r'formatted_address')
  String get formattedAddress;

  @BuiltValueField(wireName: r'latitude')
  double get latitude;

  @BuiltValueField(wireName: r'longitude')
  double get longitude;

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'address_version')
  int get addressVersion;

  @BuiltValueField(wireName: r'components')
  AddressComponents get components;

  @BuiltValueField(wireName: r'psgc')
  PsgcResolution get psgc;

  @BuiltValueField(wireName: r'contact_name')
  String? get contactName;

  @BuiltValueField(wireName: r'contact_phone_e164')
  String? get contactPhoneE164;

  /// Owner-only; shown to a Vendor only when a later order or authorized inquiry needs it.
  @BuiltValueField(wireName: r'site_instructions')
  String? get siteInstructions;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  BuyerLocation._();

  factory BuyerLocation([void updates(BuyerLocationBuilder b)]) = _$BuyerLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerLocation> get serializer => _$BuyerLocationSerializer();
}

class _$BuyerLocationSerializer implements PrimitiveSerializer<BuyerLocation> {
  @override
  final Iterable<Type> types = const [BuyerLocation, _$BuyerLocation];

  @override
  final String wireName = r'BuyerLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    yield r'location_kind';
    yield serializers.serialize(
      object.locationKind,
      specifiedType: const FullType(BuyerLocationKind),
    );
    yield r'is_primary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
    yield r'formatted_address';
    yield serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType(String),
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
      specifiedType: const FullType(String),
    );
    yield r'address_version';
    yield serializers.serialize(
      object.addressVersion,
      specifiedType: const FullType(int),
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
    yield r'contact_name';
    yield object.contactName == null ? null : serializers.serialize(
      object.contactName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'contact_phone_e164';
    yield object.contactPhoneE164 == null ? null : serializers.serialize(
      object.contactPhoneE164,
      specifiedType: const FullType.nullable(String),
    );
    yield r'site_instructions';
    yield object.siteInstructions == null ? null : serializers.serialize(
      object.siteInstructions,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'location_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerLocationKind),
          ) as BuyerLocationKind;
          result.locationKind = valueDes;
          break;
        case r'is_primary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'address_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.addressVersion = valueDes;
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerLocationBuilder();
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


