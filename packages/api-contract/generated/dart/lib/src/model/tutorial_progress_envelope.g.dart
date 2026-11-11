// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_progress_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TutorialProgressEnvelope extends TutorialProgressEnvelope {
  @override
  final BuiltList<TutorialProgress> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$TutorialProgressEnvelope(
          [void Function(TutorialProgressEnvelopeBuilder)? updates]) =>
      (TutorialProgressEnvelopeBuilder()..update(updates))._build();

  _$TutorialProgressEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  TutorialProgressEnvelope rebuild(
          void Function(TutorialProgressEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TutorialProgressEnvelopeBuilder toBuilder() =>
      TutorialProgressEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TutorialProgressEnvelope &&
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
    return (newBuiltValueToStringHelper(r'TutorialProgressEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class TutorialProgressEnvelopeBuilder
    implements
        Builder<TutorialProgressEnvelope, TutorialProgressEnvelopeBuilder> {
  _$TutorialProgressEnvelope? _$v;

  ListBuilder<TutorialProgress>? _data;
  ListBuilder<TutorialProgress> get data =>
      _$this._data ??= ListBuilder<TutorialProgress>();
  set data(ListBuilder<TutorialProgress>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  TutorialProgressEnvelopeBuilder() {
    TutorialProgressEnvelope._defaults(this);
  }

  TutorialProgressEnvelopeBuilder get _$this {
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
  void replace(TutorialProgressEnvelope other) {
    _$v = other as _$TutorialProgressEnvelope;
  }

  @override
  void update(void Function(TutorialProgressEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TutorialProgressEnvelope build() => _build();

  _$TutorialProgressEnvelope _build() {
    _$TutorialProgressEnvelope _$result;
    try {
      _$result = _$v ??
          _$TutorialProgressEnvelope._(
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
            r'TutorialProgressEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
