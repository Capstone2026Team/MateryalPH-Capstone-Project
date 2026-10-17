//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_child_registered_buyers.g.dart';

/// GeoChildRegisteredBuyers
///
/// Properties:
/// * [value]
/// * [suppressed]
@BuiltValue()
abstract class GeoChildRegisteredBuyers implements Built<GeoChildRegisteredBuyers, GeoChildRegisteredBuyersBuilder> {
  @BuiltValueField(wireName: r'value')
  int? get value;

  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  GeoChildRegisteredBuyers._();

  factory GeoChildRegisteredBuyers([void updates(GeoChildRegisteredBuyersBuilder b)]) = _$GeoChildRegisteredBuyers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoChildRegisteredBuyersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoChildRegisteredBuyers> get serializer => _$GeoChildRegisteredBuyersSerializer();
}

class _$GeoChildRegisteredBuyersSerializer implements PrimitiveSerializer<GeoChildRegisteredBuyers> {
  @override
  final Iterable<Type> types = const [GeoChildRegisteredBuyers, _$GeoChildRegisteredBuyers];

  @override
  final String wireName = r'GeoChildRegisteredBuyers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoChildRegisteredBuyers object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoChildRegisteredBuyers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoChildRegisteredBuyersBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoChildRegisteredBuyers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoChildRegisteredBuyersBuilder();
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


