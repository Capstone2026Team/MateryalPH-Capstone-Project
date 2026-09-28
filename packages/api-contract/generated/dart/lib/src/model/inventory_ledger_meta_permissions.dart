//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_ledger_meta_permissions.g.dart';

/// InventoryLedgerMetaPermissions
///
/// Properties:
/// * [canAdjust]
/// * [canChangePrice]
/// * [canConfigureAutoAccept]
/// * [canUpdateAllotment]
/// * [canViewAutoAccept]
/// * [canEditSettings]
@BuiltValue()
abstract class InventoryLedgerMetaPermissions implements Built<InventoryLedgerMetaPermissions, InventoryLedgerMetaPermissionsBuilder> {
  @BuiltValueField(wireName: r'can_adjust')
  bool get canAdjust;

  @BuiltValueField(wireName: r'can_change_price')
  bool get canChangePrice;

  @BuiltValueField(wireName: r'can_configure_auto_accept')
  bool get canConfigureAutoAccept;

  @BuiltValueField(wireName: r'can_update_allotment')
  bool get canUpdateAllotment;

  @BuiltValueField(wireName: r'can_view_auto_accept')
  bool get canViewAutoAccept;

  @BuiltValueField(wireName: r'can_edit_settings')
  bool get canEditSettings;

  InventoryLedgerMetaPermissions._();

  factory InventoryLedgerMetaPermissions([void updates(InventoryLedgerMetaPermissionsBuilder b)]) = _$InventoryLedgerMetaPermissions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLedgerMetaPermissionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLedgerMetaPermissions> get serializer => _$InventoryLedgerMetaPermissionsSerializer();
}

class _$InventoryLedgerMetaPermissionsSerializer implements PrimitiveSerializer<InventoryLedgerMetaPermissions> {
  @override
  final Iterable<Type> types = const [InventoryLedgerMetaPermissions, _$InventoryLedgerMetaPermissions];

  @override
  final String wireName = r'InventoryLedgerMetaPermissions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLedgerMetaPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_adjust';
    yield serializers.serialize(
      object.canAdjust,
      specifiedType: const FullType(bool),
    );
    yield r'can_change_price';
    yield serializers.serialize(
      object.canChangePrice,
      specifiedType: const FullType(bool),
    );
    yield r'can_configure_auto_accept';
    yield serializers.serialize(
      object.canConfigureAutoAccept,
      specifiedType: const FullType(bool),
    );
    yield r'can_update_allotment';
    yield serializers.serialize(
      object.canUpdateAllotment,
      specifiedType: const FullType(bool),
    );
    yield r'can_view_auto_accept';
    yield serializers.serialize(
      object.canViewAutoAccept,
      specifiedType: const FullType(bool),
    );
    yield r'can_edit_settings';
    yield serializers.serialize(
      object.canEditSettings,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryLedgerMetaPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryLedgerMetaPermissionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_adjust':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canAdjust = valueDes;
          break;
        case r'can_change_price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canChangePrice = valueDes;
          break;
        case r'can_configure_auto_accept':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canConfigureAutoAccept = valueDes;
          break;
        case r'can_update_allotment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canUpdateAllotment = valueDes;
          break;
        case r'can_view_auto_accept':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canViewAutoAccept = valueDes;
          break;
        case r'can_edit_settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canEditSettings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryLedgerMetaPermissions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLedgerMetaPermissionsBuilder();
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


