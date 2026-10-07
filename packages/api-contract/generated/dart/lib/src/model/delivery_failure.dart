//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_failure.g.dart';

/// DeliveryFailure
///
/// Properties:
/// * [id]
/// * [channel]
/// * [state]
/// * [attemptCount]
/// * [failureCode]
/// * [updatedAt]
@BuiltValue()
abstract class DeliveryFailure implements Built<DeliveryFailure, DeliveryFailureBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'channel')
  String get channel;

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'attempt_count')
  int get attemptCount;

  @BuiltValueField(wireName: r'failure_code')
  String? get failureCode;

  @BuiltValueField(wireName: r'updated_at')
  String get updatedAt;

  DeliveryFailure._();

  factory DeliveryFailure([void updates(DeliveryFailureBuilder b)]) = _$DeliveryFailure;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryFailureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryFailure> get serializer => _$DeliveryFailureSerializer();
}

class _$DeliveryFailureSerializer implements PrimitiveSerializer<DeliveryFailure> {
  @override
  final Iterable<Type> types = const [DeliveryFailure, _$DeliveryFailure];

  @override
  final String wireName = r'DeliveryFailure';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryFailure object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    yield r'attempt_count';
    yield serializers.serialize(
      object.attemptCount,
      specifiedType: const FullType(int),
    );
    yield r'failure_code';
    yield object.failureCode == null ? null : serializers.serialize(
      object.failureCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryFailure object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryFailureBuilder result,
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
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channel = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'attempt_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attemptCount = valueDes;
          break;
        case r'failure_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.failureCode = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryFailure deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryFailureBuilder();
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


