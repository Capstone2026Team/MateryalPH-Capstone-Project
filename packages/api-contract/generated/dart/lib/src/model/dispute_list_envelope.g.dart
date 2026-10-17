// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeListEnvelope extends DisputeListEnvelope {
  @override
  final BuiltList<DisputeSummary> data;
  @override
  final DisputeListMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DisputeListEnvelope(
          [void Function(DisputeListEnvelopeBuilder)? updates]) =>
      (DisputeListEnvelopeBuilder()..update(updates))._build();

  _$DisputeListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DisputeListEnvelope rebuild(
          void Function(DisputeListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeListEnvelopeBuilder toBuilder() =>
      DisputeListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DisputeListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DisputeListEnvelopeBuilder
    implements Builder<DisputeListEnvelope, DisputeListEnvelopeBuilder> {
  _$DisputeListEnvelope? _$v;

  ListBuilder<DisputeSummary>? _data;
  ListBuilder<DisputeSummary> get data =>
      _$this._data ??= ListBuilder<DisputeSummary>();
  set data(ListBuilder<DisputeSummary>? data) => _$this._data = data;

  DisputeListMetaBuilder? _meta;
  DisputeListMetaBuilder get meta => _$this._meta ??= DisputeListMetaBuilder();
  set meta(DisputeListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DisputeListEnvelopeBuilder() {
    DisputeListEnvelope._defaults(this);
  }

  DisputeListEnvelopeBuilder get _$this {
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
  void replace(DisputeListEnvelope other) {
    _$v = other as _$DisputeListEnvelope;
  }

  @override
  void update(void Function(DisputeListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeListEnvelope build() => _build();

  _$DisputeListEnvelope _build() {
    _$DisputeListEnvelope _$result;
    try {
      _$result = _$v ??
          _$DisputeListEnvelope._(
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
            r'DisputeListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
