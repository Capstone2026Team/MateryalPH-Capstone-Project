//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'money_nrpc.g.dart';

/// MoneyNrpc
///
/// Properties:
/// * [amountCentavos]
/// * [withinOrderValue] - NRPC is part of the materials value
/// * [status]
@BuiltValue()
abstract class MoneyNrpc implements Built<MoneyNrpc, MoneyNrpcBuilder> {
  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  /// NRPC is part of the materials value
  @BuiltValueField(wireName: r'within_order_value')
  MoneyNrpcWithinOrderValueEnum get withinOrderValue;
  // enum withinOrderValueEnum {  true,  };

  @BuiltValueField(wireName: r'status')
  MoneyNrpcStatusEnum? get status;
  // enum statusEnum {  PROPOSED,  ACCEPTED,  REJECTED,  ,  };

  MoneyNrpc._();

  factory MoneyNrpc([void updates(MoneyNrpcBuilder b)]) = _$MoneyNrpc;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MoneyNrpcBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MoneyNrpc> get serializer => _$MoneyNrpcSerializer();
}

class _$MoneyNrpcSerializer implements PrimitiveSerializer<MoneyNrpc> {
  @override
  final Iterable<Type> types = const [MoneyNrpc, _$MoneyNrpc];

  @override
  final String wireName = r'MoneyNrpc';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MoneyNrpc object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'within_order_value';
    yield serializers.serialize(
      object.withinOrderValue,
      specifiedType: const FullType(MoneyNrpcWithinOrderValueEnum),
    );
    yield r'status';
    yield object.status == null ? null : serializers.serialize(
      object.status,
      specifiedType: const FullType.nullable(MoneyNrpcStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MoneyNrpc object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MoneyNrpcBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'within_order_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyNrpcWithinOrderValueEnum),
          ) as MoneyNrpcWithinOrderValueEnum;
          result.withinOrderValue = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MoneyNrpcStatusEnum),
          ) as MoneyNrpcStatusEnum?;
          if (valueDes == null) continue;
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
  MoneyNrpc deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MoneyNrpcBuilder();
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


/// NRPC is part of the materials value
class MoneyNrpcWithinOrderValueEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const MoneyNrpcWithinOrderValueEnum true_ = _$moneyNrpcWithinOrderValueEnum_true_;

  static Serializer<MoneyNrpcWithinOrderValueEnum> get serializer => _$moneyNrpcWithinOrderValueEnumSerializer;

  const MoneyNrpcWithinOrderValueEnum._(String name): super(name);

  static BuiltSet<MoneyNrpcWithinOrderValueEnum> get values => _$moneyNrpcWithinOrderValueEnumValues;
  static MoneyNrpcWithinOrderValueEnum valueOf(String name) => _$moneyNrpcWithinOrderValueEnumValueOf(name);
}

class MoneyNrpcStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROPOSED')
  static const MoneyNrpcStatusEnum PROPOSED = _$moneyNrpcStatusEnum_PROPOSED;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const MoneyNrpcStatusEnum ACCEPTED = _$moneyNrpcStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const MoneyNrpcStatusEnum REJECTED = _$moneyNrpcStatusEnum_REJECTED;

  static Serializer<MoneyNrpcStatusEnum> get serializer => _$moneyNrpcStatusEnumSerializer;

  const MoneyNrpcStatusEnum._(String name): super(name);

  static BuiltSet<MoneyNrpcStatusEnum> get values => _$moneyNrpcStatusEnumValues;
  static MoneyNrpcStatusEnum valueOf(String name) => _$moneyNrpcStatusEnumValueOf(name);
}

