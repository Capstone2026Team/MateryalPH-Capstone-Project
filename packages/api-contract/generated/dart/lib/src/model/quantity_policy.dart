//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quantity_policy.g.dart';

/// Selling quantities in the selected unit. GAL is a whole can; US_GAL is measured volume. Absent on older records; use recorded selling unit and precision without converting quantities.
///
/// Properties:
/// * [mode]
/// * [dimension]
/// * [precision]
/// * [step]
@BuiltValue()
abstract class QuantityPolicy implements Built<QuantityPolicy, QuantityPolicyBuilder> {
  @BuiltValueField(wireName: r'mode')
  QuantityPolicyModeEnum get mode;
  // enum modeEnum {  COUNT,  PACK,  MEASURED,  };

  @BuiltValueField(wireName: r'dimension')
  String get dimension;

  @BuiltValueField(wireName: r'precision')
  int get precision;

  @BuiltValueField(wireName: r'step')
  String get step;

  QuantityPolicy._();

  factory QuantityPolicy([void updates(QuantityPolicyBuilder b)]) = _$QuantityPolicy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QuantityPolicyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QuantityPolicy> get serializer => _$QuantityPolicySerializer();
}

class _$QuantityPolicySerializer implements PrimitiveSerializer<QuantityPolicy> {
  @override
  final Iterable<Type> types = const [QuantityPolicy, _$QuantityPolicy];

  @override
  final String wireName = r'QuantityPolicy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QuantityPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(QuantityPolicyModeEnum),
    );
    yield r'dimension';
    yield serializers.serialize(
      object.dimension,
      specifiedType: const FullType(String),
    );
    yield r'precision';
    yield serializers.serialize(
      object.precision,
      specifiedType: const FullType(int),
    );
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QuantityPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QuantityPolicyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QuantityPolicyModeEnum),
          ) as QuantityPolicyModeEnum;
          result.mode = valueDes;
          break;
        case r'dimension':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dimension = valueDes;
          break;
        case r'precision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.precision = valueDes;
          break;
        case r'step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.step = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QuantityPolicy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QuantityPolicyBuilder();
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


class QuantityPolicyModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COUNT')
  static const QuantityPolicyModeEnum COUNT = _$quantityPolicyModeEnum_COUNT;
  @BuiltValueEnumConst(wireName: r'PACK')
  static const QuantityPolicyModeEnum PACK = _$quantityPolicyModeEnum_PACK;
  @BuiltValueEnumConst(wireName: r'MEASURED')
  static const QuantityPolicyModeEnum MEASURED = _$quantityPolicyModeEnum_MEASURED;

  static Serializer<QuantityPolicyModeEnum> get serializer => _$quantityPolicyModeEnumSerializer;

  const QuantityPolicyModeEnum._(String name): super(name);

  static BuiltSet<QuantityPolicyModeEnum> get values => _$quantityPolicyModeEnumValues;
  static QuantityPolicyModeEnum valueOf(String name) => _$quantityPolicyModeEnumValueOf(name);
}

