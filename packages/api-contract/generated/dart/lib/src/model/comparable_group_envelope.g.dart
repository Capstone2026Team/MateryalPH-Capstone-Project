// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_group_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComparableGroupEnvelope extends ComparableGroupEnvelope {
  @override
  final ComparableGroupEnvelopeData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ComparableGroupEnvelope(
          [void Function(ComparableGroupEnvelopeBuilder)? updates]) =>
      (ComparableGroupEnvelopeBuilder()..update(updates))._build();

  _$ComparableGroupEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ComparableGroupEnvelope rebuild(
          void Function(ComparableGroupEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableGroupEnvelopeBuilder toBuilder() =>
      ComparableGroupEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableGroupEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ComparableGroupEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ComparableGroupEnvelopeBuilder
    implements
        Builder<ComparableGroupEnvelope, ComparableGroupEnvelopeBuilder> {
  _$ComparableGroupEnvelope? _$v;

  ComparableGroupEnvelopeDataBuilder? _data;
  ComparableGroupEnvelopeDataBuilder get data =>
      _$this._data ??= ComparableGroupEnvelopeDataBuilder();
  set data(ComparableGroupEnvelopeDataBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ComparableGroupEnvelopeBuilder() {
    ComparableGroupEnvelope._defaults(this);
  }

  ComparableGroupEnvelopeBuilder get _$this {
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
  void replace(ComparableGroupEnvelope other) {
    _$v = other as _$ComparableGroupEnvelope;
  }

  @override
  void update(void Function(ComparableGroupEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableGroupEnvelope build() => _build();

  _$ComparableGroupEnvelope _build() {
    _$ComparableGroupEnvelope _$result;
    try {
      _$result = _$v ??
          _$ComparableGroupEnvelope._(
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
            r'ComparableGroupEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
