//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_material_ref.g.dart';

/// AnalyticsMaterialRef
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class AnalyticsMaterialRef implements Built<AnalyticsMaterialRef, AnalyticsMaterialRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AnalyticsMaterialRef._();

  factory AnalyticsMaterialRef([void updates(AnalyticsMaterialRefBuilder b)]) = _$AnalyticsMaterialRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsMaterialRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsMaterialRef> get serializer => _$AnalyticsMaterialRefSerializer();
}

class _$AnalyticsMaterialRefSerializer implements PrimitiveSerializer<AnalyticsMaterialRef> {
  @override
  final Iterable<Type> types = const [AnalyticsMaterialRef, _$AnalyticsMaterialRef];

  @override
  final String wireName = r'AnalyticsMaterialRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsMaterialRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsMaterialRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsMaterialRefBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsMaterialRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsMaterialRefBuilder();
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


