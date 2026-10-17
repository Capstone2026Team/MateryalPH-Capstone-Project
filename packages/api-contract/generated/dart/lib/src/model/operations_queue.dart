//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operations_queue.g.dart';

/// OperationsQueue
///
/// Properties:
/// * [key]
/// * [label]
/// * [group]
/// * [count]
/// * [href]
/// * [description]
/// * [oldestAt]
@BuiltValue()
abstract class OperationsQueue implements Built<OperationsQueue, OperationsQueueBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'group')
  String get group;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'href')
  String get href;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'oldest_at')
  DateTime? get oldestAt;

  OperationsQueue._();

  factory OperationsQueue([void updates(OperationsQueueBuilder b)]) = _$OperationsQueue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperationsQueueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperationsQueue> get serializer => _$OperationsQueueSerializer();
}

class _$OperationsQueueSerializer implements PrimitiveSerializer<OperationsQueue> {
  @override
  final Iterable<Type> types = const [OperationsQueue, _$OperationsQueue];

  @override
  final String wireName = r'OperationsQueue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperationsQueue object, {
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
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'href';
    yield serializers.serialize(
      object.href,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    if (object.oldestAt != null) {
      yield r'oldest_at';
      yield serializers.serialize(
        object.oldestAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OperationsQueue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperationsQueueBuilder result,
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
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.group = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'href':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.href = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'oldest_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.oldestAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperationsQueue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperationsQueueBuilder();
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


