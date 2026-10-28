// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_location_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QuotationLocationEnvelope extends QuotationLocationEnvelope {
  @override
  final QuotationLocation data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$QuotationLocationEnvelope(
          [void Function(QuotationLocationEnvelopeBuilder)? updates]) =>
      (QuotationLocationEnvelopeBuilder()..update(updates))._build();

  _$QuotationLocationEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  QuotationLocationEnvelope rebuild(
          void Function(QuotationLocationEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuotationLocationEnvelopeBuilder toBuilder() =>
      QuotationLocationEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuotationLocationEnvelope &&
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
    return (newBuiltValueToStringHelper(r'QuotationLocationEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class QuotationLocationEnvelopeBuilder
    implements
        Builder<QuotationLocationEnvelope, QuotationLocationEnvelopeBuilder> {
  _$QuotationLocationEnvelope? _$v;

  QuotationLocationBuilder? _data;
  QuotationLocationBuilder get data =>
      _$this._data ??= QuotationLocationBuilder();
  set data(QuotationLocationBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  QuotationLocationEnvelopeBuilder() {
    QuotationLocationEnvelope._defaults(this);
  }

  QuotationLocationEnvelopeBuilder get _$this {
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
  void replace(QuotationLocationEnvelope other) {
    _$v = other as _$QuotationLocationEnvelope;
  }

  @override
  void update(void Function(QuotationLocationEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QuotationLocationEnvelope build() => _build();

  _$QuotationLocationEnvelope _build() {
    _$QuotationLocationEnvelope _$result;
    try {
      _$result = _$v ??
          _$QuotationLocationEnvelope._(
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
            r'QuotationLocationEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
