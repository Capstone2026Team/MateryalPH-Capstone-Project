// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamEnvelope extends VendorTeamEnvelope {
  @override
  final VendorTeam data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorTeamEnvelope(
          [void Function(VendorTeamEnvelopeBuilder)? updates]) =>
      (VendorTeamEnvelopeBuilder()..update(updates))._build();

  _$VendorTeamEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorTeamEnvelope rebuild(
          void Function(VendorTeamEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamEnvelopeBuilder toBuilder() =>
      VendorTeamEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorTeamEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorTeamEnvelopeBuilder
    implements Builder<VendorTeamEnvelope, VendorTeamEnvelopeBuilder> {
  _$VendorTeamEnvelope? _$v;

  VendorTeamBuilder? _data;
  VendorTeamBuilder get data => _$this._data ??= VendorTeamBuilder();
  set data(VendorTeamBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorTeamEnvelopeBuilder() {
    VendorTeamEnvelope._defaults(this);
  }

  VendorTeamEnvelopeBuilder get _$this {
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
  void replace(VendorTeamEnvelope other) {
    _$v = other as _$VendorTeamEnvelope;
  }

  @override
  void update(void Function(VendorTeamEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamEnvelope build() => _build();

  _$VendorTeamEnvelope _build() {
    _$VendorTeamEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorTeamEnvelope._(
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
            r'VendorTeamEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
