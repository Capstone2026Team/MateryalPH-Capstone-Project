//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_workstreams_discoverability.g.dart';

/// VendorWorkstreamsDiscoverability
///
/// Properties:
/// * [status]
/// * [reason]
/// * [evaluatedAt]
@BuiltValue()
abstract class VendorWorkstreamsDiscoverability implements Built<VendorWorkstreamsDiscoverability, VendorWorkstreamsDiscoverabilityBuilder> {
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'evaluated_at')
  DateTime? get evaluatedAt;

  VendorWorkstreamsDiscoverability._();

  factory VendorWorkstreamsDiscoverability([void updates(VendorWorkstreamsDiscoverabilityBuilder b)]) = _$VendorWorkstreamsDiscoverability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorWorkstreamsDiscoverabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorWorkstreamsDiscoverability> get serializer => _$VendorWorkstreamsDiscoverabilitySerializer();
}

class _$VendorWorkstreamsDiscoverabilitySerializer implements PrimitiveSerializer<VendorWorkstreamsDiscoverability> {
  @override
  final Iterable<Type> types = const [VendorWorkstreamsDiscoverability, _$VendorWorkstreamsDiscoverability];

  @override
  final String wireName = r'VendorWorkstreamsDiscoverability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorWorkstreamsDiscoverability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.evaluatedAt != null) {
      yield r'evaluated_at';
      yield serializers.serialize(
        object.evaluatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorWorkstreamsDiscoverability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorWorkstreamsDiscoverabilityBuilder result,
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
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'evaluated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.evaluatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorWorkstreamsDiscoverability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorWorkstreamsDiscoverabilityBuilder();
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


