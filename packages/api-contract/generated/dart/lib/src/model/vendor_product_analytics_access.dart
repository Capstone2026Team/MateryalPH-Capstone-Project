//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_access.g.dart';

/// VendorProductAnalyticsAccess
///
/// Properties:
/// * [salesValue]
@BuiltValue()
abstract class VendorProductAnalyticsAccess implements Built<VendorProductAnalyticsAccess, VendorProductAnalyticsAccessBuilder> {
  @BuiltValueField(wireName: r'sales_value')
  bool get salesValue;

  VendorProductAnalyticsAccess._();

  factory VendorProductAnalyticsAccess([void updates(VendorProductAnalyticsAccessBuilder b)]) = _$VendorProductAnalyticsAccess;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsAccessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsAccess> get serializer => _$VendorProductAnalyticsAccessSerializer();
}

class _$VendorProductAnalyticsAccessSerializer implements PrimitiveSerializer<VendorProductAnalyticsAccess> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsAccess, _$VendorProductAnalyticsAccess];

  @override
  final String wireName = r'VendorProductAnalyticsAccess';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsAccess object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sales_value';
    yield serializers.serialize(
      object.salesValue,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsAccess object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsAccessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sales_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.salesValue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsAccess deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsAccessBuilder();
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


