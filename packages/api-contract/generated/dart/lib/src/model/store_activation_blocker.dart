//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_activation_blocker.g.dart';

/// StoreActivationBlocker
///
/// Properties:
/// * [key]
/// * [condition]
/// * [reason]
@BuiltValue()
abstract class StoreActivationBlocker implements Built<StoreActivationBlocker, StoreActivationBlockerBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'condition')
  int get condition;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  StoreActivationBlocker._();

  factory StoreActivationBlocker([void updates(StoreActivationBlockerBuilder b)]) = _$StoreActivationBlocker;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoreActivationBlockerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoreActivationBlocker> get serializer => _$StoreActivationBlockerSerializer();
}

class _$StoreActivationBlockerSerializer implements PrimitiveSerializer<StoreActivationBlocker> {
  @override
  final Iterable<Type> types = const [StoreActivationBlocker, _$StoreActivationBlocker];

  @override
  final String wireName = r'StoreActivationBlocker';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoreActivationBlocker object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'condition';
    yield serializers.serialize(
      object.condition,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StoreActivationBlocker object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoreActivationBlockerBuilder result,
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
        case r'condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.condition = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  StoreActivationBlocker deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoreActivationBlockerBuilder();
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


