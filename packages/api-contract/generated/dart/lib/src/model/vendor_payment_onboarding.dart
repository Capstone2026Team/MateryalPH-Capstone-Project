//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_payment_onboarding.g.dart';

/// VendorPaymentOnboarding
///
/// Properties:
/// * [status]
/// * [environment]
@BuiltValue()
abstract class VendorPaymentOnboarding implements Built<VendorPaymentOnboarding, VendorPaymentOnboardingBuilder> {
  @BuiltValueField(wireName: r'status')
  VendorPaymentOnboardingStatusEnum get status;
  // enum statusEnum {  NOT_CONNECTED,  CONNECTING,  PENDING,  CONNECTED_TEST,  CONNECTION_FAILED,  };

  @BuiltValueField(wireName: r'environment')
  VendorPaymentOnboardingEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  VendorPaymentOnboarding._();

  factory VendorPaymentOnboarding([void updates(VendorPaymentOnboardingBuilder b)]) = _$VendorPaymentOnboarding;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorPaymentOnboardingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorPaymentOnboarding> get serializer => _$VendorPaymentOnboardingSerializer();
}

class _$VendorPaymentOnboardingSerializer implements PrimitiveSerializer<VendorPaymentOnboarding> {
  @override
  final Iterable<Type> types = const [VendorPaymentOnboarding, _$VendorPaymentOnboarding];

  @override
  final String wireName = r'VendorPaymentOnboarding';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorPaymentOnboarding object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorPaymentOnboardingStatusEnum),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(VendorPaymentOnboardingEnvironmentEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorPaymentOnboarding object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorPaymentOnboardingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorPaymentOnboardingStatusEnum),
          ) as VendorPaymentOnboardingStatusEnum;
          result.status = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorPaymentOnboardingEnvironmentEnum),
          ) as VendorPaymentOnboardingEnvironmentEnum;
          result.environment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorPaymentOnboarding deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorPaymentOnboardingBuilder();
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


class VendorPaymentOnboardingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_CONNECTED')
  static const VendorPaymentOnboardingStatusEnum NOT_CONNECTED = _$vendorPaymentOnboardingStatusEnum_NOT_CONNECTED;
  @BuiltValueEnumConst(wireName: r'CONNECTING')
  static const VendorPaymentOnboardingStatusEnum CONNECTING = _$vendorPaymentOnboardingStatusEnum_CONNECTING;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const VendorPaymentOnboardingStatusEnum PENDING = _$vendorPaymentOnboardingStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'CONNECTED_TEST')
  static const VendorPaymentOnboardingStatusEnum CONNECTED_TEST = _$vendorPaymentOnboardingStatusEnum_CONNECTED_TEST;
  @BuiltValueEnumConst(wireName: r'CONNECTION_FAILED')
  static const VendorPaymentOnboardingStatusEnum CONNECTION_FAILED = _$vendorPaymentOnboardingStatusEnum_CONNECTION_FAILED;

  static Serializer<VendorPaymentOnboardingStatusEnum> get serializer => _$vendorPaymentOnboardingStatusEnumSerializer;

  const VendorPaymentOnboardingStatusEnum._(String name): super(name);

  static BuiltSet<VendorPaymentOnboardingStatusEnum> get values => _$vendorPaymentOnboardingStatusEnumValues;
  static VendorPaymentOnboardingStatusEnum valueOf(String name) => _$vendorPaymentOnboardingStatusEnumValueOf(name);
}

class VendorPaymentOnboardingEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const VendorPaymentOnboardingEnvironmentEnum TEST = _$vendorPaymentOnboardingEnvironmentEnum_TEST;

  static Serializer<VendorPaymentOnboardingEnvironmentEnum> get serializer => _$vendorPaymentOnboardingEnvironmentEnumSerializer;

  const VendorPaymentOnboardingEnvironmentEnum._(String name): super(name);

  static BuiltSet<VendorPaymentOnboardingEnvironmentEnum> get values => _$vendorPaymentOnboardingEnvironmentEnumValues;
  static VendorPaymentOnboardingEnvironmentEnum valueOf(String name) => _$vendorPaymentOnboardingEnvironmentEnumValueOf(name);
}

