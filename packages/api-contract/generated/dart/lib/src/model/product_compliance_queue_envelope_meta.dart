//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_compliance_queue_envelope_meta.g.dart';

/// ProductComplianceQueueEnvelopeMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
/// * [total]
/// * [counts] - Full totals by submission status, including ALL, after path, reference result and date filters but before status selection and pagination.
@BuiltValue()
abstract class ProductComplianceQueueEnvelopeMeta implements Built<ProductComplianceQueueEnvelopeMeta, ProductComplianceQueueEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  /// Full totals by submission status, including ALL, after path, reference result and date filters but before status selection and pagination.
  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int> get counts;

  ProductComplianceQueueEnvelopeMeta._();

  factory ProductComplianceQueueEnvelopeMeta([void updates(ProductComplianceQueueEnvelopeMetaBuilder b)]) = _$ProductComplianceQueueEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductComplianceQueueEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductComplianceQueueEnvelopeMeta> get serializer => _$ProductComplianceQueueEnvelopeMetaSerializer();
}

class _$ProductComplianceQueueEnvelopeMetaSerializer implements PrimitiveSerializer<ProductComplianceQueueEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [ProductComplianceQueueEnvelopeMeta, _$ProductComplianceQueueEnvelopeMeta];

  @override
  final String wireName = r'ProductComplianceQueueEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductComplianceQueueEnvelopeMeta object, {
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
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductComplianceQueueEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductComplianceQueueEnvelopeMetaBuilder result,
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
  ProductComplianceQueueEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductComplianceQueueEnvelopeMetaBuilder();
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


