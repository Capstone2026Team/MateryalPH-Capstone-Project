// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_workstreams_discoverability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWorkstreamsDiscoverability
    extends VendorWorkstreamsDiscoverability {
  @override
  final String status;
  @override
  final String? reason;
  @override
  final DateTime? evaluatedAt;

  factory _$VendorWorkstreamsDiscoverability(
          [void Function(VendorWorkstreamsDiscoverabilityBuilder)? updates]) =>
      (VendorWorkstreamsDiscoverabilityBuilder()..update(updates))._build();

  _$VendorWorkstreamsDiscoverability._(
      {required this.status, this.reason, this.evaluatedAt})
      : super._();
  @override
  VendorWorkstreamsDiscoverability rebuild(
          void Function(VendorWorkstreamsDiscoverabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWorkstreamsDiscoverabilityBuilder toBuilder() =>
      VendorWorkstreamsDiscoverabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWorkstreamsDiscoverability &&
        status == other.status &&
        reason == other.reason &&
        evaluatedAt == other.evaluatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, evaluatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorWorkstreamsDiscoverability')
          ..add('status', status)
          ..add('reason', reason)
          ..add('evaluatedAt', evaluatedAt))
        .toString();
  }
}

class VendorWorkstreamsDiscoverabilityBuilder
    implements
        Builder<VendorWorkstreamsDiscoverability,
            VendorWorkstreamsDiscoverabilityBuilder> {
  _$VendorWorkstreamsDiscoverability? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _evaluatedAt;
  DateTime? get evaluatedAt => _$this._evaluatedAt;
  set evaluatedAt(DateTime? evaluatedAt) => _$this._evaluatedAt = evaluatedAt;

  VendorWorkstreamsDiscoverabilityBuilder() {
    VendorWorkstreamsDiscoverability._defaults(this);
  }

  VendorWorkstreamsDiscoverabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _reason = $v.reason;
      _evaluatedAt = $v.evaluatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorWorkstreamsDiscoverability other) {
    _$v = other as _$VendorWorkstreamsDiscoverability;
  }

  @override
  void update(void Function(VendorWorkstreamsDiscoverabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWorkstreamsDiscoverability build() => _build();

  _$VendorWorkstreamsDiscoverability _build() {
    final _$result = _$v ??
        _$VendorWorkstreamsDiscoverability._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorWorkstreamsDiscoverability', 'status'),
          reason: reason,
          evaluatedAt: evaluatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
