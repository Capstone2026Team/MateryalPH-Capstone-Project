//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_account_deletion_request.g.dart';

/// BuyerAccountDeletionRequest
///
/// Properties:
/// * [confirmation]
@BuiltValue()
abstract class BuyerAccountDeletionRequest implements Built<BuyerAccountDeletionRequest, BuyerAccountDeletionRequestBuilder> {
  @BuiltValueField(wireName: r'confirmation')
  BuyerAccountDeletionRequestConfirmationEnum get confirmation;
  // enum confirmationEnum {  DELETE,  };

  BuyerAccountDeletionRequest._();

  factory BuyerAccountDeletionRequest([void updates(BuyerAccountDeletionRequestBuilder b)]) = _$BuyerAccountDeletionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAccountDeletionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAccountDeletionRequest> get serializer => _$BuyerAccountDeletionRequestSerializer();
}

class _$BuyerAccountDeletionRequestSerializer implements PrimitiveSerializer<BuyerAccountDeletionRequest> {
  @override
  final Iterable<Type> types = const [BuyerAccountDeletionRequest, _$BuyerAccountDeletionRequest];

  @override
  final String wireName = r'BuyerAccountDeletionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAccountDeletionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'confirmation';
    yield serializers.serialize(
      object.confirmation,
      specifiedType: const FullType(BuyerAccountDeletionRequestConfirmationEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAccountDeletionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAccountDeletionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAccountDeletionRequestConfirmationEnum),
          ) as BuyerAccountDeletionRequestConfirmationEnum;
          result.confirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAccountDeletionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAccountDeletionRequestBuilder();
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


class BuyerAccountDeletionRequestConfirmationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELETE')
  static const BuyerAccountDeletionRequestConfirmationEnum DELETE = _$buyerAccountDeletionRequestConfirmationEnum_DELETE;

  static Serializer<BuyerAccountDeletionRequestConfirmationEnum> get serializer => _$buyerAccountDeletionRequestConfirmationEnumSerializer;

  const BuyerAccountDeletionRequestConfirmationEnum._(String name): super(name);

  static BuiltSet<BuyerAccountDeletionRequestConfirmationEnum> get values => _$buyerAccountDeletionRequestConfirmationEnumValues;
  static BuyerAccountDeletionRequestConfirmationEnum valueOf(String name) => _$buyerAccountDeletionRequestConfirmationEnumValueOf(name);
}

