//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_version_mutation.g.dart';

/// VendorVersionMutation
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class VendorVersionMutation implements Built<VendorVersionMutation, VendorVersionMutationBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  VendorVersionMutation._();

  factory VendorVersionMutation([void updates(VendorVersionMutationBuilder b)]) = _$VendorVersionMutation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVersionMutationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVersionMutation> get serializer => _$VendorVersionMutationSerializer();
}

class _$VendorVersionMutationSerializer implements PrimitiveSerializer<VendorVersionMutation> {
  @override
  final Iterable<Type> types = const [VendorVersionMutation, _$VendorVersionMutation];

  @override
  final String wireName = r'VendorVersionMutation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVersionMutation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVersionMutation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVersionMutationBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVersionMutation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVersionMutationBuilder();
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


