// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_workstreams_provider_readiness.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWorkstreamsProviderReadiness
    extends VendorWorkstreamsProviderReadiness {
  @override
  final String? status;
  @override
  final String? providerStatus;
  @override
  final String? environment;
  @override
  final String? lastErrorCode;
  @override
  final DateTime? lastReconciledAt;
  @override
  final String? note;

  factory _$VendorWorkstreamsProviderReadiness(
          [void Function(VendorWorkstreamsProviderReadinessBuilder)?
              updates]) =>
      (VendorWorkstreamsProviderReadinessBuilder()..update(updates))._build();

  _$VendorWorkstreamsProviderReadiness._(
      {this.status,
      this.providerStatus,
      this.environment,
      this.lastErrorCode,
      this.lastReconciledAt,
      this.note})
      : super._();
  @override
  VendorWorkstreamsProviderReadiness rebuild(
          void Function(VendorWorkstreamsProviderReadinessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWorkstreamsProviderReadinessBuilder toBuilder() =>
      VendorWorkstreamsProviderReadinessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWorkstreamsProviderReadiness &&
        status == other.status &&
        providerStatus == other.providerStatus &&
        environment == other.environment &&
        lastErrorCode == other.lastErrorCode &&
        lastReconciledAt == other.lastReconciledAt &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, providerStatus.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, lastErrorCode.hashCode);
    _$hash = $jc(_$hash, lastReconciledAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorWorkstreamsProviderReadiness')
          ..add('status', status)
          ..add('providerStatus', providerStatus)
          ..add('environment', environment)
          ..add('lastErrorCode', lastErrorCode)
          ..add('lastReconciledAt', lastReconciledAt)
          ..add('note', note))
        .toString();
  }
}

class VendorWorkstreamsProviderReadinessBuilder
    implements
        Builder<VendorWorkstreamsProviderReadiness,
            VendorWorkstreamsProviderReadinessBuilder> {
  _$VendorWorkstreamsProviderReadiness? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _providerStatus;
  String? get providerStatus => _$this._providerStatus;
  set providerStatus(String? providerStatus) =>
      _$this._providerStatus = providerStatus;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _lastErrorCode;
  String? get lastErrorCode => _$this._lastErrorCode;
  set lastErrorCode(String? lastErrorCode) =>
      _$this._lastErrorCode = lastErrorCode;

  DateTime? _lastReconciledAt;
  DateTime? get lastReconciledAt => _$this._lastReconciledAt;
  set lastReconciledAt(DateTime? lastReconciledAt) =>
      _$this._lastReconciledAt = lastReconciledAt;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  VendorWorkstreamsProviderReadinessBuilder() {
    VendorWorkstreamsProviderReadiness._defaults(this);
  }

  VendorWorkstreamsProviderReadinessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _providerStatus = $v.providerStatus;
      _environment = $v.environment;
      _lastErrorCode = $v.lastErrorCode;
      _lastReconciledAt = $v.lastReconciledAt;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorWorkstreamsProviderReadiness other) {
    _$v = other as _$VendorWorkstreamsProviderReadiness;
  }

  @override
  void update(
      void Function(VendorWorkstreamsProviderReadinessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWorkstreamsProviderReadiness build() => _build();

  _$VendorWorkstreamsProviderReadiness _build() {
    final _$result = _$v ??
        _$VendorWorkstreamsProviderReadiness._(
          status: status,
          providerStatus: providerStatus,
          environment: environment,
          lastErrorCode: lastErrorCode,
          lastReconciledAt: lastReconciledAt,
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
