//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile_owner.g.dart';

/// DirectoryVendorProfileOwner
///
/// Properties:
/// * [name]
/// * [email]
/// * [mobile]
@BuiltValue()
abstract class DirectoryVendorProfileOwner implements Built<DirectoryVendorProfileOwner, DirectoryVendorProfileOwnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'mobile')
  String? get mobile;

  DirectoryVendorProfileOwner._();

  factory DirectoryVendorProfileOwner([void updates(DirectoryVendorProfileOwnerBuilder b)]) = _$DirectoryVendorProfileOwner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileOwnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfileOwner> get serializer => _$DirectoryVendorProfileOwnerSerializer();
}

class _$DirectoryVendorProfileOwnerSerializer implements PrimitiveSerializer<DirectoryVendorProfileOwner> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfileOwner, _$DirectoryVendorProfileOwner];

  @override
  final String wireName = r'DirectoryVendorProfileOwner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfileOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'mobile';
    yield object.mobile == null ? null : serializers.serialize(
      object.mobile,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfileOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileOwnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'mobile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mobile = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfileOwner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileOwnerBuilder();
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


