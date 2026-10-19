//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_command_result.g.dart';

/// SupportCommandResult
///
/// Properties:
/// * [id]
@BuiltValue()
abstract class SupportCommandResult implements Built<SupportCommandResult, SupportCommandResultBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  SupportCommandResult._();

  factory SupportCommandResult([void updates(SupportCommandResultBuilder b)]) = _$SupportCommandResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportCommandResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportCommandResult> get serializer => _$SupportCommandResultSerializer();
}

class _$SupportCommandResultSerializer implements PrimitiveSerializer<SupportCommandResult> {
  @override
  final Iterable<Type> types = const [SupportCommandResult, _$SupportCommandResult];

  @override
  final String wireName = r'SupportCommandResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportCommandResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportCommandResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportCommandResultBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportCommandResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportCommandResultBuilder();
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


