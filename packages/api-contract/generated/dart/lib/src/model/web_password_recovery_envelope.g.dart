// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_password_recovery_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WebPasswordRecoveryEnvelope extends WebPasswordRecoveryEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<JsonObject?> errors;

  factory _$WebPasswordRecoveryEnvelope(
          [void Function(WebPasswordRecoveryEnvelopeBuilder)? updates]) =>
      (WebPasswordRecoveryEnvelopeBuilder()..update(updates))._build();

  _$WebPasswordRecoveryEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  WebPasswordRecoveryEnvelope rebuild(
          void Function(WebPasswordRecoveryEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WebPasswordRecoveryEnvelopeBuilder toBuilder() =>
      WebPasswordRecoveryEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WebPasswordRecoveryEnvelope &&
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
    return (newBuiltValueToStringHelper(r'WebPasswordRecoveryEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class WebPasswordRecoveryEnvelopeBuilder
    implements
        Builder<WebPasswordRecoveryEnvelope,
            WebPasswordRecoveryEnvelopeBuilder>,
        SuccessEnvelopeBuilder {
  _$WebPasswordRecoveryEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(covariant MapBuilder<String, JsonObject?>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(covariant MapBuilder<String, JsonObject?>? meta) =>
      _$this._meta = meta;

  ListBuilder<JsonObject?>? _errors;
  ListBuilder<JsonObject?> get errors =>
      _$this._errors ??= ListBuilder<JsonObject?>();
  set errors(covariant ListBuilder<JsonObject?>? errors) =>
      _$this._errors = errors;

  WebPasswordRecoveryEnvelopeBuilder() {
    WebPasswordRecoveryEnvelope._defaults(this);
  }

  WebPasswordRecoveryEnvelopeBuilder get _$this {
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
  void replace(covariant WebPasswordRecoveryEnvelope other) {
    _$v = other as _$WebPasswordRecoveryEnvelope;
  }

  @override
  void update(void Function(WebPasswordRecoveryEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WebPasswordRecoveryEnvelope build() => _build();

  _$WebPasswordRecoveryEnvelope _build() {
    _$WebPasswordRecoveryEnvelope _$result;
    try {
      _$result = _$v ??
          _$WebPasswordRecoveryEnvelope._(
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
            r'WebPasswordRecoveryEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
