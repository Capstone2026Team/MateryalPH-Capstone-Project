//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_analytics_product_detail_product.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dataset_label.dart';
import 'package:materyalph_api_client/src/model/analytics_snapshot_ref.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_product_variant.dart';
import 'package:materyalph_api_client/src/model/analytics_window.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_featured_variant.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_product_detail.g.dart';

/// BuyerAnalyticsProductDetail
///
/// Properties:
/// * [audience]
/// * [scope]
/// * [sourceKind]
/// * [dataset]
/// * [window]
/// * [currentAsOf]
/// * [snapshot]
/// * [updateSchedule]
/// * [explanation]
/// * [product]
/// * [featured]
/// * [variants]
@BuiltValue()
abstract class BuyerAnalyticsProductDetail implements Built<BuyerAnalyticsProductDetail, BuyerAnalyticsProductDetailBuilder> {
  @BuiltValueField(wireName: r'audience')
  BuyerAnalyticsProductDetailAudienceEnum get audience;
  // enum audienceEnum {  BUYER,  };

  @BuiltValueField(wireName: r'scope')
  BuiltMap<String, JsonObject?> get scope;

  @BuiltValueField(wireName: r'source_kind')
  BuyerAnalyticsProductDetailSourceKindEnum get sourceKind;
  // enum sourceKindEnum {  PUBLIC_LISTING,  };

  @BuiltValueField(wireName: r'dataset')
  DatasetLabel get dataset;

  @BuiltValueField(wireName: r'window')
  AnalyticsWindow get window;

  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'snapshot')
  AnalyticsSnapshotRef? get snapshot;

  @BuiltValueField(wireName: r'update_schedule')
  String get updateSchedule;

  @BuiltValueField(wireName: r'explanation')
  String get explanation;

  @BuiltValueField(wireName: r'product')
  BuyerAnalyticsProductDetailProduct get product;

  @BuiltValueField(wireName: r'featured')
  BuyerAnalyticsFeaturedVariant? get featured;

  @BuiltValueField(wireName: r'variants')
  BuiltList<BuyerAnalyticsProductVariant> get variants;

  BuyerAnalyticsProductDetail._();

  factory BuyerAnalyticsProductDetail([void updates(BuyerAnalyticsProductDetailBuilder b)]) = _$BuyerAnalyticsProductDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsProductDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsProductDetail> get serializer => _$BuyerAnalyticsProductDetailSerializer();
}

class _$BuyerAnalyticsProductDetailSerializer implements PrimitiveSerializer<BuyerAnalyticsProductDetail> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsProductDetail, _$BuyerAnalyticsProductDetail];

  @override
  final String wireName = r'BuyerAnalyticsProductDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsProductDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(BuyerAnalyticsProductDetailAudienceEnum),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'source_kind';
    yield serializers.serialize(
      object.sourceKind,
      specifiedType: const FullType(BuyerAnalyticsProductDetailSourceKindEnum),
    );
    yield r'dataset';
    yield serializers.serialize(
      object.dataset,
      specifiedType: const FullType(DatasetLabel),
    );
    yield r'window';
    yield serializers.serialize(
      object.window,
      specifiedType: const FullType(AnalyticsWindow),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    if (object.snapshot != null) {
      yield r'snapshot';
      yield serializers.serialize(
        object.snapshot,
        specifiedType: const FullType.nullable(AnalyticsSnapshotRef),
      );
    }
    yield r'update_schedule';
    yield serializers.serialize(
      object.updateSchedule,
      specifiedType: const FullType(String),
    );
    yield r'explanation';
    yield serializers.serialize(
      object.explanation,
      specifiedType: const FullType(String),
    );
    yield r'product';
    yield serializers.serialize(
      object.product,
      specifiedType: const FullType(BuyerAnalyticsProductDetailProduct),
    );
    if (object.featured != null) {
      yield r'featured';
      yield serializers.serialize(
        object.featured,
        specifiedType: const FullType.nullable(BuyerAnalyticsFeaturedVariant),
      );
    }
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsProductVariant)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsProductDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsProductDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsProductDetailAudienceEnum),
          ) as BuyerAnalyticsProductDetailAudienceEnum;
          result.audience = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.scope.replace(valueDes);
          break;
        case r'source_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsProductDetailSourceKindEnum),
          ) as BuyerAnalyticsProductDetailSourceKindEnum;
          result.sourceKind = valueDes;
          break;
        case r'dataset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatasetLabel),
          ) as DatasetLabel;
          result.dataset.replace(valueDes);
          break;
        case r'window':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsWindow),
          ) as AnalyticsWindow;
          result.window.replace(valueDes);
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AnalyticsSnapshotRef),
          ) as AnalyticsSnapshotRef?;
          if (valueDes == null) continue;
          result.snapshot.replace(valueDes);
          break;
        case r'update_schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updateSchedule = valueDes;
          break;
        case r'explanation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.explanation = valueDes;
          break;
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsProductDetailProduct),
          ) as BuyerAnalyticsProductDetailProduct;
          result.product.replace(valueDes);
          break;
        case r'featured':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerAnalyticsFeaturedVariant),
          ) as BuyerAnalyticsFeaturedVariant?;
          if (valueDes == null) continue;
          result.featured.replace(valueDes);
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsProductVariant)]),
          ) as BuiltList<BuyerAnalyticsProductVariant>;
          result.variants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAnalyticsProductDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsProductDetailBuilder();
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


class BuyerAnalyticsProductDetailAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const BuyerAnalyticsProductDetailAudienceEnum BUYER = _$buyerAnalyticsProductDetailAudienceEnum_BUYER;

  static Serializer<BuyerAnalyticsProductDetailAudienceEnum> get serializer => _$buyerAnalyticsProductDetailAudienceEnumSerializer;

  const BuyerAnalyticsProductDetailAudienceEnum._(String name): super(name);

  static BuiltSet<BuyerAnalyticsProductDetailAudienceEnum> get values => _$buyerAnalyticsProductDetailAudienceEnumValues;
  static BuyerAnalyticsProductDetailAudienceEnum valueOf(String name) => _$buyerAnalyticsProductDetailAudienceEnumValueOf(name);
}

class BuyerAnalyticsProductDetailSourceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC_LISTING')
  static const BuyerAnalyticsProductDetailSourceKindEnum PUBLIC_LISTING = _$buyerAnalyticsProductDetailSourceKindEnum_PUBLIC_LISTING;

  static Serializer<BuyerAnalyticsProductDetailSourceKindEnum> get serializer => _$buyerAnalyticsProductDetailSourceKindEnumSerializer;

  const BuyerAnalyticsProductDetailSourceKindEnum._(String name): super(name);

  static BuiltSet<BuyerAnalyticsProductDetailSourceKindEnum> get values => _$buyerAnalyticsProductDetailSourceKindEnumValues;
  static BuyerAnalyticsProductDetailSourceKindEnum valueOf(String name) => _$buyerAnalyticsProductDetailSourceKindEnumValueOf(name);
}

