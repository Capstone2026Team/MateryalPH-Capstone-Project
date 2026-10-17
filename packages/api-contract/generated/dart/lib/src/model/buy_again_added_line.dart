//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buy_again_added_line.g.dart';

/// BuyAgainAddedLine
///
/// Properties:
/// * [displayName]
/// * [quantity]
@BuiltValue()
abstract class BuyAgainAddedLine implements Built<BuyAgainAddedLine, BuyAgainAddedLineBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  BuyAgainAddedLine._();

  factory BuyAgainAddedLine([void updates(BuyAgainAddedLineBuilder b)]) = _$BuyAgainAddedLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyAgainAddedLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyAgainAddedLine> get serializer => _$BuyAgainAddedLineSerializer();
}

class _$BuyAgainAddedLineSerializer implements PrimitiveSerializer<BuyAgainAddedLine> {
  @override
  final Iterable<Type> types = const [BuyAgainAddedLine, _$BuyAgainAddedLine];

  @override
  final String wireName = r'BuyAgainAddedLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyAgainAddedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyAgainAddedLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyAgainAddedLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyAgainAddedLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyAgainAddedLineBuilder();
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


