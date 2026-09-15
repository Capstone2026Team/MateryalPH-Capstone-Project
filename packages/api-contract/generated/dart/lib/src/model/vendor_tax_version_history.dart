//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_tax_review_history.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_tax_version_history.g.dart';

/// VendorTaxVersionHistory
///
/// Properties:
/// * [id]
/// * [version]
/// * [evidenceOrigin]
/// * [environment]
/// * [ownerAttestedAt]
/// * [createdAt]
/// * [status]
/// * [reviews]
@BuiltValue()
abstract class VendorTaxVersionHistory implements Built<VendorTaxVersionHistory, VendorTaxVersionHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'evidence_origin')
  VendorTaxVersionHistoryEvidenceOriginEnum get evidenceOrigin;
  // enum evidenceOriginEnum {  SAMPLE_DEMO,  };

  @BuiltValueField(wireName: r'environment')
  VendorTaxVersionHistoryEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'owner_attested_at')
  String? get ownerAttestedAt;

  @BuiltValueField(wireName: r'created_at')
  String get createdAt;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'reviews')
  BuiltList<VendorTaxReviewHistory> get reviews;

  VendorTaxVersionHistory._();

  factory VendorTaxVersionHistory([void updates(VendorTaxVersionHistoryBuilder b)]) = _$VendorTaxVersionHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTaxVersionHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTaxVersionHistory> get serializer => _$VendorTaxVersionHistorySerializer();
}

class _$VendorTaxVersionHistorySerializer implements PrimitiveSerializer<VendorTaxVersionHistory> {
  @override
  final Iterable<Type> types = const [VendorTaxVersionHistory, _$VendorTaxVersionHistory];

  @override
  final String wireName = r'VendorTaxVersionHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTaxVersionHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'evidence_origin';
    yield serializers.serialize(
      object.evidenceOrigin,
      specifiedType: const FullType(VendorTaxVersionHistoryEvidenceOriginEnum),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(VendorTaxVersionHistoryEnvironmentEnum),
    );
    yield r'owner_attested_at';
    yield object.ownerAttestedAt == null ? null : serializers.serialize(
      object.ownerAttestedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'reviews';
    yield serializers.serialize(
      object.reviews,
      specifiedType: const FullType(BuiltList, [FullType(VendorTaxReviewHistory)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTaxVersionHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTaxVersionHistoryBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxVersionHistoryEvidenceOriginEnum),
          ) as VendorTaxVersionHistoryEvidenceOriginEnum;
          result.evidenceOrigin = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxVersionHistoryEnvironmentEnum),
          ) as VendorTaxVersionHistoryEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'owner_attested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ownerAttestedAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTaxReviewHistory)]),
          ) as BuiltList<VendorTaxReviewHistory>;
          result.reviews.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTaxVersionHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTaxVersionHistoryBuilder();
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


class VendorTaxVersionHistoryEvidenceOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SAMPLE_DEMO')
  static const VendorTaxVersionHistoryEvidenceOriginEnum SAMPLE_DEMO = _$vendorTaxVersionHistoryEvidenceOriginEnum_SAMPLE_DEMO;

  static Serializer<VendorTaxVersionHistoryEvidenceOriginEnum> get serializer => _$vendorTaxVersionHistoryEvidenceOriginEnumSerializer;

  const VendorTaxVersionHistoryEvidenceOriginEnum._(String name): super(name);

  static BuiltSet<VendorTaxVersionHistoryEvidenceOriginEnum> get values => _$vendorTaxVersionHistoryEvidenceOriginEnumValues;
  static VendorTaxVersionHistoryEvidenceOriginEnum valueOf(String name) => _$vendorTaxVersionHistoryEvidenceOriginEnumValueOf(name);
}

class VendorTaxVersionHistoryEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const VendorTaxVersionHistoryEnvironmentEnum TEST = _$vendorTaxVersionHistoryEnvironmentEnum_TEST;

  static Serializer<VendorTaxVersionHistoryEnvironmentEnum> get serializer => _$vendorTaxVersionHistoryEnvironmentEnumSerializer;

  const VendorTaxVersionHistoryEnvironmentEnum._(String name): super(name);

  static BuiltSet<VendorTaxVersionHistoryEnvironmentEnum> get values => _$vendorTaxVersionHistoryEnvironmentEnumValues;
  static VendorTaxVersionHistoryEnvironmentEnum valueOf(String name) => _$vendorTaxVersionHistoryEnvironmentEnumValueOf(name);
}

