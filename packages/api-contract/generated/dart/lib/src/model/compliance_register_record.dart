//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_register_record.g.dart';

/// Public DTI-BPS register details for the looked-up number.
///
/// Properties:
/// * [registerKind]
/// * [companyName]
/// * [productDescription]
/// * [brand]
/// * [modelType]
/// * [referenceStandard]
/// * [address]
/// * [origin]
/// * [licenseNumber]
/// * [iccCertificateNumber]
/// * [serialRange]
/// * [expiresOn]
@BuiltValue()
abstract class ComplianceRegisterRecord implements Built<ComplianceRegisterRecord, ComplianceRegisterRecordBuilder> {
  @BuiltValueField(wireName: r'register_kind')
  ComplianceRegisterRecordRegisterKindEnum get registerKind;
  // enum registerKindEnum {  PS_LICENSE,  ICC_CERTIFICATE,  };

  @BuiltValueField(wireName: r'company_name')
  String get companyName;

  @BuiltValueField(wireName: r'product_description')
  String? get productDescription;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'model_type')
  String? get modelType;

  @BuiltValueField(wireName: r'reference_standard')
  String? get referenceStandard;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'origin')
  String? get origin;

  @BuiltValueField(wireName: r'license_number')
  String? get licenseNumber;

  @BuiltValueField(wireName: r'icc_certificate_number')
  String? get iccCertificateNumber;

  @BuiltValueField(wireName: r'serial_range')
  String? get serialRange;

  @BuiltValueField(wireName: r'expires_on')
  String? get expiresOn;

  ComplianceRegisterRecord._();

  factory ComplianceRegisterRecord([void updates(ComplianceRegisterRecordBuilder b)]) = _$ComplianceRegisterRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceRegisterRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceRegisterRecord> get serializer => _$ComplianceRegisterRecordSerializer();
}

class _$ComplianceRegisterRecordSerializer implements PrimitiveSerializer<ComplianceRegisterRecord> {
  @override
  final Iterable<Type> types = const [ComplianceRegisterRecord, _$ComplianceRegisterRecord];

  @override
  final String wireName = r'ComplianceRegisterRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceRegisterRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'register_kind';
    yield serializers.serialize(
      object.registerKind,
      specifiedType: const FullType(ComplianceRegisterRecordRegisterKindEnum),
    );
    yield r'company_name';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    if (object.productDescription != null) {
      yield r'product_description';
      yield serializers.serialize(
        object.productDescription,
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
    if (object.modelType != null) {
      yield r'model_type';
      yield serializers.serialize(
        object.modelType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.referenceStandard != null) {
      yield r'reference_standard';
      yield serializers.serialize(
        object.referenceStandard,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.origin != null) {
      yield r'origin';
      yield serializers.serialize(
        object.origin,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.licenseNumber != null) {
      yield r'license_number';
      yield serializers.serialize(
        object.licenseNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.iccCertificateNumber != null) {
      yield r'icc_certificate_number';
      yield serializers.serialize(
        object.iccCertificateNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.serialRange != null) {
      yield r'serial_range';
      yield serializers.serialize(
        object.serialRange,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.expiresOn != null) {
      yield r'expires_on';
      yield serializers.serialize(
        object.expiresOn,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceRegisterRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceRegisterRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'register_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceRegisterRecordRegisterKindEnum),
          ) as ComplianceRegisterRecordRegisterKindEnum;
          result.registerKind = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'product_description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.productDescription = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'model_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.modelType = valueDes;
          break;
        case r'reference_standard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referenceStandard = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.origin = valueDes;
          break;
        case r'license_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.licenseNumber = valueDes;
          break;
        case r'icc_certificate_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.iccCertificateNumber = valueDes;
          break;
        case r'serial_range':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.serialRange = valueDes;
          break;
        case r'expires_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresOn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceRegisterRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceRegisterRecordBuilder();
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


class ComplianceRegisterRecordRegisterKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PS_LICENSE')
  static const ComplianceRegisterRecordRegisterKindEnum PS_LICENSE = _$complianceRegisterRecordRegisterKindEnum_PS_LICENSE;
  @BuiltValueEnumConst(wireName: r'ICC_CERTIFICATE')
  static const ComplianceRegisterRecordRegisterKindEnum ICC_CERTIFICATE = _$complianceRegisterRecordRegisterKindEnum_ICC_CERTIFICATE;

  static Serializer<ComplianceRegisterRecordRegisterKindEnum> get serializer => _$complianceRegisterRecordRegisterKindEnumSerializer;

  const ComplianceRegisterRecordRegisterKindEnum._(String name): super(name);

  static BuiltSet<ComplianceRegisterRecordRegisterKindEnum> get values => _$complianceRegisterRecordRegisterKindEnumValues;
  static ComplianceRegisterRecordRegisterKindEnum valueOf(String name) => _$complianceRegisterRecordRegisterKindEnumValueOf(name);
}

