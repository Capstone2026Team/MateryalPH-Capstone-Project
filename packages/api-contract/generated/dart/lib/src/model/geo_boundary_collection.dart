//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/geo_boundary_collection_psgc_version.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_boundary_collection.g.dart';

/// Simplified GeoJSON per child area; properties are code, name and level only. Areas without imported geometry are listed for the tile fallback.
///
/// Properties:
/// * [type]
/// * [features]
/// * [missingCodes]
/// * [psgcVersion]
@BuiltValue()
abstract class GeoBoundaryCollection implements Built<GeoBoundaryCollection, GeoBoundaryCollectionBuilder> {
  @BuiltValueField(wireName: r'type')
  GeoBoundaryCollectionTypeEnum get type;
  // enum typeEnum {  FeatureCollection,  };

  @BuiltValueField(wireName: r'features')
  BuiltList<BuiltMap<String, JsonObject?>> get features;

  @BuiltValueField(wireName: r'missing_codes')
  BuiltList<String> get missingCodes;

  @BuiltValueField(wireName: r'psgc_version')
  GeoBoundaryCollectionPsgcVersion get psgcVersion;

  GeoBoundaryCollection._();

  factory GeoBoundaryCollection([void updates(GeoBoundaryCollectionBuilder b)]) = _$GeoBoundaryCollection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoBoundaryCollectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoBoundaryCollection> get serializer => _$GeoBoundaryCollectionSerializer();
}

class _$GeoBoundaryCollectionSerializer implements PrimitiveSerializer<GeoBoundaryCollection> {
  @override
  final Iterable<Type> types = const [GeoBoundaryCollection, _$GeoBoundaryCollection];

  @override
  final String wireName = r'GeoBoundaryCollection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoBoundaryCollection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(GeoBoundaryCollectionTypeEnum),
    );
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'missing_codes';
    yield serializers.serialize(
      object.missingCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'psgc_version';
    yield serializers.serialize(
      object.psgcVersion,
      specifiedType: const FullType(GeoBoundaryCollectionPsgcVersion),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoBoundaryCollection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoBoundaryCollectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoBoundaryCollectionTypeEnum),
          ) as GeoBoundaryCollectionTypeEnum;
          result.type = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.features.replace(valueDes);
          break;
        case r'missing_codes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.missingCodes.replace(valueDes);
          break;
        case r'psgc_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoBoundaryCollectionPsgcVersion),
          ) as GeoBoundaryCollectionPsgcVersion;
          result.psgcVersion.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoBoundaryCollection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoBoundaryCollectionBuilder();
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


class GeoBoundaryCollectionTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FeatureCollection')
  static const GeoBoundaryCollectionTypeEnum featureCollection = _$geoBoundaryCollectionTypeEnum_featureCollection;

  static Serializer<GeoBoundaryCollectionTypeEnum> get serializer => _$geoBoundaryCollectionTypeEnumSerializer;

  const GeoBoundaryCollectionTypeEnum._(String name): super(name);

  static BuiltSet<GeoBoundaryCollectionTypeEnum> get values => _$geoBoundaryCollectionTypeEnumValues;
  static GeoBoundaryCollectionTypeEnum valueOf(String name) => _$geoBoundaryCollectionTypeEnumValueOf(name);
}

