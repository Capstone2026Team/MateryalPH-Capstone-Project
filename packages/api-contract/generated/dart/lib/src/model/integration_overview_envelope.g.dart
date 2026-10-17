// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_overview_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IntegrationOverviewEnvelope extends IntegrationOverviewEnvelope {
  @override
  final IntegrationOverview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$IntegrationOverviewEnvelope(
          [void Function(IntegrationOverviewEnvelopeBuilder)? updates]) =>
      (IntegrationOverviewEnvelopeBuilder()..update(updates))._build();

  _$IntegrationOverviewEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  IntegrationOverviewEnvelope rebuild(
          void Function(IntegrationOverviewEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IntegrationOverviewEnvelopeBuilder toBuilder() =>
      IntegrationOverviewEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IntegrationOverviewEnvelope &&
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
    return (newBuiltValueToStringHelper(r'IntegrationOverviewEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class IntegrationOverviewEnvelopeBuilder
    implements
        Builder<IntegrationOverviewEnvelope,
            IntegrationOverviewEnvelopeBuilder> {
  _$IntegrationOverviewEnvelope? _$v;

  IntegrationOverviewBuilder? _data;
  IntegrationOverviewBuilder get data =>
      _$this._data ??= IntegrationOverviewBuilder();
  set data(IntegrationOverviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  IntegrationOverviewEnvelopeBuilder() {
    IntegrationOverviewEnvelope._defaults(this);
  }

  IntegrationOverviewEnvelopeBuilder get _$this {
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
  void replace(IntegrationOverviewEnvelope other) {
    _$v = other as _$IntegrationOverviewEnvelope;
  }

  @override
  void update(void Function(IntegrationOverviewEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IntegrationOverviewEnvelope build() => _build();

  _$IntegrationOverviewEnvelope _build() {
    _$IntegrationOverviewEnvelope _$result;
    try {
      _$result = _$v ??
          _$IntegrationOverviewEnvelope._(
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
            r'IntegrationOverviewEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
