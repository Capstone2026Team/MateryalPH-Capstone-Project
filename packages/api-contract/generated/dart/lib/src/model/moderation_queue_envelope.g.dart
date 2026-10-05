// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_queue_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ModerationQueueEnvelope extends ModerationQueueEnvelope {
  @override
  final BuiltList<ModerationQueueRow> data;
  @override
  final ReviewListMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ModerationQueueEnvelope(
          [void Function(ModerationQueueEnvelopeBuilder)? updates]) =>
      (ModerationQueueEnvelopeBuilder()..update(updates))._build();

  _$ModerationQueueEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ModerationQueueEnvelope rebuild(
          void Function(ModerationQueueEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModerationQueueEnvelopeBuilder toBuilder() =>
      ModerationQueueEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModerationQueueEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ModerationQueueEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ModerationQueueEnvelopeBuilder
    implements
        Builder<ModerationQueueEnvelope, ModerationQueueEnvelopeBuilder> {
  _$ModerationQueueEnvelope? _$v;

  ListBuilder<ModerationQueueRow>? _data;
  ListBuilder<ModerationQueueRow> get data =>
      _$this._data ??= ListBuilder<ModerationQueueRow>();
  set data(ListBuilder<ModerationQueueRow>? data) => _$this._data = data;

  ReviewListMetaBuilder? _meta;
  ReviewListMetaBuilder get meta => _$this._meta ??= ReviewListMetaBuilder();
  set meta(ReviewListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ModerationQueueEnvelopeBuilder() {
    ModerationQueueEnvelope._defaults(this);
  }

  ModerationQueueEnvelopeBuilder get _$this {
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
  void replace(ModerationQueueEnvelope other) {
    _$v = other as _$ModerationQueueEnvelope;
  }

  @override
  void update(void Function(ModerationQueueEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModerationQueueEnvelope build() => _build();

  _$ModerationQueueEnvelope _build() {
    _$ModerationQueueEnvelope _$result;
    try {
      _$result = _$v ??
          _$ModerationQueueEnvelope._(
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
            r'ModerationQueueEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
