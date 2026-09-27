//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_completion_step.g.dart';

/// CatalogCompletionStep
///
/// Properties:
/// * [key]
/// * [label]
/// * [level]
/// * [status]
/// * [reason]
@BuiltValue()
abstract class CatalogCompletionStep implements Built<CatalogCompletionStep, CatalogCompletionStepBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'level')
  CatalogCompletionStepLevelEnum get level;
  // enum levelEnum {  REQUIRED,  CONDITIONALLY_REQUIRED,  };

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CatalogCompletionStep._();

  factory CatalogCompletionStep([void updates(CatalogCompletionStepBuilder b)]) = _$CatalogCompletionStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogCompletionStepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogCompletionStep> get serializer => _$CatalogCompletionStepSerializer();
}

class _$CatalogCompletionStepSerializer implements PrimitiveSerializer<CatalogCompletionStep> {
  @override
  final Iterable<Type> types = const [CatalogCompletionStep, _$CatalogCompletionStep];

  @override
  final String wireName = r'CatalogCompletionStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogCompletionStep object, {
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
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(CatalogCompletionStepLevelEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogCompletionStep object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogCompletionStepBuilder result,
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
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogCompletionStepLevelEnum),
          ) as CatalogCompletionStepLevelEnum;
          result.level = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogCompletionStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogCompletionStepBuilder();
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


class CatalogCompletionStepLevelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const CatalogCompletionStepLevelEnum REQUIRED = _$catalogCompletionStepLevelEnum_REQUIRED;
  @BuiltValueEnumConst(wireName: r'CONDITIONALLY_REQUIRED')
  static const CatalogCompletionStepLevelEnum CONDITIONALLY_REQUIRED = _$catalogCompletionStepLevelEnum_CONDITIONALLY_REQUIRED;

  static Serializer<CatalogCompletionStepLevelEnum> get serializer => _$catalogCompletionStepLevelEnumSerializer;

  const CatalogCompletionStepLevelEnum._(String name): super(name);

  static BuiltSet<CatalogCompletionStepLevelEnum> get values => _$catalogCompletionStepLevelEnumValues;
  static CatalogCompletionStepLevelEnum valueOf(String name) => _$catalogCompletionStepLevelEnumValueOf(name);
}

