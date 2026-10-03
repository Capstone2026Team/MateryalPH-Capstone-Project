//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_channel_option.g.dart';

/// PaymentChannelOption
///
/// Properties:
/// * [code]
/// * [displayName]
/// * [kind]
/// * [available]
/// * [unavailableReason]
/// * [refundSupported]
/// * [feeVersion]
/// * [rateLabel]
/// * [feeCentavos]
/// * [totalCentavos]
/// * [feeBearer]
/// * [rateSource]
@BuiltValue()
abstract class PaymentChannelOption implements Built<PaymentChannelOption, PaymentChannelOptionBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'kind')
  PaymentChannelOptionKindEnum get kind;
  // enum kindEnum {  CARD,  EWALLET,  QR,  OVER_THE_COUNTER,  DIRECT_DEBIT,  BANK_TRANSFER,  };

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'unavailable_reason')
  String? get unavailableReason;

  @BuiltValueField(wireName: r'refund_supported')
  bool get refundSupported;

  @BuiltValueField(wireName: r'fee_version')
  int get feeVersion;

  @BuiltValueField(wireName: r'rate_label')
  String get rateLabel;

  @BuiltValueField(wireName: r'fee_centavos')
  int? get feeCentavos;

  @BuiltValueField(wireName: r'total_centavos')
  int? get totalCentavos;

  @BuiltValueField(wireName: r'fee_bearer')
  PaymentChannelOptionFeeBearerEnum get feeBearer;
  // enum feeBearerEnum {  BUYER,  PLATFORM,  };

  @BuiltValueField(wireName: r'rate_source')
  PaymentChannelOptionRateSourceEnum get rateSource;
  // enum rateSourceEnum {  DEMO_PUBLISHED_RATE,  };

  PaymentChannelOption._();

  factory PaymentChannelOption([void updates(PaymentChannelOptionBuilder b)]) = _$PaymentChannelOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentChannelOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentChannelOption> get serializer => _$PaymentChannelOptionSerializer();
}

class _$PaymentChannelOptionSerializer implements PrimitiveSerializer<PaymentChannelOption> {
  @override
  final Iterable<Type> types = const [PaymentChannelOption, _$PaymentChannelOption];

  @override
  final String wireName = r'PaymentChannelOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentChannelOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PaymentChannelOptionKindEnum),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    if (object.unavailableReason != null) {
      yield r'unavailable_reason';
      yield serializers.serialize(
        object.unavailableReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'refund_supported';
    yield serializers.serialize(
      object.refundSupported,
      specifiedType: const FullType(bool),
    );
    yield r'fee_version';
    yield serializers.serialize(
      object.feeVersion,
      specifiedType: const FullType(int),
    );
    yield r'rate_label';
    yield serializers.serialize(
      object.rateLabel,
      specifiedType: const FullType(String),
    );
    if (object.feeCentavos != null) {
      yield r'fee_centavos';
      yield serializers.serialize(
        object.feeCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalCentavos != null) {
      yield r'total_centavos';
      yield serializers.serialize(
        object.totalCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'fee_bearer';
    yield serializers.serialize(
      object.feeBearer,
      specifiedType: const FullType(PaymentChannelOptionFeeBearerEnum),
    );
    yield r'rate_source';
    yield serializers.serialize(
      object.rateSource,
      specifiedType: const FullType(PaymentChannelOptionRateSourceEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentChannelOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentChannelOptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentChannelOptionKindEnum),
          ) as PaymentChannelOptionKindEnum;
          result.kind = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'unavailable_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unavailableReason = valueDes;
          break;
        case r'refund_supported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.refundSupported = valueDes;
          break;
        case r'fee_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feeVersion = valueDes;
          break;
        case r'rate_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rateLabel = valueDes;
          break;
        case r'fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.feeCentavos = valueDes;
          break;
        case r'total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalCentavos = valueDes;
          break;
        case r'fee_bearer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentChannelOptionFeeBearerEnum),
          ) as PaymentChannelOptionFeeBearerEnum;
          result.feeBearer = valueDes;
          break;
        case r'rate_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentChannelOptionRateSourceEnum),
          ) as PaymentChannelOptionRateSourceEnum;
          result.rateSource = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentChannelOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentChannelOptionBuilder();
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


class PaymentChannelOptionKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CARD')
  static const PaymentChannelOptionKindEnum CARD = _$paymentChannelOptionKindEnum_CARD;
  @BuiltValueEnumConst(wireName: r'EWALLET')
  static const PaymentChannelOptionKindEnum EWALLET = _$paymentChannelOptionKindEnum_EWALLET;
  @BuiltValueEnumConst(wireName: r'QR')
  static const PaymentChannelOptionKindEnum QR = _$paymentChannelOptionKindEnum_QR;
  @BuiltValueEnumConst(wireName: r'OVER_THE_COUNTER')
  static const PaymentChannelOptionKindEnum OVER_THE_COUNTER = _$paymentChannelOptionKindEnum_OVER_THE_COUNTER;
  @BuiltValueEnumConst(wireName: r'DIRECT_DEBIT')
  static const PaymentChannelOptionKindEnum DIRECT_DEBIT = _$paymentChannelOptionKindEnum_DIRECT_DEBIT;
  @BuiltValueEnumConst(wireName: r'BANK_TRANSFER')
  static const PaymentChannelOptionKindEnum BANK_TRANSFER = _$paymentChannelOptionKindEnum_BANK_TRANSFER;

  static Serializer<PaymentChannelOptionKindEnum> get serializer => _$paymentChannelOptionKindEnumSerializer;

  const PaymentChannelOptionKindEnum._(String name): super(name);

  static BuiltSet<PaymentChannelOptionKindEnum> get values => _$paymentChannelOptionKindEnumValues;
  static PaymentChannelOptionKindEnum valueOf(String name) => _$paymentChannelOptionKindEnumValueOf(name);
}

class PaymentChannelOptionFeeBearerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const PaymentChannelOptionFeeBearerEnum BUYER = _$paymentChannelOptionFeeBearerEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const PaymentChannelOptionFeeBearerEnum PLATFORM = _$paymentChannelOptionFeeBearerEnum_PLATFORM;

  static Serializer<PaymentChannelOptionFeeBearerEnum> get serializer => _$paymentChannelOptionFeeBearerEnumSerializer;

  const PaymentChannelOptionFeeBearerEnum._(String name): super(name);

  static BuiltSet<PaymentChannelOptionFeeBearerEnum> get values => _$paymentChannelOptionFeeBearerEnumValues;
  static PaymentChannelOptionFeeBearerEnum valueOf(String name) => _$paymentChannelOptionFeeBearerEnumValueOf(name);
}

class PaymentChannelOptionRateSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEMO_PUBLISHED_RATE')
  static const PaymentChannelOptionRateSourceEnum DEMO_PUBLISHED_RATE = _$paymentChannelOptionRateSourceEnum_DEMO_PUBLISHED_RATE;

  static Serializer<PaymentChannelOptionRateSourceEnum> get serializer => _$paymentChannelOptionRateSourceEnumSerializer;

  const PaymentChannelOptionRateSourceEnum._(String name): super(name);

  static BuiltSet<PaymentChannelOptionRateSourceEnum> get values => _$paymentChannelOptionRateSourceEnumValues;
  static PaymentChannelOptionRateSourceEnum valueOf(String name) => _$paymentChannelOptionRateSourceEnumValueOf(name);
}

