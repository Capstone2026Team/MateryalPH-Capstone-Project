// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_connection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorConnection extends VendorConnection {
  @override
  final String? providerStatus;
  @override
  final String? connectionError;
  @override
  final String environment;
  @override
  final String status;
  @override
  final String? evidenceOrigin;
  @override
  final String? checkedAt;

  factory _$VendorConnection(
          [void Function(VendorConnectionBuilder)? updates]) =>
      (VendorConnectionBuilder()..update(updates))._build();

  _$VendorConnection._(
      {this.providerStatus,
      this.connectionError,
      required this.environment,
      required this.status,
      this.evidenceOrigin,
      this.checkedAt})
      : super._();
  @override
  VendorConnection rebuild(void Function(VendorConnectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorConnectionBuilder toBuilder() =>
      VendorConnectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorConnection &&
        providerStatus == other.providerStatus &&
        connectionError == other.connectionError &&
        environment == other.environment &&
        status == other.status &&
        evidenceOrigin == other.evidenceOrigin &&
        checkedAt == other.checkedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerStatus.hashCode);
    _$hash = $jc(_$hash, connectionError.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, checkedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorConnection')
          ..add('providerStatus', providerStatus)
          ..add('connectionError', connectionError)
          ..add('environment', environment)
          ..add('status', status)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('checkedAt', checkedAt))
        .toString();
  }
}

class VendorConnectionBuilder
    implements Builder<VendorConnection, VendorConnectionBuilder> {
  _$VendorConnection? _$v;

  String? _providerStatus;
  String? get providerStatus => _$this._providerStatus;
  set providerStatus(String? providerStatus) =>
      _$this._providerStatus = providerStatus;

  String? _connectionError;
  String? get connectionError => _$this._connectionError;
  set connectionError(String? connectionError) =>
      _$this._connectionError = connectionError;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _evidenceOrigin;
  String? get evidenceOrigin => _$this._evidenceOrigin;
  set evidenceOrigin(String? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  String? _checkedAt;
  String? get checkedAt => _$this._checkedAt;
  set checkedAt(String? checkedAt) => _$this._checkedAt = checkedAt;

  VendorConnectionBuilder() {
    VendorConnection._defaults(this);
  }

  VendorConnectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerStatus = $v.providerStatus;
      _connectionError = $v.connectionError;
      _environment = $v.environment;
      _status = $v.status;
      _evidenceOrigin = $v.evidenceOrigin;
      _checkedAt = $v.checkedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorConnection other) {
    _$v = other as _$VendorConnection;
  }

  @override
  void update(void Function(VendorConnectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorConnection build() => _build();

  _$VendorConnection _build() {
    final _$result = _$v ??
        _$VendorConnection._(
          providerStatus: providerStatus,
          connectionError: connectionError,
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'VendorConnection', 'environment'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorConnection', 'status'),
          evidenceOrigin: evidenceOrigin,
          checkedAt: checkedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
