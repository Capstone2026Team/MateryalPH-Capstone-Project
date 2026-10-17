//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_detail_unusual_days_days_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_detail_unusual_days.g.dart';

/// DBSCAN noise points among the product’s active days.
///
/// Properties:
/// * [state]
/// * [epsilon]
/// * [days]
@BuiltValue()
abstract class VendorProductAnalyticsDetailUnusualDays implements Built<VendorProductAnalyticsDetailUnusualDays, VendorProductAnalyticsDetailUnusualDaysBuilder> {
  @BuiltValueField(wireName: r'state')
  VendorProductAnalyticsDetailUnusualDaysStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'epsilon')
  num? get epsilon;

  @BuiltValueField(wireName: r'days')
  BuiltList<VendorProductAnalyticsDetailUnusualDaysDaysInner> get days;

  VendorProductAnalyticsDetailUnusualDays._();

  factory VendorProductAnalyticsDetailUnusualDays([void updates(VendorProductAnalyticsDetailUnusualDaysBuilder b)]) = _$VendorProductAnalyticsDetailUnusualDays;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsDetailUnusualDaysBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsDetailUnusualDays> get serializer => _$VendorProductAnalyticsDetailUnusualDaysSerializer();
}

class _$VendorProductAnalyticsDetailUnusualDaysSerializer implements PrimitiveSerializer<VendorProductAnalyticsDetailUnusualDays> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsDetailUnusualDays, _$VendorProductAnalyticsDetailUnusualDays];

  @override
  final String wireName = r'VendorProductAnalyticsDetailUnusualDays';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsDetailUnusualDays object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(VendorProductAnalyticsDetailUnusualDaysStateEnum),
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
      specifiedType: const FullType(BuiltList, [FullType(VendorProductAnalyticsDetailUnusualDaysDaysInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsDetailUnusualDays object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsDetailUnusualDaysBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsDetailUnusualDaysStateEnum),
          ) as VendorProductAnalyticsDetailUnusualDaysStateEnum;
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
            specifiedType: const FullType(BuiltList, [FullType(VendorProductAnalyticsDetailUnusualDaysDaysInner)]),
          ) as BuiltList<VendorProductAnalyticsDetailUnusualDaysDaysInner>;
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
  VendorProductAnalyticsDetailUnusualDays deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsDetailUnusualDaysBuilder();
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


class VendorProductAnalyticsDetailUnusualDaysStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const VendorProductAnalyticsDetailUnusualDaysStateEnum OK = _$vendorProductAnalyticsDetailUnusualDaysStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const VendorProductAnalyticsDetailUnusualDaysStateEnum INSUFFICIENT_DATA = _$vendorProductAnalyticsDetailUnusualDaysStateEnum_INSUFFICIENT_DATA;

  static Serializer<VendorProductAnalyticsDetailUnusualDaysStateEnum> get serializer => _$vendorProductAnalyticsDetailUnusualDaysStateEnumSerializer;

  const VendorProductAnalyticsDetailUnusualDaysStateEnum._(String name): super(name);

  static BuiltSet<VendorProductAnalyticsDetailUnusualDaysStateEnum> get values => _$vendorProductAnalyticsDetailUnusualDaysStateEnumValues;
  static VendorProductAnalyticsDetailUnusualDaysStateEnum valueOf(String name) => _$vendorProductAnalyticsDetailUnusualDaysStateEnumValueOf(name);
}

