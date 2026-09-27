//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/compliance_path.dart';
import 'package:materyalph_api_client/src/model/marking_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_submission.g.dart';

/// Vendor-confirmed declaration from Review and Confirm. Extraction output is never submitted as truth.
///
/// Properties:
/// * [listingLockVersion]
/// * [path]
/// * [evidenceIds]
/// * [markingType]
/// * [certificateNumber]
/// * [manufacturerName] - Required for a PS Mark.
/// * [manufacturerAddress]
/// * [importerName] - Required for an ICC sticker.
/// * [importerAddress]
/// * [countryOfManufacture]
/// * [brand]
/// * [batchNumber]
/// * [confirmed]
@BuiltValue()
abstract class ComplianceSubmission implements Built<ComplianceSubmission, ComplianceSubmissionBuilder> {
  @BuiltValueField(wireName: r'listing_lock_version')
  int get listingLockVersion;

  @BuiltValueField(wireName: r'path')
  CompliancePath get path;
  // enum pathEnum {  PHOTO_OCR,  QR,  MANUAL,  };

  @BuiltValueField(wireName: r'evidence_ids')
  BuiltList<String> get evidenceIds;

  @BuiltValueField(wireName: r'marking_type')
  MarkingType get markingType;
  // enum markingTypeEnum {  PS_MARK,  ICC_STICKER,  };

  @BuiltValueField(wireName: r'certificate_number')
  String get certificateNumber;

  /// Required for a PS Mark.
  @BuiltValueField(wireName: r'manufacturer_name')
  String? get manufacturerName;

  @BuiltValueField(wireName: r'manufacturer_address')
  String? get manufacturerAddress;

  /// Required for an ICC sticker.
  @BuiltValueField(wireName: r'importer_name')
  String? get importerName;

  @BuiltValueField(wireName: r'importer_address')
  String? get importerAddress;

  @BuiltValueField(wireName: r'country_of_manufacture')
  String? get countryOfManufacture;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'batch_number')
  String? get batchNumber;

  @BuiltValueField(wireName: r'confirmed')
  ComplianceSubmissionConfirmedEnum get confirmed;
  // enum confirmedEnum {  true,  };

  ComplianceSubmission._();

  factory ComplianceSubmission([void updates(ComplianceSubmissionBuilder b)]) = _$ComplianceSubmission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceSubmissionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceSubmission> get serializer => _$ComplianceSubmissionSerializer();
}

class _$ComplianceSubmissionSerializer implements PrimitiveSerializer<ComplianceSubmission> {
  @override
  final Iterable<Type> types = const [ComplianceSubmission, _$ComplianceSubmission];

  @override
  final String wireName = r'ComplianceSubmission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceSubmission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_lock_version';
    yield serializers.serialize(
      object.listingLockVersion,
      specifiedType: const FullType(int),
    );
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(CompliancePath),
    );
    yield r'evidence_ids';
    yield serializers.serialize(
      object.evidenceIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'marking_type';
    yield serializers.serialize(
      object.markingType,
      specifiedType: const FullType(MarkingType),
    );
    yield r'certificate_number';
    yield serializers.serialize(
      object.certificateNumber,
      specifiedType: const FullType(String),
    );
    if (object.manufacturerName != null) {
      yield r'manufacturer_name';
      yield serializers.serialize(
        object.manufacturerName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.manufacturerAddress != null) {
      yield r'manufacturer_address';
      yield serializers.serialize(
        object.manufacturerAddress,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.importerName != null) {
      yield r'importer_name';
      yield serializers.serialize(
        object.importerName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.importerAddress != null) {
      yield r'importer_address';
      yield serializers.serialize(
        object.importerAddress,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.countryOfManufacture != null) {
      yield r'country_of_manufacture';
      yield serializers.serialize(
        object.countryOfManufacture,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.batchNumber != null) {
      yield r'batch_number';
      yield serializers.serialize(
        object.batchNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'confirmed';
    yield serializers.serialize(
      object.confirmed,
      specifiedType: const FullType(ComplianceSubmissionConfirmedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceSubmission object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceSubmissionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingLockVersion = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompliancePath),
          ) as CompliancePath;
          result.path = valueDes;
          break;
        case r'evidence_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.evidenceIds.replace(valueDes);
          break;
        case r'marking_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MarkingType),
          ) as MarkingType;
          result.markingType = valueDes;
          break;
        case r'certificate_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.certificateNumber = valueDes;
          break;
        case r'manufacturer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturerName = valueDes;
          break;
        case r'manufacturer_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturerAddress = valueDes;
          break;
        case r'importer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.importerName = valueDes;
          break;
        case r'importer_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.importerAddress = valueDes;
          break;
        case r'country_of_manufacture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.countryOfManufacture = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'batch_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.batchNumber = valueDes;
          break;
        case r'confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceSubmissionConfirmedEnum),
          ) as ComplianceSubmissionConfirmedEnum;
          result.confirmed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceSubmission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceSubmissionBuilder();
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


class ComplianceSubmissionConfirmedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const ComplianceSubmissionConfirmedEnum true_ = _$complianceSubmissionConfirmedEnum_true_;

  static Serializer<ComplianceSubmissionConfirmedEnum> get serializer => _$complianceSubmissionConfirmedEnumSerializer;

  const ComplianceSubmissionConfirmedEnum._(String name): super(name);

  static BuiltSet<ComplianceSubmissionConfirmedEnum> get values => _$complianceSubmissionConfirmedEnumValues;
  static ComplianceSubmissionConfirmedEnum valueOf(String name) => _$complianceSubmissionConfirmedEnumValueOf(name);
}

