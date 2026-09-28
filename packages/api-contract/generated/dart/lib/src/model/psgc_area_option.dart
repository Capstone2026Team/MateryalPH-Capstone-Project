//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'psgc_area_option.g.dart';

/// PsgcAreaOption
///
/// Properties:
/// * [code]
/// * [name]
/// * [level]
@BuiltValue()
abstract class PsgcAreaOption implements Built<PsgcAreaOption, PsgcAreaOptionBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'level')
  String get level;

  PsgcAreaOption._();

  factory PsgcAreaOption([void updates(PsgcAreaOptionBuilder b)]) = _$PsgcAreaOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PsgcAreaOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PsgcAreaOption> get serializer => _$PsgcAreaOptionSerializer();
}

class _$PsgcAreaOptionSerializer implements PrimitiveSerializer<PsgcAreaOption> {
  @override
  final Iterable<Type> types = const [PsgcAreaOption, _$PsgcAreaOption];

  @override
  final String wireName = r'PsgcAreaOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PsgcAreaOption object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PsgcAreaOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PsgcAreaOptionBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PsgcAreaOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PsgcAreaOptionBuilder();
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


