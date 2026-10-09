//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_workstreams_provider_readiness.g.dart';

/// VendorWorkstreamsProviderReadiness
///
/// Properties:
/// * [status]
/// * [providerStatus]
/// * [environment]
/// * [lastErrorCode]
/// * [lastReconciledAt]
/// * [note]
@BuiltValue()
abstract class VendorWorkstreamsProviderReadiness implements Built<VendorWorkstreamsProviderReadiness, VendorWorkstreamsProviderReadinessBuilder> {
  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'provider_status')
  String? get providerStatus;

  @BuiltValueField(wireName: r'environment')
  String? get environment;

  @BuiltValueField(wireName: r'last_error_code')
  String? get lastErrorCode;

  @BuiltValueField(wireName: r'last_reconciled_at')
  DateTime? get lastReconciledAt;

  @BuiltValueField(wireName: r'note')
  String? get note;

  VendorWorkstreamsProviderReadiness._();

  factory VendorWorkstreamsProviderReadiness([void updates(VendorWorkstreamsProviderReadinessBuilder b)]) = _$VendorWorkstreamsProviderReadiness;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorWorkstreamsProviderReadinessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorWorkstreamsProviderReadiness> get serializer => _$VendorWorkstreamsProviderReadinessSerializer();
}

class _$VendorWorkstreamsProviderReadinessSerializer implements PrimitiveSerializer<VendorWorkstreamsProviderReadiness> {
  @override
  final Iterable<Type> types = const [VendorWorkstreamsProviderReadiness, _$VendorWorkstreamsProviderReadiness];

  @override
  final String wireName = r'VendorWorkstreamsProviderReadiness';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorWorkstreamsProviderReadiness object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerStatus != null) {
      yield r'provider_status';
      yield serializers.serialize(
        object.providerStatus,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.environment != null) {
      yield r'environment';
      yield serializers.serialize(
        object.environment,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastErrorCode != null) {
      yield r'last_error_code';
      yield serializers.serialize(
        object.lastErrorCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.lastReconciledAt != null) {
      yield r'last_reconciled_at';
      yield serializers.serialize(
        object.lastReconciledAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorWorkstreamsProviderReadiness object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorWorkstreamsProviderReadinessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'provider_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerStatus = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.environment = valueDes;
          break;
        case r'last_error_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastErrorCode = valueDes;
          break;
        case r'last_reconciled_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastReconciledAt = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorWorkstreamsProviderReadiness deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorWorkstreamsProviderReadinessBuilder();
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


