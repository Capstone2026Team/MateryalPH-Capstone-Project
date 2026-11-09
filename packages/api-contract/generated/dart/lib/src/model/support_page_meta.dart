//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_page_meta.g.dart';

/// SupportPageMeta
///
/// Properties:
/// * [counts] - Admin ticket lists only. Full totals for all five support statuses after search, category, user type and date filters but before status selection and cursor pagination. Includes zeroes for empty statuses; absent from Buyer, Vendor, history and handler lists.
/// * [nextCursor]
/// * [correlationId]
@BuiltValue()
abstract class SupportPageMeta implements Built<SupportPageMeta, SupportPageMetaBuilder> {
  /// Admin ticket lists only. Full totals for all five support statuses after search, category, user type and date filters but before status selection and cursor pagination. Includes zeroes for empty statuses; absent from Buyer, Vendor, history and handler lists.
  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int>? get counts;

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
    if (object.counts != null) {
      yield r'counts';
      yield serializers.serialize(
        object.counts,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
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
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.counts.replace(valueDes);
          break;
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


