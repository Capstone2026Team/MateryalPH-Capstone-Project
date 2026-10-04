//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_explanation_request.g.dart';

/// InvoiceExplanationRequest
///
/// Properties:
/// * [note]
@BuiltValue()
abstract class InvoiceExplanationRequest implements Built<InvoiceExplanationRequest, InvoiceExplanationRequestBuilder> {
  @BuiltValueField(wireName: r'note')
  String get note;

  InvoiceExplanationRequest._();

  factory InvoiceExplanationRequest([void updates(InvoiceExplanationRequestBuilder b)]) = _$InvoiceExplanationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceExplanationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceExplanationRequest> get serializer => _$InvoiceExplanationRequestSerializer();
}

class _$InvoiceExplanationRequestSerializer implements PrimitiveSerializer<InvoiceExplanationRequest> {
  @override
  final Iterable<Type> types = const [InvoiceExplanationRequest, _$InvoiceExplanationRequest];

  @override
  final String wireName = r'InvoiceExplanationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceExplanationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceExplanationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceExplanationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceExplanationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceExplanationRequestBuilder();
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


