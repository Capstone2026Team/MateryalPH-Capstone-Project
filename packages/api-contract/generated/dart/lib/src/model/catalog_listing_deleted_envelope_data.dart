//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_deleted_envelope_data.g.dart';

/// CatalogListingDeletedEnvelopeData
///
/// Properties:
/// * [id]
/// * [removedAt]
@BuiltValue()
abstract class CatalogListingDeletedEnvelopeData implements Built<CatalogListingDeletedEnvelopeData, CatalogListingDeletedEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'removed_at')
  DateTime get removedAt;

  CatalogListingDeletedEnvelopeData._();

  factory CatalogListingDeletedEnvelopeData([void updates(CatalogListingDeletedEnvelopeDataBuilder b)]) = _$CatalogListingDeletedEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingDeletedEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingDeletedEnvelopeData> get serializer => _$CatalogListingDeletedEnvelopeDataSerializer();
}

class _$CatalogListingDeletedEnvelopeDataSerializer implements PrimitiveSerializer<CatalogListingDeletedEnvelopeData> {
  @override
  final Iterable<Type> types = const [CatalogListingDeletedEnvelopeData, _$CatalogListingDeletedEnvelopeData];

  @override
  final String wireName = r'CatalogListingDeletedEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingDeletedEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'removed_at';
    yield serializers.serialize(
      object.removedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingDeletedEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingDeletedEnvelopeDataBuilder result,
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
        case r'removed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.removedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingDeletedEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingDeletedEnvelopeDataBuilder();
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


