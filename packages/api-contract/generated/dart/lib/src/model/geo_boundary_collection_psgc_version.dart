//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_boundary_collection_psgc_version.g.dart';

/// GeoBoundaryCollectionPsgcVersion
///
/// Properties:
/// * [id]
/// * [label]
@BuiltValue()
abstract class GeoBoundaryCollectionPsgcVersion implements Built<GeoBoundaryCollectionPsgcVersion, GeoBoundaryCollectionPsgcVersionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  GeoBoundaryCollectionPsgcVersion._();

  factory GeoBoundaryCollectionPsgcVersion([void updates(GeoBoundaryCollectionPsgcVersionBuilder b)]) = _$GeoBoundaryCollectionPsgcVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoBoundaryCollectionPsgcVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoBoundaryCollectionPsgcVersion> get serializer => _$GeoBoundaryCollectionPsgcVersionSerializer();
}

class _$GeoBoundaryCollectionPsgcVersionSerializer implements PrimitiveSerializer<GeoBoundaryCollectionPsgcVersion> {
  @override
  final Iterable<Type> types = const [GeoBoundaryCollectionPsgcVersion, _$GeoBoundaryCollectionPsgcVersion];

  @override
  final String wireName = r'GeoBoundaryCollectionPsgcVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoBoundaryCollectionPsgcVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoBoundaryCollectionPsgcVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoBoundaryCollectionPsgcVersionBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoBoundaryCollectionPsgcVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoBoundaryCollectionPsgcVersionBuilder();
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


