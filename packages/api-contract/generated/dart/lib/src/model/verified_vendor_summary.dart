//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/supplier_open_status.dart';
import 'package:materyalph_api_client/src/model/public_address_summary.dart';
import 'package:materyalph_api_client/src/model/supplier_serviceability.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'verified_vendor_summary.g.dart';

/// VerifiedVendorSummary
///
/// Properties:
/// * [logoUrl]
/// * [supplierType]
/// * [niches]
/// * [fulfillmentMethod]
/// * [vacationMode]
/// * [publicPhone]
/// * [address]
/// * [openStatus]
/// * [serviceability]
@BuiltValue()
abstract class VerifiedVendorSummary implements Built<VerifiedVendorSummary, VerifiedVendorSummaryBuilder> {
  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  @BuiltValueField(wireName: r'supplier_type')
  String? get supplierType;

  @BuiltValueField(wireName: r'niches')
  BuiltList<String> get niches;

  @BuiltValueField(wireName: r'fulfillment_method')
  String? get fulfillmentMethod;

  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

  @BuiltValueField(wireName: r'public_phone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'address')
  PublicAddressSummary get address;

  @BuiltValueField(wireName: r'open_status')
  SupplierOpenStatus get openStatus;

  @BuiltValueField(wireName: r'serviceability')
  SupplierServiceability get serviceability;

  VerifiedVendorSummary._();

  factory VerifiedVendorSummary([void updates(VerifiedVendorSummaryBuilder b)]) = _$VerifiedVendorSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VerifiedVendorSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VerifiedVendorSummary> get serializer => _$VerifiedVendorSummarySerializer();
}

class _$VerifiedVendorSummarySerializer implements PrimitiveSerializer<VerifiedVendorSummary> {
  @override
  final Iterable<Type> types = const [VerifiedVendorSummary, _$VerifiedVendorSummary];

  @override
  final String wireName = r'VerifiedVendorSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VerifiedVendorSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'logo_url';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'supplier_type';
    yield object.supplierType == null ? null : serializers.serialize(
      object.supplierType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'niches';
    yield serializers.serialize(
      object.niches,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'fulfillment_method';
    yield object.fulfillmentMethod == null ? null : serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
    );
    yield r'public_phone';
    yield object.publicPhone == null ? null : serializers.serialize(
      object.publicPhone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(PublicAddressSummary),
    );
    yield r'open_status';
    yield serializers.serialize(
      object.openStatus,
      specifiedType: const FullType(SupplierOpenStatus),
    );
    yield r'serviceability';
    yield serializers.serialize(
      object.serviceability,
      specifiedType: const FullType(SupplierServiceability),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VerifiedVendorSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VerifiedVendorSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'logo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'supplier_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierType = valueDes;
          break;
        case r'niches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.niches.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
          break;
        case r'public_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicPhone = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicAddressSummary),
          ) as PublicAddressSummary;
          result.address.replace(valueDes);
          break;
        case r'open_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierOpenStatus),
          ) as SupplierOpenStatus;
          result.openStatus.replace(valueDes);
          break;
        case r'serviceability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierServiceability),
          ) as SupplierServiceability;
          result.serviceability.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VerifiedVendorSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VerifiedVendorSummaryBuilder();
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


