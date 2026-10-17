//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cart.dart';
import 'package:materyalph_api_client/src/model/buy_again_added_line.dart';
import 'package:materyalph_api_client/src/model/buy_again_skipped_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buy_again_result.g.dart';

/// BuyAgainResult
///
/// Properties:
/// * [cart]
/// * [added]
/// * [skipped]
@BuiltValue()
abstract class BuyAgainResult implements Built<BuyAgainResult, BuyAgainResultBuilder> {
  @BuiltValueField(wireName: r'cart')
  Cart get cart;

  @BuiltValueField(wireName: r'added')
  BuiltList<BuyAgainAddedLine> get added;

  @BuiltValueField(wireName: r'skipped')
  BuiltList<BuyAgainSkippedLine> get skipped;

  BuyAgainResult._();

  factory BuyAgainResult([void updates(BuyAgainResultBuilder b)]) = _$BuyAgainResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyAgainResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyAgainResult> get serializer => _$BuyAgainResultSerializer();
}

class _$BuyAgainResultSerializer implements PrimitiveSerializer<BuyAgainResult> {
  @override
  final Iterable<Type> types = const [BuyAgainResult, _$BuyAgainResult];

  @override
  final String wireName = r'BuyAgainResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyAgainResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cart';
    yield serializers.serialize(
      object.cart,
      specifiedType: const FullType(Cart),
    );
    yield r'added';
    yield serializers.serialize(
      object.added,
      specifiedType: const FullType(BuiltList, [FullType(BuyAgainAddedLine)]),
    );
    yield r'skipped';
    yield serializers.serialize(
      object.skipped,
      specifiedType: const FullType(BuiltList, [FullType(BuyAgainSkippedLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyAgainResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyAgainResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cart':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Cart),
          ) as Cart;
          result.cart.replace(valueDes);
          break;
        case r'added':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyAgainAddedLine)]),
          ) as BuiltList<BuyAgainAddedLine>;
          result.added.replace(valueDes);
          break;
        case r'skipped':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyAgainSkippedLine)]),
          ) as BuiltList<BuyAgainSkippedLine>;
          result.skipped.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyAgainResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyAgainResultBuilder();
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


