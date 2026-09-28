//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/stale_listing.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_ledger_meta_stale_listings.g.dart';

/// InventoryLedgerMetaStaleListings
///
/// Properties:
/// * [count]
/// * [items]
@BuiltValue()
abstract class InventoryLedgerMetaStaleListings implements Built<InventoryLedgerMetaStaleListings, InventoryLedgerMetaStaleListingsBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'items')
  BuiltList<StaleListing> get items;

  InventoryLedgerMetaStaleListings._();

  factory InventoryLedgerMetaStaleListings([void updates(InventoryLedgerMetaStaleListingsBuilder b)]) = _$InventoryLedgerMetaStaleListings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLedgerMetaStaleListingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLedgerMetaStaleListings> get serializer => _$InventoryLedgerMetaStaleListingsSerializer();
}

class _$InventoryLedgerMetaStaleListingsSerializer implements PrimitiveSerializer<InventoryLedgerMetaStaleListings> {
  @override
  final Iterable<Type> types = const [InventoryLedgerMetaStaleListings, _$InventoryLedgerMetaStaleListings];

  @override
  final String wireName = r'InventoryLedgerMetaStaleListings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLedgerMetaStaleListings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(StaleListing)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryLedgerMetaStaleListings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryLedgerMetaStaleListingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StaleListing)]),
          ) as BuiltList<StaleListing>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryLedgerMetaStaleListings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLedgerMetaStaleListingsBuilder();
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


