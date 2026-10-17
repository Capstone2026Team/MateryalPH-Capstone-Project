//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_suggestion.g.dart';

/// A planning suggestion from data-derived comparisons with the store’s own products or a level the Vendor set. It changes nothing by itself.
///
/// Properties:
/// * [key]
/// * [kind]
/// * [priority]
/// * [title]
/// * [detail]
/// * [technique]
/// * [href]
/// * [listingId]
/// * [product]
@BuiltValue()
abstract class ProductAnalyticsSuggestion implements Built<ProductAnalyticsSuggestion, ProductAnalyticsSuggestionBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'kind')
  ProductAnalyticsSuggestionKindEnum get kind;
  // enum kindEnum {  RESTOCK_VIEWED,  REORDER_SOON,  LOW_CONVERSION,  CONVERTS_WHEN_FOUND,  BUNDLE,  NOT_VIEWED,  VIEWS_RISING,  VIEWS_FALLING,  };

  @BuiltValueField(wireName: r'priority')
  ProductAnalyticsSuggestionPriorityEnum get priority;
  // enum priorityEnum {  HIGH,  MEDIUM,  LOW,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'detail')
  String get detail;

  @BuiltValueField(wireName: r'technique')
  String get technique;

  @BuiltValueField(wireName: r'href')
  String get href;

  @BuiltValueField(wireName: r'listing_id')
  String? get listingId;

  @BuiltValueField(wireName: r'product')
  String? get product;

  ProductAnalyticsSuggestion._();

  factory ProductAnalyticsSuggestion([void updates(ProductAnalyticsSuggestionBuilder b)]) = _$ProductAnalyticsSuggestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsSuggestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsSuggestion> get serializer => _$ProductAnalyticsSuggestionSerializer();
}

class _$ProductAnalyticsSuggestionSerializer implements PrimitiveSerializer<ProductAnalyticsSuggestion> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsSuggestion, _$ProductAnalyticsSuggestion];

  @override
  final String wireName = r'ProductAnalyticsSuggestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ProductAnalyticsSuggestionKindEnum),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(ProductAnalyticsSuggestionPriorityEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'detail';
    yield serializers.serialize(
      object.detail,
      specifiedType: const FullType(String),
    );
    yield r'technique';
    yield serializers.serialize(
      object.technique,
      specifiedType: const FullType(String),
    );
    yield r'href';
    yield serializers.serialize(
      object.href,
      specifiedType: const FullType(String),
    );
    if (object.listingId != null) {
      yield r'listing_id';
      yield serializers.serialize(
        object.listingId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.product != null) {
      yield r'product';
      yield serializers.serialize(
        object.product,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsSuggestionBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsSuggestionKindEnum),
          ) as ProductAnalyticsSuggestionKindEnum;
          result.kind = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsSuggestionPriorityEnum),
          ) as ProductAnalyticsSuggestionPriorityEnum;
          result.priority = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.detail = valueDes;
          break;
        case r'technique':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.technique = valueDes;
          break;
        case r'href':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.href = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingId = valueDes;
          break;
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.product = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsSuggestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsSuggestionBuilder();
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


class ProductAnalyticsSuggestionKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESTOCK_VIEWED')
  static const ProductAnalyticsSuggestionKindEnum RESTOCK_VIEWED = _$productAnalyticsSuggestionKindEnum_RESTOCK_VIEWED;
  @BuiltValueEnumConst(wireName: r'REORDER_SOON')
  static const ProductAnalyticsSuggestionKindEnum REORDER_SOON = _$productAnalyticsSuggestionKindEnum_REORDER_SOON;
  @BuiltValueEnumConst(wireName: r'LOW_CONVERSION')
  static const ProductAnalyticsSuggestionKindEnum LOW_CONVERSION = _$productAnalyticsSuggestionKindEnum_LOW_CONVERSION;
  @BuiltValueEnumConst(wireName: r'CONVERTS_WHEN_FOUND')
  static const ProductAnalyticsSuggestionKindEnum CONVERTS_WHEN_FOUND = _$productAnalyticsSuggestionKindEnum_CONVERTS_WHEN_FOUND;
  @BuiltValueEnumConst(wireName: r'BUNDLE')
  static const ProductAnalyticsSuggestionKindEnum BUNDLE = _$productAnalyticsSuggestionKindEnum_BUNDLE;
  @BuiltValueEnumConst(wireName: r'NOT_VIEWED')
  static const ProductAnalyticsSuggestionKindEnum NOT_VIEWED = _$productAnalyticsSuggestionKindEnum_NOT_VIEWED;
  @BuiltValueEnumConst(wireName: r'VIEWS_RISING')
  static const ProductAnalyticsSuggestionKindEnum VIEWS_RISING = _$productAnalyticsSuggestionKindEnum_VIEWS_RISING;
  @BuiltValueEnumConst(wireName: r'VIEWS_FALLING')
  static const ProductAnalyticsSuggestionKindEnum VIEWS_FALLING = _$productAnalyticsSuggestionKindEnum_VIEWS_FALLING;

  static Serializer<ProductAnalyticsSuggestionKindEnum> get serializer => _$productAnalyticsSuggestionKindEnumSerializer;

  const ProductAnalyticsSuggestionKindEnum._(String name): super(name);

  static BuiltSet<ProductAnalyticsSuggestionKindEnum> get values => _$productAnalyticsSuggestionKindEnumValues;
  static ProductAnalyticsSuggestionKindEnum valueOf(String name) => _$productAnalyticsSuggestionKindEnumValueOf(name);
}

class ProductAnalyticsSuggestionPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HIGH')
  static const ProductAnalyticsSuggestionPriorityEnum HIGH = _$productAnalyticsSuggestionPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const ProductAnalyticsSuggestionPriorityEnum MEDIUM = _$productAnalyticsSuggestionPriorityEnum_MEDIUM;
  @BuiltValueEnumConst(wireName: r'LOW')
  static const ProductAnalyticsSuggestionPriorityEnum LOW = _$productAnalyticsSuggestionPriorityEnum_LOW;

  static Serializer<ProductAnalyticsSuggestionPriorityEnum> get serializer => _$productAnalyticsSuggestionPriorityEnumSerializer;

  const ProductAnalyticsSuggestionPriorityEnum._(String name): super(name);

  static BuiltSet<ProductAnalyticsSuggestionPriorityEnum> get values => _$productAnalyticsSuggestionPriorityEnumValues;
  static ProductAnalyticsSuggestionPriorityEnum valueOf(String name) => _$productAnalyticsSuggestionPriorityEnumValueOf(name);
}

