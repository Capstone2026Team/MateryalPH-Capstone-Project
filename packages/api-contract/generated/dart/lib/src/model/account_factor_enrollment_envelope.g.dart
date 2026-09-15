// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_factor_enrollment_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountFactorEnrollmentEnvelope
    extends AccountFactorEnrollmentEnvelope {
  @override
  final AccountFactorEnrollment data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AccountFactorEnrollmentEnvelope(
          [void Function(AccountFactorEnrollmentEnvelopeBuilder)? updates]) =>
      (AccountFactorEnrollmentEnvelopeBuilder()..update(updates))._build();

  _$AccountFactorEnrollmentEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AccountFactorEnrollmentEnvelope rebuild(
          void Function(AccountFactorEnrollmentEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountFactorEnrollmentEnvelopeBuilder toBuilder() =>
      AccountFactorEnrollmentEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountFactorEnrollmentEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AccountFactorEnrollmentEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AccountFactorEnrollmentEnvelopeBuilder
    implements
        Builder<AccountFactorEnrollmentEnvelope,
            AccountFactorEnrollmentEnvelopeBuilder> {
  _$AccountFactorEnrollmentEnvelope? _$v;

  AccountFactorEnrollmentBuilder? _data;
  AccountFactorEnrollmentBuilder get data =>
      _$this._data ??= AccountFactorEnrollmentBuilder();
  set data(AccountFactorEnrollmentBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AccountFactorEnrollmentEnvelopeBuilder() {
    AccountFactorEnrollmentEnvelope._defaults(this);
  }

  AccountFactorEnrollmentEnvelopeBuilder get _$this {
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
  void replace(AccountFactorEnrollmentEnvelope other) {
    _$v = other as _$AccountFactorEnrollmentEnvelope;
  }

  @override
  void update(void Function(AccountFactorEnrollmentEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountFactorEnrollmentEnvelope build() => _build();

  _$AccountFactorEnrollmentEnvelope _build() {
    _$AccountFactorEnrollmentEnvelope _$result;
    try {
      _$result = _$v ??
          _$AccountFactorEnrollmentEnvelope._(
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
            r'AccountFactorEnrollmentEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
