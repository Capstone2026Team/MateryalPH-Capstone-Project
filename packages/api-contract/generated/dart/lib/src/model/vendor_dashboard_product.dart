//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_product.g.dart';

/// VendorDashboardProduct
///
/// Properties:
/// * [name]
/// * [category]
/// * [orders]
/// * [buyers]
/// * [valueCentavos]
@BuiltValue()
abstract class VendorDashboardProduct implements Built<VendorDashboardProduct, VendorDashboardProductBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'buyers')
  int get buyers;

  @BuiltValueField(wireName: r'value_centavos')
  int? get valueCentavos;

  VendorDashboardProduct._();

  factory VendorDashboardProduct([void updates(VendorDashboardProductBuilder b)]) = _$VendorDashboardProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardProduct> get serializer => _$VendorDashboardProductSerializer();
}

class _$VendorDashboardProductSerializer implements PrimitiveSerializer<VendorDashboardProduct> {
  @override
  final Iterable<Type> types = const [VendorDashboardProduct, _$VendorDashboardProduct];

  @override
  final String wireName = r'VendorDashboardProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'buyers';
    yield serializers.serialize(
      object.buyers,
      specifiedType: const FullType(int),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyers = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.valueCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardProductBuilder();
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


