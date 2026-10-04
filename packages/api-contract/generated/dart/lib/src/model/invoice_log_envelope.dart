//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/invoice_log_row.dart';
import 'package:materyalph_api_client/src/model/invoice_list_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_log_envelope.g.dart';

/// InvoiceLogEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class InvoiceLogEnvelope implements Built<InvoiceLogEnvelope, InvoiceLogEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<InvoiceLogRow> get data;

  @BuiltValueField(wireName: r'meta')
  InvoiceListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  InvoiceLogEnvelope._();

  factory InvoiceLogEnvelope([void updates(InvoiceLogEnvelopeBuilder b)]) = _$InvoiceLogEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceLogEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceLogEnvelope> get serializer => _$InvoiceLogEnvelopeSerializer();
}

class _$InvoiceLogEnvelopeSerializer implements PrimitiveSerializer<InvoiceLogEnvelope> {
  @override
  final Iterable<Type> types = const [InvoiceLogEnvelope, _$InvoiceLogEnvelope];

  @override
  final String wireName = r'InvoiceLogEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceLogEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(InvoiceLogRow)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(InvoiceListMeta),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceLogEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceLogEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvoiceLogRow)]),
          ) as BuiltList<InvoiceLogRow>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceListMeta),
          ) as InvoiceListMeta;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceLogEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceLogEnvelopeBuilder();
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


