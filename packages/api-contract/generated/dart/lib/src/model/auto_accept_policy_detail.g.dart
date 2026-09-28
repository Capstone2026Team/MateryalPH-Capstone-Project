// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptPolicyDetail extends AutoAcceptPolicyDetail {
  @override
  final String listingVariantId;
  @override
  final String listingId;
  @override
  final String listingName;
  @override
  final ListingStatus listingStatus;
  @override
  final String? variantLabel;
  @override
  final String sku;
  @override
  final String unitCode;
  @override
  final AutoAcceptPolicyDetailStock? stock;
  @override
  final AutoAcceptPolicy policy;
  @override
  final BuiltList<AutoAcceptPolicyVersion> versions;
  @override
  final AutoAcceptPolicyDetailScope scope;
  @override
  final AutoAcceptPolicyDetailPermissions permissions;

  factory _$AutoAcceptPolicyDetail(
          [void Function(AutoAcceptPolicyDetailBuilder)? updates]) =>
      (AutoAcceptPolicyDetailBuilder()..update(updates))._build();

  _$AutoAcceptPolicyDetail._(
      {required this.listingVariantId,
      required this.listingId,
      required this.listingName,
      required this.listingStatus,
      this.variantLabel,
      required this.sku,
      required this.unitCode,
      this.stock,
      required this.policy,
      required this.versions,
      required this.scope,
      required this.permissions})
      : super._();
  @override
  AutoAcceptPolicyDetail rebuild(
          void Function(AutoAcceptPolicyDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyDetailBuilder toBuilder() =>
      AutoAcceptPolicyDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicyDetail &&
        listingVariantId == other.listingVariantId &&
        listingId == other.listingId &&
        listingName == other.listingName &&
        listingStatus == other.listingStatus &&
        variantLabel == other.variantLabel &&
        sku == other.sku &&
        unitCode == other.unitCode &&
        stock == other.stock &&
        policy == other.policy &&
        versions == other.versions &&
        scope == other.scope &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, listingName.hashCode);
    _$hash = $jc(_$hash, listingStatus.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, stock.hashCode);
    _$hash = $jc(_$hash, policy.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicyDetail')
          ..add('listingVariantId', listingVariantId)
          ..add('listingId', listingId)
          ..add('listingName', listingName)
          ..add('listingStatus', listingStatus)
          ..add('variantLabel', variantLabel)
          ..add('sku', sku)
          ..add('unitCode', unitCode)
          ..add('stock', stock)
          ..add('policy', policy)
          ..add('versions', versions)
          ..add('scope', scope)
          ..add('permissions', permissions))
        .toString();
  }
}

class AutoAcceptPolicyDetailBuilder
    implements Builder<AutoAcceptPolicyDetail, AutoAcceptPolicyDetailBuilder> {
  _$AutoAcceptPolicyDetail? _$v;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _listingName;
  String? get listingName => _$this._listingName;
  set listingName(String? listingName) => _$this._listingName = listingName;

  ListingStatus? _listingStatus;
  ListingStatus? get listingStatus => _$this._listingStatus;
  set listingStatus(ListingStatus? listingStatus) =>
      _$this._listingStatus = listingStatus;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  AutoAcceptPolicyDetailStockBuilder? _stock;
  AutoAcceptPolicyDetailStockBuilder get stock =>
      _$this._stock ??= AutoAcceptPolicyDetailStockBuilder();
  set stock(AutoAcceptPolicyDetailStockBuilder? stock) => _$this._stock = stock;

  AutoAcceptPolicyBuilder? _policy;
  AutoAcceptPolicyBuilder get policy =>
      _$this._policy ??= AutoAcceptPolicyBuilder();
  set policy(AutoAcceptPolicyBuilder? policy) => _$this._policy = policy;

  ListBuilder<AutoAcceptPolicyVersion>? _versions;
  ListBuilder<AutoAcceptPolicyVersion> get versions =>
      _$this._versions ??= ListBuilder<AutoAcceptPolicyVersion>();
  set versions(ListBuilder<AutoAcceptPolicyVersion>? versions) =>
      _$this._versions = versions;

  AutoAcceptPolicyDetailScopeBuilder? _scope;
  AutoAcceptPolicyDetailScopeBuilder get scope =>
      _$this._scope ??= AutoAcceptPolicyDetailScopeBuilder();
  set scope(AutoAcceptPolicyDetailScopeBuilder? scope) => _$this._scope = scope;

  AutoAcceptPolicyDetailPermissionsBuilder? _permissions;
  AutoAcceptPolicyDetailPermissionsBuilder get permissions =>
      _$this._permissions ??= AutoAcceptPolicyDetailPermissionsBuilder();
  set permissions(AutoAcceptPolicyDetailPermissionsBuilder? permissions) =>
      _$this._permissions = permissions;

  AutoAcceptPolicyDetailBuilder() {
    AutoAcceptPolicyDetail._defaults(this);
  }

  AutoAcceptPolicyDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingVariantId = $v.listingVariantId;
      _listingId = $v.listingId;
      _listingName = $v.listingName;
      _listingStatus = $v.listingStatus;
      _variantLabel = $v.variantLabel;
      _sku = $v.sku;
      _unitCode = $v.unitCode;
      _stock = $v.stock?.toBuilder();
      _policy = $v.policy.toBuilder();
      _versions = $v.versions.toBuilder();
      _scope = $v.scope.toBuilder();
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicyDetail other) {
    _$v = other as _$AutoAcceptPolicyDetail;
  }

  @override
  void update(void Function(AutoAcceptPolicyDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicyDetail build() => _build();

  _$AutoAcceptPolicyDetail _build() {
    _$AutoAcceptPolicyDetail _$result;
    try {
      _$result = _$v ??
          _$AutoAcceptPolicyDetail._(
            listingVariantId: BuiltValueNullFieldError.checkNotNull(
                listingVariantId,
                r'AutoAcceptPolicyDetail',
                'listingVariantId'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'AutoAcceptPolicyDetail', 'listingId'),
            listingName: BuiltValueNullFieldError.checkNotNull(
                listingName, r'AutoAcceptPolicyDetail', 'listingName'),
            listingStatus: BuiltValueNullFieldError.checkNotNull(
                listingStatus, r'AutoAcceptPolicyDetail', 'listingStatus'),
            variantLabel: variantLabel,
            sku: BuiltValueNullFieldError.checkNotNull(
                sku, r'AutoAcceptPolicyDetail', 'sku'),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'AutoAcceptPolicyDetail', 'unitCode'),
            stock: _stock?.build(),
            policy: policy.build(),
            versions: versions.build(),
            scope: scope.build(),
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stock';
        _stock?.build();
        _$failedField = 'policy';
        policy.build();
        _$failedField = 'versions';
        versions.build();
        _$failedField = 'scope';
        scope.build();
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AutoAcceptPolicyDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
