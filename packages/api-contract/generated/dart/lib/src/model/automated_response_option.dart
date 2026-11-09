//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'automated_response_option.g.dart';

/// AutomatedResponseOption
///
/// Properties:
/// * [label]
/// * [response]
@BuiltValue()
abstract class AutomatedResponseOption implements Built<AutomatedResponseOption, AutomatedResponseOptionBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'response')
  String get response;

  AutomatedResponseOption._();

  factory AutomatedResponseOption([void updates(AutomatedResponseOptionBuilder b)]) = _$AutomatedResponseOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutomatedResponseOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutomatedResponseOption> get serializer => _$AutomatedResponseOptionSerializer();
}

class _$AutomatedResponseOptionSerializer implements PrimitiveSerializer<AutomatedResponseOption> {
  @override
  final Iterable<Type> types = const [AutomatedResponseOption, _$AutomatedResponseOption];

  @override
  final String wireName = r'AutomatedResponseOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutomatedResponseOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'response';
    yield serializers.serialize(
      object.response,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutomatedResponseOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutomatedResponseOptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.response = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutomatedResponseOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutomatedResponseOptionBuilder();
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


