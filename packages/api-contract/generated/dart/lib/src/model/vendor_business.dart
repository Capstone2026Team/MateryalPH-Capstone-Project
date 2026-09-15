//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_business_draft.dart';
import 'package:materyalph_api_client/src/model/vendor_store_email_verification.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_business.g.dart';

/// VendorBusiness
///
/// Properties:
/// * [reviewReason]
/// * [lockVersion]
/// * [draft]
/// * [status]
/// * [storeEmailVerification]
@BuiltValue()
abstract class VendorBusiness implements Built<VendorBusiness, VendorBusinessBuilder> {
  @BuiltValueField(wireName: r'review_reason')
  String? get reviewReason;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'draft')
  VendorBusinessDraft get draft;

  @BuiltValueField(wireName: r'status')
  VendorBusinessStatusEnum get status;
  // enum statusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'store_email_verification')
  VendorStoreEmailVerification get storeEmailVerification;

  VendorBusiness._();

  factory VendorBusiness([void updates(VendorBusinessBuilder b)]) = _$VendorBusiness;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBusinessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBusiness> get serializer => _$VendorBusinessSerializer();
}

class _$VendorBusinessSerializer implements PrimitiveSerializer<VendorBusiness> {
  @override
  final Iterable<Type> types = const [VendorBusiness, _$VendorBusiness];

  @override
  final String wireName = r'VendorBusiness';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBusiness object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'review_reason';
    yield object.reviewReason == null ? null : serializers.serialize(
      object.reviewReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'draft';
    yield serializers.serialize(
      object.draft,
      specifiedType: const FullType(VendorBusinessDraft),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorBusinessStatusEnum),
    );
    yield r'store_email_verification';
    yield serializers.serialize(
      object.storeEmailVerification,
      specifiedType: const FullType(VendorStoreEmailVerification),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBusiness object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBusinessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'review_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewReason = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorBusinessDraft),
          ) as VendorBusinessDraft;
          result.draft.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorBusinessStatusEnum),
          ) as VendorBusinessStatusEnum;
          result.status = valueDes;
          break;
        case r'store_email_verification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorStoreEmailVerification),
          ) as VendorStoreEmailVerification;
          result.storeEmailVerification.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBusiness deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBusinessBuilder();
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


class VendorBusinessStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorBusinessStatusEnum NOT_STARTED = _$vendorBusinessStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorBusinessStatusEnum IN_PROGRESS = _$vendorBusinessStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorBusinessStatusEnum SUBMITTED = _$vendorBusinessStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorBusinessStatusEnum PENDING_VERIFICATION = _$vendorBusinessStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorBusinessStatusEnum APPROVED = _$vendorBusinessStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorBusinessStatusEnum COMPLETED = _$vendorBusinessStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorBusinessStatusEnum CHANGES_REQUIRED = _$vendorBusinessStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorBusinessStatusEnum REJECTED = _$vendorBusinessStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorBusinessStatusEnum EXPIRED = _$vendorBusinessStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorBusinessStatusEnum NOT_APPLICABLE = _$vendorBusinessStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorBusinessStatusEnum> get serializer => _$vendorBusinessStatusEnumSerializer;

  const VendorBusinessStatusEnum._(String name): super(name);

  static BuiltSet<VendorBusinessStatusEnum> get values => _$vendorBusinessStatusEnumValues;
  static VendorBusinessStatusEnum valueOf(String name) => _$vendorBusinessStatusEnumValueOf(name);
}

