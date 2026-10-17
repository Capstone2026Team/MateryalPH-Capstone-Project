//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_cell.g.dart';

/// A person-derived value; null with a reason when suppressed under the small-cell rule.
///
/// Properties:
/// * [value]
/// * [suppressed]
/// * [reason]
@BuiltValue()
abstract class GeoCell implements Built<GeoCell, GeoCellBuilder> {
  @BuiltValueField(wireName: r'value')
  int? get value;

  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  GeoCell._();

  factory GeoCell([void updates(GeoCellBuilder b)]) = _$GeoCell;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoCellBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoCell> get serializer => _$GeoCellSerializer();
}

class _$GeoCellSerializer implements PrimitiveSerializer<GeoCell> {
  @override
  final Iterable<Type> types = const [GeoCell, _$GeoCell];

  @override
  final String wireName = r'GeoCell';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoCell object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.value != null) {
      yield r'value';
      yield serializers.serialize(
        object.value,
        specifiedType: const FullType.nullable(int),
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
    GeoCell object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoCellBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.value = valueDes;
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
  GeoCell deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoCellBuilder();
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


