//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_preset_input.g.dart';

/// InvoicePresetInput
///
/// Properties:
/// * [invoiceType]
/// * [issuerName] - Must equal the registered business name.
/// * [sourceSystem]
/// * [invoicingMethod]
/// * [lockVersion] - Current lock version; zero creates a new draft or preset.
@BuiltValue()
abstract class InvoicePresetInput implements Built<InvoicePresetInput, InvoicePresetInputBuilder> {
  @BuiltValueField(wireName: r'invoice_type')
  InvoicePresetInputInvoiceTypeEnum get invoiceType;
  // enum invoiceTypeEnum {  VENDOR_GOODS_INVOICE,  VENDOR_ADJUSTMENT_DOCUMENT,  };

  /// Must equal the registered business name.
  @BuiltValueField(wireName: r'issuer_name')
  String get issuerName;

  @BuiltValueField(wireName: r'source_system')
  InvoicePresetInputSourceSystemEnum get sourceSystem;
  // enum sourceSystemEnum {  REGISTERED_CAS,  BIR_EIS,  LOOSE_LEAF_OR_PRINTED,  OTHER_REGISTERED,  };

  @BuiltValueField(wireName: r'invoicing_method')
  InvoicePresetInputInvoicingMethodEnum get invoicingMethod;
  // enum invoicingMethodEnum {  ELECTRONIC,  COMPUTERIZED,  MANUAL,  };

  /// Current lock version; zero creates a new draft or preset.
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  InvoicePresetInput._();

  factory InvoicePresetInput([void updates(InvoicePresetInputBuilder b)]) = _$InvoicePresetInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoicePresetInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoicePresetInput> get serializer => _$InvoicePresetInputSerializer();
}

class _$InvoicePresetInputSerializer implements PrimitiveSerializer<InvoicePresetInput> {
  @override
  final Iterable<Type> types = const [InvoicePresetInput, _$InvoicePresetInput];

  @override
  final String wireName = r'InvoicePresetInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoicePresetInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'invoice_type';
    yield serializers.serialize(
      object.invoiceType,
      specifiedType: const FullType(InvoicePresetInputInvoiceTypeEnum),
    );
    yield r'issuer_name';
    yield serializers.serialize(
      object.issuerName,
      specifiedType: const FullType(String),
    );
    yield r'source_system';
    yield serializers.serialize(
      object.sourceSystem,
      specifiedType: const FullType(InvoicePresetInputSourceSystemEnum),
    );
    yield r'invoicing_method';
    yield serializers.serialize(
      object.invoicingMethod,
      specifiedType: const FullType(InvoicePresetInputInvoicingMethodEnum),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoicePresetInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoicePresetInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'invoice_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoicePresetInputInvoiceTypeEnum),
          ) as InvoicePresetInputInvoiceTypeEnum;
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
            specifiedType: const FullType(InvoicePresetInputSourceSystemEnum),
          ) as InvoicePresetInputSourceSystemEnum;
          result.sourceSystem = valueDes;
          break;
        case r'invoicing_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoicePresetInputInvoicingMethodEnum),
          ) as InvoicePresetInputInvoicingMethodEnum;
          result.invoicingMethod = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoicePresetInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoicePresetInputBuilder();
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


class InvoicePresetInputInvoiceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_GOODS_INVOICE')
  static const InvoicePresetInputInvoiceTypeEnum VENDOR_GOODS_INVOICE = _$invoicePresetInputInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
  @BuiltValueEnumConst(wireName: r'VENDOR_ADJUSTMENT_DOCUMENT')
  static const InvoicePresetInputInvoiceTypeEnum VENDOR_ADJUSTMENT_DOCUMENT = _$invoicePresetInputInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;

  static Serializer<InvoicePresetInputInvoiceTypeEnum> get serializer => _$invoicePresetInputInvoiceTypeEnumSerializer;

  const InvoicePresetInputInvoiceTypeEnum._(String name): super(name);

  static BuiltSet<InvoicePresetInputInvoiceTypeEnum> get values => _$invoicePresetInputInvoiceTypeEnumValues;
  static InvoicePresetInputInvoiceTypeEnum valueOf(String name) => _$invoicePresetInputInvoiceTypeEnumValueOf(name);
}

class InvoicePresetInputSourceSystemEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REGISTERED_CAS')
  static const InvoicePresetInputSourceSystemEnum REGISTERED_CAS = _$invoicePresetInputSourceSystemEnum_REGISTERED_CAS;
  @BuiltValueEnumConst(wireName: r'BIR_EIS')
  static const InvoicePresetInputSourceSystemEnum BIR_EIS = _$invoicePresetInputSourceSystemEnum_BIR_EIS;
  @BuiltValueEnumConst(wireName: r'LOOSE_LEAF_OR_PRINTED')
  static const InvoicePresetInputSourceSystemEnum LOOSE_LEAF_OR_PRINTED = _$invoicePresetInputSourceSystemEnum_LOOSE_LEAF_OR_PRINTED;
  @BuiltValueEnumConst(wireName: r'OTHER_REGISTERED')
  static const InvoicePresetInputSourceSystemEnum OTHER_REGISTERED = _$invoicePresetInputSourceSystemEnum_OTHER_REGISTERED;

  static Serializer<InvoicePresetInputSourceSystemEnum> get serializer => _$invoicePresetInputSourceSystemEnumSerializer;

  const InvoicePresetInputSourceSystemEnum._(String name): super(name);

  static BuiltSet<InvoicePresetInputSourceSystemEnum> get values => _$invoicePresetInputSourceSystemEnumValues;
  static InvoicePresetInputSourceSystemEnum valueOf(String name) => _$invoicePresetInputSourceSystemEnumValueOf(name);
}

class InvoicePresetInputInvoicingMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ELECTRONIC')
  static const InvoicePresetInputInvoicingMethodEnum ELECTRONIC = _$invoicePresetInputInvoicingMethodEnum_ELECTRONIC;
  @BuiltValueEnumConst(wireName: r'COMPUTERIZED')
  static const InvoicePresetInputInvoicingMethodEnum COMPUTERIZED = _$invoicePresetInputInvoicingMethodEnum_COMPUTERIZED;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const InvoicePresetInputInvoicingMethodEnum MANUAL = _$invoicePresetInputInvoicingMethodEnum_MANUAL;

  static Serializer<InvoicePresetInputInvoicingMethodEnum> get serializer => _$invoicePresetInputInvoicingMethodEnumSerializer;

  const InvoicePresetInputInvoicingMethodEnum._(String name): super(name);

  static BuiltSet<InvoicePresetInputInvoicingMethodEnum> get values => _$invoicePresetInputInvoicingMethodEnumValues;
  static InvoicePresetInputInvoicingMethodEnum valueOf(String name) => _$invoicePresetInputInvoicingMethodEnumValueOf(name);
}

