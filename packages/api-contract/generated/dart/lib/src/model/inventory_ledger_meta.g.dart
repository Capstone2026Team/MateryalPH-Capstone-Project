// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_ledger_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InventoryLedgerMetaTimezoneEnum
    _$inventoryLedgerMetaTimezoneEnum_asiaSlashManila =
    const InventoryLedgerMetaTimezoneEnum._('asiaSlashManila');

InventoryLedgerMetaTimezoneEnum _$inventoryLedgerMetaTimezoneEnumValueOf(
    String name) {
  switch (name) {
    case 'asiaSlashManila':
      return _$inventoryLedgerMetaTimezoneEnum_asiaSlashManila;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventoryLedgerMetaTimezoneEnum>
    _$inventoryLedgerMetaTimezoneEnumValues = BuiltSet<
        InventoryLedgerMetaTimezoneEnum>(const <InventoryLedgerMetaTimezoneEnum>[
  _$inventoryLedgerMetaTimezoneEnum_asiaSlashManila,
]);

Serializer<InventoryLedgerMetaTimezoneEnum>
    _$inventoryLedgerMetaTimezoneEnumSerializer =
    _$InventoryLedgerMetaTimezoneEnumSerializer();

class _$InventoryLedgerMetaTimezoneEnumSerializer
    implements PrimitiveSerializer<InventoryLedgerMetaTimezoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'asiaSlashManila': 'Asia/Manila',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Asia/Manila': 'asiaSlashManila',
  };

  @override
  final Iterable<Type> types = const <Type>[InventoryLedgerMetaTimezoneEnum];
  @override
  final String wireName = 'InventoryLedgerMetaTimezoneEnum';

  @override
  Object serialize(
          Serializers serializers, InventoryLedgerMetaTimezoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventoryLedgerMetaTimezoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventoryLedgerMetaTimezoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventoryLedgerMeta extends InventoryLedgerMeta {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int total;
  @override
  final int pageSize;
  @override
  final InventoryLedgerMetaSummary summary;
  @override
  final InventoryLedgerMetaStaleListings staleListings;
  @override
  final String labelRuleVersion;
  @override
  final InventoryLedgerMetaTimezoneEnum timezone;
  @override
  final InventoryLedgerMetaPermissions permissions;

  factory _$InventoryLedgerMeta(
          [void Function(InventoryLedgerMetaBuilder)? updates]) =>
      (InventoryLedgerMetaBuilder()..update(updates))._build();

  _$InventoryLedgerMeta._(
      {required this.currentPage,
      required this.lastPage,
      required this.total,
      required this.pageSize,
      required this.summary,
      required this.staleListings,
      required this.labelRuleVersion,
      required this.timezone,
      required this.permissions})
      : super._();
  @override
  InventoryLedgerMeta rebuild(
          void Function(InventoryLedgerMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLedgerMetaBuilder toBuilder() =>
      InventoryLedgerMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLedgerMeta &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        total == other.total &&
        pageSize == other.pageSize &&
        summary == other.summary &&
        staleListings == other.staleListings &&
        labelRuleVersion == other.labelRuleVersion &&
        timezone == other.timezone &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, staleListings.hashCode);
    _$hash = $jc(_$hash, labelRuleVersion.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryLedgerMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('total', total)
          ..add('pageSize', pageSize)
          ..add('summary', summary)
          ..add('staleListings', staleListings)
          ..add('labelRuleVersion', labelRuleVersion)
          ..add('timezone', timezone)
          ..add('permissions', permissions))
        .toString();
  }
}

class InventoryLedgerMetaBuilder
    implements Builder<InventoryLedgerMeta, InventoryLedgerMetaBuilder> {
  _$InventoryLedgerMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  InventoryLedgerMetaSummaryBuilder? _summary;
  InventoryLedgerMetaSummaryBuilder get summary =>
      _$this._summary ??= InventoryLedgerMetaSummaryBuilder();
  set summary(InventoryLedgerMetaSummaryBuilder? summary) =>
      _$this._summary = summary;

  InventoryLedgerMetaStaleListingsBuilder? _staleListings;
  InventoryLedgerMetaStaleListingsBuilder get staleListings =>
      _$this._staleListings ??= InventoryLedgerMetaStaleListingsBuilder();
  set staleListings(InventoryLedgerMetaStaleListingsBuilder? staleListings) =>
      _$this._staleListings = staleListings;

  String? _labelRuleVersion;
  String? get labelRuleVersion => _$this._labelRuleVersion;
  set labelRuleVersion(String? labelRuleVersion) =>
      _$this._labelRuleVersion = labelRuleVersion;

  InventoryLedgerMetaTimezoneEnum? _timezone;
  InventoryLedgerMetaTimezoneEnum? get timezone => _$this._timezone;
  set timezone(InventoryLedgerMetaTimezoneEnum? timezone) =>
      _$this._timezone = timezone;

  InventoryLedgerMetaPermissionsBuilder? _permissions;
  InventoryLedgerMetaPermissionsBuilder get permissions =>
      _$this._permissions ??= InventoryLedgerMetaPermissionsBuilder();
  set permissions(InventoryLedgerMetaPermissionsBuilder? permissions) =>
      _$this._permissions = permissions;

  InventoryLedgerMetaBuilder() {
    InventoryLedgerMeta._defaults(this);
  }

  InventoryLedgerMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _pageSize = $v.pageSize;
      _summary = $v.summary.toBuilder();
      _staleListings = $v.staleListings.toBuilder();
      _labelRuleVersion = $v.labelRuleVersion;
      _timezone = $v.timezone;
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryLedgerMeta other) {
    _$v = other as _$InventoryLedgerMeta;
  }

  @override
  void update(void Function(InventoryLedgerMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLedgerMeta build() => _build();

  _$InventoryLedgerMeta _build() {
    _$InventoryLedgerMeta _$result;
    try {
      _$result = _$v ??
          _$InventoryLedgerMeta._(
            currentPage: BuiltValueNullFieldError.checkNotNull(
                currentPage, r'InventoryLedgerMeta', 'currentPage'),
            lastPage: BuiltValueNullFieldError.checkNotNull(
                lastPage, r'InventoryLedgerMeta', 'lastPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'InventoryLedgerMeta', 'total'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'InventoryLedgerMeta', 'pageSize'),
            summary: summary.build(),
            staleListings: staleListings.build(),
            labelRuleVersion: BuiltValueNullFieldError.checkNotNull(
                labelRuleVersion, r'InventoryLedgerMeta', 'labelRuleVersion'),
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'InventoryLedgerMeta', 'timezone'),
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        summary.build();
        _$failedField = 'staleListings';
        staleListings.build();

        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InventoryLedgerMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
