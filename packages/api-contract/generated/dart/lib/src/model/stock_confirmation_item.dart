//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stock_confirmation_item.g.dart';

/// StockConfirmationItem
///
/// Properties:
/// * [listingVariantId]
/// * [lockVersion]
@BuiltValue()
abstract class StockConfirmationItem implements Built<StockConfirmationItem, StockConfirmationItemBuilder> {
  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  StockConfirmationItem._();

  factory StockConfirmationItem([void updates(StockConfirmationItemBuilder b)]) = _$StockConfirmationItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StockConfirmationItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StockConfirmationItem> get serializer => _$StockConfirmationItemSerializer();
}

class _$StockConfirmationItemSerializer implements PrimitiveSerializer<StockConfirmationItem> {
  @override
  final Iterable<Type> types = const [StockConfirmationItem, _$StockConfirmationItem];

  @override
  final String wireName = r'StockConfirmationItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StockConfirmationItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StockConfirmationItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StockConfirmationItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StockConfirmationItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StockConfirmationItemBuilder();
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


