//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_connection.g.dart';

/// VendorConnection
///
/// Properties:
/// * [providerStatus]
/// * [connectionError]
/// * [environment]
/// * [status]
/// * [evidenceOrigin]
/// * [checkedAt]
@BuiltValue()
abstract class VendorConnection implements Built<VendorConnection, VendorConnectionBuilder> {
  @BuiltValueField(wireName: r'provider_status')
  String? get providerStatus;

  @BuiltValueField(wireName: r'connection_error')
  String? get connectionError;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'evidence_origin')
  String? get evidenceOrigin;

  @BuiltValueField(wireName: r'checked_at')
  String? get checkedAt;

  VendorConnection._();

  factory VendorConnection([void updates(VendorConnectionBuilder b)]) = _$VendorConnection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorConnectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorConnection> get serializer => _$VendorConnectionSerializer();
}

class _$VendorConnectionSerializer implements PrimitiveSerializer<VendorConnection> {
  @override
  final Iterable<Type> types = const [VendorConnection, _$VendorConnection];

  @override
  final String wireName = r'VendorConnection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorConnection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider_status';
    yield object.providerStatus == null ? null : serializers.serialize(
      object.providerStatus,
      specifiedType: const FullType.nullable(String),
    );
    yield r'connection_error';
    yield object.connectionError == null ? null : serializers.serialize(
      object.connectionError,
      specifiedType: const FullType.nullable(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'evidence_origin';
    yield object.evidenceOrigin == null ? null : serializers.serialize(
      object.evidenceOrigin,
      specifiedType: const FullType.nullable(String),
    );
    yield r'checked_at';
    yield object.checkedAt == null ? null : serializers.serialize(
      object.checkedAt,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorConnection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorConnectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerStatus = valueDes;
          break;
        case r'connection_error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.connectionError = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidenceOrigin = valueDes;
          break;
        case r'checked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checkedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorConnection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorConnectionBuilder();
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


