// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_settings_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventorySettingsUpdate extends InventorySettingsUpdate {
  @override
  final int lockVersion;
  @override
  final String reminderLocalTime;
  @override
  final bool emailReminders;

  factory _$InventorySettingsUpdate(
          [void Function(InventorySettingsUpdateBuilder)? updates]) =>
      (InventorySettingsUpdateBuilder()..update(updates))._build();

  _$InventorySettingsUpdate._(
      {required this.lockVersion,
      required this.reminderLocalTime,
      required this.emailReminders})
      : super._();
  @override
  InventorySettingsUpdate rebuild(
          void Function(InventorySettingsUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventorySettingsUpdateBuilder toBuilder() =>
      InventorySettingsUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventorySettingsUpdate &&
        lockVersion == other.lockVersion &&
        reminderLocalTime == other.reminderLocalTime &&
        emailReminders == other.emailReminders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reminderLocalTime.hashCode);
    _$hash = $jc(_$hash, emailReminders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventorySettingsUpdate')
          ..add('lockVersion', lockVersion)
          ..add('reminderLocalTime', reminderLocalTime)
          ..add('emailReminders', emailReminders))
        .toString();
  }
}

class InventorySettingsUpdateBuilder
    implements
        Builder<InventorySettingsUpdate, InventorySettingsUpdateBuilder> {
  _$InventorySettingsUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reminderLocalTime;
  String? get reminderLocalTime => _$this._reminderLocalTime;
  set reminderLocalTime(String? reminderLocalTime) =>
      _$this._reminderLocalTime = reminderLocalTime;

  bool? _emailReminders;
  bool? get emailReminders => _$this._emailReminders;
  set emailReminders(bool? emailReminders) =>
      _$this._emailReminders = emailReminders;

  InventorySettingsUpdateBuilder() {
    InventorySettingsUpdate._defaults(this);
  }

  InventorySettingsUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reminderLocalTime = $v.reminderLocalTime;
      _emailReminders = $v.emailReminders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventorySettingsUpdate other) {
    _$v = other as _$InventorySettingsUpdate;
  }

  @override
  void update(void Function(InventorySettingsUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventorySettingsUpdate build() => _build();

  _$InventorySettingsUpdate _build() {
    final _$result = _$v ??
        _$InventorySettingsUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'InventorySettingsUpdate', 'lockVersion'),
          reminderLocalTime: BuiltValueNullFieldError.checkNotNull(
              reminderLocalTime,
              r'InventorySettingsUpdate',
              'reminderLocalTime'),
          emailReminders: BuiltValueNullFieldError.checkNotNull(
              emailReminders, r'InventorySettingsUpdate', 'emailReminders'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
