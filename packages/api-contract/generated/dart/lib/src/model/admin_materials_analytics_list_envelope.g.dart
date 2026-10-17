// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_materials_analytics_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMaterialsAnalyticsListEnvelope
    extends AdminMaterialsAnalyticsListEnvelope {
  @override
  final AdminMaterialsAnalyticsList data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AdminMaterialsAnalyticsListEnvelope(
          [void Function(AdminMaterialsAnalyticsListEnvelopeBuilder)?
              updates]) =>
      (AdminMaterialsAnalyticsListEnvelopeBuilder()..update(updates))._build();

  _$AdminMaterialsAnalyticsListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminMaterialsAnalyticsListEnvelope rebuild(
          void Function(AdminMaterialsAnalyticsListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMaterialsAnalyticsListEnvelopeBuilder toBuilder() =>
      AdminMaterialsAnalyticsListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMaterialsAnalyticsListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminMaterialsAnalyticsListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminMaterialsAnalyticsListEnvelopeBuilder
    implements
        Builder<AdminMaterialsAnalyticsListEnvelope,
            AdminMaterialsAnalyticsListEnvelopeBuilder> {
  _$AdminMaterialsAnalyticsListEnvelope? _$v;

  AdminMaterialsAnalyticsListBuilder? _data;
  AdminMaterialsAnalyticsListBuilder get data =>
      _$this._data ??= AdminMaterialsAnalyticsListBuilder();
  set data(AdminMaterialsAnalyticsListBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AdminMaterialsAnalyticsListEnvelopeBuilder() {
    AdminMaterialsAnalyticsListEnvelope._defaults(this);
  }

  AdminMaterialsAnalyticsListEnvelopeBuilder get _$this {
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
  void replace(AdminMaterialsAnalyticsListEnvelope other) {
    _$v = other as _$AdminMaterialsAnalyticsListEnvelope;
  }

  @override
  void update(
      void Function(AdminMaterialsAnalyticsListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMaterialsAnalyticsListEnvelope build() => _build();

  _$AdminMaterialsAnalyticsListEnvelope _build() {
    _$AdminMaterialsAnalyticsListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminMaterialsAnalyticsListEnvelope._(
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
        throw BuiltValueNestedFieldError(r'AdminMaterialsAnalyticsListEnvelope',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
