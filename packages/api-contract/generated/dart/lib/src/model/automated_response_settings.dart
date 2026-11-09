//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/automated_response_option.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'automated_response_settings.g.dart';

/// AutomatedResponseSettings
///
/// Properties:
/// * [enabled]
/// * [welcomeMessage]
/// * [options]
/// * [lockVersion]
@BuiltValue()
abstract class AutomatedResponseSettings implements Built<AutomatedResponseSettings, AutomatedResponseSettingsBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'welcome_message')
  String get welcomeMessage;

  @BuiltValueField(wireName: r'options')
  BuiltList<AutomatedResponseOption> get options;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  AutomatedResponseSettings._();

  factory AutomatedResponseSettings([void updates(AutomatedResponseSettingsBuilder b)]) = _$AutomatedResponseSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutomatedResponseSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutomatedResponseSettings> get serializer => _$AutomatedResponseSettingsSerializer();
}

class _$AutomatedResponseSettingsSerializer implements PrimitiveSerializer<AutomatedResponseSettings> {
  @override
  final Iterable<Type> types = const [AutomatedResponseSettings, _$AutomatedResponseSettings];

  @override
  final String wireName = r'AutomatedResponseSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutomatedResponseSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'welcome_message';
    yield serializers.serialize(
      object.welcomeMessage,
      specifiedType: const FullType(String),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(AutomatedResponseOption)]),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutomatedResponseSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutomatedResponseSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'welcome_message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.welcomeMessage = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AutomatedResponseOption)]),
          ) as BuiltList<AutomatedResponseOption>;
          result.options.replace(valueDes);
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutomatedResponseSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutomatedResponseSettingsBuilder();
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


