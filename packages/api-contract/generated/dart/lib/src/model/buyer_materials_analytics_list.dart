//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_row.dart';
import 'package:materyalph_api_client/src/model/dataset_label.dart';
import 'package:materyalph_api_client/src/model/analytics_snapshot_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_window.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_materials_analytics_list.g.dart';

/// BuyerMaterialsAnalyticsList
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
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class BuyerMaterialsAnalyticsList implements Built<BuyerMaterialsAnalyticsList, BuyerMaterialsAnalyticsListBuilder> {
  @BuiltValueField(wireName: r'audience')
  BuyerMaterialsAnalyticsListAudienceEnum get audience;
  // enum audienceEnum {  BUYER,  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'scope')
  BuiltMap<String, JsonObject?> get scope;

  @BuiltValueField(wireName: r'source_kind')
  BuyerMaterialsAnalyticsListSourceKindEnum get sourceKind;
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

  @BuiltValueField(wireName: r'items')
  BuiltList<BuyerAnalyticsRow> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  BuyerMaterialsAnalyticsList._();

  factory BuyerMaterialsAnalyticsList([void updates(BuyerMaterialsAnalyticsListBuilder b)]) = _$BuyerMaterialsAnalyticsList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMaterialsAnalyticsListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMaterialsAnalyticsList> get serializer => _$BuyerMaterialsAnalyticsListSerializer();
}

class _$BuyerMaterialsAnalyticsListSerializer implements PrimitiveSerializer<BuyerMaterialsAnalyticsList> {
  @override
  final Iterable<Type> types = const [BuyerMaterialsAnalyticsList, _$BuyerMaterialsAnalyticsList];

  @override
  final String wireName = r'BuyerMaterialsAnalyticsList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMaterialsAnalyticsList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(BuyerMaterialsAnalyticsListAudienceEnum),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'source_kind';
    yield serializers.serialize(
      object.sourceKind,
      specifiedType: const FullType(BuyerMaterialsAnalyticsListSourceKindEnum),
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
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsRow)]),
    );
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMaterialsAnalyticsList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMaterialsAnalyticsListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMaterialsAnalyticsListAudienceEnum),
          ) as BuyerMaterialsAnalyticsListAudienceEnum;
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
            specifiedType: const FullType(BuyerMaterialsAnalyticsListSourceKindEnum),
          ) as BuyerMaterialsAnalyticsListSourceKindEnum;
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
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsRow)]),
          ) as BuiltList<BuyerAnalyticsRow>;
          result.items.replace(valueDes);
          break;
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMaterialsAnalyticsList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMaterialsAnalyticsListBuilder();
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


class BuyerMaterialsAnalyticsListAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const BuyerMaterialsAnalyticsListAudienceEnum BUYER = _$buyerMaterialsAnalyticsListAudienceEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const BuyerMaterialsAnalyticsListAudienceEnum VENDOR = _$buyerMaterialsAnalyticsListAudienceEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const BuyerMaterialsAnalyticsListAudienceEnum ADMIN = _$buyerMaterialsAnalyticsListAudienceEnum_ADMIN;

  static Serializer<BuyerMaterialsAnalyticsListAudienceEnum> get serializer => _$buyerMaterialsAnalyticsListAudienceEnumSerializer;

  const BuyerMaterialsAnalyticsListAudienceEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsListAudienceEnum> get values => _$buyerMaterialsAnalyticsListAudienceEnumValues;
  static BuyerMaterialsAnalyticsListAudienceEnum valueOf(String name) => _$buyerMaterialsAnalyticsListAudienceEnumValueOf(name);
}

class BuyerMaterialsAnalyticsListSourceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC_LISTING')
  static const BuyerMaterialsAnalyticsListSourceKindEnum PUBLIC_LISTING = _$buyerMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING;

  static Serializer<BuyerMaterialsAnalyticsListSourceKindEnum> get serializer => _$buyerMaterialsAnalyticsListSourceKindEnumSerializer;

  const BuyerMaterialsAnalyticsListSourceKindEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsListSourceKindEnum> get values => _$buyerMaterialsAnalyticsListSourceKindEnumValues;
  static BuyerMaterialsAnalyticsListSourceKindEnum valueOf(String name) => _$buyerMaterialsAnalyticsListSourceKindEnumValueOf(name);
}

