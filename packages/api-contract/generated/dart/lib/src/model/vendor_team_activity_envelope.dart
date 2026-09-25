//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_team_activity.dart';
import 'package:materyalph_api_client/src/model/vendor_team_activity_envelope_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_activity_envelope.g.dart';

/// VendorTeamActivityEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class VendorTeamActivityEnvelope implements Built<VendorTeamActivityEnvelope, VendorTeamActivityEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<VendorTeamActivity> get data;

  @BuiltValueField(wireName: r'meta')
  VendorTeamActivityEnvelopeMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  VendorTeamActivityEnvelope._();

  factory VendorTeamActivityEnvelope([void updates(VendorTeamActivityEnvelopeBuilder b)]) = _$VendorTeamActivityEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamActivityEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamActivityEnvelope> get serializer => _$VendorTeamActivityEnvelopeSerializer();
}

class _$VendorTeamActivityEnvelopeSerializer implements PrimitiveSerializer<VendorTeamActivityEnvelope> {
  @override
  final Iterable<Type> types = const [VendorTeamActivityEnvelope, _$VendorTeamActivityEnvelope];

  @override
  final String wireName = r'VendorTeamActivityEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamActivityEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(VendorTeamActivity)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(VendorTeamActivityEnvelopeMeta),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamActivityEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamActivityEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTeamActivity)]),
          ) as BuiltList<VendorTeamActivity>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamActivityEnvelopeMeta),
          ) as VendorTeamActivityEnvelopeMeta;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamActivityEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamActivityEnvelopeBuilder();
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


