// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_activation_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorActivationSnapshot extends VendorActivationSnapshot {
  @override
  final String status;
  @override
  final String marketplaceDiscoverabilityStatus;
  @override
  final StoreActivationReadiness readiness;

  factory _$VendorActivationSnapshot(
          [void Function(VendorActivationSnapshotBuilder)? updates]) =>
      (VendorActivationSnapshotBuilder()..update(updates))._build();

  _$VendorActivationSnapshot._(
      {required this.status,
      required this.marketplaceDiscoverabilityStatus,
      required this.readiness})
      : super._();
  @override
  VendorActivationSnapshot rebuild(
          void Function(VendorActivationSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorActivationSnapshotBuilder toBuilder() =>
      VendorActivationSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorActivationSnapshot &&
        status == other.status &&
        marketplaceDiscoverabilityStatus ==
            other.marketplaceDiscoverabilityStatus &&
        readiness == other.readiness;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, marketplaceDiscoverabilityStatus.hashCode);
    _$hash = $jc(_$hash, readiness.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorActivationSnapshot')
          ..add('status', status)
          ..add('marketplaceDiscoverabilityStatus',
              marketplaceDiscoverabilityStatus)
          ..add('readiness', readiness))
        .toString();
  }
}

class VendorActivationSnapshotBuilder
    implements
        Builder<VendorActivationSnapshot, VendorActivationSnapshotBuilder> {
  _$VendorActivationSnapshot? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _marketplaceDiscoverabilityStatus;
  String? get marketplaceDiscoverabilityStatus =>
      _$this._marketplaceDiscoverabilityStatus;
  set marketplaceDiscoverabilityStatus(
          String? marketplaceDiscoverabilityStatus) =>
      _$this._marketplaceDiscoverabilityStatus =
          marketplaceDiscoverabilityStatus;

  StoreActivationReadinessBuilder? _readiness;
  StoreActivationReadinessBuilder get readiness =>
      _$this._readiness ??= StoreActivationReadinessBuilder();
  set readiness(StoreActivationReadinessBuilder? readiness) =>
      _$this._readiness = readiness;

  VendorActivationSnapshotBuilder() {
    VendorActivationSnapshot._defaults(this);
  }

  VendorActivationSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _marketplaceDiscoverabilityStatus = $v.marketplaceDiscoverabilityStatus;
      _readiness = $v.readiness.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorActivationSnapshot other) {
    _$v = other as _$VendorActivationSnapshot;
  }

  @override
  void update(void Function(VendorActivationSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorActivationSnapshot build() => _build();

  _$VendorActivationSnapshot _build() {
    _$VendorActivationSnapshot _$result;
    try {
      _$result = _$v ??
          _$VendorActivationSnapshot._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'VendorActivationSnapshot', 'status'),
            marketplaceDiscoverabilityStatus:
                BuiltValueNullFieldError.checkNotNull(
                    marketplaceDiscoverabilityStatus,
                    r'VendorActivationSnapshot',
                    'marketplaceDiscoverabilityStatus'),
            readiness: readiness.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'readiness';
        readiness.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorActivationSnapshot', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
