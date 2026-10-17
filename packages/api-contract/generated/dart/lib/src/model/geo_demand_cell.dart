//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_demand_cell_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_demand_cell.g.dart';

/// GeoDemandCell
///
/// Properties:
/// * [column]
/// * [value]
/// * [suppressed]
/// * [reason]
@BuiltValue()
abstract class GeoDemandCell implements Built<GeoDemandCell, GeoDemandCellBuilder> {
  @BuiltValueField(wireName: r'column')
  String get column;

  @BuiltValueField(wireName: r'value')
  GeoDemandCellValue? get value;

  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  GeoDemandCell._();

  factory GeoDemandCell([void updates(GeoDemandCellBuilder b)]) = _$GeoDemandCell;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDemandCellBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDemandCell> get serializer => _$GeoDemandCellSerializer();
}

class _$GeoDemandCellSerializer implements PrimitiveSerializer<GeoDemandCell> {
  @override
  final Iterable<Type> types = const [GeoDemandCell, _$GeoDemandCell];

  @override
  final String wireName = r'GeoDemandCell';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDemandCell object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'column';
    yield serializers.serialize(
      object.column,
      specifiedType: const FullType(String),
    );
    if (object.value != null) {
      yield r'value';
      yield serializers.serialize(
        object.value,
        specifiedType: const FullType.nullable(GeoDemandCellValue),
      );
    }
    yield r'suppressed';
    yield serializers.serialize(
      object.suppressed,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDemandCell object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDemandCellBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'column':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.column = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GeoDemandCellValue),
          ) as GeoDemandCellValue?;
          if (valueDes == null) continue;
          result.value.replace(valueDes);
          break;
        case r'suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.suppressed = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDemandCell deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDemandCellBuilder();
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


