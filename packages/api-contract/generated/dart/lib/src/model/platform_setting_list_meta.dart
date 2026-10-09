//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fixed_setting.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_setting_list_meta.g.dart';

/// PlatformSettingListMeta
///
/// Properties:
/// * [fixed]
/// * [canManage]
/// * [correlationId]
@BuiltValue()
abstract class PlatformSettingListMeta implements Built<PlatformSettingListMeta, PlatformSettingListMetaBuilder> {
  @BuiltValueField(wireName: r'fixed')
  BuiltList<FixedSetting>? get fixed;

  @BuiltValueField(wireName: r'can_manage')
  bool? get canManage;

  @BuiltValueField(wireName: r'correlation_id')
  String? get correlationId;

  PlatformSettingListMeta._();

  factory PlatformSettingListMeta([void updates(PlatformSettingListMetaBuilder b)]) = _$PlatformSettingListMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingListMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettingListMeta> get serializer => _$PlatformSettingListMetaSerializer();
}

class _$PlatformSettingListMetaSerializer implements PrimitiveSerializer<PlatformSettingListMeta> {
  @override
  final Iterable<Type> types = const [PlatformSettingListMeta, _$PlatformSettingListMeta];

  @override
  final String wireName = r'PlatformSettingListMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettingListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fixed != null) {
      yield r'fixed';
      yield serializers.serialize(
        object.fixed,
        specifiedType: const FullType(BuiltList, [FullType(FixedSetting)]),
      );
    }
    if (object.canManage != null) {
      yield r'can_manage';
      yield serializers.serialize(
        object.canManage,
        specifiedType: const FullType(bool),
      );
    }
    if (object.correlationId != null) {
      yield r'correlation_id';
      yield serializers.serialize(
        object.correlationId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSettingListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingListMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fixed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(FixedSetting)]),
          ) as BuiltList<FixedSetting>?;
          if (valueDes == null) continue;
          result.fixed.replace(valueDes);
          break;
        case r'can_manage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canManage = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSettingListMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingListMetaBuilder();
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


