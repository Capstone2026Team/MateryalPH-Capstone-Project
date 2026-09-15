// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_pending_change_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountPendingChangeEnvelope extends AccountPendingChangeEnvelope {
  @override
  final AccountPendingChange data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountPendingChangeEnvelope(
          [void Function(AccountPendingChangeEnvelopeBuilder)? updates]) =>
      (AccountPendingChangeEnvelopeBuilder()..update(updates))._build();

  _$AccountPendingChangeEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountPendingChangeEnvelope rebuild(
          void Function(AccountPendingChangeEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountPendingChangeEnvelopeBuilder toBuilder() =>
      AccountPendingChangeEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountPendingChangeEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountPendingChangeEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountPendingChangeEnvelopeBuilder
    implements
        Builder<AccountPendingChangeEnvelope,
            AccountPendingChangeEnvelopeBuilder> {
  _$AccountPendingChangeEnvelope? _$v;

  AccountPendingChangeBuilder? _data;
  AccountPendingChangeBuilder get data =>
      _$this._data ??= AccountPendingChangeBuilder();
  set data(AccountPendingChangeBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountPendingChangeEnvelopeBuilder() {
    AccountPendingChangeEnvelope._defaults(this);
  }

  AccountPendingChangeEnvelopeBuilder get _$this {
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
  void replace(AccountPendingChangeEnvelope other) {
    _$v = other as _$AccountPendingChangeEnvelope;
  }

  @override
  void update(void Function(AccountPendingChangeEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountPendingChangeEnvelope build() => _build();

  _$AccountPendingChangeEnvelope _build() {
    _$AccountPendingChangeEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountPendingChangeEnvelope._(
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
            r'AccountPendingChangeEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
