// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vendor_verification_queue_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVendorVerificationQueueItem
    extends AdminVendorVerificationQueueItem {
  @override
  final String id;
  @override
  final String storeName;
  @override
  final String? registeredName;
  @override
  final String? regionCode;
  @override
  final String? regionName;
  @override
  final String? province;
  @override
  final String? cityMunicipality;
  @override
  final String? businessType;
  @override
  final String verificationStatus;
  @override
  final String? setupStatus;
  @override
  final String? activationStatus;
  @override
  final DateTime? submittedAt;
  @override
  final BuiltMap<String, JsonObject?> progress;

  factory _$AdminVendorVerificationQueueItem(
          [void Function(AdminVendorVerificationQueueItemBuilder)? updates]) =>
      (AdminVendorVerificationQueueItemBuilder()..update(updates))._build();

  _$AdminVendorVerificationQueueItem._(
      {required this.id,
      required this.storeName,
      this.registeredName,
      this.regionCode,
      this.regionName,
      this.province,
      this.cityMunicipality,
      this.businessType,
      required this.verificationStatus,
      this.setupStatus,
      this.activationStatus,
      this.submittedAt,
      required this.progress})
      : super._();
  @override
  AdminVendorVerificationQueueItem rebuild(
          void Function(AdminVendorVerificationQueueItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVendorVerificationQueueItemBuilder toBuilder() =>
      AdminVendorVerificationQueueItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVendorVerificationQueueItem &&
        id == other.id &&
        storeName == other.storeName &&
        registeredName == other.registeredName &&
        regionCode == other.regionCode &&
        regionName == other.regionName &&
        province == other.province &&
        cityMunicipality == other.cityMunicipality &&
        businessType == other.businessType &&
        verificationStatus == other.verificationStatus &&
        setupStatus == other.setupStatus &&
        activationStatus == other.activationStatus &&
        submittedAt == other.submittedAt &&
        progress == other.progress;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, registeredName.hashCode);
    _$hash = $jc(_$hash, regionCode.hashCode);
    _$hash = $jc(_$hash, regionName.hashCode);
    _$hash = $jc(_$hash, province.hashCode);
    _$hash = $jc(_$hash, cityMunicipality.hashCode);
    _$hash = $jc(_$hash, businessType.hashCode);
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jc(_$hash, setupStatus.hashCode);
    _$hash = $jc(_$hash, activationStatus.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, progress.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminVendorVerificationQueueItem')
          ..add('id', id)
          ..add('storeName', storeName)
          ..add('registeredName', registeredName)
          ..add('regionCode', regionCode)
          ..add('regionName', regionName)
          ..add('province', province)
          ..add('cityMunicipality', cityMunicipality)
          ..add('businessType', businessType)
          ..add('verificationStatus', verificationStatus)
          ..add('setupStatus', setupStatus)
          ..add('activationStatus', activationStatus)
          ..add('submittedAt', submittedAt)
          ..add('progress', progress))
        .toString();
  }
}

class AdminVendorVerificationQueueItemBuilder
    implements
        Builder<AdminVendorVerificationQueueItem,
            AdminVendorVerificationQueueItemBuilder> {
  _$AdminVendorVerificationQueueItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _registeredName;
  String? get registeredName => _$this._registeredName;
  set registeredName(String? registeredName) =>
      _$this._registeredName = registeredName;

  String? _regionCode;
  String? get regionCode => _$this._regionCode;
  set regionCode(String? regionCode) => _$this._regionCode = regionCode;

  String? _regionName;
  String? get regionName => _$this._regionName;
  set regionName(String? regionName) => _$this._regionName = regionName;

  String? _province;
  String? get province => _$this._province;
  set province(String? province) => _$this._province = province;

  String? _cityMunicipality;
  String? get cityMunicipality => _$this._cityMunicipality;
  set cityMunicipality(String? cityMunicipality) =>
      _$this._cityMunicipality = cityMunicipality;

  String? _businessType;
  String? get businessType => _$this._businessType;
  set businessType(String? businessType) => _$this._businessType = businessType;

  String? _verificationStatus;
  String? get verificationStatus => _$this._verificationStatus;
  set verificationStatus(String? verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  String? _setupStatus;
  String? get setupStatus => _$this._setupStatus;
  set setupStatus(String? setupStatus) => _$this._setupStatus = setupStatus;

  String? _activationStatus;
  String? get activationStatus => _$this._activationStatus;
  set activationStatus(String? activationStatus) =>
      _$this._activationStatus = activationStatus;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  MapBuilder<String, JsonObject?>? _progress;
  MapBuilder<String, JsonObject?> get progress =>
      _$this._progress ??= MapBuilder<String, JsonObject?>();
  set progress(MapBuilder<String, JsonObject?>? progress) =>
      _$this._progress = progress;

  AdminVendorVerificationQueueItemBuilder() {
    AdminVendorVerificationQueueItem._defaults(this);
  }

  AdminVendorVerificationQueueItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _storeName = $v.storeName;
      _registeredName = $v.registeredName;
      _regionCode = $v.regionCode;
      _regionName = $v.regionName;
      _province = $v.province;
      _cityMunicipality = $v.cityMunicipality;
      _businessType = $v.businessType;
      _verificationStatus = $v.verificationStatus;
      _setupStatus = $v.setupStatus;
      _activationStatus = $v.activationStatus;
      _submittedAt = $v.submittedAt;
      _progress = $v.progress.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVendorVerificationQueueItem other) {
    _$v = other as _$AdminVendorVerificationQueueItem;
  }

  @override
  void update(void Function(AdminVendorVerificationQueueItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVendorVerificationQueueItem build() => _build();

  _$AdminVendorVerificationQueueItem _build() {
    _$AdminVendorVerificationQueueItem _$result;
    try {
      _$result = _$v ??
          _$AdminVendorVerificationQueueItem._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminVendorVerificationQueueItem', 'id'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'AdminVendorVerificationQueueItem', 'storeName'),
            registeredName: registeredName,
            regionCode: regionCode,
            regionName: regionName,
            province: province,
            cityMunicipality: cityMunicipality,
            businessType: businessType,
            verificationStatus: BuiltValueNullFieldError.checkNotNull(
                verificationStatus,
                r'AdminVendorVerificationQueueItem',
                'verificationStatus'),
            setupStatus: setupStatus,
            activationStatus: activationStatus,
            submittedAt: submittedAt,
            progress: progress.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'progress';
        progress.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminVendorVerificationQueueItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
