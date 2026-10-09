// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_setting_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSettingListEnvelope extends PlatformSettingListEnvelope {
  @override
  final BuiltList<PlatformSetting> data;
  @override
  final PlatformSettingListMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$PlatformSettingListEnvelope(
          [void Function(PlatformSettingListEnvelopeBuilder)? updates]) =>
      (PlatformSettingListEnvelopeBuilder()..update(updates))._build();

  _$PlatformSettingListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PlatformSettingListEnvelope rebuild(
          void Function(PlatformSettingListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformSettingListEnvelopeBuilder toBuilder() =>
      PlatformSettingListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettingListEnvelope &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettingListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PlatformSettingListEnvelopeBuilder
    implements
        Builder<PlatformSettingListEnvelope,
            PlatformSettingListEnvelopeBuilder> {
  _$PlatformSettingListEnvelope? _$v;

  ListBuilder<PlatformSetting>? _data;
  ListBuilder<PlatformSetting> get data =>
      _$this._data ??= ListBuilder<PlatformSetting>();
  set data(ListBuilder<PlatformSetting>? data) => _$this._data = data;

  PlatformSettingListMetaBuilder? _meta;
  PlatformSettingListMetaBuilder get meta =>
      _$this._meta ??= PlatformSettingListMetaBuilder();
  set meta(PlatformSettingListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  PlatformSettingListEnvelopeBuilder() {
    PlatformSettingListEnvelope._defaults(this);
  }

  PlatformSettingListEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettingListEnvelope other) {
    _$v = other as _$PlatformSettingListEnvelope;
  }

  @override
  void update(void Function(PlatformSettingListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettingListEnvelope build() => _build();

  _$PlatformSettingListEnvelope _build() {
    _$PlatformSettingListEnvelope _$result;
    try {
      _$result = _$v ??
          _$PlatformSettingListEnvelope._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PlatformSettingListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
