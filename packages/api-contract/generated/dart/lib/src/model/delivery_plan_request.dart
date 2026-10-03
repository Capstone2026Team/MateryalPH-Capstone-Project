//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_line_quantity.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan_request.g.dart';

/// DeliveryPlanRequest
///
/// Properties:
/// * [lines]
@BuiltValue()
abstract class DeliveryPlanRequest implements Built<DeliveryPlanRequest, DeliveryPlanRequestBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<OrderLineQuantity>? get lines;

  DeliveryPlanRequest._();

  factory DeliveryPlanRequest([void updates(DeliveryPlanRequestBuilder b)]) = _$DeliveryPlanRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlanRequest> get serializer => _$DeliveryPlanRequestSerializer();
}

class _$DeliveryPlanRequestSerializer implements PrimitiveSerializer<DeliveryPlanRequest> {
  @override
  final Iterable<Type> types = const [DeliveryPlanRequest, _$DeliveryPlanRequest];

  @override
  final String wireName = r'DeliveryPlanRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.lines != null) {
      yield r'lines';
      yield serializers.serialize(
        object.lines,
        specifiedType: const FullType(BuiltList, [FullType(OrderLineQuantity)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(OrderLineQuantity)]),
          ) as BuiltList<OrderLineQuantity>?;
          if (valueDes == null) continue;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlanRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanRequestBuilder();
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


