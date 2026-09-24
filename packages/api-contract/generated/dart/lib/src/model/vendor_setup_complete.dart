//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_setup_complete.g.dart';

/// VendorSetupComplete
///
/// Properties:
/// * [organizationLockVersion]
@BuiltValue()
abstract class VendorSetupComplete implements Built<VendorSetupComplete, VendorSetupCompleteBuilder> {
  @BuiltValueField(wireName: r'organization_lock_version')
  int get organizationLockVersion;

  VendorSetupComplete._();

  factory VendorSetupComplete([void updates(VendorSetupCompleteBuilder b)]) = _$VendorSetupComplete;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorSetupCompleteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorSetupComplete> get serializer => _$VendorSetupCompleteSerializer();
}

class _$VendorSetupCompleteSerializer implements PrimitiveSerializer<VendorSetupComplete> {
  @override
  final Iterable<Type> types = const [VendorSetupComplete, _$VendorSetupComplete];

  @override
  final String wireName = r'VendorSetupComplete';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorSetupComplete object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'organization_lock_version';
    yield serializers.serialize(
      object.organizationLockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorSetupComplete object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorSetupCompleteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'organization_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.organizationLockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorSetupComplete deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorSetupCompleteBuilder();
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
