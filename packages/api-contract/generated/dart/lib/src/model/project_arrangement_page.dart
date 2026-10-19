//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_arrangement.dart';
import 'package:materyalph_api_client/src/model/project_compiled_estimate.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement_page.g.dart';

/// ProjectArrangementPage
///
/// Properties:
/// * [sort]
/// * [estimate]
/// * [items]
/// * [page]
/// * [hasMore]
/// * [total]
/// * [unfilteredTotal]
@BuiltValue()
abstract class ProjectArrangementPage implements Built<ProjectArrangementPage, ProjectArrangementPageBuilder> {
  @BuiltValueField(wireName: r'sort')
  ProjectArrangementPageSortEnum? get sort;
  // enum sortEnum {  BEST_MATCH,  PRICE,  };

  @BuiltValueField(wireName: r'estimate')
  ProjectCompiledEstimate? get estimate;

  @BuiltValueField(wireName: r'items')
  BuiltList<ProjectArrangement> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'unfiltered_total')
  int get unfilteredTotal;

  ProjectArrangementPage._();

  factory ProjectArrangementPage([void updates(ProjectArrangementPageBuilder b)]) = _$ProjectArrangementPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangementPage> get serializer => _$ProjectArrangementPageSerializer();
}

class _$ProjectArrangementPageSerializer implements PrimitiveSerializer<ProjectArrangementPage> {
  @override
  final Iterable<Type> types = const [ProjectArrangementPage, _$ProjectArrangementPage];

  @override
  final String wireName = r'ProjectArrangementPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangementPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.sort != null) {
      yield r'sort';
      yield serializers.serialize(
        object.sort,
        specifiedType: const FullType(ProjectArrangementPageSortEnum),
      );
    }
    if (object.estimate != null) {
      yield r'estimate';
      yield serializers.serialize(
        object.estimate,
        specifiedType: const FullType.nullable(ProjectCompiledEstimate),
      );
    }
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ProjectArrangement)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'unfiltered_total';
    yield serializers.serialize(
      object.unfilteredTotal,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangementPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectArrangementPageSortEnum),
          ) as ProjectArrangementPageSortEnum?;
          if (valueDes == null) continue;
          result.sort = valueDes;
          break;
        case r'estimate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectCompiledEstimate),
          ) as ProjectCompiledEstimate?;
          if (valueDes == null) continue;
          result.estimate.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectArrangement)]),
          ) as BuiltList<ProjectArrangement>;
          result.items.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'unfiltered_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unfilteredTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangementPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementPageBuilder();
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


class ProjectArrangementPageSortEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BEST_MATCH')
  static const ProjectArrangementPageSortEnum BEST_MATCH = _$projectArrangementPageSortEnum_BEST_MATCH;
  @BuiltValueEnumConst(wireName: r'PRICE')
  static const ProjectArrangementPageSortEnum PRICE = _$projectArrangementPageSortEnum_PRICE;

  static Serializer<ProjectArrangementPageSortEnum> get serializer => _$projectArrangementPageSortEnumSerializer;

  const ProjectArrangementPageSortEnum._(String name): super(name);

  static BuiltSet<ProjectArrangementPageSortEnum> get values => _$projectArrangementPageSortEnumValues;
  static ProjectArrangementPageSortEnum valueOf(String name) => _$projectArrangementPageSortEnumValueOf(name);
}

