//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/checkout_child_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_submission.g.dart';

/// CheckoutSubmission
///
/// Properties:
/// * [id]
/// * [reference]
/// * [submittedAt]
/// * [derivedStatus]
/// * [orders]
/// * [notice]
@BuiltValue()
abstract class CheckoutSubmission implements Built<CheckoutSubmission, CheckoutSubmissionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'derived_status')
  CheckoutSubmissionDerivedStatusEnum get derivedStatus;
  // enum derivedStatusEnum {  EMPTY,  AWAITING_CONFIRMATIONS,  AWAITING_PAYMENT,  CHILD_ORDERS_UPDATED,  };

  @BuiltValueField(wireName: r'orders')
  BuiltList<CheckoutChildOrder> get orders;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  CheckoutSubmission._();

  factory CheckoutSubmission([void updates(CheckoutSubmissionBuilder b)]) = _$CheckoutSubmission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutSubmissionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutSubmission> get serializer => _$CheckoutSubmissionSerializer();
}

class _$CheckoutSubmissionSerializer implements PrimitiveSerializer<CheckoutSubmission> {
  @override
  final Iterable<Type> types = const [CheckoutSubmission, _$CheckoutSubmission];

  @override
  final String wireName = r'CheckoutSubmission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutSubmission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'submitted_at';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'derived_status';
    yield serializers.serialize(
      object.derivedStatus,
      specifiedType: const FullType(CheckoutSubmissionDerivedStatusEnum),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [FullType(CheckoutChildOrder)]),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutSubmission object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutSubmissionBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        case r'derived_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutSubmissionDerivedStatusEnum),
          ) as CheckoutSubmissionDerivedStatusEnum;
          result.derivedStatus = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CheckoutChildOrder)]),
          ) as BuiltList<CheckoutChildOrder>;
          result.orders.replace(valueDes);
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutSubmission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutSubmissionBuilder();
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


class CheckoutSubmissionDerivedStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EMPTY')
  static const CheckoutSubmissionDerivedStatusEnum EMPTY = _$checkoutSubmissionDerivedStatusEnum_EMPTY;
  @BuiltValueEnumConst(wireName: r'AWAITING_CONFIRMATIONS')
  static const CheckoutSubmissionDerivedStatusEnum AWAITING_CONFIRMATIONS = _$checkoutSubmissionDerivedStatusEnum_AWAITING_CONFIRMATIONS;
  @BuiltValueEnumConst(wireName: r'AWAITING_PAYMENT')
  static const CheckoutSubmissionDerivedStatusEnum AWAITING_PAYMENT = _$checkoutSubmissionDerivedStatusEnum_AWAITING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'CHILD_ORDERS_UPDATED')
  static const CheckoutSubmissionDerivedStatusEnum CHILD_ORDERS_UPDATED = _$checkoutSubmissionDerivedStatusEnum_CHILD_ORDERS_UPDATED;

  static Serializer<CheckoutSubmissionDerivedStatusEnum> get serializer => _$checkoutSubmissionDerivedStatusEnumSerializer;

  const CheckoutSubmissionDerivedStatusEnum._(String name): super(name);

  static BuiltSet<CheckoutSubmissionDerivedStatusEnum> get values => _$checkoutSubmissionDerivedStatusEnumValues;
  static CheckoutSubmissionDerivedStatusEnum valueOf(String name) => _$checkoutSubmissionDerivedStatusEnumValueOf(name);
}

