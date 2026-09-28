//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/auto_accept_policy_detail_permissions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_status.dart';
import 'package:materyalph_api_client/src/model/auto_accept_policy.dart';
import 'package:materyalph_api_client/src/model/auto_accept_policy_detail_stock.dart';
import 'package:materyalph_api_client/src/model/auto_accept_policy_detail_scope.dart';
import 'package:materyalph_api_client/src/model/auto_accept_policy_version.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_detail.g.dart';

/// AutoAcceptPolicyDetail
///
/// Properties:
/// * [listingVariantId]
/// * [listingId]
/// * [listingName]
/// * [listingStatus]
/// * [variantLabel]
/// * [sku]
/// * [unitCode]
/// * [stock]
/// * [policy]
/// * [versions]
/// * [scope]
/// * [permissions]
@BuiltValue()
abstract class AutoAcceptPolicyDetail implements Built<AutoAcceptPolicyDetail, AutoAcceptPolicyDetailBuilder> {
  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'listing_name')
  String get listingName;

  @BuiltValueField(wireName: r'listing_status')
  ListingStatus get listingStatus;
  // enum listingStatusEnum {  DRAFT,  PENDING_COMPLIANCE,  PENDING_ADMIN_REVIEW,  ACTIVE,  INACTIVE,  TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED,  REJECTED,  };

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'stock')
  AutoAcceptPolicyDetailStock? get stock;

  @BuiltValueField(wireName: r'policy')
  AutoAcceptPolicy get policy;

  @BuiltValueField(wireName: r'versions')
  BuiltList<AutoAcceptPolicyVersion> get versions;

  @BuiltValueField(wireName: r'scope')
  AutoAcceptPolicyDetailScope get scope;

  @BuiltValueField(wireName: r'permissions')
  AutoAcceptPolicyDetailPermissions get permissions;

  AutoAcceptPolicyDetail._();

  factory AutoAcceptPolicyDetail([void updates(AutoAcceptPolicyDetailBuilder b)]) = _$AutoAcceptPolicyDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyDetail> get serializer => _$AutoAcceptPolicyDetailSerializer();
}

class _$AutoAcceptPolicyDetailSerializer implements PrimitiveSerializer<AutoAcceptPolicyDetail> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyDetail, _$AutoAcceptPolicyDetail];

  @override
  final String wireName = r'AutoAcceptPolicyDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'listing_name';
    yield serializers.serialize(
      object.listingName,
      specifiedType: const FullType(String),
    );
    yield r'listing_status';
    yield serializers.serialize(
      object.listingStatus,
      specifiedType: const FullType(ListingStatus),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'stock';
    yield object.stock == null ? null : serializers.serialize(
      object.stock,
      specifiedType: const FullType.nullable(AutoAcceptPolicyDetailStock),
    );
    yield r'policy';
    yield serializers.serialize(
      object.policy,
      specifiedType: const FullType(AutoAcceptPolicy),
    );
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [FullType(AutoAcceptPolicyVersion)]),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(AutoAcceptPolicyDetailScope),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(AutoAcceptPolicyDetailPermissions),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'listing_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingName = valueDes;
          break;
        case r'listing_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingStatus),
          ) as ListingStatus;
          result.listingStatus = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sku = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AutoAcceptPolicyDetailStock),
          ) as AutoAcceptPolicyDetailStock?;
          if (valueDes == null) continue;
          result.stock.replace(valueDes);
          break;
        case r'policy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicy),
          ) as AutoAcceptPolicy;
          result.policy.replace(valueDes);
          break;
        case r'versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AutoAcceptPolicyVersion)]),
          ) as BuiltList<AutoAcceptPolicyVersion>;
          result.versions.replace(valueDes);
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyDetailScope),
          ) as AutoAcceptPolicyDetailScope;
          result.scope.replace(valueDes);
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyDetailPermissions),
          ) as AutoAcceptPolicyDetailPermissions;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicyDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyDetailBuilder();
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


