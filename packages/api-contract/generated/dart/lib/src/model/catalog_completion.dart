//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_completion_step.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_completion.g.dart';

/// Server-derived wizard completion. The browser never submits completion as truth.
///
/// Properties:
/// * [key]
/// * [label]
/// * [steps]
@BuiltValue()
abstract class CatalogCompletion implements Built<CatalogCompletion, CatalogCompletionBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'steps')
  BuiltList<CatalogCompletionStep> get steps;

  CatalogCompletion._();

  factory CatalogCompletion([void updates(CatalogCompletionBuilder b)]) = _$CatalogCompletion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogCompletionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogCompletion> get serializer => _$CatalogCompletionSerializer();
}

class _$CatalogCompletionSerializer implements PrimitiveSerializer<CatalogCompletion> {
  @override
  final Iterable<Type> types = const [CatalogCompletion, _$CatalogCompletion];

  @override
  final String wireName = r'CatalogCompletion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogCompletion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(CatalogCompletionStep)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogCompletion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogCompletionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogCompletionStep)]),
          ) as BuiltList<CatalogCompletionStep>;
          result.steps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogCompletion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogCompletionBuilder();
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


