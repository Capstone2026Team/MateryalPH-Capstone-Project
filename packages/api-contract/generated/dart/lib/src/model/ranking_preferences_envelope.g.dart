// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_preferences_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RankingPreferencesEnvelope extends RankingPreferencesEnvelope {
  @override
  final RankingPreferences data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$RankingPreferencesEnvelope(
          [void Function(RankingPreferencesEnvelopeBuilder)? updates]) =>
      (RankingPreferencesEnvelopeBuilder()..update(updates))._build();

  _$RankingPreferencesEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RankingPreferencesEnvelope rebuild(
          void Function(RankingPreferencesEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingPreferencesEnvelopeBuilder toBuilder() =>
      RankingPreferencesEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingPreferencesEnvelope &&
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
    return (newBuiltValueToStringHelper(r'RankingPreferencesEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RankingPreferencesEnvelopeBuilder
    implements
        Builder<RankingPreferencesEnvelope, RankingPreferencesEnvelopeBuilder> {
  _$RankingPreferencesEnvelope? _$v;

  RankingPreferencesBuilder? _data;
  RankingPreferencesBuilder get data =>
      _$this._data ??= RankingPreferencesBuilder();
  set data(RankingPreferencesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  RankingPreferencesEnvelopeBuilder() {
    RankingPreferencesEnvelope._defaults(this);
  }

  RankingPreferencesEnvelopeBuilder get _$this {
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
  void replace(RankingPreferencesEnvelope other) {
    _$v = other as _$RankingPreferencesEnvelope;
  }

  @override
  void update(void Function(RankingPreferencesEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingPreferencesEnvelope build() => _build();

  _$RankingPreferencesEnvelope _build() {
    _$RankingPreferencesEnvelope _$result;
    try {
      _$result = _$v ??
          _$RankingPreferencesEnvelope._(
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
            r'RankingPreferencesEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
