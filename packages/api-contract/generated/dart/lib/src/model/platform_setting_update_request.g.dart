// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_setting_update_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSettingUpdateRequest extends PlatformSettingUpdateRequest {
  @override
  final JsonObject? value;
  @override
  final int expectedVersion;
  @override
  final String reason;

  factory _$PlatformSettingUpdateRequest(
          [void Function(PlatformSettingUpdateRequestBuilder)? updates]) =>
      (PlatformSettingUpdateRequestBuilder()..update(updates))._build();

  _$PlatformSettingUpdateRequest._(
      {this.value, required this.expectedVersion, required this.reason})
      : super._();
  @override
  PlatformSettingUpdateRequest rebuild(
          void Function(PlatformSettingUpdateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformSettingUpdateRequestBuilder toBuilder() =>
      PlatformSettingUpdateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettingUpdateRequest &&
        value == other.value &&
        expectedVersion == other.expectedVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettingUpdateRequest')
          ..add('value', value)
          ..add('expectedVersion', expectedVersion)
          ..add('reason', reason))
        .toString();
  }
}

class PlatformSettingUpdateRequestBuilder
    implements
        Builder<PlatformSettingUpdateRequest,
            PlatformSettingUpdateRequestBuilder> {
  _$PlatformSettingUpdateRequest? _$v;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  int? _expectedVersion;
  int? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(int? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PlatformSettingUpdateRequestBuilder() {
    PlatformSettingUpdateRequest._defaults(this);
  }

  PlatformSettingUpdateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _expectedVersion = $v.expectedVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettingUpdateRequest other) {
    _$v = other as _$PlatformSettingUpdateRequest;
  }

  @override
  void update(void Function(PlatformSettingUpdateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettingUpdateRequest build() => _build();

  _$PlatformSettingUpdateRequest _build() {
    final _$result = _$v ??
        _$PlatformSettingUpdateRequest._(
          value: value,
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion,
              r'PlatformSettingUpdateRequest',
              'expectedVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'PlatformSettingUpdateRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
