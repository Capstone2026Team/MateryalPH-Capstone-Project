//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_price_change.g.dart';

/// InventoryPriceChange
///
/// Properties:
/// * [expectedPriceVersionId] - The current ordinary price version the editor started from.
/// * [amountCentavos] - VAT-inclusive payable amount; keeps the current tax classification and must stay above every volume tier.
@BuiltValue()
abstract class InventoryPriceChange implements Built<InventoryPriceChange, InventoryPriceChangeBuilder> {
  /// The current ordinary price version the editor started from.
  @BuiltValueField(wireName: r'expected_price_version_id')
  String get expectedPriceVersionId;

  /// VAT-inclusive payable amount; keeps the current tax classification and must stay above every volume tier.
  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  InventoryPriceChange._();

  factory InventoryPriceChange([void updates(InventoryPriceChangeBuilder b)]) = _$InventoryPriceChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryPriceChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryPriceChange> get serializer => _$InventoryPriceChangeSerializer();
}

class _$InventoryPriceChangeSerializer implements PrimitiveSerializer<InventoryPriceChange> {
  @override
  final Iterable<Type> types = const [InventoryPriceChange, _$InventoryPriceChange];

  @override
  final String wireName = r'InventoryPriceChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryPriceChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_price_version_id';
    yield serializers.serialize(
      object.expectedPriceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryPriceChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryPriceChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expected_price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expectedPriceVersionId = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryPriceChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryPriceChangeBuilder();
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


