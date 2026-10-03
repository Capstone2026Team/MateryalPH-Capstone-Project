//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/money_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'money_delivery.g.dart';

/// MoneyDelivery
///
/// Properties:
/// * [status]
/// * [amountCentavos]
/// * [estimate]
@BuiltValue()
abstract class MoneyDelivery implements Built<MoneyDelivery, MoneyDeliveryBuilder> {
  @BuiltValueField(wireName: r'status')
  MoneyDeliveryStatusEnum get status;
  // enum statusEnum {  NOT_APPLICABLE,  PENDING_VENDOR_CONFIRMATION,  CONFIRMED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'estimate')
  MoneyRange? get estimate;

  MoneyDelivery._();

  factory MoneyDelivery([void updates(MoneyDeliveryBuilder b)]) = _$MoneyDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MoneyDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MoneyDelivery> get serializer => _$MoneyDeliverySerializer();
}

class _$MoneyDeliverySerializer implements PrimitiveSerializer<MoneyDelivery> {
  @override
  final Iterable<Type> types = const [MoneyDelivery, _$MoneyDelivery];

  @override
  final String wireName = r'MoneyDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MoneyDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MoneyDeliveryStatusEnum),
    );
    yield r'amount_centavos';
    yield object.amountCentavos == null ? null : serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'estimate';
    yield object.estimate == null ? null : serializers.serialize(
      object.estimate,
      specifiedType: const FullType.nullable(MoneyRange),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MoneyDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MoneyDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyDeliveryStatusEnum),
          ) as MoneyDeliveryStatusEnum;
          result.status = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountCentavos = valueDes;
          break;
        case r'estimate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MoneyRange),
          ) as MoneyRange?;
          if (valueDes == null) continue;
          result.estimate.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MoneyDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MoneyDeliveryBuilder();
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


class MoneyDeliveryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const MoneyDeliveryStatusEnum NOT_APPLICABLE = _$moneyDeliveryStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'PENDING_VENDOR_CONFIRMATION')
  static const MoneyDeliveryStatusEnum PENDING_VENDOR_CONFIRMATION = _$moneyDeliveryStatusEnum_PENDING_VENDOR_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const MoneyDeliveryStatusEnum CONFIRMED = _$moneyDeliveryStatusEnum_CONFIRMED;

  static Serializer<MoneyDeliveryStatusEnum> get serializer => _$moneyDeliveryStatusEnumSerializer;

  const MoneyDeliveryStatusEnum._(String name): super(name);

  static BuiltSet<MoneyDeliveryStatusEnum> get values => _$moneyDeliveryStatusEnumValues;
  static MoneyDeliveryStatusEnum valueOf(String name) => _$moneyDeliveryStatusEnumValueOf(name);
}

