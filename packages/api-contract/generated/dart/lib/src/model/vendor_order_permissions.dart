//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_permissions.g.dart';

/// Display hints only; every action is authorized again on the server.
///
/// Properties:
/// * [canConfirm]
/// * [canRevise]
/// * [canSetNrpc]
/// * [canConfirmDelivery]
/// * [canDecline]
/// * [canViewInventory]
/// * [canRecordPhysicalPayment]
/// * [canApproveOnlineBalance]
@BuiltValue()
abstract class VendorOrderPermissions implements Built<VendorOrderPermissions, VendorOrderPermissionsBuilder> {
  @BuiltValueField(wireName: r'can_confirm')
  bool get canConfirm;

  @BuiltValueField(wireName: r'can_revise')
  bool get canRevise;

  @BuiltValueField(wireName: r'can_set_nrpc')
  bool get canSetNrpc;

  @BuiltValueField(wireName: r'can_confirm_delivery')
  bool get canConfirmDelivery;

  @BuiltValueField(wireName: r'can_decline')
  bool get canDecline;

  @BuiltValueField(wireName: r'can_view_inventory')
  bool get canViewInventory;

  @BuiltValueField(wireName: r'can_record_physical_payment')
  bool? get canRecordPhysicalPayment;

  @BuiltValueField(wireName: r'can_approve_online_balance')
  bool? get canApproveOnlineBalance;

  VendorOrderPermissions._();

  factory VendorOrderPermissions([void updates(VendorOrderPermissionsBuilder b)]) = _$VendorOrderPermissions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOrderPermissionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOrderPermissions> get serializer => _$VendorOrderPermissionsSerializer();
}

class _$VendorOrderPermissionsSerializer implements PrimitiveSerializer<VendorOrderPermissions> {
  @override
  final Iterable<Type> types = const [VendorOrderPermissions, _$VendorOrderPermissions];

  @override
  final String wireName = r'VendorOrderPermissions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOrderPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_confirm';
    yield serializers.serialize(
      object.canConfirm,
      specifiedType: const FullType(bool),
    );
    yield r'can_revise';
    yield serializers.serialize(
      object.canRevise,
      specifiedType: const FullType(bool),
    );
    yield r'can_set_nrpc';
    yield serializers.serialize(
      object.canSetNrpc,
      specifiedType: const FullType(bool),
    );
    yield r'can_confirm_delivery';
    yield serializers.serialize(
      object.canConfirmDelivery,
      specifiedType: const FullType(bool),
    );
    yield r'can_decline';
    yield serializers.serialize(
      object.canDecline,
      specifiedType: const FullType(bool),
    );
    yield r'can_view_inventory';
    yield serializers.serialize(
      object.canViewInventory,
      specifiedType: const FullType(bool),
    );
    if (object.canRecordPhysicalPayment != null) {
      yield r'can_record_physical_payment';
      yield serializers.serialize(
        object.canRecordPhysicalPayment,
        specifiedType: const FullType(bool),
      );
    }
    if (object.canApproveOnlineBalance != null) {
      yield r'can_approve_online_balance';
      yield serializers.serialize(
        object.canApproveOnlineBalance,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOrderPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOrderPermissionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_confirm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canConfirm = valueDes;
          break;
        case r'can_revise':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRevise = valueDes;
          break;
        case r'can_set_nrpc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canSetNrpc = valueDes;
          break;
        case r'can_confirm_delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canConfirmDelivery = valueDes;
          break;
        case r'can_decline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canDecline = valueDes;
          break;
        case r'can_view_inventory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canViewInventory = valueDes;
          break;
        case r'can_record_physical_payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canRecordPhysicalPayment = valueDes;
          break;
        case r'can_approve_online_balance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canApproveOnlineBalance = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOrderPermissions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOrderPermissionsBuilder();
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


