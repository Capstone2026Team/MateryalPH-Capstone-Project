//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/invoice_billing_snapshot.dart';
import 'package:materyalph_api_client/src/model/invoice_order_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_order_summary.g.dart';

/// Accepted order values and billing facts for context, excluding Buyer processing fees and full TIN. Not extracted invoice prices or newly computed tax. Snapshotted when a copy is sent; VAT is included, never added again.
///
/// Properties:
/// * [lines]
/// * [billingDetails]
/// * [materialsSubtotalCentavos]
/// * [discountCentavos]
/// * [deliveryCentavos]
/// * [includedVatCentavos]
/// * [totalCentavos]
@BuiltValue()
abstract class InvoiceOrderSummary implements Built<InvoiceOrderSummary, InvoiceOrderSummaryBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<InvoiceOrderLine> get lines;

  @BuiltValueField(wireName: r'billing_details')
  InvoiceBillingSnapshot? get billingDetails;

  @BuiltValueField(wireName: r'materials_subtotal_centavos')
  int? get materialsSubtotalCentavos;

  @BuiltValueField(wireName: r'discount_centavos')
  int? get discountCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int? get includedVatCentavos;

  @BuiltValueField(wireName: r'total_centavos')
  int? get totalCentavos;

  InvoiceOrderSummary._();

  factory InvoiceOrderSummary([void updates(InvoiceOrderSummaryBuilder b)]) = _$InvoiceOrderSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceOrderSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceOrderSummary> get serializer => _$InvoiceOrderSummarySerializer();
}

class _$InvoiceOrderSummarySerializer implements PrimitiveSerializer<InvoiceOrderSummary> {
  @override
  final Iterable<Type> types = const [InvoiceOrderSummary, _$InvoiceOrderSummary];

  @override
  final String wireName = r'InvoiceOrderSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceOrderSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(InvoiceOrderLine)]),
    );
    if (object.billingDetails != null) {
      yield r'billing_details';
      yield serializers.serialize(
        object.billingDetails,
        specifiedType: const FullType.nullable(InvoiceBillingSnapshot),
      );
    }
    yield r'materials_subtotal_centavos';
    yield object.materialsSubtotalCentavos == null ? null : serializers.serialize(
      object.materialsSubtotalCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'discount_centavos';
    yield object.discountCentavos == null ? null : serializers.serialize(
      object.discountCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'delivery_centavos';
    yield object.deliveryCentavos == null ? null : serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'included_vat_centavos';
    yield object.includedVatCentavos == null ? null : serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'total_centavos';
    yield object.totalCentavos == null ? null : serializers.serialize(
      object.totalCentavos,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceOrderSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceOrderSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvoiceOrderLine)]),
          ) as BuiltList<InvoiceOrderLine>;
          result.lines.replace(valueDes);
          break;
        case r'billing_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InvoiceBillingSnapshot),
          ) as InvoiceBillingSnapshot?;
          if (valueDes == null) continue;
          result.billingDetails.replace(valueDes);
          break;
        case r'materials_subtotal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.materialsSubtotalCentavos = valueDes;
          break;
        case r'discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.discountCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.includedVatCentavos = valueDes;
          break;
        case r'total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceOrderSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceOrderSummaryBuilder();
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


