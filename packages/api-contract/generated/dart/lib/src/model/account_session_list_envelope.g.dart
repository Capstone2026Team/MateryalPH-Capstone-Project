// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_session_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountSessionListEnvelope extends AccountSessionListEnvelope {
  @override
  final BuiltList<AccountSession> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountSessionListEnvelope(
          [void Function(AccountSessionListEnvelopeBuilder)? updates]) =>
      (AccountSessionListEnvelopeBuilder()..update(updates))._build();

  _$AccountSessionListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountSessionListEnvelope rebuild(
          void Function(AccountSessionListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountSessionListEnvelopeBuilder toBuilder() =>
      AccountSessionListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountSessionListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountSessionListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountSessionListEnvelopeBuilder
    implements
        Builder<AccountSessionListEnvelope, AccountSessionListEnvelopeBuilder> {
  _$AccountSessionListEnvelope? _$v;

  ListBuilder<AccountSession>? _data;
  ListBuilder<AccountSession> get data =>
      _$this._data ??= ListBuilder<AccountSession>();
  set data(ListBuilder<AccountSession>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountSessionListEnvelopeBuilder() {
    AccountSessionListEnvelope._defaults(this);
  }

  AccountSessionListEnvelopeBuilder get _$this {
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
  void replace(AccountSessionListEnvelope other) {
    _$v = other as _$AccountSessionListEnvelope;
  }

  @override
  void update(void Function(AccountSessionListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountSessionListEnvelope build() => _build();

  _$AccountSessionListEnvelope _build() {
    _$AccountSessionListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountSessionListEnvelope._(
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
            r'AccountSessionListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
