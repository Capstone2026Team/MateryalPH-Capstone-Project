//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_summary.g.dart';

/// CartSummary
///
/// Properties:
/// * [lineCount]
/// * [vendorCount]
/// * [materialsSubtotalCentavos]
/// * [notice]
/// * [reservesStock]
@BuiltValue()
abstract class CartSummary implements Built<CartSummary, CartSummaryBuilder> {
  @BuiltValueField(wireName: r'line_count')
  int get lineCount;

  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'materials_subtotal_centavos')
  int get materialsSubtotalCentavos;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  @BuiltValueField(wireName: r'reserves_stock')
  CartSummaryReservesStockEnum get reservesStock;
  // enum reservesStockEnum {  false,  };

  CartSummary._();

  factory CartSummary([void updates(CartSummaryBuilder b)]) = _$CartSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartSummary> get serializer => _$CartSummarySerializer();
}

class _$CartSummarySerializer implements PrimitiveSerializer<CartSummary> {
  @override
  final Iterable<Type> types = const [CartSummary, _$CartSummary];

  @override
  final String wireName = r'CartSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line_count';
    yield serializers.serialize(
      object.lineCount,
      specifiedType: const FullType(int),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'materials_subtotal_centavos';
    yield serializers.serialize(
      object.materialsSubtotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
    yield r'reserves_stock';
    yield serializers.serialize(
      object.reservesStock,
      specifiedType: const FullType(CartSummaryReservesStockEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineCount = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'materials_subtotal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsSubtotalCentavos = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        case r'reserves_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartSummaryReservesStockEnum),
          ) as CartSummaryReservesStockEnum;
          result.reservesStock = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartSummaryBuilder();
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


class CartSummaryReservesStockEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'false')
  static const CartSummaryReservesStockEnum false_ = _$cartSummaryReservesStockEnum_false_;

  static Serializer<CartSummaryReservesStockEnum> get serializer => _$cartSummaryReservesStockEnumSerializer;

  const CartSummaryReservesStockEnum._(String name): super(name);

  static BuiltSet<CartSummaryReservesStockEnum> get values => _$cartSummaryReservesStockEnumValues;
  static CartSummaryReservesStockEnum valueOf(String name) => _$cartSummaryReservesStockEnumValueOf(name);
}

