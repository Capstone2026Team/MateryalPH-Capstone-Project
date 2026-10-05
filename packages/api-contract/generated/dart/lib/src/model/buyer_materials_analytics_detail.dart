//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dataset_label.dart';
import 'package:materyalph_api_client/src/model/analytics_snapshot_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_window.dart';
import 'package:materyalph_api_client/src/model/buyer_materials_analytics_detail_group.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_point.dart';
import 'package:materyalph_api_client/src/model/comparable_variant.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_materials_analytics_detail.g.dart';

/// BuyerMaterialsAnalyticsDetail
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
/// * [group]
/// * [variants]
/// * [series]
@BuiltValue()
abstract class BuyerMaterialsAnalyticsDetail implements Built<BuyerMaterialsAnalyticsDetail, BuyerMaterialsAnalyticsDetailBuilder> {
  @BuiltValueField(wireName: r'audience')
  BuyerMaterialsAnalyticsDetailAudienceEnum get audience;
  // enum audienceEnum {  BUYER,  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'scope')
  BuiltMap<String, JsonObject?> get scope;

  @BuiltValueField(wireName: r'source_kind')
  BuyerMaterialsAnalyticsDetailSourceKindEnum get sourceKind;
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

  @BuiltValueField(wireName: r'group')
  BuyerMaterialsAnalyticsDetailGroup get group;

  @BuiltValueField(wireName: r'variants')
  BuiltList<ComparableVariant> get variants;

  @BuiltValueField(wireName: r'series')
  BuiltList<BuyerAnalyticsPoint> get series;

  BuyerMaterialsAnalyticsDetail._();

  factory BuyerMaterialsAnalyticsDetail([void updates(BuyerMaterialsAnalyticsDetailBuilder b)]) = _$BuyerMaterialsAnalyticsDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMaterialsAnalyticsDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMaterialsAnalyticsDetail> get serializer => _$BuyerMaterialsAnalyticsDetailSerializer();
}

class _$BuyerMaterialsAnalyticsDetailSerializer implements PrimitiveSerializer<BuyerMaterialsAnalyticsDetail> {
  @override
  final Iterable<Type> types = const [BuyerMaterialsAnalyticsDetail, _$BuyerMaterialsAnalyticsDetail];

  @override
  final String wireName = r'BuyerMaterialsAnalyticsDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMaterialsAnalyticsDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(BuyerMaterialsAnalyticsDetailAudienceEnum),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'source_kind';
    yield serializers.serialize(
      object.sourceKind,
      specifiedType: const FullType(BuyerMaterialsAnalyticsDetailSourceKindEnum),
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
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(BuyerMaterialsAnalyticsDetailGroup),
    );
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(BuiltList, [FullType(ComparableVariant)]),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsPoint)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMaterialsAnalyticsDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMaterialsAnalyticsDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMaterialsAnalyticsDetailAudienceEnum),
          ) as BuyerMaterialsAnalyticsDetailAudienceEnum;
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
            specifiedType: const FullType(BuyerMaterialsAnalyticsDetailSourceKindEnum),
          ) as BuyerMaterialsAnalyticsDetailSourceKindEnum;
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
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMaterialsAnalyticsDetailGroup),
          ) as BuyerMaterialsAnalyticsDetailGroup;
          result.group.replace(valueDes);
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ComparableVariant)]),
          ) as BuiltList<ComparableVariant>;
          result.variants.replace(valueDes);
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsPoint)]),
          ) as BuiltList<BuyerAnalyticsPoint>;
          result.series.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMaterialsAnalyticsDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMaterialsAnalyticsDetailBuilder();
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


class BuyerMaterialsAnalyticsDetailAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const BuyerMaterialsAnalyticsDetailAudienceEnum BUYER = _$buyerMaterialsAnalyticsDetailAudienceEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const BuyerMaterialsAnalyticsDetailAudienceEnum VENDOR = _$buyerMaterialsAnalyticsDetailAudienceEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const BuyerMaterialsAnalyticsDetailAudienceEnum ADMIN = _$buyerMaterialsAnalyticsDetailAudienceEnum_ADMIN;

  static Serializer<BuyerMaterialsAnalyticsDetailAudienceEnum> get serializer => _$buyerMaterialsAnalyticsDetailAudienceEnumSerializer;

  const BuyerMaterialsAnalyticsDetailAudienceEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsDetailAudienceEnum> get values => _$buyerMaterialsAnalyticsDetailAudienceEnumValues;
  static BuyerMaterialsAnalyticsDetailAudienceEnum valueOf(String name) => _$buyerMaterialsAnalyticsDetailAudienceEnumValueOf(name);
}

class BuyerMaterialsAnalyticsDetailSourceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC_LISTING')
  static const BuyerMaterialsAnalyticsDetailSourceKindEnum PUBLIC_LISTING = _$buyerMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING;

  static Serializer<BuyerMaterialsAnalyticsDetailSourceKindEnum> get serializer => _$buyerMaterialsAnalyticsDetailSourceKindEnumSerializer;

  const BuyerMaterialsAnalyticsDetailSourceKindEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsDetailSourceKindEnum> get values => _$buyerMaterialsAnalyticsDetailSourceKindEnumValues;
  static BuyerMaterialsAnalyticsDetailSourceKindEnum valueOf(String name) => _$buyerMaterialsAnalyticsDetailSourceKindEnumValueOf(name);
}

