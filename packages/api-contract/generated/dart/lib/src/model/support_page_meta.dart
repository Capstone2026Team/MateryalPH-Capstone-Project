//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_page_meta.g.dart';

/// SupportPageMeta
///
/// Properties:
/// * [nextCursor]
/// * [correlationId]
@BuiltValue()
abstract class SupportPageMeta implements Built<SupportPageMeta, SupportPageMetaBuilder> {
  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'correlation_id')
  String? get correlationId;

  SupportPageMeta._();

  factory SupportPageMeta([void updates(SupportPageMetaBuilder b)]) = _$SupportPageMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportPageMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportPageMeta> get serializer => _$SupportPageMetaSerializer();
}

class _$SupportPageMetaSerializer implements PrimitiveSerializer<SupportPageMeta> {
  @override
  final Iterable<Type> types = const [SupportPageMeta, _$SupportPageMeta];

  @override
  final String wireName = r'SupportPageMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportPageMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'next_cursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
    if (object.correlationId != null) {
      yield r'correlation_id';
      yield serializers.serialize(
        object.correlationId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportPageMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportPageMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportPageMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportPageMetaBuilder();
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


