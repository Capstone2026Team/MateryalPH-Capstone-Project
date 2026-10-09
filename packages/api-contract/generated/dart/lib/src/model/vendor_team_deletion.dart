//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_deletion.g.dart';

/// VendorTeamDeletion
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class VendorTeamDeletion implements Built<VendorTeamDeletion, VendorTeamDeletionBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  VendorTeamDeletion._();

  factory VendorTeamDeletion([void updates(VendorTeamDeletionBuilder b)]) = _$VendorTeamDeletion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamDeletionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamDeletion> get serializer => _$VendorTeamDeletionSerializer();
}

class _$VendorTeamDeletionSerializer implements PrimitiveSerializer<VendorTeamDeletion> {
  @override
  final Iterable<Type> types = const [VendorTeamDeletion, _$VendorTeamDeletion];

  @override
  final String wireName = r'VendorTeamDeletion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamDeletion object, {
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
    VendorTeamDeletion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamDeletionBuilder result,
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
  VendorTeamDeletion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamDeletionBuilder();
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


