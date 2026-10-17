//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_analytics_row.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dataset_label.dart';
import 'package:materyalph_api_client/src/model/analytics_snapshot_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_window.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_materials_analytics_list.g.dart';

/// VendorMaterialsAnalyticsList
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
abstract class VendorMaterialsAnalyticsList implements Built<VendorMaterialsAnalyticsList, VendorMaterialsAnalyticsListBuilder> {
  @BuiltValueField(wireName: r'audience')
  VendorMaterialsAnalyticsListAudienceEnum get audience;
  // enum audienceEnum {  BUYER,  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'scope')
  BuiltMap<String, JsonObject?> get scope;

  @BuiltValueField(wireName: r'source_kind')
  VendorMaterialsAnalyticsListSourceKindEnum get sourceKind;
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
  BuiltList<VendorAnalyticsRow> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  VendorMaterialsAnalyticsList._();

  factory VendorMaterialsAnalyticsList([void updates(VendorMaterialsAnalyticsListBuilder b)]) = _$VendorMaterialsAnalyticsList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorMaterialsAnalyticsListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorMaterialsAnalyticsList> get serializer => _$VendorMaterialsAnalyticsListSerializer();
}

class _$VendorMaterialsAnalyticsListSerializer implements PrimitiveSerializer<VendorMaterialsAnalyticsList> {
  @override
  final Iterable<Type> types = const [VendorMaterialsAnalyticsList, _$VendorMaterialsAnalyticsList];

  @override
  final String wireName = r'VendorMaterialsAnalyticsList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorMaterialsAnalyticsList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(VendorMaterialsAnalyticsListAudienceEnum),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'source_kind';
    yield serializers.serialize(
      object.sourceKind,
      specifiedType: const FullType(VendorMaterialsAnalyticsListSourceKindEnum),
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
      specifiedType: const FullType(BuiltList, [FullType(VendorAnalyticsRow)]),
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
    VendorMaterialsAnalyticsList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorMaterialsAnalyticsListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorMaterialsAnalyticsListAudienceEnum),
          ) as VendorMaterialsAnalyticsListAudienceEnum;
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
            specifiedType: const FullType(VendorMaterialsAnalyticsListSourceKindEnum),
          ) as VendorMaterialsAnalyticsListSourceKindEnum;
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
            specifiedType: const FullType(BuiltList, [FullType(VendorAnalyticsRow)]),
          ) as BuiltList<VendorAnalyticsRow>;
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
  VendorMaterialsAnalyticsList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorMaterialsAnalyticsListBuilder();
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


class VendorMaterialsAnalyticsListAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const VendorMaterialsAnalyticsListAudienceEnum BUYER = _$vendorMaterialsAnalyticsListAudienceEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const VendorMaterialsAnalyticsListAudienceEnum VENDOR = _$vendorMaterialsAnalyticsListAudienceEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const VendorMaterialsAnalyticsListAudienceEnum ADMIN = _$vendorMaterialsAnalyticsListAudienceEnum_ADMIN;

  static Serializer<VendorMaterialsAnalyticsListAudienceEnum> get serializer => _$vendorMaterialsAnalyticsListAudienceEnumSerializer;

  const VendorMaterialsAnalyticsListAudienceEnum._(String name): super(name);

  static BuiltSet<VendorMaterialsAnalyticsListAudienceEnum> get values => _$vendorMaterialsAnalyticsListAudienceEnumValues;
  static VendorMaterialsAnalyticsListAudienceEnum valueOf(String name) => _$vendorMaterialsAnalyticsListAudienceEnumValueOf(name);
}

class VendorMaterialsAnalyticsListSourceKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC_LISTING')
  static const VendorMaterialsAnalyticsListSourceKindEnum PUBLIC_LISTING = _$vendorMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING;

  static Serializer<VendorMaterialsAnalyticsListSourceKindEnum> get serializer => _$vendorMaterialsAnalyticsListSourceKindEnumSerializer;

  const VendorMaterialsAnalyticsListSourceKindEnum._(String name): super(name);

  static BuiltSet<VendorMaterialsAnalyticsListSourceKindEnum> get values => _$vendorMaterialsAnalyticsListSourceKindEnumValues;
  static VendorMaterialsAnalyticsListSourceKindEnum valueOf(String name) => _$vendorMaterialsAnalyticsListSourceKindEnumValueOf(name);
}

