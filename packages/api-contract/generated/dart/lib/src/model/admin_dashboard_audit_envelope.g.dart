// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_audit_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardAuditEnvelope extends AdminDashboardAuditEnvelope {
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AdminDashboardAuditEnvelope(
          [void Function(AdminDashboardAuditEnvelopeBuilder)? updates]) =>
      (AdminDashboardAuditEnvelopeBuilder()..update(updates))._build();

  _$AdminDashboardAuditEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminDashboardAuditEnvelope rebuild(
          void Function(AdminDashboardAuditEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardAuditEnvelopeBuilder toBuilder() =>
      AdminDashboardAuditEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardAuditEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AdminDashboardAuditEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminDashboardAuditEnvelopeBuilder
    implements
        Builder<AdminDashboardAuditEnvelope,
            AdminDashboardAuditEnvelopeBuilder> {
  _$AdminDashboardAuditEnvelope? _$v;

  ListBuilder<BuiltMap<String, JsonObject?>>? _data;
  ListBuilder<BuiltMap<String, JsonObject?>> get data =>
      _$this._data ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set data(ListBuilder<BuiltMap<String, JsonObject?>>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AdminDashboardAuditEnvelopeBuilder() {
    AdminDashboardAuditEnvelope._defaults(this);
  }

  AdminDashboardAuditEnvelopeBuilder get _$this {
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
  void replace(AdminDashboardAuditEnvelope other) {
    _$v = other as _$AdminDashboardAuditEnvelope;
  }

  @override
  void update(void Function(AdminDashboardAuditEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardAuditEnvelope build() => _build();

  _$AdminDashboardAuditEnvelope _build() {
    _$AdminDashboardAuditEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardAuditEnvelope._(
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
            r'AdminDashboardAuditEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
