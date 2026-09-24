// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardEnvelope extends AdminDashboardEnvelope {
  @override
  final AdminDashboardSummary data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AdminDashboardEnvelope(
          [void Function(AdminDashboardEnvelopeBuilder)? updates]) =>
      (AdminDashboardEnvelopeBuilder()..update(updates))._build();

  _$AdminDashboardEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminDashboardEnvelope rebuild(
          void Function(AdminDashboardEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardEnvelopeBuilder toBuilder() =>
      AdminDashboardEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminDashboardEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminDashboardEnvelopeBuilder
    implements Builder<AdminDashboardEnvelope, AdminDashboardEnvelopeBuilder> {
  _$AdminDashboardEnvelope? _$v;

  AdminDashboardSummaryBuilder? _data;
  AdminDashboardSummaryBuilder get data =>
      _$this._data ??= AdminDashboardSummaryBuilder();
  set data(AdminDashboardSummaryBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AdminDashboardEnvelopeBuilder() {
    AdminDashboardEnvelope._defaults(this);
  }

  AdminDashboardEnvelopeBuilder get _$this {
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
  void replace(AdminDashboardEnvelope other) {
    _$v = other as _$AdminDashboardEnvelope;
  }

  @override
  void update(void Function(AdminDashboardEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardEnvelope build() => _build();

  _$AdminDashboardEnvelope _build() {
    _$AdminDashboardEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardEnvelope._(
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
            r'AdminDashboardEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
