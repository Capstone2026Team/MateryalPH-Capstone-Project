// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_administrator_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountAdministratorListEnvelope
    extends AccountAdministratorListEnvelope {
  @override
  final BuiltList<AccountAdministrator> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountAdministratorListEnvelope(
          [void Function(AccountAdministratorListEnvelopeBuilder)? updates]) =>
      (AccountAdministratorListEnvelopeBuilder()..update(updates))._build();

  _$AccountAdministratorListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountAdministratorListEnvelope rebuild(
          void Function(AccountAdministratorListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountAdministratorListEnvelopeBuilder toBuilder() =>
      AccountAdministratorListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountAdministratorListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountAdministratorListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountAdministratorListEnvelopeBuilder
    implements
        Builder<AccountAdministratorListEnvelope,
            AccountAdministratorListEnvelopeBuilder> {
  _$AccountAdministratorListEnvelope? _$v;

  ListBuilder<AccountAdministrator>? _data;
  ListBuilder<AccountAdministrator> get data =>
      _$this._data ??= ListBuilder<AccountAdministrator>();
  set data(ListBuilder<AccountAdministrator>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountAdministratorListEnvelopeBuilder() {
    AccountAdministratorListEnvelope._defaults(this);
  }

  AccountAdministratorListEnvelopeBuilder get _$this {
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
  void replace(AccountAdministratorListEnvelope other) {
    _$v = other as _$AccountAdministratorListEnvelope;
  }

  @override
  void update(void Function(AccountAdministratorListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountAdministratorListEnvelope build() => _build();

  _$AccountAdministratorListEnvelope _build() {
    _$AccountAdministratorListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountAdministratorListEnvelope._(
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
            r'AccountAdministratorListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
