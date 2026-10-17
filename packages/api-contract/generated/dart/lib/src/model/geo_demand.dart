//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_scope.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/geo_demand_rows_inner.dart';
import 'package:materyalph_api_client/src/model/geo_demand_columns_inner.dart';
import 'package:materyalph_api_client/src/model/geo_dataset.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_demand.g.dart';

/// GeoDemand
///
/// Properties:
/// * [scope]
/// * [dataset]
/// * [measure]
/// * [unit]
/// * [dimension]
/// * [columns]
/// * [rows]
/// * [notComparableLines]
/// * [definition]
@BuiltValue()
abstract class GeoDemand implements Built<GeoDemand, GeoDemandBuilder> {
  @BuiltValueField(wireName: r'scope')
  GeoScope get scope;

  @BuiltValueField(wireName: r'dataset')
  GeoDataset get dataset;

  @BuiltValueField(wireName: r'measure')
  GeoDemandMeasureEnum get measure;
  // enum measureEnum {  ORDER_COUNT,  QUANTITY,  VALUE,  };

  @BuiltValueField(wireName: r'unit')
  String? get unit;

  @BuiltValueField(wireName: r'dimension')
  GeoDemandDimensionEnum get dimension;
  // enum dimensionEnum {  CATEGORY,  MATERIAL,  };

  @BuiltValueField(wireName: r'columns')
  BuiltList<GeoDemandColumnsInner> get columns;

  @BuiltValueField(wireName: r'rows')
  BuiltList<GeoDemandRowsInner> get rows;

  @BuiltValueField(wireName: r'not_comparable_lines')
  int get notComparableLines;

  @BuiltValueField(wireName: r'definition')
  String get definition;

  GeoDemand._();

  factory GeoDemand([void updates(GeoDemandBuilder b)]) = _$GeoDemand;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDemandBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDemand> get serializer => _$GeoDemandSerializer();
}

class _$GeoDemandSerializer implements PrimitiveSerializer<GeoDemand> {
  @override
  final Iterable<Type> types = const [GeoDemand, _$GeoDemand];

  @override
  final String wireName = r'GeoDemand';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDemand object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(GeoScope),
    );
    yield r'dataset';
    yield serializers.serialize(
      object.dataset,
      specifiedType: const FullType(GeoDataset),
    );
    yield r'measure';
    yield serializers.serialize(
      object.measure,
      specifiedType: const FullType(GeoDemandMeasureEnum),
    );
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'dimension';
    yield serializers.serialize(
      object.dimension,
      specifiedType: const FullType(GeoDemandDimensionEnum),
    );
    yield r'columns';
    yield serializers.serialize(
      object.columns,
      specifiedType: const FullType(BuiltList, [FullType(GeoDemandColumnsInner)]),
    );
    yield r'rows';
    yield serializers.serialize(
      object.rows,
      specifiedType: const FullType(BuiltList, [FullType(GeoDemandRowsInner)]),
    );
    yield r'not_comparable_lines';
    yield serializers.serialize(
      object.notComparableLines,
      specifiedType: const FullType(int),
    );
    yield r'definition';
    yield serializers.serialize(
      object.definition,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDemand object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDemandBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoScope),
          ) as GeoScope;
          result.scope.replace(valueDes);
          break;
        case r'dataset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDataset),
          ) as GeoDataset;
          result.dataset.replace(valueDes);
          break;
        case r'measure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDemandMeasureEnum),
          ) as GeoDemandMeasureEnum;
          result.measure = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unit = valueDes;
          break;
        case r'dimension':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDemandDimensionEnum),
          ) as GeoDemandDimensionEnum;
          result.dimension = valueDes;
          break;
        case r'columns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoDemandColumnsInner)]),
          ) as BuiltList<GeoDemandColumnsInner>;
          result.columns.replace(valueDes);
          break;
        case r'rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoDemandRowsInner)]),
          ) as BuiltList<GeoDemandRowsInner>;
          result.rows.replace(valueDes);
          break;
        case r'not_comparable_lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.notComparableLines = valueDes;
          break;
        case r'definition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.definition = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDemand deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDemandBuilder();
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


class GeoDemandMeasureEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER_COUNT')
  static const GeoDemandMeasureEnum ORDER_COUNT = _$geoDemandMeasureEnum_ORDER_COUNT;
  @BuiltValueEnumConst(wireName: r'QUANTITY')
  static const GeoDemandMeasureEnum QUANTITY = _$geoDemandMeasureEnum_QUANTITY;
  @BuiltValueEnumConst(wireName: r'VALUE')
  static const GeoDemandMeasureEnum VALUE = _$geoDemandMeasureEnum_VALUE;

  static Serializer<GeoDemandMeasureEnum> get serializer => _$geoDemandMeasureEnumSerializer;

  const GeoDemandMeasureEnum._(String name): super(name);

  static BuiltSet<GeoDemandMeasureEnum> get values => _$geoDemandMeasureEnumValues;
  static GeoDemandMeasureEnum valueOf(String name) => _$geoDemandMeasureEnumValueOf(name);
}

class GeoDemandDimensionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CATEGORY')
  static const GeoDemandDimensionEnum CATEGORY = _$geoDemandDimensionEnum_CATEGORY;
  @BuiltValueEnumConst(wireName: r'MATERIAL')
  static const GeoDemandDimensionEnum MATERIAL = _$geoDemandDimensionEnum_MATERIAL;

  static Serializer<GeoDemandDimensionEnum> get serializer => _$geoDemandDimensionEnumSerializer;

  const GeoDemandDimensionEnum._(String name): super(name);

  static BuiltSet<GeoDemandDimensionEnum> get values => _$geoDemandDimensionEnumValues;
  static GeoDemandDimensionEnum valueOf(String name) => _$geoDemandDimensionEnumValueOf(name);
}

