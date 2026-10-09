//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/platform_setting_list_meta.dart';
import 'package:materyalph_api_client/src/model/platform_setting.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_setting_list_envelope.g.dart';

/// PlatformSettingListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class PlatformSettingListEnvelope implements Built<PlatformSettingListEnvelope, PlatformSettingListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PlatformSetting> get data;

  @BuiltValueField(wireName: r'meta')
  PlatformSettingListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  PlatformSettingListEnvelope._();

  factory PlatformSettingListEnvelope([void updates(PlatformSettingListEnvelopeBuilder b)]) = _$PlatformSettingListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettingListEnvelope> get serializer => _$PlatformSettingListEnvelopeSerializer();
}

class _$PlatformSettingListEnvelopeSerializer implements PrimitiveSerializer<PlatformSettingListEnvelope> {
  @override
  final Iterable<Type> types = const [PlatformSettingListEnvelope, _$PlatformSettingListEnvelope];

  @override
  final String wireName = r'PlatformSettingListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettingListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PlatformSetting)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PlatformSettingListMeta),
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
    PlatformSettingListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PlatformSetting)]),
          ) as BuiltList<PlatformSetting>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlatformSettingListMeta),
          ) as PlatformSettingListMeta;
          result.meta.replace(valueDes);
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
  PlatformSettingListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingListEnvelopeBuilder();
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


