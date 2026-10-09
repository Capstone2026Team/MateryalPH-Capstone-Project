//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'geo_demand_cell_value.g.dart';

/// GeoDemandCellValue
@BuiltValue()
abstract class GeoDemandCellValue implements Built<GeoDemandCellValue, GeoDemandCellValueBuilder> {
  /// One Of [String], [int]
  OneOf get oneOf;

  GeoDemandCellValue._();

  factory GeoDemandCellValue([void updates(GeoDemandCellValueBuilder b)]) = _$GeoDemandCellValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDemandCellValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDemandCellValue> get serializer => _$GeoDemandCellValueSerializer();
}

class _$GeoDemandCellValueSerializer implements PrimitiveSerializer<GeoDemandCellValue> {
  @override
  final Iterable<Type> types = const [GeoDemandCellValue, _$GeoDemandCellValue];

  @override
  final String wireName = r'GeoDemandCellValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDemandCellValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDemandCellValue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  GeoDemandCellValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDemandCellValueBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(int), FullType(String), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


