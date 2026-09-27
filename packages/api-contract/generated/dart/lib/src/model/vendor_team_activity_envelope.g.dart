// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_activity_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamActivityEnvelope extends VendorTeamActivityEnvelope {
  @override
  final BuiltList<VendorTeamActivity> data;
  @override
  final VendorTeamActivityEnvelopeMeta meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorTeamActivityEnvelope(
          [void Function(VendorTeamActivityEnvelopeBuilder)? updates]) =>
      (VendorTeamActivityEnvelopeBuilder()..update(updates))._build();

  _$VendorTeamActivityEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorTeamActivityEnvelope rebuild(
          void Function(VendorTeamActivityEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamActivityEnvelopeBuilder toBuilder() =>
      VendorTeamActivityEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamActivityEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorTeamActivityEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorTeamActivityEnvelopeBuilder
    implements
        Builder<VendorTeamActivityEnvelope, VendorTeamActivityEnvelopeBuilder> {
  _$VendorTeamActivityEnvelope? _$v;

  ListBuilder<VendorTeamActivity>? _data;
  ListBuilder<VendorTeamActivity> get data =>
      _$this._data ??= ListBuilder<VendorTeamActivity>();
  set data(ListBuilder<VendorTeamActivity>? data) => _$this._data = data;

  VendorTeamActivityEnvelopeMetaBuilder? _meta;
  VendorTeamActivityEnvelopeMetaBuilder get meta =>
      _$this._meta ??= VendorTeamActivityEnvelopeMetaBuilder();
  set meta(VendorTeamActivityEnvelopeMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorTeamActivityEnvelopeBuilder() {
    VendorTeamActivityEnvelope._defaults(this);
  }

  VendorTeamActivityEnvelopeBuilder get _$this {
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
  void replace(VendorTeamActivityEnvelope other) {
    _$v = other as _$VendorTeamActivityEnvelope;
  }

  @override
  void update(void Function(VendorTeamActivityEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamActivityEnvelope build() => _build();

  _$VendorTeamActivityEnvelope _build() {
    _$VendorTeamActivityEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorTeamActivityEnvelope._(
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
            r'VendorTeamActivityEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
