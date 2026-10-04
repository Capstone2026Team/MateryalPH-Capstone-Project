//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_handler_ref.g.dart';

/// DisputeHandlerRef
///
/// Properties:
/// * [displayName]
/// * [role]
@BuiltValue()
abstract class DisputeHandlerRef implements Built<DisputeHandlerRef, DisputeHandlerRefBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'role')
  String get role;

  DisputeHandlerRef._();

  factory DisputeHandlerRef([void updates(DisputeHandlerRefBuilder b)]) = _$DisputeHandlerRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeHandlerRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeHandlerRef> get serializer => _$DisputeHandlerRefSerializer();
}

class _$DisputeHandlerRefSerializer implements PrimitiveSerializer<DisputeHandlerRef> {
  @override
  final Iterable<Type> types = const [DisputeHandlerRef, _$DisputeHandlerRef];

  @override
  final String wireName = r'DisputeHandlerRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeHandlerRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeHandlerRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeHandlerRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeHandlerRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeHandlerRefBuilder();
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


