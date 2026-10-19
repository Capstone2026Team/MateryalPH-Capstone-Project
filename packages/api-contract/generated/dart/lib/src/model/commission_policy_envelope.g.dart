// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policy_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPolicyEnvelope extends CommissionPolicyEnvelope {
  @override
  final CommissionPolicy data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$CommissionPolicyEnvelope(
          [void Function(CommissionPolicyEnvelopeBuilder)? updates]) =>
      (CommissionPolicyEnvelopeBuilder()..update(updates))._build();

  _$CommissionPolicyEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CommissionPolicyEnvelope rebuild(
          void Function(CommissionPolicyEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPolicyEnvelopeBuilder toBuilder() =>
      CommissionPolicyEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPolicyEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CommissionPolicyEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CommissionPolicyEnvelopeBuilder
    implements
        Builder<CommissionPolicyEnvelope, CommissionPolicyEnvelopeBuilder> {
  _$CommissionPolicyEnvelope? _$v;

  CommissionPolicyBuilder? _data;
  CommissionPolicyBuilder get data =>
      _$this._data ??= CommissionPolicyBuilder();
  set data(CommissionPolicyBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  CommissionPolicyEnvelopeBuilder() {
    CommissionPolicyEnvelope._defaults(this);
  }

  CommissionPolicyEnvelopeBuilder get _$this {
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
  void replace(CommissionPolicyEnvelope other) {
    _$v = other as _$CommissionPolicyEnvelope;
  }

  @override
  void update(void Function(CommissionPolicyEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPolicyEnvelope build() => _build();

  _$CommissionPolicyEnvelope _build() {
    _$CommissionPolicyEnvelope _$result;
    try {
      _$result = _$v ??
          _$CommissionPolicyEnvelope._(
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
            r'CommissionPolicyEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
