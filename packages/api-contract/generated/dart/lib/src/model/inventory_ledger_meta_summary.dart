//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_ledger_meta_summary.g.dart';

/// InventoryLedgerMetaSummary
///
/// Properties:
/// * [variants]
/// * [outOfStock]
/// * [limitedStock]
/// * [confirmationDue]
/// * [stale]
@BuiltValue()
abstract class InventoryLedgerMetaSummary implements Built<InventoryLedgerMetaSummary, InventoryLedgerMetaSummaryBuilder> {
  @BuiltValueField(wireName: r'variants')
  int get variants;

  @BuiltValueField(wireName: r'out_of_stock')
  int get outOfStock;

  @BuiltValueField(wireName: r'limited_stock')
  int get limitedStock;

  @BuiltValueField(wireName: r'confirmation_due')
  int get confirmationDue;

  @BuiltValueField(wireName: r'stale')
  int get stale;

  InventoryLedgerMetaSummary._();

  factory InventoryLedgerMetaSummary([void updates(InventoryLedgerMetaSummaryBuilder b)]) = _$InventoryLedgerMetaSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLedgerMetaSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLedgerMetaSummary> get serializer => _$InventoryLedgerMetaSummarySerializer();
}

class _$InventoryLedgerMetaSummarySerializer implements PrimitiveSerializer<InventoryLedgerMetaSummary> {
  @override
  final Iterable<Type> types = const [InventoryLedgerMetaSummary, _$InventoryLedgerMetaSummary];

  @override
  final String wireName = r'InventoryLedgerMetaSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLedgerMetaSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(int),
    );
    yield r'out_of_stock';
    yield serializers.serialize(
      object.outOfStock,
      specifiedType: const FullType(int),
    );
    yield r'limited_stock';
    yield serializers.serialize(
      object.limitedStock,
      specifiedType: const FullType(int),
    );
    yield r'confirmation_due';
    yield serializers.serialize(
      object.confirmationDue,
      specifiedType: const FullType(int),
    );
    yield r'stale';
    yield serializers.serialize(
      object.stale,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryLedgerMetaSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryLedgerMetaSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variants = valueDes;
          break;
        case r'out_of_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outOfStock = valueDes;
          break;
        case r'limited_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limitedStock = valueDes;
          break;
        case r'confirmation_due':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.confirmationDue = valueDes;
          break;
        case r'stale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stale = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryLedgerMetaSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLedgerMetaSummaryBuilder();
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


