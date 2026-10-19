//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/project_candidate.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_compiled_estimate.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_estimate_page.g.dart';

/// ProjectEstimatePage
///
/// Properties:
/// * [estimate]
/// * [items]
/// * [page]
/// * [hasMore]
/// * [total]
/// * [unfilteredTotal] - Candidates in this estimate before filters.
/// * [sort]
/// * [direction] - The direction applied, ASC or DESC; null for BEST_MATCH.
@BuiltValue()
abstract class ProjectEstimatePage implements Built<ProjectEstimatePage, ProjectEstimatePageBuilder> {
  @BuiltValueField(wireName: r'estimate')
  ProjectCompiledEstimate? get estimate;

  @BuiltValueField(wireName: r'items')
  BuiltList<ProjectCandidate> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'total')
  int get total;

  /// Candidates in this estimate before filters.
  @BuiltValueField(wireName: r'unfiltered_total')
  int? get unfilteredTotal;

  @BuiltValueField(wireName: r'sort')
  String? get sort;

  /// The direction applied, ASC or DESC; null for BEST_MATCH.
  @BuiltValueField(wireName: r'direction')
  String? get direction;

  ProjectEstimatePage._();

  factory ProjectEstimatePage([void updates(ProjectEstimatePageBuilder b)]) = _$ProjectEstimatePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectEstimatePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectEstimatePage> get serializer => _$ProjectEstimatePageSerializer();
}

class _$ProjectEstimatePageSerializer implements PrimitiveSerializer<ProjectEstimatePage> {
  @override
  final Iterable<Type> types = const [ProjectEstimatePage, _$ProjectEstimatePage];

  @override
  final String wireName = r'ProjectEstimatePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectEstimatePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.estimate != null) {
      yield r'estimate';
      yield serializers.serialize(
        object.estimate,
        specifiedType: const FullType(ProjectCompiledEstimate),
      );
    }
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ProjectCandidate)]),
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
    if (object.unfilteredTotal != null) {
      yield r'unfiltered_total';
      yield serializers.serialize(
        object.unfilteredTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.sort != null) {
      yield r'sort';
      yield serializers.serialize(
        object.sort,
        specifiedType: const FullType(String),
      );
    }
    if (object.direction != null) {
      yield r'direction';
      yield serializers.serialize(
        object.direction,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectEstimatePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectEstimatePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(BuiltList, [FullType(ProjectCandidate)]),
          ) as BuiltList<ProjectCandidate>;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.unfilteredTotal = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sort = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.direction = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectEstimatePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectEstimatePageBuilder();
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


