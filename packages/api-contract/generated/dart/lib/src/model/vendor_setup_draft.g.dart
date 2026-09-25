// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup_draft.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorSetupDraftFulfillmentMethodEnum
    _$vendorSetupDraftFulfillmentMethodEnum_SELF_PICKUP =
    const VendorSetupDraftFulfillmentMethodEnum._('SELF_PICKUP');
const VendorSetupDraftFulfillmentMethodEnum
    _$vendorSetupDraftFulfillmentMethodEnum_VENDOR_DELIVERY =
    const VendorSetupDraftFulfillmentMethodEnum._('VENDOR_DELIVERY');
const VendorSetupDraftFulfillmentMethodEnum
    _$vendorSetupDraftFulfillmentMethodEnum_BOTH =
    const VendorSetupDraftFulfillmentMethodEnum._('BOTH');

VendorSetupDraftFulfillmentMethodEnum
    _$vendorSetupDraftFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'SELF_PICKUP':
      return _$vendorSetupDraftFulfillmentMethodEnum_SELF_PICKUP;
    case 'VENDOR_DELIVERY':
      return _$vendorSetupDraftFulfillmentMethodEnum_VENDOR_DELIVERY;
    case 'BOTH':
      return _$vendorSetupDraftFulfillmentMethodEnum_BOTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorSetupDraftFulfillmentMethodEnum>
    _$vendorSetupDraftFulfillmentMethodEnumValues = BuiltSet<
        VendorSetupDraftFulfillmentMethodEnum>(const <VendorSetupDraftFulfillmentMethodEnum>[
  _$vendorSetupDraftFulfillmentMethodEnum_SELF_PICKUP,
  _$vendorSetupDraftFulfillmentMethodEnum_VENDOR_DELIVERY,
  _$vendorSetupDraftFulfillmentMethodEnum_BOTH,
]);

Serializer<VendorSetupDraftFulfillmentMethodEnum>
    _$vendorSetupDraftFulfillmentMethodEnumSerializer =
    _$VendorSetupDraftFulfillmentMethodEnumSerializer();

class _$VendorSetupDraftFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<VendorSetupDraftFulfillmentMethodEnum> {
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
  final Iterable<Type> types = const <Type>[
    VendorSetupDraftFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'VendorSetupDraftFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, VendorSetupDraftFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorSetupDraftFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorSetupDraftFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorSetupDraft extends VendorSetupDraft {
  @override
  final int? draftLockVersion;
  @override
  final int organizationLockVersion;
  @override
  final String? formState;
  @override
  final String? publicStoreName;
  @override
  final String? description;
  @override
  final bool? bulkCapability;
  @override
  final VendorSetupDraftFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final String? publicEmail;
  @override
  final String? publicPhone;
  @override
  final BuiltList<StoreOperatingDay>? operatingSchedule;
  @override
  final VendorSetupDraftDelivery? delivery;
  @override
  final BuiltList<VendorSetupDraftVehiclesInner>? vehicles;

  factory _$VendorSetupDraft(
          [void Function(VendorSetupDraftBuilder)? updates]) =>
      (VendorSetupDraftBuilder()..update(updates))._build();

  _$VendorSetupDraft._(
      {this.draftLockVersion,
      required this.organizationLockVersion,
      this.formState,
      this.publicStoreName,
      this.description,
      this.bulkCapability,
      this.fulfillmentMethod,
      this.publicEmail,
      this.publicPhone,
      this.operatingSchedule,
      this.delivery,
      this.vehicles})
      : super._();
  @override
  VendorSetupDraft rebuild(void Function(VendorSetupDraftBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupDraftBuilder toBuilder() =>
      VendorSetupDraftBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetupDraft &&
        draftLockVersion == other.draftLockVersion &&
        organizationLockVersion == other.organizationLockVersion &&
        formState == other.formState &&
        publicStoreName == other.publicStoreName &&
        description == other.description &&
        bulkCapability == other.bulkCapability &&
        fulfillmentMethod == other.fulfillmentMethod &&
        publicEmail == other.publicEmail &&
        publicPhone == other.publicPhone &&
        operatingSchedule == other.operatingSchedule &&
        delivery == other.delivery &&
        vehicles == other.vehicles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, draftLockVersion.hashCode);
    _$hash = $jc(_$hash, organizationLockVersion.hashCode);
    _$hash = $jc(_$hash, formState.hashCode);
    _$hash = $jc(_$hash, publicStoreName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, bulkCapability.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, operatingSchedule.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorSetupDraft')
          ..add('draftLockVersion', draftLockVersion)
          ..add('organizationLockVersion', organizationLockVersion)
          ..add('formState', formState)
          ..add('publicStoreName', publicStoreName)
          ..add('description', description)
          ..add('bulkCapability', bulkCapability)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('publicEmail', publicEmail)
          ..add('publicPhone', publicPhone)
          ..add('operatingSchedule', operatingSchedule)
          ..add('delivery', delivery)
          ..add('vehicles', vehicles))
        .toString();
  }
}

class VendorSetupDraftBuilder
    implements Builder<VendorSetupDraft, VendorSetupDraftBuilder> {
  _$VendorSetupDraft? _$v;

  int? _draftLockVersion;
  int? get draftLockVersion => _$this._draftLockVersion;
  set draftLockVersion(int? draftLockVersion) =>
      _$this._draftLockVersion = draftLockVersion;

  int? _organizationLockVersion;
  int? get organizationLockVersion => _$this._organizationLockVersion;
  set organizationLockVersion(int? organizationLockVersion) =>
      _$this._organizationLockVersion = organizationLockVersion;

  String? _formState;
  String? get formState => _$this._formState;
  set formState(String? formState) => _$this._formState = formState;

  String? _publicStoreName;
  String? get publicStoreName => _$this._publicStoreName;
  set publicStoreName(String? publicStoreName) =>
      _$this._publicStoreName = publicStoreName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _bulkCapability;
  bool? get bulkCapability => _$this._bulkCapability;
  set bulkCapability(bool? bulkCapability) =>
      _$this._bulkCapability = bulkCapability;

  VendorSetupDraftFulfillmentMethodEnum? _fulfillmentMethod;
  VendorSetupDraftFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          VendorSetupDraftFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  String? _publicEmail;
  String? get publicEmail => _$this._publicEmail;
  set publicEmail(String? publicEmail) => _$this._publicEmail = publicEmail;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

  ListBuilder<StoreOperatingDay>? _operatingSchedule;
  ListBuilder<StoreOperatingDay> get operatingSchedule =>
      _$this._operatingSchedule ??= ListBuilder<StoreOperatingDay>();
  set operatingSchedule(ListBuilder<StoreOperatingDay>? operatingSchedule) =>
      _$this._operatingSchedule = operatingSchedule;

  VendorSetupDraftDeliveryBuilder? _delivery;
  VendorSetupDraftDeliveryBuilder get delivery =>
      _$this._delivery ??= VendorSetupDraftDeliveryBuilder();
  set delivery(VendorSetupDraftDeliveryBuilder? delivery) =>
      _$this._delivery = delivery;

  ListBuilder<VendorSetupDraftVehiclesInner>? _vehicles;
  ListBuilder<VendorSetupDraftVehiclesInner> get vehicles =>
      _$this._vehicles ??= ListBuilder<VendorSetupDraftVehiclesInner>();
  set vehicles(ListBuilder<VendorSetupDraftVehiclesInner>? vehicles) =>
      _$this._vehicles = vehicles;

  VendorSetupDraftBuilder() {
    VendorSetupDraft._defaults(this);
  }

  VendorSetupDraftBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _draftLockVersion = $v.draftLockVersion;
      _organizationLockVersion = $v.organizationLockVersion;
      _formState = $v.formState;
      _publicStoreName = $v.publicStoreName;
      _description = $v.description;
      _bulkCapability = $v.bulkCapability;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _publicEmail = $v.publicEmail;
      _publicPhone = $v.publicPhone;
      _operatingSchedule = $v.operatingSchedule?.toBuilder();
      _delivery = $v.delivery?.toBuilder();
      _vehicles = $v.vehicles?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorSetupDraft other) {
    _$v = other as _$VendorSetupDraft;
  }

  @override
  void update(void Function(VendorSetupDraftBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetupDraft build() => _build();

  _$VendorSetupDraft _build() {
    _$VendorSetupDraft _$result;
    try {
      _$result = _$v ??
          _$VendorSetupDraft._(
            draftLockVersion: draftLockVersion,
            organizationLockVersion: BuiltValueNullFieldError.checkNotNull(
                organizationLockVersion,
                r'VendorSetupDraft',
                'organizationLockVersion'),
            formState: formState,
            publicStoreName: publicStoreName,
            description: description,
            bulkCapability: bulkCapability,
            fulfillmentMethod: fulfillmentMethod,
            publicEmail: publicEmail,
            publicPhone: publicPhone,
            operatingSchedule: _operatingSchedule?.build(),
            delivery: _delivery?.build(),
            vehicles: _vehicles?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operatingSchedule';
        _operatingSchedule?.build();
        _$failedField = 'delivery';
        _delivery?.build();
        _$failedField = 'vehicles';
        _vehicles?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorSetupDraft', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
