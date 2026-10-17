// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_eligibility_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeEligibilityEnvelope extends DisputeEligibilityEnvelope {
  @override
  final DisputeEligibility data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DisputeEligibilityEnvelope(
          [void Function(DisputeEligibilityEnvelopeBuilder)? updates]) =>
      (DisputeEligibilityEnvelopeBuilder()..update(updates))._build();

  _$DisputeEligibilityEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DisputeEligibilityEnvelope rebuild(
          void Function(DisputeEligibilityEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeEligibilityEnvelopeBuilder toBuilder() =>
      DisputeEligibilityEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeEligibilityEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DisputeEligibilityEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DisputeEligibilityEnvelopeBuilder
    implements
        Builder<DisputeEligibilityEnvelope, DisputeEligibilityEnvelopeBuilder> {
  _$DisputeEligibilityEnvelope? _$v;

  DisputeEligibilityBuilder? _data;
  DisputeEligibilityBuilder get data =>
      _$this._data ??= DisputeEligibilityBuilder();
  set data(DisputeEligibilityBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DisputeEligibilityEnvelopeBuilder() {
    DisputeEligibilityEnvelope._defaults(this);
  }

  DisputeEligibilityEnvelopeBuilder get _$this {
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
  void replace(DisputeEligibilityEnvelope other) {
    _$v = other as _$DisputeEligibilityEnvelope;
  }

  @override
  void update(void Function(DisputeEligibilityEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeEligibilityEnvelope build() => _build();

  _$DisputeEligibilityEnvelope _build() {
    _$DisputeEligibilityEnvelope _$result;
    try {
      _$result = _$v ??
          _$DisputeEligibilityEnvelope._(
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
            r'DisputeEligibilityEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
