//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_invoice_preset.g.dart';

/// VendorInvoicePreset
///
/// Properties:
/// * [invoiceType]
/// * [issuerName] - Must equal the registered business name.
/// * [sourceSystem]
/// * [invoicingMethod]
/// * [lockVersion] - Current lock version; zero creates a new draft or preset.
/// * [dateMode] - New copies start with today in Asia/Manila. Each invoice date remains editable; numbers and amounts are never preset.
@BuiltValue()
abstract class VendorInvoicePreset implements Built<VendorInvoicePreset, VendorInvoicePresetBuilder> {
  @BuiltValueField(wireName: r'invoice_type')
  VendorInvoicePresetInvoiceTypeEnum get invoiceType;
  // enum invoiceTypeEnum {  VENDOR_GOODS_INVOICE,  VENDOR_ADJUSTMENT_DOCUMENT,  };

  /// Must equal the registered business name.
  @BuiltValueField(wireName: r'issuer_name')
  String get issuerName;

  @BuiltValueField(wireName: r'source_system')
  VendorInvoicePresetSourceSystemEnum get sourceSystem;
  // enum sourceSystemEnum {  REGISTERED_CAS,  BIR_EIS,  LOOSE_LEAF_OR_PRINTED,  OTHER_REGISTERED,  };

  @BuiltValueField(wireName: r'invoicing_method')
  VendorInvoicePresetInvoicingMethodEnum get invoicingMethod;
  // enum invoicingMethodEnum {  ELECTRONIC,  COMPUTERIZED,  MANUAL,  };

  /// Current lock version; zero creates a new draft or preset.
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  /// New copies start with today in Asia/Manila. Each invoice date remains editable; numbers and amounts are never preset.
  @BuiltValueField(wireName: r'date_mode')
  VendorInvoicePresetDateModeEnum get dateMode;
  // enum dateModeEnum {  TODAY,  };

  VendorInvoicePreset._();

  factory VendorInvoicePreset([void updates(VendorInvoicePresetBuilder b)]) = _$VendorInvoicePreset;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorInvoicePresetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorInvoicePreset> get serializer => _$VendorInvoicePresetSerializer();
}

class _$VendorInvoicePresetSerializer implements PrimitiveSerializer<VendorInvoicePreset> {
  @override
  final Iterable<Type> types = const [VendorInvoicePreset, _$VendorInvoicePreset];

  @override
  final String wireName = r'VendorInvoicePreset';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorInvoicePreset object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'invoice_type';
    yield serializers.serialize(
      object.invoiceType,
      specifiedType: const FullType(VendorInvoicePresetInvoiceTypeEnum),
    );
    yield r'issuer_name';
    yield serializers.serialize(
      object.issuerName,
      specifiedType: const FullType(String),
    );
    yield r'source_system';
    yield serializers.serialize(
      object.sourceSystem,
      specifiedType: const FullType(VendorInvoicePresetSourceSystemEnum),
    );
    yield r'invoicing_method';
    yield serializers.serialize(
      object.invoicingMethod,
      specifiedType: const FullType(VendorInvoicePresetInvoicingMethodEnum),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'date_mode';
    yield serializers.serialize(
      object.dateMode,
      specifiedType: const FullType(VendorInvoicePresetDateModeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorInvoicePreset object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorInvoicePresetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'invoice_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorInvoicePresetInvoiceTypeEnum),
          ) as VendorInvoicePresetInvoiceTypeEnum;
          result.invoiceType = valueDes;
          break;
        case r'issuer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuerName = valueDes;
          break;
        case r'source_system':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorInvoicePresetSourceSystemEnum),
          ) as VendorInvoicePresetSourceSystemEnum;
          result.sourceSystem = valueDes;
          break;
        case r'invoicing_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorInvoicePresetInvoicingMethodEnum),
          ) as VendorInvoicePresetInvoicingMethodEnum;
          result.invoicingMethod = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'date_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorInvoicePresetDateModeEnum),
          ) as VendorInvoicePresetDateModeEnum;
          result.dateMode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorInvoicePreset deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorInvoicePresetBuilder();
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


class VendorInvoicePresetInvoiceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_GOODS_INVOICE')
  static const VendorInvoicePresetInvoiceTypeEnum VENDOR_GOODS_INVOICE = _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
  @BuiltValueEnumConst(wireName: r'VENDOR_ADJUSTMENT_DOCUMENT')
  static const VendorInvoicePresetInvoiceTypeEnum VENDOR_ADJUSTMENT_DOCUMENT = _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;

  static Serializer<VendorInvoicePresetInvoiceTypeEnum> get serializer => _$vendorInvoicePresetInvoiceTypeEnumSerializer;

  const VendorInvoicePresetInvoiceTypeEnum._(String name): super(name);

  static BuiltSet<VendorInvoicePresetInvoiceTypeEnum> get values => _$vendorInvoicePresetInvoiceTypeEnumValues;
  static VendorInvoicePresetInvoiceTypeEnum valueOf(String name) => _$vendorInvoicePresetInvoiceTypeEnumValueOf(name);
}

class VendorInvoicePresetSourceSystemEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REGISTERED_CAS')
  static const VendorInvoicePresetSourceSystemEnum REGISTERED_CAS = _$vendorInvoicePresetSourceSystemEnum_REGISTERED_CAS;
  @BuiltValueEnumConst(wireName: r'BIR_EIS')
  static const VendorInvoicePresetSourceSystemEnum BIR_EIS = _$vendorInvoicePresetSourceSystemEnum_BIR_EIS;
  @BuiltValueEnumConst(wireName: r'LOOSE_LEAF_OR_PRINTED')
  static const VendorInvoicePresetSourceSystemEnum LOOSE_LEAF_OR_PRINTED = _$vendorInvoicePresetSourceSystemEnum_LOOSE_LEAF_OR_PRINTED;
  @BuiltValueEnumConst(wireName: r'OTHER_REGISTERED')
  static const VendorInvoicePresetSourceSystemEnum OTHER_REGISTERED = _$vendorInvoicePresetSourceSystemEnum_OTHER_REGISTERED;

  static Serializer<VendorInvoicePresetSourceSystemEnum> get serializer => _$vendorInvoicePresetSourceSystemEnumSerializer;

  const VendorInvoicePresetSourceSystemEnum._(String name): super(name);

  static BuiltSet<VendorInvoicePresetSourceSystemEnum> get values => _$vendorInvoicePresetSourceSystemEnumValues;
  static VendorInvoicePresetSourceSystemEnum valueOf(String name) => _$vendorInvoicePresetSourceSystemEnumValueOf(name);
}

class VendorInvoicePresetInvoicingMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ELECTRONIC')
  static const VendorInvoicePresetInvoicingMethodEnum ELECTRONIC = _$vendorInvoicePresetInvoicingMethodEnum_ELECTRONIC;
  @BuiltValueEnumConst(wireName: r'COMPUTERIZED')
  static const VendorInvoicePresetInvoicingMethodEnum COMPUTERIZED = _$vendorInvoicePresetInvoicingMethodEnum_COMPUTERIZED;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const VendorInvoicePresetInvoicingMethodEnum MANUAL = _$vendorInvoicePresetInvoicingMethodEnum_MANUAL;

  static Serializer<VendorInvoicePresetInvoicingMethodEnum> get serializer => _$vendorInvoicePresetInvoicingMethodEnumSerializer;

  const VendorInvoicePresetInvoicingMethodEnum._(String name): super(name);

  static BuiltSet<VendorInvoicePresetInvoicingMethodEnum> get values => _$vendorInvoicePresetInvoicingMethodEnumValues;
  static VendorInvoicePresetInvoicingMethodEnum valueOf(String name) => _$vendorInvoicePresetInvoicingMethodEnumValueOf(name);
}

/// New copies start with today in Asia/Manila. Each invoice date remains editable; numbers and amounts are never preset.
class VendorInvoicePresetDateModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TODAY')
  static const VendorInvoicePresetDateModeEnum TODAY = _$vendorInvoicePresetDateModeEnum_TODAY;

  static Serializer<VendorInvoicePresetDateModeEnum> get serializer => _$vendorInvoicePresetDateModeEnumSerializer;

  const VendorInvoicePresetDateModeEnum._(String name): super(name);

  static BuiltSet<VendorInvoicePresetDateModeEnum> get values => _$vendorInvoicePresetDateModeEnumValues;
  static VendorInvoicePresetDateModeEnum valueOf(String name) => _$vendorInvoicePresetDateModeEnumValueOf(name);
}

