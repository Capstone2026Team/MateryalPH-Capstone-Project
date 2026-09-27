// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_register_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComplianceRegisterEnvelope extends ComplianceRegisterEnvelope {
  @override
  final ComplianceRegister data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ComplianceRegisterEnvelope(
          [void Function(ComplianceRegisterEnvelopeBuilder)? updates]) =>
      (ComplianceRegisterEnvelopeBuilder()..update(updates))._build();

  _$ComplianceRegisterEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ComplianceRegisterEnvelope rebuild(
          void Function(ComplianceRegisterEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceRegisterEnvelopeBuilder toBuilder() =>
      ComplianceRegisterEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceRegisterEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ComplianceRegisterEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ComplianceRegisterEnvelopeBuilder
    implements
        Builder<ComplianceRegisterEnvelope, ComplianceRegisterEnvelopeBuilder> {
  _$ComplianceRegisterEnvelope? _$v;

  ComplianceRegisterBuilder? _data;
  ComplianceRegisterBuilder get data =>
      _$this._data ??= ComplianceRegisterBuilder();
  set data(ComplianceRegisterBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ComplianceRegisterEnvelopeBuilder() {
    ComplianceRegisterEnvelope._defaults(this);
  }

  ComplianceRegisterEnvelopeBuilder get _$this {
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
  void replace(ComplianceRegisterEnvelope other) {
    _$v = other as _$ComplianceRegisterEnvelope;
  }

  @override
  void update(void Function(ComplianceRegisterEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceRegisterEnvelope build() => _build();

  _$ComplianceRegisterEnvelope _build() {
    _$ComplianceRegisterEnvelope _$result;
    try {
      _$result = _$v ??
          _$ComplianceRegisterEnvelope._(
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
            r'ComplianceRegisterEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
