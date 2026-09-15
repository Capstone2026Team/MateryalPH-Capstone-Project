// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountProfileEnvelope extends AccountProfileEnvelope {
  @override
  final AccountProfile data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountProfileEnvelope(
          [void Function(AccountProfileEnvelopeBuilder)? updates]) =>
      (AccountProfileEnvelopeBuilder()..update(updates))._build();

  _$AccountProfileEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountProfileEnvelope rebuild(
          void Function(AccountProfileEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountProfileEnvelopeBuilder toBuilder() =>
      AccountProfileEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountProfileEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountProfileEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountProfileEnvelopeBuilder
    implements Builder<AccountProfileEnvelope, AccountProfileEnvelopeBuilder> {
  _$AccountProfileEnvelope? _$v;

  AccountProfileBuilder? _data;
  AccountProfileBuilder get data => _$this._data ??= AccountProfileBuilder();
  set data(AccountProfileBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountProfileEnvelopeBuilder() {
    AccountProfileEnvelope._defaults(this);
  }

  AccountProfileEnvelopeBuilder get _$this {
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
  void replace(AccountProfileEnvelope other) {
    _$v = other as _$AccountProfileEnvelope;
  }

  @override
  void update(void Function(AccountProfileEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountProfileEnvelope build() => _build();

  _$AccountProfileEnvelope _build() {
    _$AccountProfileEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountProfileEnvelope._(
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
            r'AccountProfileEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
