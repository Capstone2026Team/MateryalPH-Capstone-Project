//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_next_opening.g.dart';

/// StoreNextOpening
///
/// Properties:
/// * [date]
/// * [weekday]
/// * [opensAt]
@BuiltValue()
abstract class StoreNextOpening implements Built<StoreNextOpening, StoreNextOpeningBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'weekday')
  String get weekday;

  @BuiltValueField(wireName: r'opens_at')
  String get opensAt;

  StoreNextOpening._();

  factory StoreNextOpening([void updates(StoreNextOpeningBuilder b)]) = _$StoreNextOpening;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoreNextOpeningBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoreNextOpening> get serializer => _$StoreNextOpeningSerializer();
}

class _$StoreNextOpeningSerializer implements PrimitiveSerializer<StoreNextOpening> {
  @override
  final Iterable<Type> types = const [StoreNextOpening, _$StoreNextOpening];

  @override
  final String wireName = r'StoreNextOpening';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoreNextOpening object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(String),
    );
    yield r'opens_at';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StoreNextOpening object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoreNextOpeningBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'weekday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.weekday = valueDes;
          break;
        case r'opens_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.opensAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StoreNextOpening deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoreNextOpeningBuilder();
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


