// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_vendor_store.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SaveVendorStoreFulfillmentEnum
    _$saveVendorStoreFulfillmentEnum_SELF_PICKUP =
    const SaveVendorStoreFulfillmentEnum._('SELF_PICKUP');
const SaveVendorStoreFulfillmentEnum
    _$saveVendorStoreFulfillmentEnum_VENDOR_DELIVERY =
    const SaveVendorStoreFulfillmentEnum._('VENDOR_DELIVERY');
const SaveVendorStoreFulfillmentEnum _$saveVendorStoreFulfillmentEnum_BOTH =
    const SaveVendorStoreFulfillmentEnum._('BOTH');

SaveVendorStoreFulfillmentEnum _$saveVendorStoreFulfillmentEnumValueOf(
    String name) {
  switch (name) {
    case 'SELF_PICKUP':
      return _$saveVendorStoreFulfillmentEnum_SELF_PICKUP;
    case 'VENDOR_DELIVERY':
      return _$saveVendorStoreFulfillmentEnum_VENDOR_DELIVERY;
    case 'BOTH':
      return _$saveVendorStoreFulfillmentEnum_BOTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SaveVendorStoreFulfillmentEnum>
    _$saveVendorStoreFulfillmentEnumValues = BuiltSet<
        SaveVendorStoreFulfillmentEnum>(const <SaveVendorStoreFulfillmentEnum>[
  _$saveVendorStoreFulfillmentEnum_SELF_PICKUP,
  _$saveVendorStoreFulfillmentEnum_VENDOR_DELIVERY,
  _$saveVendorStoreFulfillmentEnum_BOTH,
]);

Serializer<SaveVendorStoreFulfillmentEnum>
    _$saveVendorStoreFulfillmentEnumSerializer =
    _$SaveVendorStoreFulfillmentEnumSerializer();

class _$SaveVendorStoreFulfillmentEnumSerializer
    implements PrimitiveSerializer<SaveVendorStoreFulfillmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SELF_PICKUP': 'SELF_PICKUP',
    'VENDOR_DELIVERY': 'VENDOR_DELIVERY',
    'BOTH': 'BOTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SELF_PICKUP': 'SELF_PICKUP',
    'VENDOR_DELIVERY': 'VENDOR_DELIVERY',
    'BOTH': 'BOTH',
  };

  @override
  final Iterable<Type> types = const <Type>[SaveVendorStoreFulfillmentEnum];
  @override
  final String wireName = 'SaveVendorStoreFulfillmentEnum';

  @override
  Object serialize(
          Serializers serializers, SaveVendorStoreFulfillmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SaveVendorStoreFulfillmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SaveVendorStoreFulfillmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SaveVendorStore extends SaveVendorStore {
  @override
  final int lockVersion;
  @override
  final String description;
  @override
  final String? publicEmail;
  @override
  final String? publicPhone;
  @override
  final bool bulkOrderCapable;
  @override
  final SaveVendorStoreFulfillmentEnum fulfillment;
  @override
  final bool codEnabled;
  @override
  final bool inStorePaymentEnabled;
  @override
  final bool onlinePaymentEnabled;
  @override
  final SaveVendorStoreRefundConfiguration refundConfiguration;
  @override
  final BuiltList<VendorVehicle> deliveryVehicles;
  @override
  final BuiltList<VendorOperatingDay> hours;

  factory _$SaveVendorStore([void Function(SaveVendorStoreBuilder)? updates]) =>
      (SaveVendorStoreBuilder()..update(updates))._build();

  _$SaveVendorStore._(
      {required this.lockVersion,
      required this.description,
      this.publicEmail,
      this.publicPhone,
      required this.bulkOrderCapable,
      required this.fulfillment,
      required this.codEnabled,
      required this.inStorePaymentEnabled,
      required this.onlinePaymentEnabled,
      required this.refundConfiguration,
      required this.deliveryVehicles,
      required this.hours})
      : super._();
  @override
  SaveVendorStore rebuild(void Function(SaveVendorStoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SaveVendorStoreBuilder toBuilder() => SaveVendorStoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveVendorStore &&
        lockVersion == other.lockVersion &&
        description == other.description &&
        publicEmail == other.publicEmail &&
        publicPhone == other.publicPhone &&
        bulkOrderCapable == other.bulkOrderCapable &&
        fulfillment == other.fulfillment &&
        codEnabled == other.codEnabled &&
        inStorePaymentEnabled == other.inStorePaymentEnabled &&
        onlinePaymentEnabled == other.onlinePaymentEnabled &&
        refundConfiguration == other.refundConfiguration &&
        deliveryVehicles == other.deliveryVehicles &&
        hours == other.hours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, bulkOrderCapable.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, codEnabled.hashCode);
    _$hash = $jc(_$hash, inStorePaymentEnabled.hashCode);
    _$hash = $jc(_$hash, onlinePaymentEnabled.hashCode);
    _$hash = $jc(_$hash, refundConfiguration.hashCode);
    _$hash = $jc(_$hash, deliveryVehicles.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveVendorStore')
          ..add('lockVersion', lockVersion)
          ..add('description', description)
          ..add('publicEmail', publicEmail)
          ..add('publicPhone', publicPhone)
          ..add('bulkOrderCapable', bulkOrderCapable)
          ..add('fulfillment', fulfillment)
          ..add('codEnabled', codEnabled)
          ..add('inStorePaymentEnabled', inStorePaymentEnabled)
          ..add('onlinePaymentEnabled', onlinePaymentEnabled)
          ..add('refundConfiguration', refundConfiguration)
          ..add('deliveryVehicles', deliveryVehicles)
          ..add('hours', hours))
        .toString();
  }
}

class SaveVendorStoreBuilder
    implements Builder<SaveVendorStore, SaveVendorStoreBuilder> {
  _$SaveVendorStore? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

  bool? _bulkOrderCapable;
  bool? get bulkOrderCapable => _$this._bulkOrderCapable;
  set bulkOrderCapable(bool? bulkOrderCapable) =>
      _$this._bulkOrderCapable = bulkOrderCapable;

  SaveVendorStoreFulfillmentEnum? _fulfillment;
  SaveVendorStoreFulfillmentEnum? get fulfillment => _$this._fulfillment;
  set fulfillment(SaveVendorStoreFulfillmentEnum? fulfillment) =>
      _$this._fulfillment = fulfillment;

  bool? _codEnabled;
  bool? get codEnabled => _$this._codEnabled;
  set codEnabled(bool? codEnabled) => _$this._codEnabled = codEnabled;

  bool? _inStorePaymentEnabled;
  bool? get inStorePaymentEnabled => _$this._inStorePaymentEnabled;
  set inStorePaymentEnabled(bool? inStorePaymentEnabled) =>
      _$this._inStorePaymentEnabled = inStorePaymentEnabled;

  bool? _onlinePaymentEnabled;
  bool? get onlinePaymentEnabled => _$this._onlinePaymentEnabled;
  set onlinePaymentEnabled(bool? onlinePaymentEnabled) =>
      _$this._onlinePaymentEnabled = onlinePaymentEnabled;

  SaveVendorStoreRefundConfigurationBuilder? _refundConfiguration;
  SaveVendorStoreRefundConfigurationBuilder get refundConfiguration =>
      _$this._refundConfiguration ??=
          SaveVendorStoreRefundConfigurationBuilder();
  set refundConfiguration(
          SaveVendorStoreRefundConfigurationBuilder? refundConfiguration) =>
      _$this._refundConfiguration = refundConfiguration;

  ListBuilder<VendorVehicle>? _deliveryVehicles;
  ListBuilder<VendorVehicle> get deliveryVehicles =>
      _$this._deliveryVehicles ??= ListBuilder<VendorVehicle>();
  set deliveryVehicles(ListBuilder<VendorVehicle>? deliveryVehicles) =>
      _$this._deliveryVehicles = deliveryVehicles;

  ListBuilder<VendorOperatingDay>? _hours;
  ListBuilder<VendorOperatingDay> get hours =>
      _$this._hours ??= ListBuilder<VendorOperatingDay>();
  set hours(ListBuilder<VendorOperatingDay>? hours) => _$this._hours = hours;

  SaveVendorStoreBuilder() {
    SaveVendorStore._defaults(this);
  }

  SaveVendorStoreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _description = $v.description;
      _publicEmail = $v.publicEmail;
      _publicPhone = $v.publicPhone;
      _bulkOrderCapable = $v.bulkOrderCapable;
      _fulfillment = $v.fulfillment;
      _codEnabled = $v.codEnabled;
      _inStorePaymentEnabled = $v.inStorePaymentEnabled;
      _onlinePaymentEnabled = $v.onlinePaymentEnabled;
      _refundConfiguration = $v.refundConfiguration.toBuilder();
      _deliveryVehicles = $v.deliveryVehicles.toBuilder();
      _hours = $v.hours.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveVendorStore other) {
    _$v = other as _$SaveVendorStore;
  }

  @override
  void update(void Function(SaveVendorStoreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveVendorStore build() => _build();

  _$SaveVendorStore _build() {
    _$SaveVendorStore _$result;
    try {
      _$result = _$v ??
          _$SaveVendorStore._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'SaveVendorStore', 'lockVersion'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'SaveVendorStore', 'description'),
            publicEmail: publicEmail,
            publicPhone: publicPhone,
            bulkOrderCapable: BuiltValueNullFieldError.checkNotNull(
                bulkOrderCapable, r'SaveVendorStore', 'bulkOrderCapable'),
            fulfillment: BuiltValueNullFieldError.checkNotNull(
                fulfillment, r'SaveVendorStore', 'fulfillment'),
            codEnabled: BuiltValueNullFieldError.checkNotNull(
                codEnabled, r'SaveVendorStore', 'codEnabled'),
            inStorePaymentEnabled: BuiltValueNullFieldError.checkNotNull(
                inStorePaymentEnabled,
                r'SaveVendorStore',
                'inStorePaymentEnabled'),
            onlinePaymentEnabled: BuiltValueNullFieldError.checkNotNull(
                onlinePaymentEnabled,
                r'SaveVendorStore',
                'onlinePaymentEnabled'),
            refundConfiguration: refundConfiguration.build(),
            deliveryVehicles: deliveryVehicles.build(),
            hours: hours.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'refundConfiguration';
        refundConfiguration.build();
        _$failedField = 'deliveryVehicles';
        deliveryVehicles.build();
        _$failedField = 'hours';
        hours.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SaveVendorStore', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
