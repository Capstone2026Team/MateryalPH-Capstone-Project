// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_filter_options_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoFilterOptionsEnvelope extends GeoFilterOptionsEnvelope {
  @override
  final BuiltList<GeoFilterOption> data;
  @override
  final PageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GeoFilterOptionsEnvelope(
          [void Function(GeoFilterOptionsEnvelopeBuilder)? updates]) =>
      (GeoFilterOptionsEnvelopeBuilder()..update(updates))._build();

  _$GeoFilterOptionsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GeoFilterOptionsEnvelope rebuild(
          void Function(GeoFilterOptionsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoFilterOptionsEnvelopeBuilder toBuilder() =>
      GeoFilterOptionsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoFilterOptionsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'GeoFilterOptionsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GeoFilterOptionsEnvelopeBuilder
    implements
        Builder<GeoFilterOptionsEnvelope, GeoFilterOptionsEnvelopeBuilder> {
  _$GeoFilterOptionsEnvelope? _$v;

  ListBuilder<GeoFilterOption>? _data;
  ListBuilder<GeoFilterOption> get data =>
      _$this._data ??= ListBuilder<GeoFilterOption>();
  set data(ListBuilder<GeoFilterOption>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GeoFilterOptionsEnvelopeBuilder() {
    GeoFilterOptionsEnvelope._defaults(this);
  }

  GeoFilterOptionsEnvelopeBuilder get _$this {
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
  void replace(GeoFilterOptionsEnvelope other) {
    _$v = other as _$GeoFilterOptionsEnvelope;
  }

  @override
  void update(void Function(GeoFilterOptionsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoFilterOptionsEnvelope build() => _build();

  _$GeoFilterOptionsEnvelope _build() {
    _$GeoFilterOptionsEnvelope _$result;
    try {
      _$result = _$v ??
          _$GeoFilterOptionsEnvelope._(
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
            r'GeoFilterOptionsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
