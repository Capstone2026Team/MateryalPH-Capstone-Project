//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_funnel_inner.g.dart';

/// VendorDashboardOrdersFunnelInner
///
/// Properties:
/// * [key]
/// * [label]
/// * [count]
@BuiltValue()
abstract class VendorDashboardOrdersFunnelInner implements Built<VendorDashboardOrdersFunnelInner, VendorDashboardOrdersFunnelInnerBuilder> {
  @BuiltValueField(wireName: r'key')
  VendorDashboardOrdersFunnelInnerKeyEnum get key;
  // enum keyEnum {  INQUIRIES,  QUOTATIONS,  ORDER_REQUESTS,  CONFIRMED,  COMPLETED,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'count')
  int get count;

  VendorDashboardOrdersFunnelInner._();

  factory VendorDashboardOrdersFunnelInner([void updates(VendorDashboardOrdersFunnelInnerBuilder b)]) = _$VendorDashboardOrdersFunnelInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersFunnelInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersFunnelInner> get serializer => _$VendorDashboardOrdersFunnelInnerSerializer();
}

class _$VendorDashboardOrdersFunnelInnerSerializer implements PrimitiveSerializer<VendorDashboardOrdersFunnelInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersFunnelInner, _$VendorDashboardOrdersFunnelInner];

  @override
  final String wireName = r'VendorDashboardOrdersFunnelInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersFunnelInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(VendorDashboardOrdersFunnelInnerKeyEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersFunnelInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersFunnelInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersFunnelInnerKeyEnum),
          ) as VendorDashboardOrdersFunnelInnerKeyEnum;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersFunnelInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersFunnelInnerBuilder();
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


class VendorDashboardOrdersFunnelInnerKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INQUIRIES')
  static const VendorDashboardOrdersFunnelInnerKeyEnum INQUIRIES = _$vendorDashboardOrdersFunnelInnerKeyEnum_INQUIRIES;
  @BuiltValueEnumConst(wireName: r'QUOTATIONS')
  static const VendorDashboardOrdersFunnelInnerKeyEnum QUOTATIONS = _$vendorDashboardOrdersFunnelInnerKeyEnum_QUOTATIONS;
  @BuiltValueEnumConst(wireName: r'ORDER_REQUESTS')
  static const VendorDashboardOrdersFunnelInnerKeyEnum ORDER_REQUESTS = _$vendorDashboardOrdersFunnelInnerKeyEnum_ORDER_REQUESTS;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const VendorDashboardOrdersFunnelInnerKeyEnum CONFIRMED = _$vendorDashboardOrdersFunnelInnerKeyEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorDashboardOrdersFunnelInnerKeyEnum COMPLETED = _$vendorDashboardOrdersFunnelInnerKeyEnum_COMPLETED;

  static Serializer<VendorDashboardOrdersFunnelInnerKeyEnum> get serializer => _$vendorDashboardOrdersFunnelInnerKeyEnumSerializer;

  const VendorDashboardOrdersFunnelInnerKeyEnum._(String name): super(name);

  static BuiltSet<VendorDashboardOrdersFunnelInnerKeyEnum> get values => _$vendorDashboardOrdersFunnelInnerKeyEnumValues;
  static VendorDashboardOrdersFunnelInnerKeyEnum valueOf(String name) => _$vendorDashboardOrdersFunnelInnerKeyEnumValueOf(name);
}

