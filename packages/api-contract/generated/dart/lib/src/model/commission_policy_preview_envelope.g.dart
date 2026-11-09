// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policy_preview_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPolicyPreviewEnvelope
    extends CommissionPolicyPreviewEnvelope {
  @override
  final CommissionPolicyPreview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$CommissionPolicyPreviewEnvelope(
          [void Function(CommissionPolicyPreviewEnvelopeBuilder)? updates]) =>
      (CommissionPolicyPreviewEnvelopeBuilder()..update(updates))._build();

  _$CommissionPolicyPreviewEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CommissionPolicyPreviewEnvelope rebuild(
          void Function(CommissionPolicyPreviewEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPolicyPreviewEnvelopeBuilder toBuilder() =>
      CommissionPolicyPreviewEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPolicyPreviewEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CommissionPolicyPreviewEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CommissionPolicyPreviewEnvelopeBuilder
    implements
        Builder<CommissionPolicyPreviewEnvelope,
            CommissionPolicyPreviewEnvelopeBuilder> {
  _$CommissionPolicyPreviewEnvelope? _$v;

  CommissionPolicyPreviewBuilder? _data;
  CommissionPolicyPreviewBuilder get data =>
      _$this._data ??= CommissionPolicyPreviewBuilder();
  set data(CommissionPolicyPreviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  CommissionPolicyPreviewEnvelopeBuilder() {
    CommissionPolicyPreviewEnvelope._defaults(this);
  }

  CommissionPolicyPreviewEnvelopeBuilder get _$this {
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
  void replace(CommissionPolicyPreviewEnvelope other) {
    _$v = other as _$CommissionPolicyPreviewEnvelope;
  }

  @override
  void update(void Function(CommissionPolicyPreviewEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPolicyPreviewEnvelope build() => _build();

  _$CommissionPolicyPreviewEnvelope _build() {
    _$CommissionPolicyPreviewEnvelope _$result;
    try {
      _$result = _$v ??
          _$CommissionPolicyPreviewEnvelope._(
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
            r'CommissionPolicyPreviewEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
