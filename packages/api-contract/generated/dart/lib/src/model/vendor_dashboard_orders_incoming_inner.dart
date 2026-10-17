//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_incoming_inner.g.dart';

/// VendorDashboardOrdersIncomingInner
///
/// Properties:
/// * [orderId]
/// * [reference]
/// * [procurementType]
/// * [fulfillmentMethod]
/// * [lineCount]
/// * [totalCentavos]
/// * [submittedAt]
/// * [dueAt]
@BuiltValue()
abstract class VendorDashboardOrdersIncomingInner implements Built<VendorDashboardOrdersIncomingInner, VendorDashboardOrdersIncomingInnerBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'procurement_type')
  VendorDashboardOrdersIncomingInnerProcurementTypeEnum get procurementType;
  // enum procurementTypeEnum {  ITEM_BASED,  PROJECT_BASED,  };

  @BuiltValueField(wireName: r'fulfillment_method')
  VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'line_count')
  int get lineCount;

  @BuiltValueField(wireName: r'total_centavos')
  int get totalCentavos;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'due_at')
  DateTime? get dueAt;

  VendorDashboardOrdersIncomingInner._();

  factory VendorDashboardOrdersIncomingInner([void updates(VendorDashboardOrdersIncomingInnerBuilder b)]) = _$VendorDashboardOrdersIncomingInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersIncomingInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersIncomingInner> get serializer => _$VendorDashboardOrdersIncomingInnerSerializer();
}

class _$VendorDashboardOrdersIncomingInnerSerializer implements PrimitiveSerializer<VendorDashboardOrdersIncomingInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersIncomingInner, _$VendorDashboardOrdersIncomingInner];

  @override
  final String wireName = r'VendorDashboardOrdersIncomingInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersIncomingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'procurement_type';
    yield serializers.serialize(
      object.procurementType,
      specifiedType: const FullType(VendorDashboardOrdersIncomingInnerProcurementTypeEnum),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum),
    );
    yield r'line_count';
    yield serializers.serialize(
      object.lineCount,
      specifiedType: const FullType(int),
    );
    yield r'total_centavos';
    yield serializers.serialize(
      object.totalCentavos,
      specifiedType: const FullType(int),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.dueAt != null) {
      yield r'due_at';
      yield serializers.serialize(
        object.dueAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersIncomingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersIncomingInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'procurement_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersIncomingInnerProcurementTypeEnum),
          ) as VendorDashboardOrdersIncomingInnerProcurementTypeEnum;
          result.procurementType = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum),
          ) as VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineCount = valueDes;
          break;
        case r'total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCentavos = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersIncomingInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersIncomingInnerBuilder();
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


class VendorDashboardOrdersIncomingInnerProcurementTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ITEM_BASED')
  static const VendorDashboardOrdersIncomingInnerProcurementTypeEnum ITEM_BASED = _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_ITEM_BASED;
  @BuiltValueEnumConst(wireName: r'PROJECT_BASED')
  static const VendorDashboardOrdersIncomingInnerProcurementTypeEnum PROJECT_BASED = _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_PROJECT_BASED;

  static Serializer<VendorDashboardOrdersIncomingInnerProcurementTypeEnum> get serializer => _$vendorDashboardOrdersIncomingInnerProcurementTypeEnumSerializer;

  const VendorDashboardOrdersIncomingInnerProcurementTypeEnum._(String name): super(name);

  static BuiltSet<VendorDashboardOrdersIncomingInnerProcurementTypeEnum> get values => _$vendorDashboardOrdersIncomingInnerProcurementTypeEnumValues;
  static VendorDashboardOrdersIncomingInnerProcurementTypeEnum valueOf(String name) => _$vendorDashboardOrdersIncomingInnerProcurementTypeEnumValueOf(name);
}

class VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum DELIVERY = _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum PICKUP = _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_PICKUP;

  static Serializer<VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum> get serializer => _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnumSerializer;

  const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum> get values => _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnumValues;
  static VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum valueOf(String name) => _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnumValueOf(name);
}

