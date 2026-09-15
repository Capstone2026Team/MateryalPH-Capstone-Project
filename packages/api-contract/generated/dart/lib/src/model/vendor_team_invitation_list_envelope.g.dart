// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_invitation_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamInvitationListEnvelope
    extends VendorTeamInvitationListEnvelope {
  @override
  final BuiltList<VendorTeamInvitation> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorTeamInvitationListEnvelope(
          [void Function(VendorTeamInvitationListEnvelopeBuilder)? updates]) =>
      (VendorTeamInvitationListEnvelopeBuilder()..update(updates))._build();

  _$VendorTeamInvitationListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorTeamInvitationListEnvelope rebuild(
          void Function(VendorTeamInvitationListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamInvitationListEnvelopeBuilder toBuilder() =>
      VendorTeamInvitationListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamInvitationListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorTeamInvitationListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorTeamInvitationListEnvelopeBuilder
    implements
        Builder<VendorTeamInvitationListEnvelope,
            VendorTeamInvitationListEnvelopeBuilder> {
  _$VendorTeamInvitationListEnvelope? _$v;

  ListBuilder<VendorTeamInvitation>? _data;
  ListBuilder<VendorTeamInvitation> get data =>
      _$this._data ??= ListBuilder<VendorTeamInvitation>();
  set data(ListBuilder<VendorTeamInvitation>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorTeamInvitationListEnvelopeBuilder() {
    VendorTeamInvitationListEnvelope._defaults(this);
  }

  VendorTeamInvitationListEnvelopeBuilder get _$this {
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
  void replace(VendorTeamInvitationListEnvelope other) {
    _$v = other as _$VendorTeamInvitationListEnvelope;
  }

  @override
  void update(void Function(VendorTeamInvitationListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamInvitationListEnvelope build() => _build();

  _$VendorTeamInvitationListEnvelope _build() {
    _$VendorTeamInvitationListEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorTeamInvitationListEnvelope._(
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
            r'VendorTeamInvitationListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
