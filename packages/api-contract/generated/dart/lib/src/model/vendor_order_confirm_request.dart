//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/pickup_confirmation.dart';
import 'package:materyalph_api_client/src/model/nrpc_proposal.dart';
import 'package:materyalph_api_client/src/model/delivery_confirmation.dart';
import 'package:materyalph_api_client/src/model/order_line_quantity.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_confirm_request.g.dart';

/// VendorOrderConfirmRequest
///
/// Properties:
/// * [lockVersion]
/// * [lines]
/// * [vendorDiscountCentavos]
/// * [nrpc]
/// * [pickup]
/// * [delivery]
@BuiltValue()
abstract class VendorOrderConfirmRequest implements Built<VendorOrderConfirmRequest, VendorOrderConfirmRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'lines')
  BuiltList<OrderLineQuantity> get lines;

  @BuiltValueField(wireName: r'vendor_discount_centavos')
  int? get vendorDiscountCentavos;

  @BuiltValueField(wireName: r'nrpc')
  NrpcProposal? get nrpc;

  @BuiltValueField(wireName: r'pickup')
  PickupConfirmation? get pickup;

  @BuiltValueField(wireName: r'delivery')
  DeliveryConfirmation? get delivery;

  VendorOrderConfirmRequest._();

  factory VendorOrderConfirmRequest([void updates(VendorOrderConfirmRequestBuilder b)]) = _$VendorOrderConfirmRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOrderConfirmRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOrderConfirmRequest> get serializer => _$VendorOrderConfirmRequestSerializer();
}

class _$VendorOrderConfirmRequestSerializer implements PrimitiveSerializer<VendorOrderConfirmRequest> {
  @override
  final Iterable<Type> types = const [VendorOrderConfirmRequest, _$VendorOrderConfirmRequest];

  @override
  final String wireName = r'VendorOrderConfirmRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOrderConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(OrderLineQuantity)]),
    );
    if (object.vendorDiscountCentavos != null) {
      yield r'vendor_discount_centavos';
      yield serializers.serialize(
        object.vendorDiscountCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.nrpc != null) {
      yield r'nrpc';
      yield serializers.serialize(
        object.nrpc,
        specifiedType: const FullType.nullable(NrpcProposal),
      );
    }
    if (object.pickup != null) {
      yield r'pickup';
      yield serializers.serialize(
        object.pickup,
        specifiedType: const FullType.nullable(PickupConfirmation),
      );
    }
    if (object.delivery != null) {
      yield r'delivery';
      yield serializers.serialize(
        object.delivery,
        specifiedType: const FullType.nullable(DeliveryConfirmation),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOrderConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOrderConfirmRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderLineQuantity)]),
          ) as BuiltList<OrderLineQuantity>;
          result.lines.replace(valueDes);
          break;
        case r'vendor_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorDiscountCentavos = valueDes;
          break;
        case r'nrpc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NrpcProposal),
          ) as NrpcProposal?;
          if (valueDes == null) continue;
          result.nrpc.replace(valueDes);
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PickupConfirmation),
          ) as PickupConfirmation?;
          if (valueDes == null) continue;
          result.pickup.replace(valueDes);
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryConfirmation),
          ) as DeliveryConfirmation?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOrderConfirmRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOrderConfirmRequestBuilder();
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


