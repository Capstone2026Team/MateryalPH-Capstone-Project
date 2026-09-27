//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_lock_version.g.dart';

/// CatalogLockVersion
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class CatalogLockVersion implements Built<CatalogLockVersion, CatalogLockVersionBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  CatalogLockVersion._();

  factory CatalogLockVersion([void updates(CatalogLockVersionBuilder b)]) = _$CatalogLockVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogLockVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogLockVersion> get serializer => _$CatalogLockVersionSerializer();
}

class _$CatalogLockVersionSerializer implements PrimitiveSerializer<CatalogLockVersion> {
  @override
  final Iterable<Type> types = const [CatalogLockVersion, _$CatalogLockVersion];

  @override
  final String wireName = r'CatalogLockVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogLockVersion object, {
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
    CatalogLockVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogLockVersionBuilder result,
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
  CatalogLockVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogLockVersionBuilder();
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


