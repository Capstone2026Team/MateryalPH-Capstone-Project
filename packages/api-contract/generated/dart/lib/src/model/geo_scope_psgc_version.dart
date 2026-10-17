//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_scope_psgc_version.g.dart';

/// GeoScopePsgcVersion
///
/// Properties:
/// * [id]
/// * [label]
/// * [effectiveOn]
@BuiltValue()
abstract class GeoScopePsgcVersion implements Built<GeoScopePsgcVersion, GeoScopePsgcVersionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'effective_on')
  String get effectiveOn;

  GeoScopePsgcVersion._();

  factory GeoScopePsgcVersion([void updates(GeoScopePsgcVersionBuilder b)]) = _$GeoScopePsgcVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoScopePsgcVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoScopePsgcVersion> get serializer => _$GeoScopePsgcVersionSerializer();
}

class _$GeoScopePsgcVersionSerializer implements PrimitiveSerializer<GeoScopePsgcVersion> {
  @override
  final Iterable<Type> types = const [GeoScopePsgcVersion, _$GeoScopePsgcVersion];

  @override
  final String wireName = r'GeoScopePsgcVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoScopePsgcVersion object, {
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
    yield r'effective_on';
    yield serializers.serialize(
      object.effectiveOn,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoScopePsgcVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoScopePsgcVersionBuilder result,
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
        case r'effective_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.effectiveOn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoScopePsgcVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoScopePsgcVersionBuilder();
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


