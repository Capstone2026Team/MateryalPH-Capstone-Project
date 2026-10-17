//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/admin_dashboard_area_segment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_areas_unusual_inner.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_areas_recruitment_inner.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_areas_points_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_areas.g.dart';

/// K-Means area segments, DBSCAN unusual areas and recruitment signals over child areas without a suppressed cell.
///
/// Properties:
/// * [childrenLabel]
/// * [considered]
/// * [excludedSuppressed]
/// * [features]
/// * [state]
/// * [reason]
/// * [k]
/// * [silhouette]
/// * [segments]
/// * [unusual]
/// * [recruitment]
/// * [points]
@BuiltValue()
abstract class AdminDashboardAreas implements Built<AdminDashboardAreas, AdminDashboardAreasBuilder> {
  @BuiltValueField(wireName: r'children_label')
  String get childrenLabel;

  @BuiltValueField(wireName: r'considered')
  int get considered;

  @BuiltValueField(wireName: r'excluded_suppressed')
  int get excludedSuppressed;

  @BuiltValueField(wireName: r'features')
  BuiltList<String> get features;

  @BuiltValueField(wireName: r'state')
  AdminDashboardAreasStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'k')
  int? get k;

  @BuiltValueField(wireName: r'silhouette')
  num? get silhouette;

  @BuiltValueField(wireName: r'segments')
  BuiltList<AdminDashboardAreaSegment> get segments;

  @BuiltValueField(wireName: r'unusual')
  BuiltList<AdminDashboardAreasUnusualInner> get unusual;

  @BuiltValueField(wireName: r'recruitment')
  BuiltList<AdminDashboardAreasRecruitmentInner> get recruitment;

  @BuiltValueField(wireName: r'points')
  BuiltList<AdminDashboardAreasPointsInner> get points;

  AdminDashboardAreas._();

  factory AdminDashboardAreas([void updates(AdminDashboardAreasBuilder b)]) = _$AdminDashboardAreas;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardAreasBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardAreas> get serializer => _$AdminDashboardAreasSerializer();
}

class _$AdminDashboardAreasSerializer implements PrimitiveSerializer<AdminDashboardAreas> {
  @override
  final Iterable<Type> types = const [AdminDashboardAreas, _$AdminDashboardAreas];

  @override
  final String wireName = r'AdminDashboardAreas';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardAreas object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'children_label';
    yield serializers.serialize(
      object.childrenLabel,
      specifiedType: const FullType(String),
    );
    yield r'considered';
    yield serializers.serialize(
      object.considered,
      specifiedType: const FullType(int),
    );
    yield r'excluded_suppressed';
    yield serializers.serialize(
      object.excludedSuppressed,
      specifiedType: const FullType(int),
    );
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminDashboardAreasStateEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.k != null) {
      yield r'k';
      yield serializers.serialize(
        object.k,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.silhouette != null) {
      yield r'silhouette';
      yield serializers.serialize(
        object.silhouette,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreaSegment)]),
    );
    yield r'unusual';
    yield serializers.serialize(
      object.unusual,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreasUnusualInner)]),
    );
    yield r'recruitment';
    yield serializers.serialize(
      object.recruitment,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreasRecruitmentInner)]),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreasPointsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardAreas object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardAreasBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'children_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.childrenLabel = valueDes;
          break;
        case r'considered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.considered = valueDes;
          break;
        case r'excluded_suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.excludedSuppressed = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.features.replace(valueDes);
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardAreasStateEnum),
          ) as AdminDashboardAreasStateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'k':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.k = valueDes;
          break;
        case r'silhouette':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.silhouette = valueDes;
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreaSegment)]),
          ) as BuiltList<AdminDashboardAreaSegment>;
          result.segments.replace(valueDes);
          break;
        case r'unusual':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreasUnusualInner)]),
          ) as BuiltList<AdminDashboardAreasUnusualInner>;
          result.unusual.replace(valueDes);
          break;
        case r'recruitment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreasRecruitmentInner)]),
          ) as BuiltList<AdminDashboardAreasRecruitmentInner>;
          result.recruitment.replace(valueDes);
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardAreasPointsInner)]),
          ) as BuiltList<AdminDashboardAreasPointsInner>;
          result.points.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardAreas deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardAreasBuilder();
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


class AdminDashboardAreasStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const AdminDashboardAreasStateEnum OK = _$adminDashboardAreasStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const AdminDashboardAreasStateEnum INSUFFICIENT_DATA = _$adminDashboardAreasStateEnum_INSUFFICIENT_DATA;

  static Serializer<AdminDashboardAreasStateEnum> get serializer => _$adminDashboardAreasStateEnumSerializer;

  const AdminDashboardAreasStateEnum._(String name): super(name);

  static BuiltSet<AdminDashboardAreasStateEnum> get values => _$adminDashboardAreasStateEnumValues;
  static AdminDashboardAreasStateEnum valueOf(String name) => _$adminDashboardAreasStateEnumValueOf(name);
}

