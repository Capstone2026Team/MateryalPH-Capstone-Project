//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_settings.g.dart';

/// InventorySettings
///
/// Properties:
/// * [reminderLocalTime]
/// * [emailReminders]
/// * [inAppReminders]
/// * [timezone]
/// * [reminderDays]
/// * [hideAfterDays]
/// * [autoAcceptReadyLeadDays] - Days after acceptance an auto-accepted Self-Pickup order is ready (Asia/Manila). Null routes Self-Pickup auto-accept to manual review.
/// * [lockVersion]
/// * [canEdit]
@BuiltValue()
abstract class InventorySettings implements Built<InventorySettings, InventorySettingsBuilder> {
  @BuiltValueField(wireName: r'reminder_local_time')
  String get reminderLocalTime;

  @BuiltValueField(wireName: r'email_reminders')
  bool get emailReminders;

  @BuiltValueField(wireName: r'in_app_reminders')
  InventorySettingsInAppRemindersEnum get inAppReminders;
  // enum inAppRemindersEnum {  true,  };

  @BuiltValueField(wireName: r'timezone')
  InventorySettingsTimezoneEnum get timezone;
  // enum timezoneEnum {  Asia/Manila,  };

  @BuiltValueField(wireName: r'reminder_days')
  BuiltList<int> get reminderDays;

  @BuiltValueField(wireName: r'hide_after_days')
  int get hideAfterDays;

  /// Days after acceptance an auto-accepted Self-Pickup order is ready (Asia/Manila). Null routes Self-Pickup auto-accept to manual review.
  @BuiltValueField(wireName: r'auto_accept_ready_lead_days')
  int? get autoAcceptReadyLeadDays;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'can_edit')
  bool get canEdit;

  InventorySettings._();

  factory InventorySettings([void updates(InventorySettingsBuilder b)]) = _$InventorySettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventorySettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventorySettings> get serializer => _$InventorySettingsSerializer();
}

class _$InventorySettingsSerializer implements PrimitiveSerializer<InventorySettings> {
  @override
  final Iterable<Type> types = const [InventorySettings, _$InventorySettings];

  @override
  final String wireName = r'InventorySettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventorySettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'in_app_reminders';
    yield serializers.serialize(
      object.inAppReminders,
      specifiedType: const FullType(InventorySettingsInAppRemindersEnum),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(InventorySettingsTimezoneEnum),
    );
    yield r'reminder_days';
    yield serializers.serialize(
      object.reminderDays,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'hide_after_days';
    yield serializers.serialize(
      object.hideAfterDays,
      specifiedType: const FullType(int),
    );
    yield r'auto_accept_ready_lead_days';
    yield object.autoAcceptReadyLeadDays == null ? null : serializers.serialize(
      object.autoAcceptReadyLeadDays,
      specifiedType: const FullType.nullable(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'can_edit';
    yield serializers.serialize(
      object.canEdit,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventorySettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventorySettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'in_app_reminders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventorySettingsInAppRemindersEnum),
          ) as InventorySettingsInAppRemindersEnum;
          result.inAppReminders = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventorySettingsTimezoneEnum),
          ) as InventorySettingsTimezoneEnum;
          result.timezone = valueDes;
          break;
        case r'reminder_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.reminderDays.replace(valueDes);
          break;
        case r'hide_after_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.hideAfterDays = valueDes;
          break;
        case r'auto_accept_ready_lead_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.autoAcceptReadyLeadDays = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'can_edit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canEdit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventorySettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventorySettingsBuilder();
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


class InventorySettingsInAppRemindersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const InventorySettingsInAppRemindersEnum true_ = _$inventorySettingsInAppRemindersEnum_true_;

  static Serializer<InventorySettingsInAppRemindersEnum> get serializer => _$inventorySettingsInAppRemindersEnumSerializer;

  const InventorySettingsInAppRemindersEnum._(String name): super(name);

  static BuiltSet<InventorySettingsInAppRemindersEnum> get values => _$inventorySettingsInAppRemindersEnumValues;
  static InventorySettingsInAppRemindersEnum valueOf(String name) => _$inventorySettingsInAppRemindersEnumValueOf(name);
}

class InventorySettingsTimezoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Asia/Manila')
  static const InventorySettingsTimezoneEnum asiaSlashManila = _$inventorySettingsTimezoneEnum_asiaSlashManila;

  static Serializer<InventorySettingsTimezoneEnum> get serializer => _$inventorySettingsTimezoneEnumSerializer;

  const InventorySettingsTimezoneEnum._(String name): super(name);

  static BuiltSet<InventorySettingsTimezoneEnum> get values => _$inventorySettingsTimezoneEnumValues;
  static InventorySettingsTimezoneEnum valueOf(String name) => _$inventorySettingsTimezoneEnumValueOf(name);
}

