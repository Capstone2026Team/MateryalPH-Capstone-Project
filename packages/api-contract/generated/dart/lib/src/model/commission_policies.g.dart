// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policies.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPolicies extends CommissionPolicies {
  @override
  final CommissionPolicy? current;
  @override
  final CommissionPolicy? next;
  @override
  final int latestVersion;
  @override
  final bool canManage;
  @override
  final int? minNoticeDays;
  @override
  final int? eligibleVendorCount;
  @override
  final bool? canExport;
  @override
  final BuiltList<CommissionPolicy> versions;

  factory _$CommissionPolicies(
          [void Function(CommissionPoliciesBuilder)? updates]) =>
      (CommissionPoliciesBuilder()..update(updates))._build();

  _$CommissionPolicies._(
      {this.current,
      this.next,
      required this.latestVersion,
      required this.canManage,
      this.minNoticeDays,
      this.eligibleVendorCount,
      this.canExport,
      required this.versions})
      : super._();
  @override
  CommissionPolicies rebuild(
          void Function(CommissionPoliciesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPoliciesBuilder toBuilder() =>
      CommissionPoliciesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPolicies &&
        current == other.current &&
        next == other.next &&
        latestVersion == other.latestVersion &&
        canManage == other.canManage &&
        minNoticeDays == other.minNoticeDays &&
        eligibleVendorCount == other.eligibleVendorCount &&
        canExport == other.canExport &&
        versions == other.versions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, latestVersion.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jc(_$hash, minNoticeDays.hashCode);
    _$hash = $jc(_$hash, eligibleVendorCount.hashCode);
    _$hash = $jc(_$hash, canExport.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPolicies')
          ..add('current', current)
          ..add('next', next)
          ..add('latestVersion', latestVersion)
          ..add('canManage', canManage)
          ..add('minNoticeDays', minNoticeDays)
          ..add('eligibleVendorCount', eligibleVendorCount)
          ..add('canExport', canExport)
          ..add('versions', versions))
        .toString();
  }
}

class CommissionPoliciesBuilder
    implements Builder<CommissionPolicies, CommissionPoliciesBuilder> {
  _$CommissionPolicies? _$v;

  CommissionPolicyBuilder? _current;
  CommissionPolicyBuilder get current =>
      _$this._current ??= CommissionPolicyBuilder();
  set current(CommissionPolicyBuilder? current) => _$this._current = current;

  CommissionPolicyBuilder? _next;
  CommissionPolicyBuilder get next =>
      _$this._next ??= CommissionPolicyBuilder();
  set next(CommissionPolicyBuilder? next) => _$this._next = next;

  int? _latestVersion;
  int? get latestVersion => _$this._latestVersion;
  set latestVersion(int? latestVersion) =>
      _$this._latestVersion = latestVersion;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  int? _minNoticeDays;
  int? get minNoticeDays => _$this._minNoticeDays;
  set minNoticeDays(int? minNoticeDays) =>
      _$this._minNoticeDays = minNoticeDays;

  int? _eligibleVendorCount;
  int? get eligibleVendorCount => _$this._eligibleVendorCount;
  set eligibleVendorCount(int? eligibleVendorCount) =>
      _$this._eligibleVendorCount = eligibleVendorCount;

  bool? _canExport;
  bool? get canExport => _$this._canExport;
  set canExport(bool? canExport) => _$this._canExport = canExport;

  ListBuilder<CommissionPolicy>? _versions;
  ListBuilder<CommissionPolicy> get versions =>
      _$this._versions ??= ListBuilder<CommissionPolicy>();
  set versions(ListBuilder<CommissionPolicy>? versions) =>
      _$this._versions = versions;

  CommissionPoliciesBuilder() {
    CommissionPolicies._defaults(this);
  }

  CommissionPoliciesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _current = $v.current?.toBuilder();
      _next = $v.next?.toBuilder();
      _latestVersion = $v.latestVersion;
      _canManage = $v.canManage;
      _minNoticeDays = $v.minNoticeDays;
      _eligibleVendorCount = $v.eligibleVendorCount;
      _canExport = $v.canExport;
      _versions = $v.versions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionPolicies other) {
    _$v = other as _$CommissionPolicies;
  }

  @override
  void update(void Function(CommissionPoliciesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPolicies build() => _build();

  _$CommissionPolicies _build() {
    _$CommissionPolicies _$result;
    try {
      _$result = _$v ??
          _$CommissionPolicies._(
            current: _current?.build(),
            next: _next?.build(),
            latestVersion: BuiltValueNullFieldError.checkNotNull(
                latestVersion, r'CommissionPolicies', 'latestVersion'),
            canManage: BuiltValueNullFieldError.checkNotNull(
                canManage, r'CommissionPolicies', 'canManage'),
            minNoticeDays: minNoticeDays,
            eligibleVendorCount: eligibleVendorCount,
            canExport: canExport,
            versions: versions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        _current?.build();
        _$failedField = 'next';
        _next?.build();

        _$failedField = 'versions';
        versions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CommissionPolicies', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
