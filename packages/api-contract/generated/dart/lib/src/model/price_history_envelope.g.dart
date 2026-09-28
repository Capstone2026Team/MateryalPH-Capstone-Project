// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PriceHistoryEnvelope extends PriceHistoryEnvelope {
  @override
  final BuiltList<PriceHistoryEntry> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$PriceHistoryEnvelope(
          [void Function(PriceHistoryEnvelopeBuilder)? updates]) =>
      (PriceHistoryEnvelopeBuilder()..update(updates))._build();

  _$PriceHistoryEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PriceHistoryEnvelope rebuild(
          void Function(PriceHistoryEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PriceHistoryEnvelopeBuilder toBuilder() =>
      PriceHistoryEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PriceHistoryEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PriceHistoryEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PriceHistoryEnvelopeBuilder
    implements Builder<PriceHistoryEnvelope, PriceHistoryEnvelopeBuilder> {
  _$PriceHistoryEnvelope? _$v;

  ListBuilder<PriceHistoryEntry>? _data;
  ListBuilder<PriceHistoryEntry> get data =>
      _$this._data ??= ListBuilder<PriceHistoryEntry>();
  set data(ListBuilder<PriceHistoryEntry>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  PriceHistoryEnvelopeBuilder() {
    PriceHistoryEnvelope._defaults(this);
  }

  PriceHistoryEnvelopeBuilder get _$this {
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
  void replace(PriceHistoryEnvelope other) {
    _$v = other as _$PriceHistoryEnvelope;
  }

  @override
  void update(void Function(PriceHistoryEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PriceHistoryEnvelope build() => _build();

  _$PriceHistoryEnvelope _build() {
    _$PriceHistoryEnvelope _$result;
    try {
      _$result = _$v ??
          _$PriceHistoryEnvelope._(
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
            r'PriceHistoryEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
