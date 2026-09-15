// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_membership_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountMembershipListEnvelope extends AccountMembershipListEnvelope {
  @override
  final BuiltList<AccountMembership> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountMembershipListEnvelope(
          [void Function(AccountMembershipListEnvelopeBuilder)? updates]) =>
      (AccountMembershipListEnvelopeBuilder()..update(updates))._build();

  _$AccountMembershipListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountMembershipListEnvelope rebuild(
          void Function(AccountMembershipListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountMembershipListEnvelopeBuilder toBuilder() =>
      AccountMembershipListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountMembershipListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountMembershipListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountMembershipListEnvelopeBuilder
    implements
        Builder<AccountMembershipListEnvelope,
            AccountMembershipListEnvelopeBuilder> {
  _$AccountMembershipListEnvelope? _$v;

  ListBuilder<AccountMembership>? _data;
  ListBuilder<AccountMembership> get data =>
      _$this._data ??= ListBuilder<AccountMembership>();
  set data(ListBuilder<AccountMembership>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountMembershipListEnvelopeBuilder() {
    AccountMembershipListEnvelope._defaults(this);
  }

  AccountMembershipListEnvelopeBuilder get _$this {
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
  void replace(AccountMembershipListEnvelope other) {
    _$v = other as _$AccountMembershipListEnvelope;
  }

  @override
  void update(void Function(AccountMembershipListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountMembershipListEnvelope build() => _build();

  _$AccountMembershipListEnvelope _build() {
    _$AccountMembershipListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountMembershipListEnvelope._(
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
            r'AccountMembershipListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
