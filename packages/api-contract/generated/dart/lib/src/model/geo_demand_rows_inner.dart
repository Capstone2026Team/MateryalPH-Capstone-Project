//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_demand_cell.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_demand_rows_inner.g.dart';

/// GeoDemandRowsInner
///
/// Properties:
/// * [code]
/// * [name]
/// * [level]
/// * [cells]
@BuiltValue()
abstract class GeoDemandRowsInner implements Built<GeoDemandRowsInner, GeoDemandRowsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'level')
  String get level;

  @BuiltValueField(wireName: r'cells')
  BuiltList<GeoDemandCell> get cells;

  GeoDemandRowsInner._();

  factory GeoDemandRowsInner([void updates(GeoDemandRowsInnerBuilder b)]) = _$GeoDemandRowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDemandRowsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDemandRowsInner> get serializer => _$GeoDemandRowsInnerSerializer();
}

class _$GeoDemandRowsInnerSerializer implements PrimitiveSerializer<GeoDemandRowsInner> {
  @override
  final Iterable<Type> types = const [GeoDemandRowsInner, _$GeoDemandRowsInner];

  @override
  final String wireName = r'GeoDemandRowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDemandRowsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(String),
    );
    yield r'cells';
    yield serializers.serialize(
      object.cells,
      specifiedType: const FullType(BuiltList, [FullType(GeoDemandCell)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDemandRowsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDemandRowsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.level = valueDes;
          break;
        case r'cells':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoDemandCell)]),
          ) as BuiltList<GeoDemandCell>;
          result.cells.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDemandRowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDemandRowsInnerBuilder();
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


