// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ModerationDetailEnvelope extends ModerationDetailEnvelope {
  @override
  final ModerationDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ModerationDetailEnvelope(
          [void Function(ModerationDetailEnvelopeBuilder)? updates]) =>
      (ModerationDetailEnvelopeBuilder()..update(updates))._build();

  _$ModerationDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ModerationDetailEnvelope rebuild(
          void Function(ModerationDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModerationDetailEnvelopeBuilder toBuilder() =>
      ModerationDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModerationDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ModerationDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ModerationDetailEnvelopeBuilder
    implements
        Builder<ModerationDetailEnvelope, ModerationDetailEnvelopeBuilder> {
  _$ModerationDetailEnvelope? _$v;

  ModerationDetailBuilder? _data;
  ModerationDetailBuilder get data =>
      _$this._data ??= ModerationDetailBuilder();
  set data(ModerationDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ModerationDetailEnvelopeBuilder() {
    ModerationDetailEnvelope._defaults(this);
  }

  ModerationDetailEnvelopeBuilder get _$this {
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
  void replace(ModerationDetailEnvelope other) {
    _$v = other as _$ModerationDetailEnvelope;
  }

  @override
  void update(void Function(ModerationDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModerationDetailEnvelope build() => _build();

  _$ModerationDetailEnvelope _build() {
    _$ModerationDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$ModerationDetailEnvelope._(
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
            r'ModerationDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
