//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_eligibility_method.g.dart';

/// DisputeEligibilityMethod
///
/// Properties:
/// * [label]
/// * [channel]
/// * [physical]
@BuiltValue()
abstract class DisputeEligibilityMethod implements Built<DisputeEligibilityMethod, DisputeEligibilityMethodBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'channel')
  String? get channel;

  @BuiltValueField(wireName: r'physical')
  bool get physical;

  DisputeEligibilityMethod._();

  factory DisputeEligibilityMethod([void updates(DisputeEligibilityMethodBuilder b)]) = _$DisputeEligibilityMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeEligibilityMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeEligibilityMethod> get serializer => _$DisputeEligibilityMethodSerializer();
}

class _$DisputeEligibilityMethodSerializer implements PrimitiveSerializer<DisputeEligibilityMethod> {
  @override
  final Iterable<Type> types = const [DisputeEligibilityMethod, _$DisputeEligibilityMethod];

  @override
  final String wireName = r'DisputeEligibilityMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeEligibilityMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    if (object.channel != null) {
      yield r'channel';
      yield serializers.serialize(
        object.channel,
        specifiedType: const FullType(String),
      );
    }
    yield r'physical';
    yield serializers.serialize(
      object.physical,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeEligibilityMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeEligibilityMethodBuilder result,
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
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.channel = valueDes;
          break;
        case r'physical':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.physical = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeEligibilityMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeEligibilityMethodBuilder();
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


