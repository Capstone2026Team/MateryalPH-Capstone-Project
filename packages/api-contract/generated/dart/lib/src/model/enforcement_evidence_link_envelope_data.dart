//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_evidence_link_envelope_data.g.dart';

/// EnforcementEvidenceLinkEnvelopeData
///
/// Properties:
/// * [url]
/// * [expiresAt]
@BuiltValue()
abstract class EnforcementEvidenceLinkEnvelopeData implements Built<EnforcementEvidenceLinkEnvelopeData, EnforcementEvidenceLinkEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  EnforcementEvidenceLinkEnvelopeData._();

  factory EnforcementEvidenceLinkEnvelopeData([void updates(EnforcementEvidenceLinkEnvelopeDataBuilder b)]) = _$EnforcementEvidenceLinkEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementEvidenceLinkEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementEvidenceLinkEnvelopeData> get serializer => _$EnforcementEvidenceLinkEnvelopeDataSerializer();
}

class _$EnforcementEvidenceLinkEnvelopeDataSerializer implements PrimitiveSerializer<EnforcementEvidenceLinkEnvelopeData> {
  @override
  final Iterable<Type> types = const [EnforcementEvidenceLinkEnvelopeData, _$EnforcementEvidenceLinkEnvelopeData];

  @override
  final String wireName = r'EnforcementEvidenceLinkEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementEvidenceLinkEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementEvidenceLinkEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementEvidenceLinkEnvelopeDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementEvidenceLinkEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementEvidenceLinkEnvelopeDataBuilder();
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


