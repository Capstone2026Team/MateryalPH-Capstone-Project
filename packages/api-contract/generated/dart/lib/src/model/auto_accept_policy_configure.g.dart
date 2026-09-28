// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy_configure.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptPolicyConfigure extends AutoAcceptPolicyConfigure {
  @override
  final int lockVersion;
  @override
  final bool enabled;
  @override
  final String allotmentQuantity;
  @override
  final String? maxUnitCount;
  @override
  final int? maxOrderAmountCentavos;

  factory _$AutoAcceptPolicyConfigure(
          [void Function(AutoAcceptPolicyConfigureBuilder)? updates]) =>
      (AutoAcceptPolicyConfigureBuilder()..update(updates))._build();

  _$AutoAcceptPolicyConfigure._(
      {required this.lockVersion,
      required this.enabled,
      required this.allotmentQuantity,
      this.maxUnitCount,
      this.maxOrderAmountCentavos})
      : super._();
  @override
  AutoAcceptPolicyConfigure rebuild(
          void Function(AutoAcceptPolicyConfigureBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyConfigureBuilder toBuilder() =>
      AutoAcceptPolicyConfigureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicyConfigure &&
        lockVersion == other.lockVersion &&
        enabled == other.enabled &&
        allotmentQuantity == other.allotmentQuantity &&
        maxUnitCount == other.maxUnitCount &&
        maxOrderAmountCentavos == other.maxOrderAmountCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, allotmentQuantity.hashCode);
    _$hash = $jc(_$hash, maxUnitCount.hashCode);
    _$hash = $jc(_$hash, maxOrderAmountCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicyConfigure')
          ..add('lockVersion', lockVersion)
          ..add('enabled', enabled)
          ..add('allotmentQuantity', allotmentQuantity)
          ..add('maxUnitCount', maxUnitCount)
          ..add('maxOrderAmountCentavos', maxOrderAmountCentavos))
        .toString();
  }
}

class AutoAcceptPolicyConfigureBuilder
    implements
        Builder<AutoAcceptPolicyConfigure, AutoAcceptPolicyConfigureBuilder> {
  _$AutoAcceptPolicyConfigure? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _allotmentQuantity;
  String? get allotmentQuantity => _$this._allotmentQuantity;
  set allotmentQuantity(String? allotmentQuantity) =>
      _$this._allotmentQuantity = allotmentQuantity;

  String? _maxUnitCount;
  String? get maxUnitCount => _$this._maxUnitCount;
  set maxUnitCount(String? maxUnitCount) => _$this._maxUnitCount = maxUnitCount;

  int? _maxOrderAmountCentavos;
  int? get maxOrderAmountCentavos => _$this._maxOrderAmountCentavos;
  set maxOrderAmountCentavos(int? maxOrderAmountCentavos) =>
      _$this._maxOrderAmountCentavos = maxOrderAmountCentavos;

  AutoAcceptPolicyConfigureBuilder() {
    AutoAcceptPolicyConfigure._defaults(this);
  }

  AutoAcceptPolicyConfigureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _enabled = $v.enabled;
      _allotmentQuantity = $v.allotmentQuantity;
      _maxUnitCount = $v.maxUnitCount;
      _maxOrderAmountCentavos = $v.maxOrderAmountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicyConfigure other) {
    _$v = other as _$AutoAcceptPolicyConfigure;
  }

  @override
  void update(void Function(AutoAcceptPolicyConfigureBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicyConfigure build() => _build();

  _$AutoAcceptPolicyConfigure _build() {
    final _$result = _$v ??
        _$AutoAcceptPolicyConfigure._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AutoAcceptPolicyConfigure', 'lockVersion'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'AutoAcceptPolicyConfigure', 'enabled'),
          allotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              allotmentQuantity,
              r'AutoAcceptPolicyConfigure',
              'allotmentQuantity'),
          maxUnitCount: maxUnitCount,
          maxOrderAmountCentavos: maxOrderAmountCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
