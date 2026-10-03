//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_amount.g.dart';

/// DeliveryAmount
///
/// Properties:
/// * [status]
/// * [minCentavos]
/// * [maxCentavos]
@BuiltValue()
abstract class DeliveryAmount implements Built<DeliveryAmount, DeliveryAmountBuilder> {
  @BuiltValueField(wireName: r'status')
  DeliveryAmountStatusEnum get status;
  // enum statusEnum {  ESTIMATE,  NOT_APPLICABLE,  PENDING_VENDOR_REVIEW,  };

  @BuiltValueField(wireName: r'min_centavos')
  int? get minCentavos;

  @BuiltValueField(wireName: r'max_centavos')
  int? get maxCentavos;

  DeliveryAmount._();

  factory DeliveryAmount([void updates(DeliveryAmountBuilder b)]) = _$DeliveryAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryAmountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryAmount> get serializer => _$DeliveryAmountSerializer();
}

class _$DeliveryAmountSerializer implements PrimitiveSerializer<DeliveryAmount> {
  @override
  final Iterable<Type> types = const [DeliveryAmount, _$DeliveryAmount];

  @override
  final String wireName = r'DeliveryAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DeliveryAmountStatusEnum),
    );
    yield r'min_centavos';
    yield object.minCentavos == null ? null : serializers.serialize(
      object.minCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'max_centavos';
    yield object.maxCentavos == null ? null : serializers.serialize(
      object.maxCentavos,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryAmountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryAmountStatusEnum),
          ) as DeliveryAmountStatusEnum;
          result.status = valueDes;
          break;
        case r'min_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minCentavos = valueDes;
          break;
        case r'max_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryAmountBuilder();
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


class DeliveryAmountStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ESTIMATE')
  static const DeliveryAmountStatusEnum ESTIMATE = _$deliveryAmountStatusEnum_ESTIMATE;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const DeliveryAmountStatusEnum NOT_APPLICABLE = _$deliveryAmountStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'PENDING_VENDOR_REVIEW')
  static const DeliveryAmountStatusEnum PENDING_VENDOR_REVIEW = _$deliveryAmountStatusEnum_PENDING_VENDOR_REVIEW;

  static Serializer<DeliveryAmountStatusEnum> get serializer => _$deliveryAmountStatusEnumSerializer;

  const DeliveryAmountStatusEnum._(String name): super(name);

  static BuiltSet<DeliveryAmountStatusEnum> get values => _$deliveryAmountStatusEnumValues;
  static DeliveryAmountStatusEnum valueOf(String name) => _$deliveryAmountStatusEnumValueOf(name);
}

