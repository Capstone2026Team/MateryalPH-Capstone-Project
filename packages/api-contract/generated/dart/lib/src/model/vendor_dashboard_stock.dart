//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_stock_attention_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_stock.g.dart';

/// inventory.view. The store’s own stock only.
///
/// Properties:
/// * [variants]
/// * [inStock]
/// * [limitedStock]
/// * [outOfStock]
/// * [attention]
@BuiltValue()
abstract class VendorDashboardStock implements Built<VendorDashboardStock, VendorDashboardStockBuilder> {
  @BuiltValueField(wireName: r'variants')
  int get variants;

  @BuiltValueField(wireName: r'in_stock')
  int get inStock;

  @BuiltValueField(wireName: r'limited_stock')
  int get limitedStock;

  @BuiltValueField(wireName: r'out_of_stock')
  int get outOfStock;

  @BuiltValueField(wireName: r'attention')
  BuiltList<VendorDashboardStockAttentionInner> get attention;

  VendorDashboardStock._();

  factory VendorDashboardStock([void updates(VendorDashboardStockBuilder b)]) = _$VendorDashboardStock;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardStockBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardStock> get serializer => _$VendorDashboardStockSerializer();
}

class _$VendorDashboardStockSerializer implements PrimitiveSerializer<VendorDashboardStock> {
  @override
  final Iterable<Type> types = const [VendorDashboardStock, _$VendorDashboardStock];

  @override
  final String wireName = r'VendorDashboardStock';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardStock object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(int),
    );
    yield r'in_stock';
    yield serializers.serialize(
      object.inStock,
      specifiedType: const FullType(int),
    );
    yield r'limited_stock';
    yield serializers.serialize(
      object.limitedStock,
      specifiedType: const FullType(int),
    );
    yield r'out_of_stock';
    yield serializers.serialize(
      object.outOfStock,
      specifiedType: const FullType(int),
    );
    yield r'attention';
    yield serializers.serialize(
      object.attention,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardStockAttentionInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardStock object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardStockBuilder result,
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
        case r'in_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inStock = valueDes;
          break;
        case r'limited_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limitedStock = valueDes;
          break;
        case r'out_of_stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outOfStock = valueDes;
          break;
        case r'attention':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardStockAttentionInner)]),
          ) as BuiltList<VendorDashboardStockAttentionInner>;
          result.attention.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardStock deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardStockBuilder();
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


