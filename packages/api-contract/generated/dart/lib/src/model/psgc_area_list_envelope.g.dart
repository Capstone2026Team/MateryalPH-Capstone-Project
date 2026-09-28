// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_area_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PsgcAreaListEnvelope extends PsgcAreaListEnvelope {
  @override
  final BuiltList<PsgcAreaOption> data;
  @override
  final PsgcAreaListMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$PsgcAreaListEnvelope(
          [void Function(PsgcAreaListEnvelopeBuilder)? updates]) =>
      (PsgcAreaListEnvelopeBuilder()..update(updates))._build();

  _$PsgcAreaListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PsgcAreaListEnvelope rebuild(
          void Function(PsgcAreaListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcAreaListEnvelopeBuilder toBuilder() =>
      PsgcAreaListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcAreaListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PsgcAreaListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PsgcAreaListEnvelopeBuilder
    implements Builder<PsgcAreaListEnvelope, PsgcAreaListEnvelopeBuilder> {
  _$PsgcAreaListEnvelope? _$v;

  ListBuilder<PsgcAreaOption>? _data;
  ListBuilder<PsgcAreaOption> get data =>
      _$this._data ??= ListBuilder<PsgcAreaOption>();
  set data(ListBuilder<PsgcAreaOption>? data) => _$this._data = data;

  PsgcAreaListMetaBuilder? _meta;
  PsgcAreaListMetaBuilder get meta =>
      _$this._meta ??= PsgcAreaListMetaBuilder();
  set meta(PsgcAreaListMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  PsgcAreaListEnvelopeBuilder() {
    PsgcAreaListEnvelope._defaults(this);
  }

  PsgcAreaListEnvelopeBuilder get _$this {
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
  void replace(PsgcAreaListEnvelope other) {
    _$v = other as _$PsgcAreaListEnvelope;
  }

  @override
  void update(void Function(PsgcAreaListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcAreaListEnvelope build() => _build();

  _$PsgcAreaListEnvelope _build() {
    _$PsgcAreaListEnvelope _$result;
    try {
      _$result = _$v ??
          _$PsgcAreaListEnvelope._(
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
            r'PsgcAreaListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
