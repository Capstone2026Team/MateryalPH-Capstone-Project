// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTeamPerformanceRoleEnum _$vendorTeamPerformanceRoleEnum_OWNER =
    const VendorTeamPerformanceRoleEnum._('OWNER');
const VendorTeamPerformanceRoleEnum
    _$vendorTeamPerformanceRoleEnum_STORE_MANAGER =
    const VendorTeamPerformanceRoleEnum._('STORE_MANAGER');
const VendorTeamPerformanceRoleEnum
    _$vendorTeamPerformanceRoleEnum_STORE_STAFF =
    const VendorTeamPerformanceRoleEnum._('STORE_STAFF');
const VendorTeamPerformanceRoleEnum
    _$vendorTeamPerformanceRoleEnum_CUSTOMER_SERVICE =
    const VendorTeamPerformanceRoleEnum._('CUSTOMER_SERVICE');
const VendorTeamPerformanceRoleEnum _$vendorTeamPerformanceRoleEnum_INVENTORY =
    const VendorTeamPerformanceRoleEnum._('INVENTORY');
const VendorTeamPerformanceRoleEnum
    _$vendorTeamPerformanceRoleEnum_FULFILLMENT =
    const VendorTeamPerformanceRoleEnum._('FULFILLMENT');

VendorTeamPerformanceRoleEnum _$vendorTeamPerformanceRoleEnumValueOf(
    String name) {
  switch (name) {
    case 'OWNER':
      return _$vendorTeamPerformanceRoleEnum_OWNER;
    case 'STORE_MANAGER':
      return _$vendorTeamPerformanceRoleEnum_STORE_MANAGER;
    case 'STORE_STAFF':
      return _$vendorTeamPerformanceRoleEnum_STORE_STAFF;
    case 'CUSTOMER_SERVICE':
      return _$vendorTeamPerformanceRoleEnum_CUSTOMER_SERVICE;
    case 'INVENTORY':
      return _$vendorTeamPerformanceRoleEnum_INVENTORY;
    case 'FULFILLMENT':
      return _$vendorTeamPerformanceRoleEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTeamPerformanceRoleEnum>
    _$vendorTeamPerformanceRoleEnumValues = BuiltSet<
        VendorTeamPerformanceRoleEnum>(const <VendorTeamPerformanceRoleEnum>[
  _$vendorTeamPerformanceRoleEnum_OWNER,
  _$vendorTeamPerformanceRoleEnum_STORE_MANAGER,
  _$vendorTeamPerformanceRoleEnum_STORE_STAFF,
  _$vendorTeamPerformanceRoleEnum_CUSTOMER_SERVICE,
  _$vendorTeamPerformanceRoleEnum_INVENTORY,
  _$vendorTeamPerformanceRoleEnum_FULFILLMENT,
]);

const VendorTeamPerformanceTimezoneEnum
    _$vendorTeamPerformanceTimezoneEnum_asiaSlashManila =
    const VendorTeamPerformanceTimezoneEnum._('asiaSlashManila');

VendorTeamPerformanceTimezoneEnum _$vendorTeamPerformanceTimezoneEnumValueOf(
    String name) {
  switch (name) {
    case 'asiaSlashManila':
      return _$vendorTeamPerformanceTimezoneEnum_asiaSlashManila;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTeamPerformanceTimezoneEnum>
    _$vendorTeamPerformanceTimezoneEnumValues = BuiltSet<
        VendorTeamPerformanceTimezoneEnum>(const <VendorTeamPerformanceTimezoneEnum>[
  _$vendorTeamPerformanceTimezoneEnum_asiaSlashManila,
]);

Serializer<VendorTeamPerformanceRoleEnum>
    _$vendorTeamPerformanceRoleEnumSerializer =
    _$VendorTeamPerformanceRoleEnumSerializer();
Serializer<VendorTeamPerformanceTimezoneEnum>
    _$vendorTeamPerformanceTimezoneEnumSerializer =
    _$VendorTeamPerformanceTimezoneEnumSerializer();

class _$VendorTeamPerformanceRoleEnumSerializer
    implements PrimitiveSerializer<VendorTeamPerformanceRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OWNER': 'OWNER',
    'STORE_MANAGER': 'STORE_MANAGER',
    'STORE_STAFF': 'STORE_STAFF',
    'CUSTOMER_SERVICE': 'CUSTOMER_SERVICE',
    'INVENTORY': 'INVENTORY',
    'FULFILLMENT': 'FULFILLMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OWNER': 'OWNER',
    'STORE_MANAGER': 'STORE_MANAGER',
    'STORE_STAFF': 'STORE_STAFF',
    'CUSTOMER_SERVICE': 'CUSTOMER_SERVICE',
    'INVENTORY': 'INVENTORY',
    'FULFILLMENT': 'FULFILLMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorTeamPerformanceRoleEnum];
  @override
  final String wireName = 'VendorTeamPerformanceRoleEnum';

  @override
  Object serialize(
          Serializers serializers, VendorTeamPerformanceRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTeamPerformanceRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTeamPerformanceRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTeamPerformanceTimezoneEnumSerializer
    implements PrimitiveSerializer<VendorTeamPerformanceTimezoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'asiaSlashManila': 'Asia/Manila',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Asia/Manila': 'asiaSlashManila',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorTeamPerformanceTimezoneEnum];
  @override
  final String wireName = 'VendorTeamPerformanceTimezoneEnum';

  @override
  Object serialize(
          Serializers serializers, VendorTeamPerformanceTimezoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTeamPerformanceTimezoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTeamPerformanceTimezoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTeamPerformance extends VendorTeamPerformance {
  @override
  final String memberId;
  @override
  final VendorTeamPerformanceRoleEnum role;
  @override
  final VendorTeamPerformanceTimezoneEnum timezone;
  @override
  final String? from;
  @override
  final String? to;
  @override
  final bool salesValueVisible;
  @override
  final VendorTeamPerformanceActivity activity;
  @override
  final VendorTeamSalesPerformance? sales;
  @override
  final VendorTeamQuotationPerformance? quotations;
  @override
  final VendorTeamConfirmationPerformance? orders;
  @override
  final VendorTeamDisputePerformance? disputes;
  @override
  final VendorTeamInventoryPerformance? inventory;
  @override
  final VendorTeamFulfillmentPerformance? fulfillment;
  @override
  final VendorTeamPerformanceTrend trend;

  factory _$VendorTeamPerformance(
          [void Function(VendorTeamPerformanceBuilder)? updates]) =>
      (VendorTeamPerformanceBuilder()..update(updates))._build();

  _$VendorTeamPerformance._(
      {required this.memberId,
      required this.role,
      required this.timezone,
      this.from,
      this.to,
      required this.salesValueVisible,
      required this.activity,
      this.sales,
      this.quotations,
      this.orders,
      this.disputes,
      this.inventory,
      this.fulfillment,
      required this.trend})
      : super._();
  @override
  VendorTeamPerformance rebuild(
          void Function(VendorTeamPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamPerformanceBuilder toBuilder() =>
      VendorTeamPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamPerformance &&
        memberId == other.memberId &&
        role == other.role &&
        timezone == other.timezone &&
        from == other.from &&
        to == other.to &&
        salesValueVisible == other.salesValueVisible &&
        activity == other.activity &&
        sales == other.sales &&
        quotations == other.quotations &&
        orders == other.orders &&
        disputes == other.disputes &&
        inventory == other.inventory &&
        fulfillment == other.fulfillment &&
        trend == other.trend;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, salesValueVisible.hashCode);
    _$hash = $jc(_$hash, activity.hashCode);
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jc(_$hash, quotations.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, disputes.hashCode);
    _$hash = $jc(_$hash, inventory.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, trend.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamPerformance')
          ..add('memberId', memberId)
          ..add('role', role)
          ..add('timezone', timezone)
          ..add('from', from)
          ..add('to', to)
          ..add('salesValueVisible', salesValueVisible)
          ..add('activity', activity)
          ..add('sales', sales)
          ..add('quotations', quotations)
          ..add('orders', orders)
          ..add('disputes', disputes)
          ..add('inventory', inventory)
          ..add('fulfillment', fulfillment)
          ..add('trend', trend))
        .toString();
  }
}

class VendorTeamPerformanceBuilder
    implements Builder<VendorTeamPerformance, VendorTeamPerformanceBuilder> {
  _$VendorTeamPerformance? _$v;

  String? _memberId;
  String? get memberId => _$this._memberId;
  set memberId(String? memberId) => _$this._memberId = memberId;

  VendorTeamPerformanceRoleEnum? _role;
  VendorTeamPerformanceRoleEnum? get role => _$this._role;
  set role(VendorTeamPerformanceRoleEnum? role) => _$this._role = role;

  VendorTeamPerformanceTimezoneEnum? _timezone;
  VendorTeamPerformanceTimezoneEnum? get timezone => _$this._timezone;
  set timezone(VendorTeamPerformanceTimezoneEnum? timezone) =>
      _$this._timezone = timezone;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  bool? _salesValueVisible;
  bool? get salesValueVisible => _$this._salesValueVisible;
  set salesValueVisible(bool? salesValueVisible) =>
      _$this._salesValueVisible = salesValueVisible;

  VendorTeamPerformanceActivityBuilder? _activity;
  VendorTeamPerformanceActivityBuilder get activity =>
      _$this._activity ??= VendorTeamPerformanceActivityBuilder();
  set activity(VendorTeamPerformanceActivityBuilder? activity) =>
      _$this._activity = activity;

  VendorTeamSalesPerformanceBuilder? _sales;
  VendorTeamSalesPerformanceBuilder get sales =>
      _$this._sales ??= VendorTeamSalesPerformanceBuilder();
  set sales(VendorTeamSalesPerformanceBuilder? sales) => _$this._sales = sales;

  VendorTeamQuotationPerformanceBuilder? _quotations;
  VendorTeamQuotationPerformanceBuilder get quotations =>
      _$this._quotations ??= VendorTeamQuotationPerformanceBuilder();
  set quotations(VendorTeamQuotationPerformanceBuilder? quotations) =>
      _$this._quotations = quotations;

  VendorTeamConfirmationPerformanceBuilder? _orders;
  VendorTeamConfirmationPerformanceBuilder get orders =>
      _$this._orders ??= VendorTeamConfirmationPerformanceBuilder();
  set orders(VendorTeamConfirmationPerformanceBuilder? orders) =>
      _$this._orders = orders;

  VendorTeamDisputePerformanceBuilder? _disputes;
  VendorTeamDisputePerformanceBuilder get disputes =>
      _$this._disputes ??= VendorTeamDisputePerformanceBuilder();
  set disputes(VendorTeamDisputePerformanceBuilder? disputes) =>
      _$this._disputes = disputes;

  VendorTeamInventoryPerformanceBuilder? _inventory;
  VendorTeamInventoryPerformanceBuilder get inventory =>
      _$this._inventory ??= VendorTeamInventoryPerformanceBuilder();
  set inventory(VendorTeamInventoryPerformanceBuilder? inventory) =>
      _$this._inventory = inventory;

  VendorTeamFulfillmentPerformanceBuilder? _fulfillment;
  VendorTeamFulfillmentPerformanceBuilder get fulfillment =>
      _$this._fulfillment ??= VendorTeamFulfillmentPerformanceBuilder();
  set fulfillment(VendorTeamFulfillmentPerformanceBuilder? fulfillment) =>
      _$this._fulfillment = fulfillment;

  VendorTeamPerformanceTrendBuilder? _trend;
  VendorTeamPerformanceTrendBuilder get trend =>
      _$this._trend ??= VendorTeamPerformanceTrendBuilder();
  set trend(VendorTeamPerformanceTrendBuilder? trend) => _$this._trend = trend;

  VendorTeamPerformanceBuilder() {
    VendorTeamPerformance._defaults(this);
  }

  VendorTeamPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _role = $v.role;
      _timezone = $v.timezone;
      _from = $v.from;
      _to = $v.to;
      _salesValueVisible = $v.salesValueVisible;
      _activity = $v.activity.toBuilder();
      _sales = $v.sales?.toBuilder();
      _quotations = $v.quotations?.toBuilder();
      _orders = $v.orders?.toBuilder();
      _disputes = $v.disputes?.toBuilder();
      _inventory = $v.inventory?.toBuilder();
      _fulfillment = $v.fulfillment?.toBuilder();
      _trend = $v.trend.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamPerformance other) {
    _$v = other as _$VendorTeamPerformance;
  }

  @override
  void update(void Function(VendorTeamPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamPerformance build() => _build();

  _$VendorTeamPerformance _build() {
    _$VendorTeamPerformance _$result;
    try {
      _$result = _$v ??
          _$VendorTeamPerformance._(
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'VendorTeamPerformance', 'memberId'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'VendorTeamPerformance', 'role'),
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'VendorTeamPerformance', 'timezone'),
            from: from,
            to: to,
            salesValueVisible: BuiltValueNullFieldError.checkNotNull(
                salesValueVisible,
                r'VendorTeamPerformance',
                'salesValueVisible'),
            activity: activity.build(),
            sales: _sales?.build(),
            quotations: _quotations?.build(),
            orders: _orders?.build(),
            disputes: _disputes?.build(),
            inventory: _inventory?.build(),
            fulfillment: _fulfillment?.build(),
            trend: trend.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'activity';
        activity.build();
        _$failedField = 'sales';
        _sales?.build();
        _$failedField = 'quotations';
        _quotations?.build();
        _$failedField = 'orders';
        _orders?.build();
        _$failedField = 'disputes';
        _disputes?.build();
        _$failedField = 'inventory';
        _inventory?.build();
        _$failedField = 'fulfillment';
        _fulfillment?.build();
        _$failedField = 'trend';
        trend.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeamPerformance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
