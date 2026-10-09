//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_setting.g.dart';

/// An approved non-secret default. Version 0 means the approved default has never been stored; consuming rules apply it to new records only.
///
/// Properties:
/// * [key]
/// * [group]
/// * [label]
/// * [description]
/// * [validationRule]
/// * [appliesTo]
/// * [value]
/// * [defaultValue]
/// * [version]
/// * [previousValue]
/// * [lastReason]
/// * [updatedAt]
/// * [updatedBy]
/// * [editable]
@BuiltValue()
abstract class PlatformSetting implements Built<PlatformSetting, PlatformSettingBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'group')
  String get group;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'validation_rule')
  String get validationRule;

  @BuiltValueField(wireName: r'applies_to')
  String get appliesTo;

  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  @BuiltValueField(wireName: r'default_value')
  JsonObject? get defaultValue;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'previous_value')
  JsonObject? get previousValue;

  @BuiltValueField(wireName: r'last_reason')
  String? get lastReason;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'updated_by')
  String? get updatedBy;

  @BuiltValueField(wireName: r'editable')
  bool get editable;

  PlatformSetting._();

  factory PlatformSetting([void updates(PlatformSettingBuilder b)]) = _$PlatformSetting;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSetting> get serializer => _$PlatformSettingSerializer();
}

class _$PlatformSettingSerializer implements PrimitiveSerializer<PlatformSetting> {
  @override
  final Iterable<Type> types = const [PlatformSetting, _$PlatformSetting];

  @override
  final String wireName = r'PlatformSetting';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'validation_rule';
    yield serializers.serialize(
      object.validationRule,
      specifiedType: const FullType(String),
    );
    yield r'applies_to';
    yield serializers.serialize(
      object.appliesTo,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield object.value == null ? null : serializers.serialize(
      object.value,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'default_value';
    yield object.defaultValue == null ? null : serializers.serialize(
      object.defaultValue,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    if (object.previousValue != null) {
      yield r'previous_value';
      yield serializers.serialize(
        object.previousValue,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    if (object.lastReason != null) {
      yield r'last_reason';
      yield serializers.serialize(
        object.lastReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.updatedBy != null) {
      yield r'updated_by';
      yield serializers.serialize(
        object.updatedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'editable';
    yield serializers.serialize(
      object.editable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSetting object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.group = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'validation_rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.validationRule = valueDes;
          break;
        case r'applies_to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appliesTo = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'default_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.defaultValue = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'previous_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.previousValue = valueDes;
          break;
        case r'last_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastReason = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'updated_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updatedBy = valueDes;
          break;
        case r'editable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.editable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSetting deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingBuilder();
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


