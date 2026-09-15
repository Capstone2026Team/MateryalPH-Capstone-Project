//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_business_address.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_business_contact.dart';
import 'package:materyalph_api_client/src/model/vendor_individual_registered_name.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_business_draft.g.dart';

/// VendorBusinessDraft
///
/// Properties:
/// * [legalName]
/// * [individualRegisteredName]
/// * [companyRegisteredName]
/// * [governmentIdType]
/// * [governmentIdNumber]
/// * [storeName]
/// * [establishedOn]
/// * [storeEmail]
/// * [storePhone]
/// * [businessType]
/// * [classification]
/// * [niches]
/// * [otherNiche]
/// * [address]
/// * [contacts]
@BuiltValue()
abstract class VendorBusinessDraft implements Built<VendorBusinessDraft, VendorBusinessDraftBuilder> {
  @BuiltValueField(wireName: r'legal_name')
  String? get legalName;

  @BuiltValueField(wireName: r'individual_registered_name')
  VendorIndividualRegisteredName? get individualRegisteredName;

  @BuiltValueField(wireName: r'company_registered_name')
  String? get companyRegisteredName;

  @BuiltValueField(wireName: r'government_id_type')
  String? get governmentIdType;

  @BuiltValueField(wireName: r'government_id_number')
  String? get governmentIdNumber;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  @BuiltValueField(wireName: r'established_on')
  String? get establishedOn;

  @BuiltValueField(wireName: r'store_email')
  String? get storeEmail;

  @BuiltValueField(wireName: r'store_phone')
  String? get storePhone;

  @BuiltValueField(wireName: r'business_type')
  VendorBusinessDraftBusinessTypeEnum? get businessType;
  // enum businessTypeEnum {  SOLE_PROPRIETORSHIP,  PARTNERSHIP,  CORPORATION,  ONE_PERSON_CORPORATION,  COOPERATIVE,  };

  @BuiltValueField(wireName: r'classification')
  VendorBusinessDraftClassificationEnum? get classification;
  // enum classificationEnum {  WHOLESALER_DISTRIBUTOR,  RETAIL_HARDWARE_STORE,  SPECIALIZED_SUPPLIER,  };

  @BuiltValueField(wireName: r'niches')
  BuiltList<VendorBusinessDraftNichesEnum>? get niches;
  // enum nichesEnum {  CONSTRUCTION_MATERIALS,  ELECTRICAL_SUPPLIES,  PLUMBING_SANITARY,  TOOLS_EQUIPMENT,  FINISHING_MATERIALS,  FASTENERS_HARDWARE,  CEMENT_CONCRETE,  ROOFING_MATERIALS,  FORMWORKS_SCAFFOLDING,  WOOD_LUMBER,  LANDSCAPING_EXTERIOR,  STEEL_REINFORCEMENT,  TOOLS_ACCESSORIES,  MASONRY,  INSULATION_WATERPROOFING,  AGGREGATES,  DRAINAGE_SEPTIC,  CONSTRUCTION_CHEMICALS,  FLOORING_MATERIALS,  WALL_CEILING,  HVAC_MATERIALS,  SANITARY_FIXTURES,  FIRE_PROTECTION,  PAINTS_FINISHES,  ADHESIVES_SEALANTS,  DOORS_WINDOWS_GLASS,  OTHER,  };

  @BuiltValueField(wireName: r'other_niche')
  String? get otherNiche;

  @BuiltValueField(wireName: r'address')
  VendorBusinessAddress? get address;

  @BuiltValueField(wireName: r'contacts')
  BuiltList<VendorBusinessContact>? get contacts;

  VendorBusinessDraft._();

  factory VendorBusinessDraft([void updates(VendorBusinessDraftBuilder b)]) = _$VendorBusinessDraft;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBusinessDraftBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBusinessDraft> get serializer => _$VendorBusinessDraftSerializer();
}

class _$VendorBusinessDraftSerializer implements PrimitiveSerializer<VendorBusinessDraft> {
  @override
  final Iterable<Type> types = const [VendorBusinessDraft, _$VendorBusinessDraft];

  @override
  final String wireName = r'VendorBusinessDraft';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBusinessDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.legalName != null) {
      yield r'legal_name';
      yield serializers.serialize(
        object.legalName,
        specifiedType: const FullType(String),
      );
    }
    if (object.individualRegisteredName != null) {
      yield r'individual_registered_name';
      yield serializers.serialize(
        object.individualRegisteredName,
        specifiedType: const FullType.nullable(VendorIndividualRegisteredName),
      );
    }
    if (object.companyRegisteredName != null) {
      yield r'company_registered_name';
      yield serializers.serialize(
        object.companyRegisteredName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.governmentIdType != null) {
      yield r'government_id_type';
      yield serializers.serialize(
        object.governmentIdType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.governmentIdNumber != null) {
      yield r'government_id_number';
      yield serializers.serialize(
        object.governmentIdNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.storeName != null) {
      yield r'store_name';
      yield serializers.serialize(
        object.storeName,
        specifiedType: const FullType(String),
      );
    }
    if (object.establishedOn != null) {
      yield r'established_on';
      yield serializers.serialize(
        object.establishedOn,
        specifiedType: const FullType(String),
      );
    }
    if (object.storeEmail != null) {
      yield r'store_email';
      yield serializers.serialize(
        object.storeEmail,
        specifiedType: const FullType(String),
      );
    }
    if (object.storePhone != null) {
      yield r'store_phone';
      yield serializers.serialize(
        object.storePhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.businessType != null) {
      yield r'business_type';
      yield serializers.serialize(
        object.businessType,
        specifiedType: const FullType(VendorBusinessDraftBusinessTypeEnum),
      );
    }
    if (object.classification != null) {
      yield r'classification';
      yield serializers.serialize(
        object.classification,
        specifiedType: const FullType(VendorBusinessDraftClassificationEnum),
      );
    }
    if (object.niches != null) {
      yield r'niches';
      yield serializers.serialize(
        object.niches,
        specifiedType: const FullType(BuiltList, [FullType(VendorBusinessDraftNichesEnum)]),
      );
    }
    if (object.otherNiche != null) {
      yield r'other_niche';
      yield serializers.serialize(
        object.otherNiche,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(VendorBusinessAddress),
      );
    }
    if (object.contacts != null) {
      yield r'contacts';
      yield serializers.serialize(
        object.contacts,
        specifiedType: const FullType(BuiltList, [FullType(VendorBusinessContact)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBusinessDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBusinessDraftBuilder result,
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
        case r'individual_registered_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorIndividualRegisteredName),
          ) as VendorIndividualRegisteredName?;
          if (valueDes == null) continue;
          result.individualRegisteredName.replace(valueDes);
          break;
        case r'company_registered_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyRegisteredName = valueDes;
          break;
        case r'government_id_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.governmentIdType = valueDes;
          break;
        case r'government_id_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.governmentIdNumber = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeName = valueDes;
          break;
        case r'established_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.establishedOn = valueDes;
          break;
        case r'store_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeEmail = valueDes;
          break;
        case r'store_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storePhone = valueDes;
          break;
        case r'business_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorBusinessDraftBusinessTypeEnum),
          ) as VendorBusinessDraftBusinessTypeEnum?;
          if (valueDes == null) continue;
          result.businessType = valueDes;
          break;
        case r'classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorBusinessDraftClassificationEnum),
          ) as VendorBusinessDraftClassificationEnum?;
          if (valueDes == null) continue;
          result.classification = valueDes;
          break;
        case r'niches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(VendorBusinessDraftNichesEnum)]),
          ) as BuiltList<VendorBusinessDraftNichesEnum>?;
          if (valueDes == null) continue;
          result.niches.replace(valueDes);
          break;
        case r'other_niche':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otherNiche = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorBusinessAddress),
          ) as VendorBusinessAddress?;
          if (valueDes == null) continue;
          result.address.replace(valueDes);
          break;
        case r'contacts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(VendorBusinessContact)]),
          ) as BuiltList<VendorBusinessContact>?;
          if (valueDes == null) continue;
          result.contacts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBusinessDraft deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBusinessDraftBuilder();
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


class VendorBusinessDraftBusinessTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SOLE_PROPRIETORSHIP')
  static const VendorBusinessDraftBusinessTypeEnum SOLE_PROPRIETORSHIP = _$vendorBusinessDraftBusinessTypeEnum_SOLE_PROPRIETORSHIP;
  @BuiltValueEnumConst(wireName: r'PARTNERSHIP')
  static const VendorBusinessDraftBusinessTypeEnum PARTNERSHIP = _$vendorBusinessDraftBusinessTypeEnum_PARTNERSHIP;
  @BuiltValueEnumConst(wireName: r'CORPORATION')
  static const VendorBusinessDraftBusinessTypeEnum CORPORATION = _$vendorBusinessDraftBusinessTypeEnum_CORPORATION;
  @BuiltValueEnumConst(wireName: r'ONE_PERSON_CORPORATION')
  static const VendorBusinessDraftBusinessTypeEnum ONE_PERSON_CORPORATION = _$vendorBusinessDraftBusinessTypeEnum_ONE_PERSON_CORPORATION;
  @BuiltValueEnumConst(wireName: r'COOPERATIVE')
  static const VendorBusinessDraftBusinessTypeEnum COOPERATIVE = _$vendorBusinessDraftBusinessTypeEnum_COOPERATIVE;

  static Serializer<VendorBusinessDraftBusinessTypeEnum> get serializer => _$vendorBusinessDraftBusinessTypeEnumSerializer;

  const VendorBusinessDraftBusinessTypeEnum._(String name): super(name);

  static BuiltSet<VendorBusinessDraftBusinessTypeEnum> get values => _$vendorBusinessDraftBusinessTypeEnumValues;
  static VendorBusinessDraftBusinessTypeEnum valueOf(String name) => _$vendorBusinessDraftBusinessTypeEnumValueOf(name);
}

class VendorBusinessDraftClassificationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WHOLESALER_DISTRIBUTOR')
  static const VendorBusinessDraftClassificationEnum WHOLESALER_DISTRIBUTOR = _$vendorBusinessDraftClassificationEnum_WHOLESALER_DISTRIBUTOR;
  @BuiltValueEnumConst(wireName: r'RETAIL_HARDWARE_STORE')
  static const VendorBusinessDraftClassificationEnum RETAIL_HARDWARE_STORE = _$vendorBusinessDraftClassificationEnum_RETAIL_HARDWARE_STORE;
  @BuiltValueEnumConst(wireName: r'SPECIALIZED_SUPPLIER')
  static const VendorBusinessDraftClassificationEnum SPECIALIZED_SUPPLIER = _$vendorBusinessDraftClassificationEnum_SPECIALIZED_SUPPLIER;

  static Serializer<VendorBusinessDraftClassificationEnum> get serializer => _$vendorBusinessDraftClassificationEnumSerializer;

  const VendorBusinessDraftClassificationEnum._(String name): super(name);

  static BuiltSet<VendorBusinessDraftClassificationEnum> get values => _$vendorBusinessDraftClassificationEnumValues;
  static VendorBusinessDraftClassificationEnum valueOf(String name) => _$vendorBusinessDraftClassificationEnumValueOf(name);
}

class VendorBusinessDraftNichesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONSTRUCTION_MATERIALS')
  static const VendorBusinessDraftNichesEnum CONSTRUCTION_MATERIALS = _$vendorBusinessDraftNichesEnum_CONSTRUCTION_MATERIALS;
  @BuiltValueEnumConst(wireName: r'ELECTRICAL_SUPPLIES')
  static const VendorBusinessDraftNichesEnum ELECTRICAL_SUPPLIES = _$vendorBusinessDraftNichesEnum_ELECTRICAL_SUPPLIES;
  @BuiltValueEnumConst(wireName: r'PLUMBING_SANITARY')
  static const VendorBusinessDraftNichesEnum PLUMBING_SANITARY = _$vendorBusinessDraftNichesEnum_PLUMBING_SANITARY;
  @BuiltValueEnumConst(wireName: r'TOOLS_EQUIPMENT')
  static const VendorBusinessDraftNichesEnum TOOLS_EQUIPMENT = _$vendorBusinessDraftNichesEnum_TOOLS_EQUIPMENT;
  @BuiltValueEnumConst(wireName: r'FINISHING_MATERIALS')
  static const VendorBusinessDraftNichesEnum FINISHING_MATERIALS = _$vendorBusinessDraftNichesEnum_FINISHING_MATERIALS;
  @BuiltValueEnumConst(wireName: r'FASTENERS_HARDWARE')
  static const VendorBusinessDraftNichesEnum FASTENERS_HARDWARE = _$vendorBusinessDraftNichesEnum_FASTENERS_HARDWARE;
  @BuiltValueEnumConst(wireName: r'CEMENT_CONCRETE')
  static const VendorBusinessDraftNichesEnum CEMENT_CONCRETE = _$vendorBusinessDraftNichesEnum_CEMENT_CONCRETE;
  @BuiltValueEnumConst(wireName: r'ROOFING_MATERIALS')
  static const VendorBusinessDraftNichesEnum ROOFING_MATERIALS = _$vendorBusinessDraftNichesEnum_ROOFING_MATERIALS;
  @BuiltValueEnumConst(wireName: r'FORMWORKS_SCAFFOLDING')
  static const VendorBusinessDraftNichesEnum FORMWORKS_SCAFFOLDING = _$vendorBusinessDraftNichesEnum_FORMWORKS_SCAFFOLDING;
  @BuiltValueEnumConst(wireName: r'WOOD_LUMBER')
  static const VendorBusinessDraftNichesEnum WOOD_LUMBER = _$vendorBusinessDraftNichesEnum_WOOD_LUMBER;
  @BuiltValueEnumConst(wireName: r'LANDSCAPING_EXTERIOR')
  static const VendorBusinessDraftNichesEnum LANDSCAPING_EXTERIOR = _$vendorBusinessDraftNichesEnum_LANDSCAPING_EXTERIOR;
  @BuiltValueEnumConst(wireName: r'STEEL_REINFORCEMENT')
  static const VendorBusinessDraftNichesEnum STEEL_REINFORCEMENT = _$vendorBusinessDraftNichesEnum_STEEL_REINFORCEMENT;
  @BuiltValueEnumConst(wireName: r'TOOLS_ACCESSORIES')
  static const VendorBusinessDraftNichesEnum TOOLS_ACCESSORIES = _$vendorBusinessDraftNichesEnum_TOOLS_ACCESSORIES;
  @BuiltValueEnumConst(wireName: r'MASONRY')
  static const VendorBusinessDraftNichesEnum MASONRY = _$vendorBusinessDraftNichesEnum_MASONRY;
  @BuiltValueEnumConst(wireName: r'INSULATION_WATERPROOFING')
  static const VendorBusinessDraftNichesEnum INSULATION_WATERPROOFING = _$vendorBusinessDraftNichesEnum_INSULATION_WATERPROOFING;
  @BuiltValueEnumConst(wireName: r'AGGREGATES')
  static const VendorBusinessDraftNichesEnum AGGREGATES = _$vendorBusinessDraftNichesEnum_AGGREGATES;
  @BuiltValueEnumConst(wireName: r'DRAINAGE_SEPTIC')
  static const VendorBusinessDraftNichesEnum DRAINAGE_SEPTIC = _$vendorBusinessDraftNichesEnum_DRAINAGE_SEPTIC;
  @BuiltValueEnumConst(wireName: r'CONSTRUCTION_CHEMICALS')
  static const VendorBusinessDraftNichesEnum CONSTRUCTION_CHEMICALS = _$vendorBusinessDraftNichesEnum_CONSTRUCTION_CHEMICALS;
  @BuiltValueEnumConst(wireName: r'FLOORING_MATERIALS')
  static const VendorBusinessDraftNichesEnum FLOORING_MATERIALS = _$vendorBusinessDraftNichesEnum_FLOORING_MATERIALS;
  @BuiltValueEnumConst(wireName: r'WALL_CEILING')
  static const VendorBusinessDraftNichesEnum WALL_CEILING = _$vendorBusinessDraftNichesEnum_WALL_CEILING;
  @BuiltValueEnumConst(wireName: r'HVAC_MATERIALS')
  static const VendorBusinessDraftNichesEnum HVAC_MATERIALS = _$vendorBusinessDraftNichesEnum_HVAC_MATERIALS;
  @BuiltValueEnumConst(wireName: r'SANITARY_FIXTURES')
  static const VendorBusinessDraftNichesEnum SANITARY_FIXTURES = _$vendorBusinessDraftNichesEnum_SANITARY_FIXTURES;
  @BuiltValueEnumConst(wireName: r'FIRE_PROTECTION')
  static const VendorBusinessDraftNichesEnum FIRE_PROTECTION = _$vendorBusinessDraftNichesEnum_FIRE_PROTECTION;
  @BuiltValueEnumConst(wireName: r'PAINTS_FINISHES')
  static const VendorBusinessDraftNichesEnum PAINTS_FINISHES = _$vendorBusinessDraftNichesEnum_PAINTS_FINISHES;
  @BuiltValueEnumConst(wireName: r'ADHESIVES_SEALANTS')
  static const VendorBusinessDraftNichesEnum ADHESIVES_SEALANTS = _$vendorBusinessDraftNichesEnum_ADHESIVES_SEALANTS;
  @BuiltValueEnumConst(wireName: r'DOORS_WINDOWS_GLASS')
  static const VendorBusinessDraftNichesEnum DOORS_WINDOWS_GLASS = _$vendorBusinessDraftNichesEnum_DOORS_WINDOWS_GLASS;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const VendorBusinessDraftNichesEnum OTHER = _$vendorBusinessDraftNichesEnum_OTHER;

  static Serializer<VendorBusinessDraftNichesEnum> get serializer => _$vendorBusinessDraftNichesEnumSerializer;

  const VendorBusinessDraftNichesEnum._(String name): super(name);

  static BuiltSet<VendorBusinessDraftNichesEnum> get values => _$vendorBusinessDraftNichesEnumValues;
  static VendorBusinessDraftNichesEnum valueOf(String name) => _$vendorBusinessDraftNichesEnumValueOf(name);
}

