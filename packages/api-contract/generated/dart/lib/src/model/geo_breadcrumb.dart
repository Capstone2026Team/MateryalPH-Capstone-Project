//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_breadcrumb.g.dart';

/// GeoBreadcrumb
///
/// Properties:
/// * [code]
/// * [name]
/// * [level]
@BuiltValue()
abstract class GeoBreadcrumb implements Built<GeoBreadcrumb, GeoBreadcrumbBuilder> {
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'level')
  String? get level;

  GeoBreadcrumb._();

  factory GeoBreadcrumb([void updates(GeoBreadcrumbBuilder b)]) = _$GeoBreadcrumb;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoBreadcrumbBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoBreadcrumb> get serializer => _$GeoBreadcrumbSerializer();
}

class _$GeoBreadcrumbSerializer implements PrimitiveSerializer<GeoBreadcrumb> {
  @override
  final Iterable<Type> types = const [GeoBreadcrumb, _$GeoBreadcrumb];

  @override
  final String wireName = r'GeoBreadcrumb';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoBreadcrumb object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.level != null) {
      yield r'level';
      yield serializers.serialize(
        object.level,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoBreadcrumb object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoBreadcrumbBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.level = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoBreadcrumb deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoBreadcrumbBuilder();
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


