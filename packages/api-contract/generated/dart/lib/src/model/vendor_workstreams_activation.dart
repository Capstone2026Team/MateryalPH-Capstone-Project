//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_workstreams_activation.g.dart';

/// VendorWorkstreamsActivation
///
/// Properties:
/// * [status]
/// * [holdCode]
@BuiltValue()
abstract class VendorWorkstreamsActivation implements Built<VendorWorkstreamsActivation, VendorWorkstreamsActivationBuilder> {
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'hold_code')
  String? get holdCode;

  VendorWorkstreamsActivation._();

  factory VendorWorkstreamsActivation([void updates(VendorWorkstreamsActivationBuilder b)]) = _$VendorWorkstreamsActivation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorWorkstreamsActivationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorWorkstreamsActivation> get serializer => _$VendorWorkstreamsActivationSerializer();
}

class _$VendorWorkstreamsActivationSerializer implements PrimitiveSerializer<VendorWorkstreamsActivation> {
  @override
  final Iterable<Type> types = const [VendorWorkstreamsActivation, _$VendorWorkstreamsActivation];

  @override
  final String wireName = r'VendorWorkstreamsActivation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorWorkstreamsActivation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.holdCode != null) {
      yield r'hold_code';
      yield serializers.serialize(
        object.holdCode,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorWorkstreamsActivation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorWorkstreamsActivationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'hold_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.holdCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorWorkstreamsActivation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorWorkstreamsActivationBuilder();
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


