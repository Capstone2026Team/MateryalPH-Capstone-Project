// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policies_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPoliciesEnvelope extends CommissionPoliciesEnvelope {
  @override
  final CommissionPolicies data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$CommissionPoliciesEnvelope(
          [void Function(CommissionPoliciesEnvelopeBuilder)? updates]) =>
      (CommissionPoliciesEnvelopeBuilder()..update(updates))._build();

  _$CommissionPoliciesEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CommissionPoliciesEnvelope rebuild(
          void Function(CommissionPoliciesEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPoliciesEnvelopeBuilder toBuilder() =>
      CommissionPoliciesEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPoliciesEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CommissionPoliciesEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CommissionPoliciesEnvelopeBuilder
    implements
        Builder<CommissionPoliciesEnvelope, CommissionPoliciesEnvelopeBuilder> {
  _$CommissionPoliciesEnvelope? _$v;

  CommissionPoliciesBuilder? _data;
  CommissionPoliciesBuilder get data =>
      _$this._data ??= CommissionPoliciesBuilder();
  set data(CommissionPoliciesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  CommissionPoliciesEnvelopeBuilder() {
    CommissionPoliciesEnvelope._defaults(this);
  }

  CommissionPoliciesEnvelopeBuilder get _$this {
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
  void replace(CommissionPoliciesEnvelope other) {
    _$v = other as _$CommissionPoliciesEnvelope;
  }

  @override
  void update(void Function(CommissionPoliciesEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPoliciesEnvelope build() => _build();

  _$CommissionPoliciesEnvelope _build() {
    _$CommissionPoliciesEnvelope _$result;
    try {
      _$result = _$v ??
          _$CommissionPoliciesEnvelope._(
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
            r'CommissionPoliciesEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
