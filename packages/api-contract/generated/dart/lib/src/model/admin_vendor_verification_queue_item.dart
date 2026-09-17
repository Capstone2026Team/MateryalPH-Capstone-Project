//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vendor_verification_queue_item.g.dart';

/// AdminVendorVerificationQueueItem
///
/// Properties:
/// * [id]
/// * [storeName]
/// * [registeredName]
/// * [regionCode]
/// * [regionName]
/// * [province]
/// * [cityMunicipality]
/// * [businessType]
/// * [verificationStatus]
/// * [setupStatus]
/// * [activationStatus]
/// * [submittedAt]
/// * [progress]
@BuiltValue()
abstract class AdminVendorVerificationQueueItem implements Built<AdminVendorVerificationQueueItem, AdminVendorVerificationQueueItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'registered_name')
  String? get registeredName;

  @BuiltValueField(wireName: r'region_code')
  String? get regionCode;

  @BuiltValueField(wireName: r'region_name')
  String? get regionName;

  @BuiltValueField(wireName: r'province')
  String? get province;

  @BuiltValueField(wireName: r'city_municipality')
  String? get cityMunicipality;

  @BuiltValueField(wireName: r'business_type')
  String? get businessType;

  @BuiltValueField(wireName: r'verification_status')
  String get verificationStatus;

  @BuiltValueField(wireName: r'setup_status')
  String? get setupStatus;

  @BuiltValueField(wireName: r'activation_status')
  String? get activationStatus;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'progress')
  BuiltMap<String, JsonObject?> get progress;

  AdminVendorVerificationQueueItem._();

  factory AdminVendorVerificationQueueItem([void updates(AdminVendorVerificationQueueItemBuilder b)]) = _$AdminVendorVerificationQueueItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVendorVerificationQueueItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVendorVerificationQueueItem> get serializer => _$AdminVendorVerificationQueueItemSerializer();
}

class _$AdminVendorVerificationQueueItemSerializer implements PrimitiveSerializer<AdminVendorVerificationQueueItem> {
  @override
  final Iterable<Type> types = const [AdminVendorVerificationQueueItem, _$AdminVendorVerificationQueueItem];

  @override
  final String wireName = r'AdminVendorVerificationQueueItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVendorVerificationQueueItem object, {
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
    if (object.registeredName != null) {
      yield r'registered_name';
      yield serializers.serialize(
        object.registeredName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.regionCode != null) {
      yield r'region_code';
      yield serializers.serialize(
        object.regionCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.regionName != null) {
      yield r'region_name';
      yield serializers.serialize(
        object.regionName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.province != null) {
      yield r'province';
      yield serializers.serialize(
        object.province,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cityMunicipality != null) {
      yield r'city_municipality';
      yield serializers.serialize(
        object.cityMunicipality,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.businessType != null) {
      yield r'business_type';
      yield serializers.serialize(
        object.businessType,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'verification_status';
    yield serializers.serialize(
      object.verificationStatus,
      specifiedType: const FullType(String),
    );
    if (object.setupStatus != null) {
      yield r'setup_status';
      yield serializers.serialize(
        object.setupStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.activationStatus != null) {
      yield r'activation_status';
      yield serializers.serialize(
        object.activationStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'progress';
    yield serializers.serialize(
      object.progress,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVendorVerificationQueueItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVendorVerificationQueueItemBuilder result,
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
        case r'registered_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.registeredName = valueDes;
          break;
        case r'region_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.regionCode = valueDes;
          break;
        case r'region_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.regionName = valueDes;
          break;
        case r'province':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.province = valueDes;
          break;
        case r'city_municipality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityMunicipality = valueDes;
          break;
        case r'business_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.businessType = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.setupStatus = valueDes;
          break;
        case r'activation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.activationStatus = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'progress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.progress.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVendorVerificationQueueItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVendorVerificationQueueItemBuilder();
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


