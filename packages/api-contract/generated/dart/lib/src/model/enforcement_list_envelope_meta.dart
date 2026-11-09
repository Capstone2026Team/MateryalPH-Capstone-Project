//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_list_envelope_meta.g.dart';

/// EnforcementListEnvelopeMeta
///
/// Properties:
/// * [page]
/// * [perPage]
/// * [total]
/// * [hasMore]
/// * [counts] - Full totals by enforcement state after subject, action, source and date filters but before state selection and pagination. Includes zeroes for empty states.
@BuiltValue()
abstract class EnforcementListEnvelopeMeta implements Built<EnforcementListEnvelopeMeta, EnforcementListEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  /// Full totals by enforcement state after subject, action, source and date filters but before state selection and pagination. Includes zeroes for empty states.
  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int> get counts;

  EnforcementListEnvelopeMeta._();

  factory EnforcementListEnvelopeMeta([void updates(EnforcementListEnvelopeMetaBuilder b)]) = _$EnforcementListEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementListEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementListEnvelopeMeta> get serializer => _$EnforcementListEnvelopeMetaSerializer();
}

class _$EnforcementListEnvelopeMetaSerializer implements PrimitiveSerializer<EnforcementListEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [EnforcementListEnvelopeMeta, _$EnforcementListEnvelopeMeta];

  @override
  final String wireName = r'EnforcementListEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementListEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementListEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementListEnvelopeMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.counts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementListEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementListEnvelopeMetaBuilder();
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


