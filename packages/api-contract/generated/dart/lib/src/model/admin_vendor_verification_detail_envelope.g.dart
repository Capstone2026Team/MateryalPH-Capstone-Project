// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vendor_verification_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVendorVerificationDetailEnvelope
    extends AdminVendorVerificationDetailEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$AdminVendorVerificationDetailEnvelope(
          [void Function(AdminVendorVerificationDetailEnvelopeBuilder)?
              updates]) =>
      (AdminVendorVerificationDetailEnvelopeBuilder()..update(updates))
          ._build();

  _$AdminVendorVerificationDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AdminVendorVerificationDetailEnvelope rebuild(
          void Function(AdminVendorVerificationDetailEnvelopeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVendorVerificationDetailEnvelopeBuilder toBuilder() =>
      AdminVendorVerificationDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVendorVerificationDetailEnvelope &&
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
            r'AdminVendorVerificationDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AdminVendorVerificationDetailEnvelopeBuilder
    implements
        Builder<AdminVendorVerificationDetailEnvelope,
            AdminVendorVerificationDetailEnvelopeBuilder> {
  _$AdminVendorVerificationDetailEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  AdminVendorVerificationDetailEnvelopeBuilder() {
    AdminVendorVerificationDetailEnvelope._defaults(this);
  }

  AdminVendorVerificationDetailEnvelopeBuilder get _$this {
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
  void replace(AdminVendorVerificationDetailEnvelope other) {
    _$v = other as _$AdminVendorVerificationDetailEnvelope;
  }

  @override
  void update(
      void Function(AdminVendorVerificationDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVendorVerificationDetailEnvelope build() => _build();

  _$AdminVendorVerificationDetailEnvelope _build() {
    _$AdminVendorVerificationDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$AdminVendorVerificationDetailEnvelope._(
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
            r'AdminVendorVerificationDetailEnvelope',
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
