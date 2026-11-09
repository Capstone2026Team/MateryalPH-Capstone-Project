//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_order_line.g.dart';

/// InvoiceOrderLine
///
/// Properties:
/// * [orderLineId]
/// * [displayName]
/// * [category]
/// * [quantity]
/// * [unitName]
/// * [unitPriceCentavos]
/// * [lineTotalCentavos]
@BuiltValue()
abstract class InvoiceOrderLine implements Built<InvoiceOrderLine, InvoiceOrderLineBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'quantity')
  String? get quantity;

  @BuiltValueField(wireName: r'unit_name')
  String? get unitName;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int? get unitPriceCentavos;

  @BuiltValueField(wireName: r'line_total_centavos')
  int? get lineTotalCentavos;

  InvoiceOrderLine._();

  factory InvoiceOrderLine([void updates(InvoiceOrderLineBuilder b)]) = _$InvoiceOrderLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceOrderLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceOrderLine> get serializer => _$InvoiceOrderLineSerializer();
}

class _$InvoiceOrderLineSerializer implements PrimitiveSerializer<InvoiceOrderLine> {
  @override
  final Iterable<Type> types = const [InvoiceOrderLine, _$InvoiceOrderLine];

  @override
  final String wireName = r'InvoiceOrderLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceOrderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.quantity != null) {
      yield r'quantity';
      yield serializers.serialize(
        object.quantity,
        specifiedType: const FullType(String),
      );
    }
    if (object.unitName != null) {
      yield r'unit_name';
      yield serializers.serialize(
        object.unitName,
        specifiedType: const FullType(String),
      );
    }
    if (object.unitPriceCentavos != null) {
      yield r'unit_price_centavos';
      yield serializers.serialize(
        object.unitPriceCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.lineTotalCentavos != null) {
      yield r'line_total_centavos';
      yield serializers.serialize(
        object.lineTotalCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceOrderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceOrderLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderLineId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.quantity = valueDes;
          break;
        case r'unit_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitName = valueDes;
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.unitPriceCentavos = valueDes;
          break;
        case r'line_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lineTotalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceOrderLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceOrderLineBuilder();
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


