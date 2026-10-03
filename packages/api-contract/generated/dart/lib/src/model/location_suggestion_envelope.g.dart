// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_suggestion_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationSuggestionEnvelope extends LocationSuggestionEnvelope {
  @override
  final BuiltList<LocationSuggestion> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$LocationSuggestionEnvelope(
          [void Function(LocationSuggestionEnvelopeBuilder)? updates]) =>
      (LocationSuggestionEnvelopeBuilder()..update(updates))._build();

  _$LocationSuggestionEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  LocationSuggestionEnvelope rebuild(
          void Function(LocationSuggestionEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationSuggestionEnvelopeBuilder toBuilder() =>
      LocationSuggestionEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationSuggestionEnvelope &&
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
    return (newBuiltValueToStringHelper(r'LocationSuggestionEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class LocationSuggestionEnvelopeBuilder
    implements
        Builder<LocationSuggestionEnvelope, LocationSuggestionEnvelopeBuilder> {
  _$LocationSuggestionEnvelope? _$v;

  ListBuilder<LocationSuggestion>? _data;
  ListBuilder<LocationSuggestion> get data =>
      _$this._data ??= ListBuilder<LocationSuggestion>();
  set data(ListBuilder<LocationSuggestion>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  LocationSuggestionEnvelopeBuilder() {
    LocationSuggestionEnvelope._defaults(this);
  }

  LocationSuggestionEnvelopeBuilder get _$this {
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
  void replace(LocationSuggestionEnvelope other) {
    _$v = other as _$LocationSuggestionEnvelope;
  }

  @override
  void update(void Function(LocationSuggestionEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationSuggestionEnvelope build() => _build();

  _$LocationSuggestionEnvelope _build() {
    _$LocationSuggestionEnvelope _$result;
    try {
      _$result = _$v ??
          _$LocationSuggestionEnvelope._(
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
            r'LocationSuggestionEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
