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
@BuiltValue()
abstract class InvoiceOrderLine implements Built<InvoiceOrderLine, InvoiceOrderLineBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

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


