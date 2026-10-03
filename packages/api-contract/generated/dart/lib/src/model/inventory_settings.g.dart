// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InventorySettingsInAppRemindersEnum
    _$inventorySettingsInAppRemindersEnum_true_ =
    const InventorySettingsInAppRemindersEnum._('true_');

InventorySettingsInAppRemindersEnum
    _$inventorySettingsInAppRemindersEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$inventorySettingsInAppRemindersEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventorySettingsInAppRemindersEnum>
    _$inventorySettingsInAppRemindersEnumValues = BuiltSet<
        InventorySettingsInAppRemindersEnum>(const <InventorySettingsInAppRemindersEnum>[
  _$inventorySettingsInAppRemindersEnum_true_,
]);

const InventorySettingsTimezoneEnum
    _$inventorySettingsTimezoneEnum_asiaSlashManila =
    const InventorySettingsTimezoneEnum._('asiaSlashManila');

InventorySettingsTimezoneEnum _$inventorySettingsTimezoneEnumValueOf(
    String name) {
  switch (name) {
    case 'asiaSlashManila':
      return _$inventorySettingsTimezoneEnum_asiaSlashManila;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventorySettingsTimezoneEnum>
    _$inventorySettingsTimezoneEnumValues = BuiltSet<
        InventorySettingsTimezoneEnum>(const <InventorySettingsTimezoneEnum>[
  _$inventorySettingsTimezoneEnum_asiaSlashManila,
]);

Serializer<InventorySettingsInAppRemindersEnum>
    _$inventorySettingsInAppRemindersEnumSerializer =
    _$InventorySettingsInAppRemindersEnumSerializer();
Serializer<InventorySettingsTimezoneEnum>
    _$inventorySettingsTimezoneEnumSerializer =
    _$InventorySettingsTimezoneEnumSerializer();

class _$InventorySettingsInAppRemindersEnumSerializer
    implements PrimitiveSerializer<InventorySettingsInAppRemindersEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    InventorySettingsInAppRemindersEnum
  ];
  @override
  final String wireName = 'InventorySettingsInAppRemindersEnum';

  @override
  Object serialize(
          Serializers serializers, InventorySettingsInAppRemindersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventorySettingsInAppRemindersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventorySettingsInAppRemindersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventorySettingsTimezoneEnumSerializer
    implements PrimitiveSerializer<InventorySettingsTimezoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'asiaSlashManila': 'Asia/Manila',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Asia/Manila': 'asiaSlashManila',
  };

  @override
  final Iterable<Type> types = const <Type>[InventorySettingsTimezoneEnum];
  @override
  final String wireName = 'InventorySettingsTimezoneEnum';

  @override
  Object serialize(
          Serializers serializers, InventorySettingsTimezoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventorySettingsTimezoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventorySettingsTimezoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventorySettings extends InventorySettings {
  @override
  final String reminderLocalTime;
  @override
  final bool emailReminders;
  @override
  final InventorySettingsInAppRemindersEnum inAppReminders;
  @override
  final InventorySettingsTimezoneEnum timezone;
  @override
  final BuiltList<int> reminderDays;
  @override
  final int hideAfterDays;
  @override
  final int? autoAcceptReadyLeadDays;
  @override
  final int lockVersion;
  @override
  final bool canEdit;

  factory _$InventorySettings(
          [void Function(InventorySettingsBuilder)? updates]) =>
      (InventorySettingsBuilder()..update(updates))._build();

  _$InventorySettings._(
      {required this.reminderLocalTime,
      required this.emailReminders,
      required this.inAppReminders,
      required this.timezone,
      required this.reminderDays,
      required this.hideAfterDays,
      this.autoAcceptReadyLeadDays,
      required this.lockVersion,
      required this.canEdit})
      : super._();
  @override
  InventorySettings rebuild(void Function(InventorySettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventorySettingsBuilder toBuilder() =>
      InventorySettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventorySettings &&
        reminderLocalTime == other.reminderLocalTime &&
        emailReminders == other.emailReminders &&
        inAppReminders == other.inAppReminders &&
        timezone == other.timezone &&
        reminderDays == other.reminderDays &&
        hideAfterDays == other.hideAfterDays &&
        autoAcceptReadyLeadDays == other.autoAcceptReadyLeadDays &&
        lockVersion == other.lockVersion &&
        canEdit == other.canEdit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reminderLocalTime.hashCode);
    _$hash = $jc(_$hash, emailReminders.hashCode);
    _$hash = $jc(_$hash, inAppReminders.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, reminderDays.hashCode);
    _$hash = $jc(_$hash, hideAfterDays.hashCode);
    _$hash = $jc(_$hash, autoAcceptReadyLeadDays.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, canEdit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventorySettings')
          ..add('reminderLocalTime', reminderLocalTime)
          ..add('emailReminders', emailReminders)
          ..add('inAppReminders', inAppReminders)
          ..add('timezone', timezone)
          ..add('reminderDays', reminderDays)
          ..add('hideAfterDays', hideAfterDays)
          ..add('autoAcceptReadyLeadDays', autoAcceptReadyLeadDays)
          ..add('lockVersion', lockVersion)
          ..add('canEdit', canEdit))
        .toString();
  }
}

class InventorySettingsBuilder
    implements Builder<InventorySettings, InventorySettingsBuilder> {
  _$InventorySettings? _$v;

  String? _reminderLocalTime;
  String? get reminderLocalTime => _$this._reminderLocalTime;
  set reminderLocalTime(String? reminderLocalTime) =>
      _$this._reminderLocalTime = reminderLocalTime;

  bool? _emailReminders;
  bool? get emailReminders => _$this._emailReminders;
  set emailReminders(bool? emailReminders) =>
      _$this._emailReminders = emailReminders;

  InventorySettingsInAppRemindersEnum? _inAppReminders;
  InventorySettingsInAppRemindersEnum? get inAppReminders =>
      _$this._inAppReminders;
  set inAppReminders(InventorySettingsInAppRemindersEnum? inAppReminders) =>
      _$this._inAppReminders = inAppReminders;

  InventorySettingsTimezoneEnum? _timezone;
  InventorySettingsTimezoneEnum? get timezone => _$this._timezone;
  set timezone(InventorySettingsTimezoneEnum? timezone) =>
      _$this._timezone = timezone;

  ListBuilder<int>? _reminderDays;
  ListBuilder<int> get reminderDays =>
      _$this._reminderDays ??= ListBuilder<int>();
  set reminderDays(ListBuilder<int>? reminderDays) =>
      _$this._reminderDays = reminderDays;

  int? _hideAfterDays;
  int? get hideAfterDays => _$this._hideAfterDays;
  set hideAfterDays(int? hideAfterDays) =>
      _$this._hideAfterDays = hideAfterDays;

  int? _autoAcceptReadyLeadDays;
  int? get autoAcceptReadyLeadDays => _$this._autoAcceptReadyLeadDays;
  set autoAcceptReadyLeadDays(int? autoAcceptReadyLeadDays) =>
      _$this._autoAcceptReadyLeadDays = autoAcceptReadyLeadDays;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _canEdit;
  bool? get canEdit => _$this._canEdit;
  set canEdit(bool? canEdit) => _$this._canEdit = canEdit;

  InventorySettingsBuilder() {
    InventorySettings._defaults(this);
  }

  InventorySettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reminderLocalTime = $v.reminderLocalTime;
      _emailReminders = $v.emailReminders;
      _inAppReminders = $v.inAppReminders;
      _timezone = $v.timezone;
      _reminderDays = $v.reminderDays.toBuilder();
      _hideAfterDays = $v.hideAfterDays;
      _autoAcceptReadyLeadDays = $v.autoAcceptReadyLeadDays;
      _lockVersion = $v.lockVersion;
      _canEdit = $v.canEdit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventorySettings other) {
    _$v = other as _$InventorySettings;
  }

  @override
  void update(void Function(InventorySettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventorySettings build() => _build();

  _$InventorySettings _build() {
    _$InventorySettings _$result;
    try {
      _$result = _$v ??
          _$InventorySettings._(
            reminderLocalTime: BuiltValueNullFieldError.checkNotNull(
                reminderLocalTime, r'InventorySettings', 'reminderLocalTime'),
            emailReminders: BuiltValueNullFieldError.checkNotNull(
                emailReminders, r'InventorySettings', 'emailReminders'),
            inAppReminders: BuiltValueNullFieldError.checkNotNull(
                inAppReminders, r'InventorySettings', 'inAppReminders'),
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'InventorySettings', 'timezone'),
            reminderDays: reminderDays.build(),
            hideAfterDays: BuiltValueNullFieldError.checkNotNull(
                hideAfterDays, r'InventorySettings', 'hideAfterDays'),
            autoAcceptReadyLeadDays: autoAcceptReadyLeadDays,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'InventorySettings', 'lockVersion'),
            canEdit: BuiltValueNullFieldError.checkNotNull(
                canEdit, r'InventorySettings', 'canEdit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reminderDays';
        reminderDays.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InventorySettings', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
