//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_unusual_days_days_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_unusual_days.g.dart';

/// DBSCAN noise points among the store’s active days.
///
/// Properties:
/// * [state]
/// * [epsilon]
/// * [days]
@BuiltValue()
abstract class VendorDashboardOrdersUnusualDays implements Built<VendorDashboardOrdersUnusualDays, VendorDashboardOrdersUnusualDaysBuilder> {
  @BuiltValueField(wireName: r'state')
  VendorDashboardOrdersUnusualDaysStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'epsilon')
  num? get epsilon;

  @BuiltValueField(wireName: r'days')
  BuiltList<VendorDashboardOrdersUnusualDaysDaysInner> get days;

  VendorDashboardOrdersUnusualDays._();

  factory VendorDashboardOrdersUnusualDays([void updates(VendorDashboardOrdersUnusualDaysBuilder b)]) = _$VendorDashboardOrdersUnusualDays;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersUnusualDaysBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersUnusualDays> get serializer => _$VendorDashboardOrdersUnusualDaysSerializer();
}

class _$VendorDashboardOrdersUnusualDaysSerializer implements PrimitiveSerializer<VendorDashboardOrdersUnusualDays> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersUnusualDays, _$VendorDashboardOrdersUnusualDays];

  @override
  final String wireName = r'VendorDashboardOrdersUnusualDays';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersUnusualDays object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(VendorDashboardOrdersUnusualDaysStateEnum),
    );
    if (object.epsilon != null) {
      yield r'epsilon';
      yield serializers.serialize(
        object.epsilon,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersUnusualDaysDaysInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersUnusualDays object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersUnusualDaysBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersUnusualDaysStateEnum),
          ) as VendorDashboardOrdersUnusualDaysStateEnum;
          result.state = valueDes;
          break;
        case r'epsilon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.epsilon = valueDes;
          break;
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersUnusualDaysDaysInner)]),
          ) as BuiltList<VendorDashboardOrdersUnusualDaysDaysInner>;
          result.days.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersUnusualDays deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersUnusualDaysBuilder();
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


class VendorDashboardOrdersUnusualDaysStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const VendorDashboardOrdersUnusualDaysStateEnum OK = _$vendorDashboardOrdersUnusualDaysStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const VendorDashboardOrdersUnusualDaysStateEnum INSUFFICIENT_DATA = _$vendorDashboardOrdersUnusualDaysStateEnum_INSUFFICIENT_DATA;

  static Serializer<VendorDashboardOrdersUnusualDaysStateEnum> get serializer => _$vendorDashboardOrdersUnusualDaysStateEnumSerializer;

  const VendorDashboardOrdersUnusualDaysStateEnum._(String name): super(name);

  static BuiltSet<VendorDashboardOrdersUnusualDaysStateEnum> get values => _$vendorDashboardOrdersUnusualDaysStateEnumValues;
  static VendorDashboardOrdersUnusualDaysStateEnum valueOf(String name) => _$vendorDashboardOrdersUnusualDaysStateEnumValueOf(name);
}

