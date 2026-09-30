//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_settings_update.g.dart';

/// InventorySettingsUpdate
///
/// Properties:
/// * [lockVersion]
/// * [reminderLocalTime]
/// * [emailReminders]
/// * [autoAcceptReadyLeadDays] - Owner/Manager only. Omit to keep the current value.
@BuiltValue()
abstract class InventorySettingsUpdate implements Built<InventorySettingsUpdate, InventorySettingsUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reminder_local_time')
  String get reminderLocalTime;

  @BuiltValueField(wireName: r'email_reminders')
  bool get emailReminders;

  /// Owner/Manager only. Omit to keep the current value.
  @BuiltValueField(wireName: r'auto_accept_ready_lead_days')
  int? get autoAcceptReadyLeadDays;

  InventorySettingsUpdate._();

  factory InventorySettingsUpdate([void updates(InventorySettingsUpdateBuilder b)]) = _$InventorySettingsUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventorySettingsUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventorySettingsUpdate> get serializer => _$InventorySettingsUpdateSerializer();
}

class _$InventorySettingsUpdateSerializer implements PrimitiveSerializer<InventorySettingsUpdate> {
  @override
  final Iterable<Type> types = const [InventorySettingsUpdate, _$InventorySettingsUpdate];

  @override
  final String wireName = r'InventorySettingsUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventorySettingsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reminder_local_time';
    yield serializers.serialize(
      object.reminderLocalTime,
      specifiedType: const FullType(String),
    );
    yield r'email_reminders';
    yield serializers.serialize(
      object.emailReminders,
      specifiedType: const FullType(bool),
    );
    if (object.autoAcceptReadyLeadDays != null) {
      yield r'auto_accept_ready_lead_days';
      yield serializers.serialize(
        object.autoAcceptReadyLeadDays,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InventorySettingsUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventorySettingsUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'reminder_local_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reminderLocalTime = valueDes;
          break;
        case r'email_reminders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailReminders = valueDes;
          break;
        case r'auto_accept_ready_lead_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.autoAcceptReadyLeadDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventorySettingsUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventorySettingsUpdateBuilder();
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


