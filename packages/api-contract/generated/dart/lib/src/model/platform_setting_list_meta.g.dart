// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_setting_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSettingListMeta extends PlatformSettingListMeta {
  @override
  final BuiltList<FixedSetting>? fixed;
  @override
  final bool? canManage;
  @override
  final String? correlationId;

  factory _$PlatformSettingListMeta(
          [void Function(PlatformSettingListMetaBuilder)? updates]) =>
      (PlatformSettingListMetaBuilder()..update(updates))._build();

  _$PlatformSettingListMeta._({this.fixed, this.canManage, this.correlationId})
      : super._();
  @override
  PlatformSettingListMeta rebuild(
          void Function(PlatformSettingListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformSettingListMetaBuilder toBuilder() =>
      PlatformSettingListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettingListMeta &&
        fixed == other.fixed &&
        canManage == other.canManage &&
        correlationId == other.correlationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fixed.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettingListMeta')
          ..add('fixed', fixed)
          ..add('canManage', canManage)
          ..add('correlationId', correlationId))
        .toString();
  }
}

class PlatformSettingListMetaBuilder
    implements
        Builder<PlatformSettingListMeta, PlatformSettingListMetaBuilder> {
  _$PlatformSettingListMeta? _$v;

  ListBuilder<FixedSetting>? _fixed;
  ListBuilder<FixedSetting> get fixed =>
      _$this._fixed ??= ListBuilder<FixedSetting>();
  set fixed(ListBuilder<FixedSetting>? fixed) => _$this._fixed = fixed;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  PlatformSettingListMetaBuilder() {
    PlatformSettingListMeta._defaults(this);
  }

  PlatformSettingListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fixed = $v.fixed?.toBuilder();
      _canManage = $v.canManage;
      _correlationId = $v.correlationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettingListMeta other) {
    _$v = other as _$PlatformSettingListMeta;
  }

  @override
  void update(void Function(PlatformSettingListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettingListMeta build() => _build();

  _$PlatformSettingListMeta _build() {
    _$PlatformSettingListMeta _$result;
    try {
      _$result = _$v ??
          _$PlatformSettingListMeta._(
            fixed: _fixed?.build(),
            canManage: canManage,
            correlationId: correlationId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fixed';
        _fixed?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PlatformSettingListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
