// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_materials_analytics_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMaterialsAnalyticsDetailEnvelope
    extends AdminMaterialsAnalyticsDetailEnvelope {
  @override
  final AdminMaterialsAnalyticsDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminMaterialsAnalyticsDetailEnvelope(
          [void Function(AdminMaterialsAnalyticsDetailEnvelopeBuilder)?
              updates]) =>
      (AdminMaterialsAnalyticsDetailEnvelopeBuilder()..update(updates))
          ._build();

  _$AdminMaterialsAnalyticsDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminMaterialsAnalyticsDetailEnvelope rebuild(
          void Function(AdminMaterialsAnalyticsDetailEnvelopeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMaterialsAnalyticsDetailEnvelopeBuilder toBuilder() =>
      AdminMaterialsAnalyticsDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMaterialsAnalyticsDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(
            r'AdminMaterialsAnalyticsDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminMaterialsAnalyticsDetailEnvelopeBuilder
    implements
        Builder<AdminMaterialsAnalyticsDetailEnvelope,
            AdminMaterialsAnalyticsDetailEnvelopeBuilder> {
  _$AdminMaterialsAnalyticsDetailEnvelope? _$v;

  AdminMaterialsAnalyticsDetailBuilder? _data;
  AdminMaterialsAnalyticsDetailBuilder get data =>
      _$this._data ??= AdminMaterialsAnalyticsDetailBuilder();
  set data(AdminMaterialsAnalyticsDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminMaterialsAnalyticsDetailEnvelopeBuilder() {
    AdminMaterialsAnalyticsDetailEnvelope._defaults(this);
  }

  AdminMaterialsAnalyticsDetailEnvelopeBuilder get _$this {
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
  void replace(AdminMaterialsAnalyticsDetailEnvelope other) {
    _$v = other as _$AdminMaterialsAnalyticsDetailEnvelope;
  }

  @override
  void update(
      void Function(AdminMaterialsAnalyticsDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMaterialsAnalyticsDetailEnvelope build() => _build();

  _$AdminMaterialsAnalyticsDetailEnvelope _build() {
    _$AdminMaterialsAnalyticsDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminMaterialsAnalyticsDetailEnvelope._(
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
            r'AdminMaterialsAnalyticsDetailEnvelope',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
