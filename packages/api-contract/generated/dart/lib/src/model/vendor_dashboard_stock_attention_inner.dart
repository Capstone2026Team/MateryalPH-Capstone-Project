//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_stock_attention_inner.g.dart';

/// VendorDashboardStockAttentionInner
///
/// Properties:
/// * [name]
/// * [variant]
/// * [available]
/// * [reorderLevel]
/// * [status]
@BuiltValue()
abstract class VendorDashboardStockAttentionInner implements Built<VendorDashboardStockAttentionInner, VendorDashboardStockAttentionInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'variant')
  String? get variant;

  @BuiltValueField(wireName: r'available')
  String get available;

  @BuiltValueField(wireName: r'reorder_level')
  String? get reorderLevel;

  @BuiltValueField(wireName: r'status')
  VendorDashboardStockAttentionInnerStatusEnum get status;
  // enum statusEnum {  OUT_OF_STOCK,  LIMITED_STOCK,  };

  VendorDashboardStockAttentionInner._();

  factory VendorDashboardStockAttentionInner([void updates(VendorDashboardStockAttentionInnerBuilder b)]) = _$VendorDashboardStockAttentionInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardStockAttentionInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardStockAttentionInner> get serializer => _$VendorDashboardStockAttentionInnerSerializer();
}

class _$VendorDashboardStockAttentionInnerSerializer implements PrimitiveSerializer<VendorDashboardStockAttentionInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardStockAttentionInner, _$VendorDashboardStockAttentionInner];

  @override
  final String wireName = r'VendorDashboardStockAttentionInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardStockAttentionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.variant != null) {
      yield r'variant';
      yield serializers.serialize(
        object.variant,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(String),
    );
    if (object.reorderLevel != null) {
      yield r'reorder_level';
      yield serializers.serialize(
        object.reorderLevel,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorDashboardStockAttentionInnerStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardStockAttentionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardStockAttentionInnerBuilder result,
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
        case r'variant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variant = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.available = valueDes;
          break;
        case r'reorder_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reorderLevel = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardStockAttentionInnerStatusEnum),
          ) as VendorDashboardStockAttentionInnerStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardStockAttentionInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardStockAttentionInnerBuilder();
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


class VendorDashboardStockAttentionInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const VendorDashboardStockAttentionInnerStatusEnum OUT_OF_STOCK = _$vendorDashboardStockAttentionInnerStatusEnum_OUT_OF_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const VendorDashboardStockAttentionInnerStatusEnum LIMITED_STOCK = _$vendorDashboardStockAttentionInnerStatusEnum_LIMITED_STOCK;

  static Serializer<VendorDashboardStockAttentionInnerStatusEnum> get serializer => _$vendorDashboardStockAttentionInnerStatusEnumSerializer;

  const VendorDashboardStockAttentionInnerStatusEnum._(String name): super(name);

  static BuiltSet<VendorDashboardStockAttentionInnerStatusEnum> get values => _$vendorDashboardStockAttentionInnerStatusEnumValues;
  static VendorDashboardStockAttentionInnerStatusEnum valueOf(String name) => _$vendorDashboardStockAttentionInnerStatusEnumValueOf(name);
}

