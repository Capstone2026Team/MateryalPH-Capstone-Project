// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorSetup extends VendorSetup {
  @override
  final int lockVersion;
  @override
  final bool bulkOrderCapable;
  @override
  final VendorStore? store;
  @override
  final BuiltList<VendorOperatingDay> hours;
  @override
  final BuiltList<VendorVehicle> deliveryVehicles;
  @override
  final VendorConnection? payment;
  @override
  final String? withholdingDemoScenario;
  @override
  final String productionWithholdingAssignment;
  @override
  final String environment;

  factory _$VendorSetup([void Function(VendorSetupBuilder)? updates]) =>
      (VendorSetupBuilder()..update(updates))._build();

  _$VendorSetup._(
      {required this.lockVersion,
      required this.bulkOrderCapable,
      this.store,
      required this.hours,
      required this.deliveryVehicles,
      this.payment,
      this.withholdingDemoScenario,
      required this.productionWithholdingAssignment,
      required this.environment})
      : super._();
  @override
  VendorSetup rebuild(void Function(VendorSetupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupBuilder toBuilder() => VendorSetupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetup &&
        lockVersion == other.lockVersion &&
        bulkOrderCapable == other.bulkOrderCapable &&
        store == other.store &&
        hours == other.hours &&
        deliveryVehicles == other.deliveryVehicles &&
        payment == other.payment &&
        withholdingDemoScenario == other.withholdingDemoScenario &&
        productionWithholdingAssignment ==
            other.productionWithholdingAssignment &&
        environment == other.environment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, bulkOrderCapable.hashCode);
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, deliveryVehicles.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jc(_$hash, withholdingDemoScenario.hashCode);
    _$hash = $jc(_$hash, productionWithholdingAssignment.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorSetup')
          ..add('lockVersion', lockVersion)
          ..add('bulkOrderCapable', bulkOrderCapable)
          ..add('store', store)
          ..add('hours', hours)
          ..add('deliveryVehicles', deliveryVehicles)
          ..add('payment', payment)
          ..add('withholdingDemoScenario', withholdingDemoScenario)
          ..add('productionWithholdingAssignment',
              productionWithholdingAssignment)
          ..add('environment', environment))
        .toString();
  }
}

class VendorSetupBuilder implements Builder<VendorSetup, VendorSetupBuilder> {
  _$VendorSetup? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _bulkOrderCapable;
  bool? get bulkOrderCapable => _$this._bulkOrderCapable;
  set bulkOrderCapable(bool? bulkOrderCapable) =>
      _$this._bulkOrderCapable = bulkOrderCapable;

  VendorStoreBuilder? _store;
  VendorStoreBuilder get store => _$this._store ??= VendorStoreBuilder();
  set store(VendorStoreBuilder? store) => _$this._store = store;

  ListBuilder<VendorOperatingDay>? _hours;
  ListBuilder<VendorOperatingDay> get hours =>
      _$this._hours ??= ListBuilder<VendorOperatingDay>();
  set hours(ListBuilder<VendorOperatingDay>? hours) => _$this._hours = hours;

  ListBuilder<VendorVehicle>? _deliveryVehicles;
  ListBuilder<VendorVehicle> get deliveryVehicles =>
      _$this._deliveryVehicles ??= ListBuilder<VendorVehicle>();
  set deliveryVehicles(ListBuilder<VendorVehicle>? deliveryVehicles) =>
      _$this._deliveryVehicles = deliveryVehicles;

  VendorConnectionBuilder? _payment;
  VendorConnectionBuilder get payment =>
      _$this._payment ??= VendorConnectionBuilder();
  set payment(VendorConnectionBuilder? payment) => _$this._payment = payment;

  String? _withholdingDemoScenario;
  String? get withholdingDemoScenario => _$this._withholdingDemoScenario;
  set withholdingDemoScenario(String? withholdingDemoScenario) =>
      _$this._withholdingDemoScenario = withholdingDemoScenario;

  String? _productionWithholdingAssignment;
  String? get productionWithholdingAssignment =>
      _$this._productionWithholdingAssignment;
  set productionWithholdingAssignment(
          String? productionWithholdingAssignment) =>
      _$this._productionWithholdingAssignment = productionWithholdingAssignment;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  VendorSetupBuilder() {
    VendorSetup._defaults(this);
  }

  VendorSetupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _bulkOrderCapable = $v.bulkOrderCapable;
      _store = $v.store?.toBuilder();
      _hours = $v.hours.toBuilder();
      _deliveryVehicles = $v.deliveryVehicles.toBuilder();
      _payment = $v.payment?.toBuilder();
      _withholdingDemoScenario = $v.withholdingDemoScenario;
      _productionWithholdingAssignment = $v.productionWithholdingAssignment;
      _environment = $v.environment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorSetup other) {
    _$v = other as _$VendorSetup;
  }

  @override
  void update(void Function(VendorSetupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetup build() => _build();

  _$VendorSetup _build() {
    _$VendorSetup _$result;
    try {
      _$result = _$v ??
          _$VendorSetup._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'VendorSetup', 'lockVersion'),
            bulkOrderCapable: BuiltValueNullFieldError.checkNotNull(
                bulkOrderCapable, r'VendorSetup', 'bulkOrderCapable'),
            store: _store?.build(),
            hours: hours.build(),
            deliveryVehicles: deliveryVehicles.build(),
            payment: _payment?.build(),
            withholdingDemoScenario: withholdingDemoScenario,
            productionWithholdingAssignment:
                BuiltValueNullFieldError.checkNotNull(
                    productionWithholdingAssignment,
                    r'VendorSetup',
                    'productionWithholdingAssignment'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'VendorSetup', 'environment'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'store';
        _store?.build();
        _$failedField = 'hours';
        hours.build();
        _$failedField = 'deliveryVehicles';
        deliveryVehicles.build();
        _$failedField = 'payment';
        _payment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorSetup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
