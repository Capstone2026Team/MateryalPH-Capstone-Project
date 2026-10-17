//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_workstreams_activation.dart';
import 'package:materyalph_api_client/src/model/vendor_workstreams_verification.dart';
import 'package:materyalph_api_client/src/model/vendor_workstreams_discoverability.dart';
import 'package:materyalph_api_client/src/model/vendor_workstreams_provider_readiness.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_workstreams.g.dart';

/// VendorWorkstreams
///
/// Properties:
/// * [verification]
/// * [setup]
/// * [providerReadiness]
/// * [activation]
/// * [discoverability]
@BuiltValue()
abstract class VendorWorkstreams implements Built<VendorWorkstreams, VendorWorkstreamsBuilder> {
  @BuiltValueField(wireName: r'verification')
  VendorWorkstreamsVerification get verification;

  @BuiltValueField(wireName: r'setup')
  VendorWorkstreamsVerification get setup;

  @BuiltValueField(wireName: r'provider_readiness')
  VendorWorkstreamsProviderReadiness get providerReadiness;

  @BuiltValueField(wireName: r'activation')
  VendorWorkstreamsActivation get activation;

  @BuiltValueField(wireName: r'discoverability')
  VendorWorkstreamsDiscoverability get discoverability;

  VendorWorkstreams._();

  factory VendorWorkstreams([void updates(VendorWorkstreamsBuilder b)]) = _$VendorWorkstreams;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorWorkstreamsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorWorkstreams> get serializer => _$VendorWorkstreamsSerializer();
}

class _$VendorWorkstreamsSerializer implements PrimitiveSerializer<VendorWorkstreams> {
  @override
  final Iterable<Type> types = const [VendorWorkstreams, _$VendorWorkstreams];

  @override
  final String wireName = r'VendorWorkstreams';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorWorkstreams object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verification';
    yield serializers.serialize(
      object.verification,
      specifiedType: const FullType(VendorWorkstreamsVerification),
    );
    yield r'setup';
    yield serializers.serialize(
      object.setup,
      specifiedType: const FullType(VendorWorkstreamsVerification),
    );
    yield r'provider_readiness';
    yield serializers.serialize(
      object.providerReadiness,
      specifiedType: const FullType(VendorWorkstreamsProviderReadiness),
    );
    yield r'activation';
    yield serializers.serialize(
      object.activation,
      specifiedType: const FullType(VendorWorkstreamsActivation),
    );
    yield r'discoverability';
    yield serializers.serialize(
      object.discoverability,
      specifiedType: const FullType(VendorWorkstreamsDiscoverability),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorWorkstreams object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorWorkstreamsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'verification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorWorkstreamsVerification),
          ) as VendorWorkstreamsVerification;
          result.verification.replace(valueDes);
          break;
        case r'setup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorWorkstreamsVerification),
          ) as VendorWorkstreamsVerification;
          result.setup.replace(valueDes);
          break;
        case r'provider_readiness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorWorkstreamsProviderReadiness),
          ) as VendorWorkstreamsProviderReadiness;
          result.providerReadiness.replace(valueDes);
          break;
        case r'activation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorWorkstreamsActivation),
          ) as VendorWorkstreamsActivation;
          result.activation.replace(valueDes);
          break;
        case r'discoverability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorWorkstreamsDiscoverability),
          ) as VendorWorkstreamsDiscoverability;
          result.discoverability.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorWorkstreams deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorWorkstreamsBuilder();
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


