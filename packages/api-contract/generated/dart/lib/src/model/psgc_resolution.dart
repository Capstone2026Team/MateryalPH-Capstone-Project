//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/psgc_area_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'psgc_resolution.g.dart';

/// Best resolved versioned PSGC codes. Coordinates stay authoritative; UNRESOLVED is a valid saved state.
///
/// Properties:
/// * [resolution]
/// * [version]
/// * [reason]
/// * [region]
/// * [province]
/// * [cityMunicipality]
/// * [barangay]
@BuiltValue()
abstract class PsgcResolution implements Built<PsgcResolution, PsgcResolutionBuilder> {
  @BuiltValueField(wireName: r'resolution')
  PsgcResolutionResolutionEnum get resolution;
  // enum resolutionEnum {  RESOLVED,  PARTIAL,  UNRESOLVED,  };

  @BuiltValueField(wireName: r'version')
  String? get version;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'region')
  PsgcAreaRef? get region;

  @BuiltValueField(wireName: r'province')
  PsgcAreaRef? get province;

  @BuiltValueField(wireName: r'city_municipality')
  PsgcAreaRef? get cityMunicipality;

  @BuiltValueField(wireName: r'barangay')
  PsgcAreaRef? get barangay;

  PsgcResolution._();

  factory PsgcResolution([void updates(PsgcResolutionBuilder b)]) = _$PsgcResolution;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PsgcResolutionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PsgcResolution> get serializer => _$PsgcResolutionSerializer();
}

class _$PsgcResolutionSerializer implements PrimitiveSerializer<PsgcResolution> {
  @override
  final Iterable<Type> types = const [PsgcResolution, _$PsgcResolution];

  @override
  final String wireName = r'PsgcResolution';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PsgcResolution object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'resolution';
    yield serializers.serialize(
      object.resolution,
      specifiedType: const FullType(PsgcResolutionResolutionEnum),
    );
    yield r'version';
    yield object.version == null ? null : serializers.serialize(
      object.version,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'region';
    yield object.region == null ? null : serializers.serialize(
      object.region,
      specifiedType: const FullType.nullable(PsgcAreaRef),
    );
    yield r'province';
    yield object.province == null ? null : serializers.serialize(
      object.province,
      specifiedType: const FullType.nullable(PsgcAreaRef),
    );
    yield r'city_municipality';
    yield object.cityMunicipality == null ? null : serializers.serialize(
      object.cityMunicipality,
      specifiedType: const FullType.nullable(PsgcAreaRef),
    );
    yield r'barangay';
    yield object.barangay == null ? null : serializers.serialize(
      object.barangay,
      specifiedType: const FullType.nullable(PsgcAreaRef),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PsgcResolution object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PsgcResolutionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PsgcResolutionResolutionEnum),
          ) as PsgcResolutionResolutionEnum;
          result.resolution = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.version = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'region':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PsgcAreaRef),
          ) as PsgcAreaRef?;
          if (valueDes == null) continue;
          result.region.replace(valueDes);
          break;
        case r'province':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PsgcAreaRef),
          ) as PsgcAreaRef?;
          if (valueDes == null) continue;
          result.province.replace(valueDes);
          break;
        case r'city_municipality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PsgcAreaRef),
          ) as PsgcAreaRef?;
          if (valueDes == null) continue;
          result.cityMunicipality.replace(valueDes);
          break;
        case r'barangay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PsgcAreaRef),
          ) as PsgcAreaRef?;
          if (valueDes == null) continue;
          result.barangay.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PsgcResolution deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PsgcResolutionBuilder();
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


class PsgcResolutionResolutionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const PsgcResolutionResolutionEnum RESOLVED = _$psgcResolutionResolutionEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'PARTIAL')
  static const PsgcResolutionResolutionEnum PARTIAL = _$psgcResolutionResolutionEnum_PARTIAL;
  @BuiltValueEnumConst(wireName: r'UNRESOLVED')
  static const PsgcResolutionResolutionEnum UNRESOLVED = _$psgcResolutionResolutionEnum_UNRESOLVED;

  static Serializer<PsgcResolutionResolutionEnum> get serializer => _$psgcResolutionResolutionEnumSerializer;

  const PsgcResolutionResolutionEnum._(String name): super(name);

  static BuiltSet<PsgcResolutionResolutionEnum> get values => _$psgcResolutionResolutionEnumValues;
  static PsgcResolutionResolutionEnum valueOf(String name) => _$psgcResolutionResolutionEnumValueOf(name);
}

