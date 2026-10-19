//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_row.g.dart';

/// DirectoryVendorRow
///
/// Properties:
/// * [id]
/// * [storeName]
/// * [ownerName]
/// * [ownerEmail]
/// * [status] - Store Activation status.
/// * [verificationStatus]
/// * [discoverabilityStatus]
/// * [accountStatus]
/// * [location]
/// * [joinedAt]
@BuiltValue()
abstract class DirectoryVendorRow implements Built<DirectoryVendorRow, DirectoryVendorRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'owner_name')
  String? get ownerName;

  @BuiltValueField(wireName: r'owner_email')
  String? get ownerEmail;

  /// Store Activation status.
  @BuiltValueField(wireName: r'status')
  DirectoryVendorRowStatusEnum get status;
  // enum statusEnum {  NOT_READY,  READY,  ACTIVE,  RESTRICTED,  SUSPENDED,  };

  @BuiltValueField(wireName: r'verification_status')
  DirectoryVendorRowVerificationStatusEnum get verificationStatus;
  // enum verificationStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  };

  @BuiltValueField(wireName: r'discoverability_status')
  String get discoverabilityStatus;

  @BuiltValueField(wireName: r'account_status')
  String get accountStatus;

  @BuiltValueField(wireName: r'location')
  String? get location;

  @BuiltValueField(wireName: r'joined_at')
  DateTime get joinedAt;

  DirectoryVendorRow._();

  factory DirectoryVendorRow([void updates(DirectoryVendorRowBuilder b)]) = _$DirectoryVendorRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorRow> get serializer => _$DirectoryVendorRowSerializer();
}

class _$DirectoryVendorRowSerializer implements PrimitiveSerializer<DirectoryVendorRow> {
  @override
  final Iterable<Type> types = const [DirectoryVendorRow, _$DirectoryVendorRow];

  @override
  final String wireName = r'DirectoryVendorRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'owner_name';
    yield object.ownerName == null ? null : serializers.serialize(
      object.ownerName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'owner_email';
    yield object.ownerEmail == null ? null : serializers.serialize(
      object.ownerEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DirectoryVendorRowStatusEnum),
    );
    yield r'verification_status';
    yield serializers.serialize(
      object.verificationStatus,
      specifiedType: const FullType(DirectoryVendorRowVerificationStatusEnum),
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
    yield r'location';
    yield object.location == null ? null : serializers.serialize(
      object.location,
      specifiedType: const FullType.nullable(String),
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
    DirectoryVendorRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'owner_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ownerName = valueDes;
          break;
        case r'owner_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ownerEmail = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorRowStatusEnum),
          ) as DirectoryVendorRowStatusEnum;
          result.status = valueDes;
          break;
        case r'verification_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorRowVerificationStatusEnum),
          ) as DirectoryVendorRowVerificationStatusEnum;
          result.verificationStatus = valueDes;
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
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.location = valueDes;
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
  DirectoryVendorRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorRowBuilder();
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


/// Store Activation status.
class DirectoryVendorRowStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_READY')
  static const DirectoryVendorRowStatusEnum NOT_READY = _$directoryVendorRowStatusEnum_NOT_READY;
  @BuiltValueEnumConst(wireName: r'READY')
  static const DirectoryVendorRowStatusEnum READY = _$directoryVendorRowStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const DirectoryVendorRowStatusEnum ACTIVE = _$directoryVendorRowStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'RESTRICTED')
  static const DirectoryVendorRowStatusEnum RESTRICTED = _$directoryVendorRowStatusEnum_RESTRICTED;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const DirectoryVendorRowStatusEnum SUSPENDED = _$directoryVendorRowStatusEnum_SUSPENDED;

  static Serializer<DirectoryVendorRowStatusEnum> get serializer => _$directoryVendorRowStatusEnumSerializer;

  const DirectoryVendorRowStatusEnum._(String name): super(name);

  static BuiltSet<DirectoryVendorRowStatusEnum> get values => _$directoryVendorRowStatusEnumValues;
  static DirectoryVendorRowStatusEnum valueOf(String name) => _$directoryVendorRowStatusEnumValueOf(name);
}

class DirectoryVendorRowVerificationStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const DirectoryVendorRowVerificationStatusEnum NOT_STARTED = _$directoryVendorRowVerificationStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const DirectoryVendorRowVerificationStatusEnum IN_PROGRESS = _$directoryVendorRowVerificationStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const DirectoryVendorRowVerificationStatusEnum SUBMITTED = _$directoryVendorRowVerificationStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const DirectoryVendorRowVerificationStatusEnum PENDING_VERIFICATION = _$directoryVendorRowVerificationStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const DirectoryVendorRowVerificationStatusEnum APPROVED = _$directoryVendorRowVerificationStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const DirectoryVendorRowVerificationStatusEnum CHANGES_REQUIRED = _$directoryVendorRowVerificationStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const DirectoryVendorRowVerificationStatusEnum REJECTED = _$directoryVendorRowVerificationStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const DirectoryVendorRowVerificationStatusEnum EXPIRED = _$directoryVendorRowVerificationStatusEnum_EXPIRED;

  static Serializer<DirectoryVendorRowVerificationStatusEnum> get serializer => _$directoryVendorRowVerificationStatusEnumSerializer;

  const DirectoryVendorRowVerificationStatusEnum._(String name): super(name);

  static BuiltSet<DirectoryVendorRowVerificationStatusEnum> get values => _$directoryVendorRowVerificationStatusEnumValues;
  static DirectoryVendorRowVerificationStatusEnum valueOf(String name) => _$directoryVendorRowVerificationStatusEnumValueOf(name);
}

