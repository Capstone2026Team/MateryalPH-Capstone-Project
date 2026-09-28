//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_detail_permissions.g.dart';

/// AutoAcceptPolicyDetailPermissions
///
/// Properties:
/// * [canConfigure]
/// * [canUpdateAllotment]
@BuiltValue()
abstract class AutoAcceptPolicyDetailPermissions implements Built<AutoAcceptPolicyDetailPermissions, AutoAcceptPolicyDetailPermissionsBuilder> {
  @BuiltValueField(wireName: r'can_configure')
  bool get canConfigure;

  @BuiltValueField(wireName: r'can_update_allotment')
  bool get canUpdateAllotment;

  AutoAcceptPolicyDetailPermissions._();

  factory AutoAcceptPolicyDetailPermissions([void updates(AutoAcceptPolicyDetailPermissionsBuilder b)]) = _$AutoAcceptPolicyDetailPermissions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyDetailPermissionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyDetailPermissions> get serializer => _$AutoAcceptPolicyDetailPermissionsSerializer();
}

class _$AutoAcceptPolicyDetailPermissionsSerializer implements PrimitiveSerializer<AutoAcceptPolicyDetailPermissions> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyDetailPermissions, _$AutoAcceptPolicyDetailPermissions];

  @override
  final String wireName = r'AutoAcceptPolicyDetailPermissions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyDetailPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_configure';
    yield serializers.serialize(
      object.canConfigure,
      specifiedType: const FullType(bool),
    );
    yield r'can_update_allotment';
    yield serializers.serialize(
      object.canUpdateAllotment,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyDetailPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyDetailPermissionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_configure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canConfigure = valueDes;
          break;
        case r'can_update_allotment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canUpdateAllotment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicyDetailPermissions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyDetailPermissionsBuilder();
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


