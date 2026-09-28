// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_supplier_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectorySupplierDetailEnvelope
    extends DirectorySupplierDetailEnvelope {
  @override
  final DirectorySupplierDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$DirectorySupplierDetailEnvelope(
          [void Function(DirectorySupplierDetailEnvelopeBuilder)? updates]) =>
      (DirectorySupplierDetailEnvelopeBuilder()..update(updates))._build();

  _$DirectorySupplierDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DirectorySupplierDetailEnvelope rebuild(
          void Function(DirectorySupplierDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectorySupplierDetailEnvelopeBuilder toBuilder() =>
      DirectorySupplierDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectorySupplierDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DirectorySupplierDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DirectorySupplierDetailEnvelopeBuilder
    implements
        Builder<DirectorySupplierDetailEnvelope,
            DirectorySupplierDetailEnvelopeBuilder> {
  _$DirectorySupplierDetailEnvelope? _$v;

  DirectorySupplierDetailBuilder? _data;
  DirectorySupplierDetailBuilder get data =>
      _$this._data ??= DirectorySupplierDetailBuilder();
  set data(DirectorySupplierDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  DirectorySupplierDetailEnvelopeBuilder() {
    DirectorySupplierDetailEnvelope._defaults(this);
  }

  DirectorySupplierDetailEnvelopeBuilder get _$this {
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
  void replace(DirectorySupplierDetailEnvelope other) {
    _$v = other as _$DirectorySupplierDetailEnvelope;
  }

  @override
  void update(void Function(DirectorySupplierDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectorySupplierDetailEnvelope build() => _build();

  _$DirectorySupplierDetailEnvelope _build() {
    _$DirectorySupplierDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$DirectorySupplierDetailEnvelope._(
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
            r'DirectorySupplierDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
