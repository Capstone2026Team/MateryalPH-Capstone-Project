//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/activation_restrictions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_workstreams.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vendor_verification_detail.g.dart';

/// Documents the Phase 16 keys of the free-form Phase 3E case payload (AdminVendorVerificationDetailEnvelope.data): separate workstream states and source-revision activation restrictions.
///
/// Properties:
/// * [workstreams]
/// * [activationRestrictions]
/// * [readiness]
@BuiltValue()
abstract class AdminVendorVerificationDetail implements Built<AdminVendorVerificationDetail, AdminVendorVerificationDetailBuilder> {
  @BuiltValueField(wireName: r'workstreams')
  VendorWorkstreams? get workstreams;

  @BuiltValueField(wireName: r'activation_restrictions')
  ActivationRestrictions? get activationRestrictions;

  @BuiltValueField(wireName: r'readiness')
  BuiltMap<String, JsonObject?>? get readiness;

  AdminVendorVerificationDetail._();

  factory AdminVendorVerificationDetail([void updates(AdminVendorVerificationDetailBuilder b)]) = _$AdminVendorVerificationDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVendorVerificationDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVendorVerificationDetail> get serializer => _$AdminVendorVerificationDetailSerializer();
}

class _$AdminVendorVerificationDetailSerializer implements PrimitiveSerializer<AdminVendorVerificationDetail> {
  @override
  final Iterable<Type> types = const [AdminVendorVerificationDetail, _$AdminVendorVerificationDetail];

  @override
  final String wireName = r'AdminVendorVerificationDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVendorVerificationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.workstreams != null) {
      yield r'workstreams';
      yield serializers.serialize(
        object.workstreams,
        specifiedType: const FullType(VendorWorkstreams),
      );
    }
    if (object.activationRestrictions != null) {
      yield r'activation_restrictions';
      yield serializers.serialize(
        object.activationRestrictions,
        specifiedType: const FullType(ActivationRestrictions),
      );
    }
    if (object.readiness != null) {
      yield r'readiness';
      yield serializers.serialize(
        object.readiness,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVendorVerificationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVendorVerificationDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'workstreams':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorWorkstreams),
          ) as VendorWorkstreams?;
          if (valueDes == null) continue;
          result.workstreams.replace(valueDes);
          break;
        case r'activation_restrictions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ActivationRestrictions),
          ) as ActivationRestrictions?;
          if (valueDes == null) continue;
          result.activationRestrictions.replace(valueDes);
          break;
        case r'readiness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.readiness.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVendorVerificationDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVendorVerificationDetailBuilder();
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


