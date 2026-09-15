// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStore extends VendorStore {
  @override
  final String id;
  @override
  final String? description;
  @override
  final String? publicEmail;
  @override
  final String? publicPhone;
  @override
  final bool pickupEnabled;
  @override
  final bool deliveryEnabled;
  @override
  final bool codEnabled;
  @override
  final bool inStorePaymentEnabled;
  @override
  final BuiltMap<String, JsonObject?> paymentMethods;
  @override
  final BuiltMap<String, JsonObject?> refundConfiguration;

  factory _$VendorStore([void Function(VendorStoreBuilder)? updates]) =>
      (VendorStoreBuilder()..update(updates))._build();

  _$VendorStore._(
      {required this.id,
      this.description,
      this.publicEmail,
      this.publicPhone,
      required this.pickupEnabled,
      required this.deliveryEnabled,
      required this.codEnabled,
      required this.inStorePaymentEnabled,
      required this.paymentMethods,
      required this.refundConfiguration})
      : super._();
  @override
  VendorStore rebuild(void Function(VendorStoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreBuilder toBuilder() => VendorStoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStore &&
        id == other.id &&
        description == other.description &&
        publicEmail == other.publicEmail &&
        publicPhone == other.publicPhone &&
        pickupEnabled == other.pickupEnabled &&
        deliveryEnabled == other.deliveryEnabled &&
        codEnabled == other.codEnabled &&
        inStorePaymentEnabled == other.inStorePaymentEnabled &&
        paymentMethods == other.paymentMethods &&
        refundConfiguration == other.refundConfiguration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, pickupEnabled.hashCode);
    _$hash = $jc(_$hash, deliveryEnabled.hashCode);
    _$hash = $jc(_$hash, codEnabled.hashCode);
    _$hash = $jc(_$hash, inStorePaymentEnabled.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jc(_$hash, refundConfiguration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStore')
          ..add('id', id)
          ..add('description', description)
          ..add('publicEmail', publicEmail)
          ..add('publicPhone', publicPhone)
          ..add('pickupEnabled', pickupEnabled)
          ..add('deliveryEnabled', deliveryEnabled)
          ..add('codEnabled', codEnabled)
          ..add('inStorePaymentEnabled', inStorePaymentEnabled)
          ..add('paymentMethods', paymentMethods)
          ..add('refundConfiguration', refundConfiguration))
        .toString();
  }
}

class VendorStoreBuilder implements Builder<VendorStore, VendorStoreBuilder> {
  _$VendorStore? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

  bool? _pickupEnabled;
  bool? get pickupEnabled => _$this._pickupEnabled;
  set pickupEnabled(bool? pickupEnabled) =>
      _$this._pickupEnabled = pickupEnabled;

  bool? _deliveryEnabled;
  bool? get deliveryEnabled => _$this._deliveryEnabled;
  set deliveryEnabled(bool? deliveryEnabled) =>
      _$this._deliveryEnabled = deliveryEnabled;

  bool? _codEnabled;
  bool? get codEnabled => _$this._codEnabled;
  set codEnabled(bool? codEnabled) => _$this._codEnabled = codEnabled;

  bool? _inStorePaymentEnabled;
  bool? get inStorePaymentEnabled => _$this._inStorePaymentEnabled;
  set inStorePaymentEnabled(bool? inStorePaymentEnabled) =>
      _$this._inStorePaymentEnabled = inStorePaymentEnabled;

  MapBuilder<String, JsonObject?>? _paymentMethods;
  MapBuilder<String, JsonObject?> get paymentMethods =>
      _$this._paymentMethods ??= MapBuilder<String, JsonObject?>();
  set paymentMethods(MapBuilder<String, JsonObject?>? paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  MapBuilder<String, JsonObject?>? _refundConfiguration;
  MapBuilder<String, JsonObject?> get refundConfiguration =>
      _$this._refundConfiguration ??= MapBuilder<String, JsonObject?>();
  set refundConfiguration(
          MapBuilder<String, JsonObject?>? refundConfiguration) =>
      _$this._refundConfiguration = refundConfiguration;

  VendorStoreBuilder() {
    VendorStore._defaults(this);
  }

  VendorStoreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _description = $v.description;
      _publicEmail = $v.publicEmail;
      _publicPhone = $v.publicPhone;
      _pickupEnabled = $v.pickupEnabled;
      _deliveryEnabled = $v.deliveryEnabled;
      _codEnabled = $v.codEnabled;
      _inStorePaymentEnabled = $v.inStorePaymentEnabled;
      _paymentMethods = $v.paymentMethods.toBuilder();
      _refundConfiguration = $v.refundConfiguration.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStore other) {
    _$v = other as _$VendorStore;
  }

  @override
  void update(void Function(VendorStoreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStore build() => _build();

  _$VendorStore _build() {
    _$VendorStore _$result;
    try {
      _$result = _$v ??
          _$VendorStore._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'VendorStore', 'id'),
            description: description,
            publicEmail: publicEmail,
            publicPhone: publicPhone,
            pickupEnabled: BuiltValueNullFieldError.checkNotNull(
                pickupEnabled, r'VendorStore', 'pickupEnabled'),
            deliveryEnabled: BuiltValueNullFieldError.checkNotNull(
                deliveryEnabled, r'VendorStore', 'deliveryEnabled'),
            codEnabled: BuiltValueNullFieldError.checkNotNull(
                codEnabled, r'VendorStore', 'codEnabled'),
            inStorePaymentEnabled: BuiltValueNullFieldError.checkNotNull(
                inStorePaymentEnabled, r'VendorStore', 'inStorePaymentEnabled'),
            paymentMethods: paymentMethods.build(),
            refundConfiguration: refundConfiguration.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'paymentMethods';
        paymentMethods.build();
        _$failedField = 'refundConfiguration';
        refundConfiguration.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorStore', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
