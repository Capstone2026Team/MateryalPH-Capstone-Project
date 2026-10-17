//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/admin_analytics_point.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dataset_label.dart';
import 'package:materyalph_api_client/src/model/analytics_snapshot_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_window.dart';
import 'package:materyalph_api_client/src/model/comparable_variant.dart';
import 'package:materyalph_api_client/src/model/admin_materials_analytics_detail_group.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_materials_analytics_detail.g.dart';

/// AdminMaterialsAnalyticsDetail
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
/// * [canInspectSources]
@BuiltValue()
abstract class AdminMaterialsAnalyticsDetail implements Built<AdminMaterialsAnalyticsDetail, AdminMaterialsAnalyticsDetailBuilder> {
  @BuiltValueField(wireName: r'audience')
  AdminMaterialsAnalyticsDetailAudienceEnum get audience;
  // enum audienceEnum {  BUYER,  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'scope')
  BuiltMap<String, JsonObject?> get scope;

  @BuiltValueField(wireName: r'source_kind')
  AdminMaterialsAnalyticsDetailSourceKindEnum get sourceKind;
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
  AdminMaterialsAnalyticsDetailGroup get group;

  @BuiltValueField(wireName: r'variants')
  BuiltList<ComparableVariant> get variants;

  @BuiltValueField(wireName: r'series')
  BuiltList<AdminAnalyticsPoint> get series;

  @BuiltValueField(wireName: r'can_inspect_sources')
  bool get canInspectSources;

  AdminMaterialsAnalyticsDetail._();

  factory AdminMaterialsAnalyticsDetail([void updates(AdminMaterialsAnalyticsDetailBuilder b)]) = _$AdminMaterialsAnalyticsDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMaterialsAnalyticsDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMaterialsAnalyticsDetail> get serializer => _$AdminMaterialsAnalyticsDetailSerializer();
}

class _$AdminMaterialsAnalyticsDetailSerializer implements PrimitiveSerializer<AdminMaterialsAnalyticsDetail> {
  @override
  final Iterable<Type> types = const [AdminMaterialsAnalyticsDetail, _$AdminMaterialsAnalyticsDetail];

  @override
  final String wireName = r'AdminMaterialsAnalyticsDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMaterialsAnalyticsDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(AdminMaterialsAnalyticsDetailAudienceEnum),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'source_kind';
    yield serializers.serialize(
      object.sourceKind,
      specifiedType: const FullType(AdminMaterialsAnalyticsDetailSourceKindEnum),
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
      specifiedType: const FullType(AdminMaterialsAnalyticsDetailGroup),
    );
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(BuiltList, [FullType(ComparableVariant)]),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(AdminAnalyticsPoint)]),
    );
    yield r'can_inspect_sources';
    yield serializers.serialize(
      object.canInspectSources,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMaterialsAnalyticsDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminMaterialsAnalyticsDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminMaterialsAnalyticsDetailAudienceEnum),
          ) as AdminMaterialsAnalyticsDetailAudienceEnum;
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
            specifiedType: const FullType(AdminMaterialsAnalyticsDetailSourceKindEnum),
          ) as AdminMaterialsAnalyticsDetailSourceKindEnum;
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
            specifiedType: const FullType(AdminMaterialsAnalyticsDetailGroup),
          ) as AdminMaterialsAnalyticsDetailGroup;
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
            specifiedType: const FullType(BuiltList, [FullType(AdminAnalyticsPoint)]),
          ) as BuiltList<AdminAnalyticsPoint>;
          result.series.replace(valueDes);
          break;
        case r'can_inspect_sources':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canInspectSources = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMaterialsAnalyticsDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMaterialsAnalyticsDetailBuilder();
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


class AdminMaterialsAnalyticsDetailAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const AdminMaterialsAnalyticsDetailAudienceEnum BUYER = _$adminMaterialsAnalyticsDetailAudienceEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const AdminMaterialsAnalyticsDetailAudienceEnum VENDOR = _$adminMaterialsAnalyticsDetailAudienceEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const AdminMaterialsAnalyticsDetailAudienceEnum ADMIN = _$adminMaterialsAnalyticsDetailAudienceEnum_ADMIN;

  static Serializer<AdminMaterialsAnalyticsDetailAudienceEnum> get serializer => _$adminMaterialsAnalyticsDetailAudienceEnumSerializer;

  const AdminMaterialsAnalyticsDetailAudienceEnum._(String name): super(name);

  static BuiltSet<AdminMaterialsAnalyticsDetailAudienceEnum> get values => _$adminMaterialsAnalyticsDetailAudienceEnumValues;
  static AdminMaterialsAnalyticsDetailAudienceEnum valueOf(String name) => _$adminMaterialsAnalyticsDetailAudienceEnumValueOf(name);
}

class AdminMaterialsAnalyticsDetailSourceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC_LISTING')
  static const AdminMaterialsAnalyticsDetailSourceKindEnum PUBLIC_LISTING = _$adminMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING;

  static Serializer<AdminMaterialsAnalyticsDetailSourceKindEnum> get serializer => _$adminMaterialsAnalyticsDetailSourceKindEnumSerializer;

  const AdminMaterialsAnalyticsDetailSourceKindEnum._(String name): super(name);

  static BuiltSet<AdminMaterialsAnalyticsDetailSourceKindEnum> get values => _$adminMaterialsAnalyticsDetailSourceKindEnumValues;
  static AdminMaterialsAnalyticsDetailSourceKindEnum valueOf(String name) => _$adminMaterialsAnalyticsDetailSourceKindEnumValueOf(name);
}

