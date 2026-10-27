//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_filter_option.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_filter_options_envelope.g.dart';

/// GeoFilterOptionsEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class GeoFilterOptionsEnvelope implements Built<GeoFilterOptionsEnvelope, GeoFilterOptionsEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<GeoFilterOption> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  GeoFilterOptionsEnvelope._();

  factory GeoFilterOptionsEnvelope([void updates(GeoFilterOptionsEnvelopeBuilder b)]) = _$GeoFilterOptionsEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoFilterOptionsEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoFilterOptionsEnvelope> get serializer => _$GeoFilterOptionsEnvelopeSerializer();
}

class _$GeoFilterOptionsEnvelopeSerializer implements PrimitiveSerializer<GeoFilterOptionsEnvelope> {
  @override
  final Iterable<Type> types = const [GeoFilterOptionsEnvelope, _$GeoFilterOptionsEnvelope];

  @override
  final String wireName = r'GeoFilterOptionsEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoFilterOptionsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(GeoFilterOption)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoFilterOptionsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoFilterOptionsEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoFilterOption)]),
          ) as BuiltList<GeoFilterOption>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta = valueDes.toBuilder();
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
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
  GeoFilterOptionsEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoFilterOptionsEnvelopeBuilder();
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


