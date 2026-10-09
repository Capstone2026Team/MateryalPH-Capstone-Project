//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_setting_version.g.dart';

/// PlatformSettingVersion
///
/// Properties:
/// * [version]
/// * [value]
/// * [previousValue]
/// * [source_]
/// * [reason]
/// * [changedBy]
/// * [changedRole]
/// * [correlationId]
/// * [effectiveFrom]
@BuiltValue()
abstract class PlatformSettingVersion implements Built<PlatformSettingVersion, PlatformSettingVersionBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  @BuiltValueField(wireName: r'previous_value')
  JsonObject? get previousValue;

  @BuiltValueField(wireName: r'source')
  PlatformSettingVersionSource_Enum get source_;
  // enum source_Enum {  SEED,  ADMIN,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'changed_by')
  String? get changedBy;

  @BuiltValueField(wireName: r'changed_role')
  String? get changedRole;

  @BuiltValueField(wireName: r'correlation_id')
  String? get correlationId;

  @BuiltValueField(wireName: r'effective_from')
  DateTime get effectiveFrom;

  PlatformSettingVersion._();

  factory PlatformSettingVersion([void updates(PlatformSettingVersionBuilder b)]) = _$PlatformSettingVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettingVersion> get serializer => _$PlatformSettingVersionSerializer();
}

class _$PlatformSettingVersionSerializer implements PrimitiveSerializer<PlatformSettingVersion> {
  @override
  final Iterable<Type> types = const [PlatformSettingVersion, _$PlatformSettingVersion];

  @override
  final String wireName = r'PlatformSettingVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettingVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'value';
    yield object.value == null ? null : serializers.serialize(
      object.value,
      specifiedType: const FullType.nullable(JsonObject),
    );
    if (object.previousValue != null) {
      yield r'previous_value';
      yield serializers.serialize(
        object.previousValue,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(PlatformSettingVersionSource_Enum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.changedBy != null) {
      yield r'changed_by';
      yield serializers.serialize(
        object.changedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.changedRole != null) {
      yield r'changed_role';
      yield serializers.serialize(
        object.changedRole,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.correlationId != null) {
      yield r'correlation_id';
      yield serializers.serialize(
        object.correlationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'effective_from';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSettingVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingVersionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'previous_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.previousValue = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlatformSettingVersionSource_Enum),
          ) as PlatformSettingVersionSource_Enum;
          result.source_ = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'changed_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changedBy = valueDes;
          break;
        case r'changed_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changedRole = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlationId = valueDes;
          break;
        case r'effective_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSettingVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingVersionBuilder();
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


class PlatformSettingVersionSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEED')
  static const PlatformSettingVersionSource_Enum SEED = _$platformSettingVersionSourceEnum_SEED;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const PlatformSettingVersionSource_Enum ADMIN = _$platformSettingVersionSourceEnum_ADMIN;

  static Serializer<PlatformSettingVersionSource_Enum> get serializer => _$platformSettingVersionSourceEnumSerializer;

  const PlatformSettingVersionSource_Enum._(String name): super(name);

  static BuiltSet<PlatformSettingVersionSource_Enum> get values => _$platformSettingVersionSourceEnumValues;
  static PlatformSettingVersionSource_Enum valueOf(String name) => _$platformSettingVersionSourceEnumValueOf(name);
}

