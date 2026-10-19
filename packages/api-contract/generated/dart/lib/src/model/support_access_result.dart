//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_access_result.g.dart';

/// SupportAccessResult
///
/// Properties:
/// * [ticketId]
@BuiltValue()
abstract class SupportAccessResult implements Built<SupportAccessResult, SupportAccessResultBuilder> {
  @BuiltValueField(wireName: r'ticket_id')
  String get ticketId;

  SupportAccessResult._();

  factory SupportAccessResult([void updates(SupportAccessResultBuilder b)]) = _$SupportAccessResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportAccessResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportAccessResult> get serializer => _$SupportAccessResultSerializer();
}

class _$SupportAccessResultSerializer implements PrimitiveSerializer<SupportAccessResult> {
  @override
  final Iterable<Type> types = const [SupportAccessResult, _$SupportAccessResult];

  @override
  final String wireName = r'SupportAccessResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportAccessResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticket_id';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportAccessResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportAccessResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticket_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportAccessResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportAccessResultBuilder();
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


