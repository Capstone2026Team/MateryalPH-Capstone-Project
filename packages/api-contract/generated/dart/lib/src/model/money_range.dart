//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'money_range.g.dart';

/// MoneyRange
///
/// Properties:
/// * [minCentavos]
/// * [maxCentavos]
@BuiltValue()
abstract class MoneyRange implements Built<MoneyRange, MoneyRangeBuilder> {
  @BuiltValueField(wireName: r'min_centavos')
  int get minCentavos;

  @BuiltValueField(wireName: r'max_centavos')
  int get maxCentavos;

  MoneyRange._();

  factory MoneyRange([void updates(MoneyRangeBuilder b)]) = _$MoneyRange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MoneyRangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MoneyRange> get serializer => _$MoneyRangeSerializer();
}

class _$MoneyRangeSerializer implements PrimitiveSerializer<MoneyRange> {
  @override
  final Iterable<Type> types = const [MoneyRange, _$MoneyRange];

  @override
  final String wireName = r'MoneyRange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MoneyRange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'min_centavos';
    yield serializers.serialize(
      object.minCentavos,
      specifiedType: const FullType(int),
    );
    yield r'max_centavos';
    yield serializers.serialize(
      object.maxCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MoneyRange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MoneyRangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'min_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minCentavos = valueDes;
          break;
        case r'max_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MoneyRange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MoneyRangeBuilder();
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


