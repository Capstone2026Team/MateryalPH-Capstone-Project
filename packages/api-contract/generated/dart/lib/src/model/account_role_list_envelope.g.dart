// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_role_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountRoleListEnvelope extends AccountRoleListEnvelope {
  @override
  final BuiltList<AccountRole> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountRoleListEnvelope(
          [void Function(AccountRoleListEnvelopeBuilder)? updates]) =>
      (AccountRoleListEnvelopeBuilder()..update(updates))._build();

  _$AccountRoleListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountRoleListEnvelope rebuild(
          void Function(AccountRoleListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountRoleListEnvelopeBuilder toBuilder() =>
      AccountRoleListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountRoleListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountRoleListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountRoleListEnvelopeBuilder
    implements
        Builder<AccountRoleListEnvelope, AccountRoleListEnvelopeBuilder> {
  _$AccountRoleListEnvelope? _$v;

  ListBuilder<AccountRole>? _data;
  ListBuilder<AccountRole> get data =>
      _$this._data ??= ListBuilder<AccountRole>();
  set data(ListBuilder<AccountRole>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountRoleListEnvelopeBuilder() {
    AccountRoleListEnvelope._defaults(this);
  }

  AccountRoleListEnvelopeBuilder get _$this {
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
  void replace(AccountRoleListEnvelope other) {
    _$v = other as _$AccountRoleListEnvelope;
  }

  @override
  void update(void Function(AccountRoleListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountRoleListEnvelope build() => _build();

  _$AccountRoleListEnvelope _build() {
    _$AccountRoleListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountRoleListEnvelope._(
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
            r'AccountRoleListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
