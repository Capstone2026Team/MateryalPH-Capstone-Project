// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vendor_verification_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVendorVerificationDetail extends AdminVendorVerificationDetail {
  @override
  final VendorWorkstreams? workstreams;
  @override
  final ActivationRestrictions? activationRestrictions;
  @override
  final BuiltMap<String, JsonObject?>? readiness;

  factory _$AdminVendorVerificationDetail(
          [void Function(AdminVendorVerificationDetailBuilder)? updates]) =>
      (AdminVendorVerificationDetailBuilder()..update(updates))._build();

  _$AdminVendorVerificationDetail._(
      {this.workstreams, this.activationRestrictions, this.readiness})
      : super._();
  @override
  AdminVendorVerificationDetail rebuild(
          void Function(AdminVendorVerificationDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVendorVerificationDetailBuilder toBuilder() =>
      AdminVendorVerificationDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVendorVerificationDetail &&
        workstreams == other.workstreams &&
        activationRestrictions == other.activationRestrictions &&
        readiness == other.readiness;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, workstreams.hashCode);
    _$hash = $jc(_$hash, activationRestrictions.hashCode);
    _$hash = $jc(_$hash, readiness.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminVendorVerificationDetail')
          ..add('workstreams', workstreams)
          ..add('activationRestrictions', activationRestrictions)
          ..add('readiness', readiness))
        .toString();
  }
}

class AdminVendorVerificationDetailBuilder
    implements
        Builder<AdminVendorVerificationDetail,
            AdminVendorVerificationDetailBuilder> {
  _$AdminVendorVerificationDetail? _$v;

  VendorWorkstreamsBuilder? _workstreams;
  VendorWorkstreamsBuilder get workstreams =>
      _$this._workstreams ??= VendorWorkstreamsBuilder();
  set workstreams(VendorWorkstreamsBuilder? workstreams) =>
      _$this._workstreams = workstreams;

  ActivationRestrictionsBuilder? _activationRestrictions;
  ActivationRestrictionsBuilder get activationRestrictions =>
      _$this._activationRestrictions ??= ActivationRestrictionsBuilder();
  set activationRestrictions(
          ActivationRestrictionsBuilder? activationRestrictions) =>
      _$this._activationRestrictions = activationRestrictions;

  MapBuilder<String, JsonObject?>? _readiness;
  MapBuilder<String, JsonObject?> get readiness =>
      _$this._readiness ??= MapBuilder<String, JsonObject?>();
  set readiness(MapBuilder<String, JsonObject?>? readiness) =>
      _$this._readiness = readiness;

  AdminVendorVerificationDetailBuilder() {
    AdminVendorVerificationDetail._defaults(this);
  }

  AdminVendorVerificationDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _workstreams = $v.workstreams?.toBuilder();
      _activationRestrictions = $v.activationRestrictions?.toBuilder();
      _readiness = $v.readiness?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVendorVerificationDetail other) {
    _$v = other as _$AdminVendorVerificationDetail;
  }

  @override
  void update(void Function(AdminVendorVerificationDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVendorVerificationDetail build() => _build();

  _$AdminVendorVerificationDetail _build() {
    _$AdminVendorVerificationDetail _$result;
    try {
      _$result = _$v ??
          _$AdminVendorVerificationDetail._(
            workstreams: _workstreams?.build(),
            activationRestrictions: _activationRestrictions?.build(),
            readiness: _readiness?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'workstreams';
        _workstreams?.build();
        _$failedField = 'activationRestrictions';
        _activationRestrictions?.build();
        _$failedField = 'readiness';
        _readiness?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminVendorVerificationDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
