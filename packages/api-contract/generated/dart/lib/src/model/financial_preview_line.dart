//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'financial_preview_line.g.dart';

/// FinancialPreviewLine
///
/// Properties:
/// * [lineId]
/// * [payableCentavos]
/// * [includedVatCentavos]
/// * [taxCategory]
@BuiltValue()
abstract class FinancialPreviewLine implements Built<FinancialPreviewLine, FinancialPreviewLineBuilder> {
  @BuiltValueField(wireName: r'line_id')
  String get lineId;

  @BuiltValueField(wireName: r'payable_centavos')
  int get payableCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'tax_category')
  FinancialPreviewLineTaxCategoryEnum get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  FinancialPreviewLine._();

  factory FinancialPreviewLine([void updates(FinancialPreviewLineBuilder b)]) = _$FinancialPreviewLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinancialPreviewLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinancialPreviewLine> get serializer => _$FinancialPreviewLineSerializer();
}

class _$FinancialPreviewLineSerializer implements PrimitiveSerializer<FinancialPreviewLine> {
  @override
  final Iterable<Type> types = const [FinancialPreviewLine, _$FinancialPreviewLine];

  @override
  final String wireName = r'FinancialPreviewLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinancialPreviewLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line_id';
    yield serializers.serialize(
      object.lineId,
      specifiedType: const FullType(String),
    );
    yield r'payable_centavos';
    yield serializers.serialize(
      object.payableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(FinancialPreviewLineTaxCategoryEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinancialPreviewLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinancialPreviewLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lineId = valueDes;
          break;
        case r'payable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payableCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancialPreviewLineTaxCategoryEnum),
          ) as FinancialPreviewLineTaxCategoryEnum;
          result.taxCategory = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinancialPreviewLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinancialPreviewLineBuilder();
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


class FinancialPreviewLineTaxCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT_12')
  static const FinancialPreviewLineTaxCategoryEnum VAT_12 = _$financialPreviewLineTaxCategoryEnum_VAT_12;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const FinancialPreviewLineTaxCategoryEnum VAT_ZERO = _$financialPreviewLineTaxCategoryEnum_VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const FinancialPreviewLineTaxCategoryEnum VAT_EXEMPT = _$financialPreviewLineTaxCategoryEnum_VAT_EXEMPT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const FinancialPreviewLineTaxCategoryEnum NON_VAT = _$financialPreviewLineTaxCategoryEnum_NON_VAT;

  static Serializer<FinancialPreviewLineTaxCategoryEnum> get serializer => _$financialPreviewLineTaxCategoryEnumSerializer;

  const FinancialPreviewLineTaxCategoryEnum._(String name): super(name);

  static BuiltSet<FinancialPreviewLineTaxCategoryEnum> get values => _$financialPreviewLineTaxCategoryEnumValues;
  static FinancialPreviewLineTaxCategoryEnum valueOf(String name) => _$financialPreviewLineTaxCategoryEnumValueOf(name);
}

