// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_onboarding_snapshot_setup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOnboardingSnapshotSetup extends VendorOnboardingSnapshotSetup {
  @override
  final BuiltList<StoreOperatingDay>? operatingSchedule;

  factory _$VendorOnboardingSnapshotSetup(
          [void Function(VendorOnboardingSnapshotSetupBuilder)? updates]) =>
      (VendorOnboardingSnapshotSetupBuilder()..update(updates))._build();

  _$VendorOnboardingSnapshotSetup._({this.operatingSchedule}) : super._();
  @override
  VendorOnboardingSnapshotSetup rebuild(
          void Function(VendorOnboardingSnapshotSetupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOnboardingSnapshotSetupBuilder toBuilder() =>
      VendorOnboardingSnapshotSetupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOnboardingSnapshotSetup &&
        operatingSchedule == other.operatingSchedule;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatingSchedule.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOnboardingSnapshotSetup')
          ..add('operatingSchedule', operatingSchedule))
        .toString();
  }
}

class VendorOnboardingSnapshotSetupBuilder
    implements
        Builder<VendorOnboardingSnapshotSetup,
            VendorOnboardingSnapshotSetupBuilder> {
  _$VendorOnboardingSnapshotSetup? _$v;

  ListBuilder<StoreOperatingDay>? _operatingSchedule;
  ListBuilder<StoreOperatingDay> get operatingSchedule =>
      _$this._operatingSchedule ??= ListBuilder<StoreOperatingDay>();
  set operatingSchedule(ListBuilder<StoreOperatingDay>? operatingSchedule) =>
      _$this._operatingSchedule = operatingSchedule;

  VendorOnboardingSnapshotSetupBuilder() {
    VendorOnboardingSnapshotSetup._defaults(this);
  }

  VendorOnboardingSnapshotSetupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatingSchedule = $v.operatingSchedule?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOnboardingSnapshotSetup other) {
    _$v = other as _$VendorOnboardingSnapshotSetup;
  }

  @override
  void update(void Function(VendorOnboardingSnapshotSetupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOnboardingSnapshotSetup build() => _build();

  _$VendorOnboardingSnapshotSetup _build() {
    _$VendorOnboardingSnapshotSetup _$result;
    try {
      _$result = _$v ??
          _$VendorOnboardingSnapshotSetup._(
            operatingSchedule: _operatingSchedule?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operatingSchedule';
        _operatingSchedule?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOnboardingSnapshotSetup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
