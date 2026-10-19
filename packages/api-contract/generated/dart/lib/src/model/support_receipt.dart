//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/support_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_receipt.g.dart';

/// SupportReceipt
///
/// Properties:
/// * [id]
/// * [ticketNumber]
/// * [status]
@BuiltValue()
abstract class SupportReceipt implements Built<SupportReceipt, SupportReceiptBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'ticket_number')
  String get ticketNumber;

  @BuiltValueField(wireName: r'status')
  SupportStatus get status;
  // enum statusEnum {  OPEN,  IN_PROGRESS,  WAITING_FOR_USER,  RESOLVED,  CLOSED,  };

  SupportReceipt._();

  factory SupportReceipt([void updates(SupportReceiptBuilder b)]) = _$SupportReceipt;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportReceiptBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportReceipt> get serializer => _$SupportReceiptSerializer();
}

class _$SupportReceiptSerializer implements PrimitiveSerializer<SupportReceipt> {
  @override
  final Iterable<Type> types = const [SupportReceipt, _$SupportReceipt];

  @override
  final String wireName = r'SupportReceipt';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ticket_number';
    yield serializers.serialize(
      object.ticketNumber,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SupportStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportReceiptBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'ticket_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketNumber = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportStatus),
          ) as SupportStatus;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportReceipt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportReceiptBuilder();
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


