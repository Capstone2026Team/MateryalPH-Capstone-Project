//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_request_create.g.dart';

/// InvoiceRequestCreate
///
/// Properties:
/// * [kind]
/// * [details]
/// * [invoiceRecordId]
@BuiltValue()
abstract class InvoiceRequestCreate implements Built<InvoiceRequestCreate, InvoiceRequestCreateBuilder> {
  @BuiltValueField(wireName: r'kind')
  InvoiceRequestCreateKindEnum get kind;
  // enum kindEnum {  COPY,  CORRECTION,  };

  @BuiltValueField(wireName: r'details')
  String get details;

  @BuiltValueField(wireName: r'invoice_record_id')
  String? get invoiceRecordId;

  InvoiceRequestCreate._();

  factory InvoiceRequestCreate([void updates(InvoiceRequestCreateBuilder b)]) = _$InvoiceRequestCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceRequestCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceRequestCreate> get serializer => _$InvoiceRequestCreateSerializer();
}

class _$InvoiceRequestCreateSerializer implements PrimitiveSerializer<InvoiceRequestCreate> {
  @override
  final Iterable<Type> types = const [InvoiceRequestCreate, _$InvoiceRequestCreate];

  @override
  final String wireName = r'InvoiceRequestCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceRequestCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(InvoiceRequestCreateKindEnum),
    );
    yield r'details';
    yield serializers.serialize(
      object.details,
      specifiedType: const FullType(String),
    );
    if (object.invoiceRecordId != null) {
      yield r'invoice_record_id';
      yield serializers.serialize(
        object.invoiceRecordId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceRequestCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceRequestCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRequestCreateKindEnum),
          ) as InvoiceRequestCreateKindEnum;
          result.kind = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.details = valueDes;
          break;
        case r'invoice_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoiceRecordId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceRequestCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceRequestCreateBuilder();
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


class InvoiceRequestCreateKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COPY')
  static const InvoiceRequestCreateKindEnum COPY = _$invoiceRequestCreateKindEnum_COPY;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const InvoiceRequestCreateKindEnum CORRECTION = _$invoiceRequestCreateKindEnum_CORRECTION;

  static Serializer<InvoiceRequestCreateKindEnum> get serializer => _$invoiceRequestCreateKindEnumSerializer;

  const InvoiceRequestCreateKindEnum._(String name): super(name);

  static BuiltSet<InvoiceRequestCreateKindEnum> get values => _$invoiceRequestCreateKindEnumValues;
  static InvoiceRequestCreateKindEnum valueOf(String name) => _$invoiceRequestCreateKindEnumValueOf(name);
}

