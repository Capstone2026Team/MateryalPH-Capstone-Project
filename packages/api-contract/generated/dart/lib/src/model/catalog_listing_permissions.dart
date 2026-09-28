//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_permissions.g.dart';

/// CatalogListingPermissions
///
/// Properties:
/// * [canManage]
/// * [canSubmitCompliance]
/// * [canDelete] - True when the caller may delete this never-published listing.
@BuiltValue()
abstract class CatalogListingPermissions implements Built<CatalogListingPermissions, CatalogListingPermissionsBuilder> {
  @BuiltValueField(wireName: r'can_manage')
  bool get canManage;

  @BuiltValueField(wireName: r'can_submit_compliance')
  bool get canSubmitCompliance;

  /// True when the caller may delete this never-published listing.
  @BuiltValueField(wireName: r'can_delete')
  bool? get canDelete;

  CatalogListingPermissions._();

  factory CatalogListingPermissions([void updates(CatalogListingPermissionsBuilder b)]) = _$CatalogListingPermissions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingPermissionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingPermissions> get serializer => _$CatalogListingPermissionsSerializer();
}

class _$CatalogListingPermissionsSerializer implements PrimitiveSerializer<CatalogListingPermissions> {
  @override
  final Iterable<Type> types = const [CatalogListingPermissions, _$CatalogListingPermissions];

  @override
  final String wireName = r'CatalogListingPermissions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_manage';
    yield serializers.serialize(
      object.canManage,
      specifiedType: const FullType(bool),
    );
    yield r'can_submit_compliance';
    yield serializers.serialize(
      object.canSubmitCompliance,
      specifiedType: const FullType(bool),
    );
    if (object.canDelete != null) {
      yield r'can_delete';
      yield serializers.serialize(
        object.canDelete,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingPermissionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_manage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canManage = valueDes;
          break;
        case r'can_submit_compliance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canSubmitCompliance = valueDes;
          break;
        case r'can_delete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canDelete = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingPermissions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingPermissionsBuilder();
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


