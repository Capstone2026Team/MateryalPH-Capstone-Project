//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/work_package_alternative.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_alternative_page.g.dart';

/// WorkPackageAlternativePage
///
/// Properties:
/// * [line]
/// * [status]
/// * [locationId] - The Project site's saved location; pass it with radius_km when adding to the cart.
/// * [radiusKm]
/// * [items]
/// * [page]
/// * [hasMore]
/// * [total]
@BuiltValue()
abstract class WorkPackageAlternativePage implements Built<WorkPackageAlternativePage, WorkPackageAlternativePageBuilder> {
  @BuiltValueField(wireName: r'line')
  BuiltMap<String, JsonObject?> get line;

  @BuiltValueField(wireName: r'status')
  WorkPackageAlternativePageStatusEnum get status;
  // enum statusEnum {  CATALOG,  UNLISTED,  };

  /// The Project site's saved location; pass it with radius_km when adding to the cart.
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'radius_km')
  int get radiusKm;

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
      specifiedType: const FullType(int),
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
            specifiedType: const FullType(int),
          ) as int;
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


class WorkPackageAlternativePageStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CATALOG')
  static const WorkPackageAlternativePageStatusEnum CATALOG = _$workPackageAlternativePageStatusEnum_CATALOG;
  @BuiltValueEnumConst(wireName: r'UNLISTED')
  static const WorkPackageAlternativePageStatusEnum UNLISTED = _$workPackageAlternativePageStatusEnum_UNLISTED;

  static Serializer<WorkPackageAlternativePageStatusEnum> get serializer => _$workPackageAlternativePageStatusEnumSerializer;

  const WorkPackageAlternativePageStatusEnum._(String name): super(name);

  static BuiltSet<WorkPackageAlternativePageStatusEnum> get values => _$workPackageAlternativePageStatusEnumValues;
  static WorkPackageAlternativePageStatusEnum valueOf(String name) => _$workPackageAlternativePageStatusEnumValueOf(name);
}

