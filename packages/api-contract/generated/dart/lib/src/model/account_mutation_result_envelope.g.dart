// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_mutation_result_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountMutationResultEnvelope extends AccountMutationResultEnvelope {
  @override
  final AccountMutationResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountMutationResultEnvelope(
          [void Function(AccountMutationResultEnvelopeBuilder)? updates]) =>
      (AccountMutationResultEnvelopeBuilder()..update(updates))._build();

  _$AccountMutationResultEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountMutationResultEnvelope rebuild(
          void Function(AccountMutationResultEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountMutationResultEnvelopeBuilder toBuilder() =>
      AccountMutationResultEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountMutationResultEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountMutationResultEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountMutationResultEnvelopeBuilder
    implements
        Builder<AccountMutationResultEnvelope,
            AccountMutationResultEnvelopeBuilder> {
  _$AccountMutationResultEnvelope? _$v;

  AccountMutationResultBuilder? _data;
  AccountMutationResultBuilder get data =>
      _$this._data ??= AccountMutationResultBuilder();
  set data(AccountMutationResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountMutationResultEnvelopeBuilder() {
    AccountMutationResultEnvelope._defaults(this);
  }

  AccountMutationResultEnvelopeBuilder get _$this {
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
  void replace(AccountMutationResultEnvelope other) {
    _$v = other as _$AccountMutationResultEnvelope;
  }

  @override
  void update(void Function(AccountMutationResultEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountMutationResultEnvelope build() => _build();

  _$AccountMutationResultEnvelope _build() {
    _$AccountMutationResultEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountMutationResultEnvelope._(
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
            r'AccountMutationResultEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
