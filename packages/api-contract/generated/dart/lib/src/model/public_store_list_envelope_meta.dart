//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_store_list_envelope_meta.g.dart';

/// PublicStoreListEnvelopeMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
/// * [total]
@BuiltValue()
abstract class PublicStoreListEnvelopeMeta implements Built<PublicStoreListEnvelopeMeta, PublicStoreListEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  PublicStoreListEnvelopeMeta._();

  factory PublicStoreListEnvelopeMeta([void updates(PublicStoreListEnvelopeMetaBuilder b)]) = _$PublicStoreListEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicStoreListEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicStoreListEnvelopeMeta> get serializer => _$PublicStoreListEnvelopeMetaSerializer();
}

class _$PublicStoreListEnvelopeMetaSerializer implements PrimitiveSerializer<PublicStoreListEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [PublicStoreListEnvelopeMeta, _$PublicStoreListEnvelopeMeta];

  @override
  final String wireName = r'PublicStoreListEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicStoreListEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current_page';
    yield serializers.serialize(
      object.currentPage,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicStoreListEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicStoreListEnvelopeMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentPage = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicStoreListEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicStoreListEnvelopeMetaBuilder();
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


