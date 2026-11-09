//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statement_invoice_update_request.g.dart';

/// StatementInvoiceUpdateRequest
///
/// Properties:
/// * [lockVersion]
/// * [invoiceHeading]
/// * [invoiceMessage]
@BuiltValue()
abstract class StatementInvoiceUpdateRequest implements Built<StatementInvoiceUpdateRequest, StatementInvoiceUpdateRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'invoice_heading')
  String get invoiceHeading;

  @BuiltValueField(wireName: r'invoice_message')
  String? get invoiceMessage;

  StatementInvoiceUpdateRequest._();

  factory StatementInvoiceUpdateRequest([void updates(StatementInvoiceUpdateRequestBuilder b)]) = _$StatementInvoiceUpdateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatementInvoiceUpdateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatementInvoiceUpdateRequest> get serializer => _$StatementInvoiceUpdateRequestSerializer();
}

class _$StatementInvoiceUpdateRequestSerializer implements PrimitiveSerializer<StatementInvoiceUpdateRequest> {
  @override
  final Iterable<Type> types = const [StatementInvoiceUpdateRequest, _$StatementInvoiceUpdateRequest];

  @override
  final String wireName = r'StatementInvoiceUpdateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatementInvoiceUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'invoice_heading';
    yield serializers.serialize(
      object.invoiceHeading,
      specifiedType: const FullType(String),
    );
    yield r'invoice_message';
    yield object.invoiceMessage == null ? null : serializers.serialize(
      object.invoiceMessage,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StatementInvoiceUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatementInvoiceUpdateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'invoice_heading':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceHeading = valueDes;
          break;
        case r'invoice_message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoiceMessage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatementInvoiceUpdateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatementInvoiceUpdateRequestBuilder();
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


