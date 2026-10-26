//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile_store.g.dart';

/// DirectoryVendorProfileStore
///
/// Properties:
/// * [legalName]
/// * [registeredName]
/// * [businessType]
/// * [description]
/// * [logoUrl] - Short-lived link to the scanned store logo.
/// * [bannerUrl] - Short-lived link to the scanned store banner; null when absent or unavailable.
/// * [contactEmail]
/// * [contactPhone]
/// * [address]
/// * [location]
/// * [verificationStatus]
/// * [setupStatus]
/// * [activationStatus]
/// * [discoverabilityStatus]
/// * [accountStatus]
/// * [activationHoldCode]
/// * [vacationMode]
/// * [bulkCapability]
/// * [joinedAt]
@BuiltValue()
abstract class DirectoryVendorProfileStore implements Built<DirectoryVendorProfileStore, DirectoryVendorProfileStoreBuilder> {
  @BuiltValueField(wireName: r'legal_name')
  String? get legalName;

  @BuiltValueField(wireName: r'registered_name')
  String? get registeredName;

  @BuiltValueField(wireName: r'business_type')
  String? get businessType;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Short-lived link to the scanned store logo.
  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  /// Short-lived link to the scanned store banner; null when absent or unavailable.
  @BuiltValueField(wireName: r'banner_url')
  String? get bannerUrl;

  @BuiltValueField(wireName: r'contact_email')
  String? get contactEmail;

  @BuiltValueField(wireName: r'contact_phone')
  String? get contactPhone;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'location')
  String? get location;

  @BuiltValueField(wireName: r'verification_status')
  String get verificationStatus;

  @BuiltValueField(wireName: r'setup_status')
  String get setupStatus;

  @BuiltValueField(wireName: r'activation_status')
  String get activationStatus;

  @BuiltValueField(wireName: r'discoverability_status')
  String get discoverabilityStatus;

  @BuiltValueField(wireName: r'account_status')
  String get accountStatus;

  @BuiltValueField(wireName: r'activation_hold_code')
  String? get activationHoldCode;

  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

  @BuiltValueField(wireName: r'bulk_capability')
  bool get bulkCapability;

  @BuiltValueField(wireName: r'joined_at')
  DateTime get joinedAt;

  DirectoryVendorProfileStore._();

  factory DirectoryVendorProfileStore([void updates(DirectoryVendorProfileStoreBuilder b)]) = _$DirectoryVendorProfileStore;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileStoreBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfileStore> get serializer => _$DirectoryVendorProfileStoreSerializer();
}

class _$DirectoryVendorProfileStoreSerializer implements PrimitiveSerializer<DirectoryVendorProfileStore> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfileStore, _$DirectoryVendorProfileStore];

  @override
  final String wireName = r'DirectoryVendorProfileStore';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfileStore object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'legal_name';
    yield object.legalName == null ? null : serializers.serialize(
      object.legalName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'registered_name';
    yield object.registeredName == null ? null : serializers.serialize(
      object.registeredName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'business_type';
    yield object.businessType == null ? null : serializers.serialize(
      object.businessType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'logo_url';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'banner_url';
    yield object.bannerUrl == null ? null : serializers.serialize(
      object.bannerUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'contact_email';
    yield object.contactEmail == null ? null : serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'contact_phone';
    yield object.contactPhone == null ? null : serializers.serialize(
      object.contactPhone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield object.address == null ? null : serializers.serialize(
      object.address,
      specifiedType: const FullType.nullable(String),
    );
    yield r'location';
    yield object.location == null ? null : serializers.serialize(
      object.location,
      specifiedType: const FullType.nullable(String),
    );
    yield r'verification_status';
    yield serializers.serialize(
      object.verificationStatus,
      specifiedType: const FullType(String),
    );
    yield r'setup_status';
    yield serializers.serialize(
      object.setupStatus,
      specifiedType: const FullType(String),
    );
    yield r'activation_status';
    yield serializers.serialize(
      object.activationStatus,
      specifiedType: const FullType(String),
    );
    yield r'discoverability_status';
    yield serializers.serialize(
      object.discoverabilityStatus,
      specifiedType: const FullType(String),
    );
    yield r'account_status';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(String),
    );
    yield r'activation_hold_code';
    yield object.activationHoldCode == null ? null : serializers.serialize(
      object.activationHoldCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
    );
    yield r'bulk_capability';
    yield serializers.serialize(
      object.bulkCapability,
      specifiedType: const FullType(bool),
    );
    yield r'joined_at';
    yield serializers.serialize(
      object.joinedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfileStore object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileStoreBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'legal_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalName = valueDes;
          break;
        case r'registered_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.registeredName = valueDes;
          break;
        case r'business_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.businessType = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'logo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'banner_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bannerUrl = valueDes;
          break;
        case r'contact_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactEmail = valueDes;
          break;
        case r'contact_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactPhone = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.location = valueDes;
          break;
        case r'verification_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.verificationStatus = valueDes;
          break;
        case r'setup_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.setupStatus = valueDes;
          break;
        case r'activation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.activationStatus = valueDes;
          break;
        case r'discoverability_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discoverabilityStatus = valueDes;
          break;
        case r'account_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountStatus = valueDes;
          break;
        case r'activation_hold_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.activationHoldCode = valueDes;
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
          break;
        case r'bulk_capability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bulkCapability = valueDes;
          break;
        case r'joined_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.joinedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfileStore deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileStoreBuilder();
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


