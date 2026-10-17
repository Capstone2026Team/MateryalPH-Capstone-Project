//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_dispute_ref.g.dart';

/// OrderDisputeRef
///
/// Properties:
/// * [caseId]
/// * [reference]
/// * [status]
/// * [filedByParty]
/// * [filingAvailable]
/// * [filingNote]
@BuiltValue()
abstract class OrderDisputeRef implements Built<OrderDisputeRef, OrderDisputeRefBuilder> {
  @BuiltValueField(wireName: r'case_id')
  String get caseId;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'status')
  OrderDisputeRefStatusEnum get status;
  // enum statusEnum {  OPEN_AWAITING_RESPONSE,  MUTUAL_RESOLUTION,  ESCALATED_ADMIN_REVIEW,  AWAITING_CLARIFICATION,  DECIDED,  APPEAL_OPEN,  RESOLVED,  CLOSED_INCONCLUSIVE,  };

  @BuiltValueField(wireName: r'filed_by_party')
  OrderDisputeRefFiledByPartyEnum get filedByParty;
  // enum filedByPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'filing_available')
  bool? get filingAvailable;

  @BuiltValueField(wireName: r'filing_note')
  String? get filingNote;

  OrderDisputeRef._();

  factory OrderDisputeRef([void updates(OrderDisputeRefBuilder b)]) = _$OrderDisputeRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDisputeRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDisputeRef> get serializer => _$OrderDisputeRefSerializer();
}

class _$OrderDisputeRefSerializer implements PrimitiveSerializer<OrderDisputeRef> {
  @override
  final Iterable<Type> types = const [OrderDisputeRef, _$OrderDisputeRef];

  @override
  final String wireName = r'OrderDisputeRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDisputeRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'case_id';
    yield serializers.serialize(
      object.caseId,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OrderDisputeRefStatusEnum),
    );
    yield r'filed_by_party';
    yield serializers.serialize(
      object.filedByParty,
      specifiedType: const FullType(OrderDisputeRefFiledByPartyEnum),
    );
    if (object.filingAvailable != null) {
      yield r'filing_available';
      yield serializers.serialize(
        object.filingAvailable,
        specifiedType: const FullType(bool),
      );
    }
    if (object.filingNote != null) {
      yield r'filing_note';
      yield serializers.serialize(
        object.filingNote,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDisputeRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDisputeRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'case_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caseId = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDisputeRefStatusEnum),
          ) as OrderDisputeRefStatusEnum;
          result.status = valueDes;
          break;
        case r'filed_by_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDisputeRefFiledByPartyEnum),
          ) as OrderDisputeRefFiledByPartyEnum;
          result.filedByParty = valueDes;
          break;
        case r'filing_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.filingAvailable = valueDes;
          break;
        case r'filing_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.filingNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDisputeRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDisputeRefBuilder();
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


class OrderDisputeRefStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN_AWAITING_RESPONSE')
  static const OrderDisputeRefStatusEnum OPEN_AWAITING_RESPONSE = _$orderDisputeRefStatusEnum_OPEN_AWAITING_RESPONSE;
  @BuiltValueEnumConst(wireName: r'MUTUAL_RESOLUTION')
  static const OrderDisputeRefStatusEnum MUTUAL_RESOLUTION = _$orderDisputeRefStatusEnum_MUTUAL_RESOLUTION;
  @BuiltValueEnumConst(wireName: r'ESCALATED_ADMIN_REVIEW')
  static const OrderDisputeRefStatusEnum ESCALATED_ADMIN_REVIEW = _$orderDisputeRefStatusEnum_ESCALATED_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'AWAITING_CLARIFICATION')
  static const OrderDisputeRefStatusEnum AWAITING_CLARIFICATION = _$orderDisputeRefStatusEnum_AWAITING_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'DECIDED')
  static const OrderDisputeRefStatusEnum DECIDED = _$orderDisputeRefStatusEnum_DECIDED;
  @BuiltValueEnumConst(wireName: r'APPEAL_OPEN')
  static const OrderDisputeRefStatusEnum APPEAL_OPEN = _$orderDisputeRefStatusEnum_APPEAL_OPEN;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const OrderDisputeRefStatusEnum RESOLVED = _$orderDisputeRefStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED_INCONCLUSIVE')
  static const OrderDisputeRefStatusEnum CLOSED_INCONCLUSIVE = _$orderDisputeRefStatusEnum_CLOSED_INCONCLUSIVE;

  static Serializer<OrderDisputeRefStatusEnum> get serializer => _$orderDisputeRefStatusEnumSerializer;

  const OrderDisputeRefStatusEnum._(String name): super(name);

  static BuiltSet<OrderDisputeRefStatusEnum> get values => _$orderDisputeRefStatusEnumValues;
  static OrderDisputeRefStatusEnum valueOf(String name) => _$orderDisputeRefStatusEnumValueOf(name);
}

class OrderDisputeRefFiledByPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const OrderDisputeRefFiledByPartyEnum BUYER = _$orderDisputeRefFiledByPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const OrderDisputeRefFiledByPartyEnum VENDOR = _$orderDisputeRefFiledByPartyEnum_VENDOR;

  static Serializer<OrderDisputeRefFiledByPartyEnum> get serializer => _$orderDisputeRefFiledByPartyEnumSerializer;

  const OrderDisputeRefFiledByPartyEnum._(String name): super(name);

  static BuiltSet<OrderDisputeRefFiledByPartyEnum> get values => _$orderDisputeRefFiledByPartyEnumValues;
  static OrderDisputeRefFiledByPartyEnum valueOf(String name) => _$orderDisputeRefFiledByPartyEnumValueOf(name);
}

