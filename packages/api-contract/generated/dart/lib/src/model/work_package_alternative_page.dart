//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/work_package_alternative_page_excluded.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/work_package_alternative.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_alternative_page.g.dart';

/// WorkPackageAlternativePage
///
/// Properties:
/// * [line]
/// * [status] - NO_SUITABLE_ALTERNATIVE: no eligible store within the radius can supply the quantity still needed (see `excluded`). COVERED: separate purchases already satisfy the line. A failed request is an error response, never one of these.
/// * [neededQuantity] - The quantity still to source: the compared Vendor's gap less the separate purchases that satisfy the line (the full line quantity when no `candidate_id` is sent).
/// * [excluded]
/// * [locationId] - The Project site's saved location, for display only. The server scopes the purchase from the package's locked site point.
/// * [radiusKm] - The fixed Project-Based radius.
/// * [items]
/// * [page]
/// * [hasMore]
/// * [total]
@BuiltValue()
abstract class WorkPackageAlternativePage implements Built<WorkPackageAlternativePage, WorkPackageAlternativePageBuilder> {
  @BuiltValueField(wireName: r'line')
  BuiltMap<String, JsonObject?> get line;

  /// NO_SUITABLE_ALTERNATIVE: no eligible store within the radius can supply the quantity still needed (see `excluded`). COVERED: separate purchases already satisfy the line. A failed request is an error response, never one of these.
  @BuiltValueField(wireName: r'status')
  WorkPackageAlternativePageStatusEnum get status;
  // enum statusEnum {  CATALOG,  NO_SUITABLE_ALTERNATIVE,  COVERED,  UNLISTED,  };

  /// The quantity still to source: the compared Vendor's gap less the separate purchases that satisfy the line (the full line quantity when no `candidate_id` is sent).
  @BuiltValueField(wireName: r'needed_quantity')
  String get neededQuantity;

  @BuiltValueField(wireName: r'excluded')
  WorkPackageAlternativePageExcluded get excluded;

  /// The Project site's saved location, for display only. The server scopes the purchase from the package's locked site point.
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  /// The fixed Project-Based radius.
  @BuiltValueField(wireName: r'radius_km')
  WorkPackageAlternativePageRadiusKmEnum get radiusKm;
  // enum radiusKmEnum {  50,  };

  @BuiltValueField(wireName: r'items')
  BuiltList<WorkPackageAlternative> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'total')
  int get total;

  WorkPackageAlternativePage._();

  factory WorkPackageAlternativePage([void updates(WorkPackageAlternativePageBuilder b)]) = _$WorkPackageAlternativePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageAlternativePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageAlternativePage> get serializer => _$WorkPackageAlternativePageSerializer();
}

class _$WorkPackageAlternativePageSerializer implements PrimitiveSerializer<WorkPackageAlternativePage> {
  @override
  final Iterable<Type> types = const [WorkPackageAlternativePage, _$WorkPackageAlternativePage];

  @override
  final String wireName = r'WorkPackageAlternativePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageAlternativePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line';
    yield serializers.serialize(
      object.line,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WorkPackageAlternativePageStatusEnum),
    );
    yield r'needed_quantity';
    yield serializers.serialize(
      object.neededQuantity,
      specifiedType: const FullType(String),
    );
    yield r'excluded';
    yield serializers.serialize(
      object.excluded,
      specifiedType: const FullType(WorkPackageAlternativePageExcluded),
    );
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType(String),
      );
    }
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(WorkPackageAlternativePageRadiusKmEnum),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageAlternative)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageAlternativePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageAlternativePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.line.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageAlternativePageStatusEnum),
          ) as WorkPackageAlternativePageStatusEnum;
          result.status = valueDes;
          break;
        case r'needed_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.neededQuantity = valueDes;
          break;
        case r'excluded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageAlternativePageExcluded),
          ) as WorkPackageAlternativePageExcluded;
          result.excluded.replace(valueDes);
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageAlternativePageRadiusKmEnum),
          ) as WorkPackageAlternativePageRadiusKmEnum;
          result.radiusKm = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageAlternative)]),
          ) as BuiltList<WorkPackageAlternative>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageAlternativePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageAlternativePageBuilder();
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


/// NO_SUITABLE_ALTERNATIVE: no eligible store within the radius can supply the quantity still needed (see `excluded`). COVERED: separate purchases already satisfy the line. A failed request is an error response, never one of these.
class WorkPackageAlternativePageStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CATALOG')
  static const WorkPackageAlternativePageStatusEnum CATALOG = _$workPackageAlternativePageStatusEnum_CATALOG;
  @BuiltValueEnumConst(wireName: r'NO_SUITABLE_ALTERNATIVE')
  static const WorkPackageAlternativePageStatusEnum NO_SUITABLE_ALTERNATIVE = _$workPackageAlternativePageStatusEnum_NO_SUITABLE_ALTERNATIVE;
  @BuiltValueEnumConst(wireName: r'COVERED')
  static const WorkPackageAlternativePageStatusEnum COVERED = _$workPackageAlternativePageStatusEnum_COVERED;
  @BuiltValueEnumConst(wireName: r'UNLISTED')
  static const WorkPackageAlternativePageStatusEnum UNLISTED = _$workPackageAlternativePageStatusEnum_UNLISTED;

  static Serializer<WorkPackageAlternativePageStatusEnum> get serializer => _$workPackageAlternativePageStatusEnumSerializer;

  const WorkPackageAlternativePageStatusEnum._(String name): super(name);

  static BuiltSet<WorkPackageAlternativePageStatusEnum> get values => _$workPackageAlternativePageStatusEnumValues;
  static WorkPackageAlternativePageStatusEnum valueOf(String name) => _$workPackageAlternativePageStatusEnumValueOf(name);
}

/// The fixed Project-Based radius.
class WorkPackageAlternativePageRadiusKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 50)
  static const WorkPackageAlternativePageRadiusKmEnum number50 = _$workPackageAlternativePageRadiusKmEnum_number50;

  static Serializer<WorkPackageAlternativePageRadiusKmEnum> get serializer => _$workPackageAlternativePageRadiusKmEnumSerializer;

  const WorkPackageAlternativePageRadiusKmEnum._(String name): super(name);

  static BuiltSet<WorkPackageAlternativePageRadiusKmEnum> get values => _$workPackageAlternativePageRadiusKmEnumValues;
  static WorkPackageAlternativePageRadiusKmEnum valueOf(String name) => _$workPackageAlternativePageRadiusKmEnumValueOf(name);
}

