// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_register_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComplianceRegisterListEnvelope extends ComplianceRegisterListEnvelope {
  @override
  final BuiltList<ComplianceRegister> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ComplianceRegisterListEnvelope(
          [void Function(ComplianceRegisterListEnvelopeBuilder)? updates]) =>
      (ComplianceRegisterListEnvelopeBuilder()..update(updates))._build();

  _$ComplianceRegisterListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ComplianceRegisterListEnvelope rebuild(
          void Function(ComplianceRegisterListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceRegisterListEnvelopeBuilder toBuilder() =>
      ComplianceRegisterListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceRegisterListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ComplianceRegisterListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ComplianceRegisterListEnvelopeBuilder
    implements
        Builder<ComplianceRegisterListEnvelope,
            ComplianceRegisterListEnvelopeBuilder> {
  _$ComplianceRegisterListEnvelope? _$v;

  ListBuilder<ComplianceRegister>? _data;
  ListBuilder<ComplianceRegister> get data =>
      _$this._data ??= ListBuilder<ComplianceRegister>();
  set data(ListBuilder<ComplianceRegister>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ComplianceRegisterListEnvelopeBuilder() {
    ComplianceRegisterListEnvelope._defaults(this);
  }

  ComplianceRegisterListEnvelopeBuilder get _$this {
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
  void replace(ComplianceRegisterListEnvelope other) {
    _$v = other as _$ComplianceRegisterListEnvelope;
  }

  @override
  void update(void Function(ComplianceRegisterListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceRegisterListEnvelope build() => _build();

  _$ComplianceRegisterListEnvelope _build() {
    _$ComplianceRegisterListEnvelope _$result;
    try {
      _$result = _$v ??
          _$ComplianceRegisterListEnvelope._(
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
            r'ComplianceRegisterListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
