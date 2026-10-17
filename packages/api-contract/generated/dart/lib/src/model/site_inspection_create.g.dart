// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SiteInspectionCreateHeavyVehicleRestrictionEnum
    _$siteInspectionCreateHeavyVehicleRestrictionEnum_NO =
    const SiteInspectionCreateHeavyVehicleRestrictionEnum._('NO');
const SiteInspectionCreateHeavyVehicleRestrictionEnum
    _$siteInspectionCreateHeavyVehicleRestrictionEnum_YES =
    const SiteInspectionCreateHeavyVehicleRestrictionEnum._('YES');

SiteInspectionCreateHeavyVehicleRestrictionEnum
    _$siteInspectionCreateHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'NO':
      return _$siteInspectionCreateHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$siteInspectionCreateHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SiteInspectionCreateHeavyVehicleRestrictionEnum>
    _$siteInspectionCreateHeavyVehicleRestrictionEnumValues = BuiltSet<
        SiteInspectionCreateHeavyVehicleRestrictionEnum>(const <SiteInspectionCreateHeavyVehicleRestrictionEnum>[
  _$siteInspectionCreateHeavyVehicleRestrictionEnum_NO,
  _$siteInspectionCreateHeavyVehicleRestrictionEnum_YES,
]);

Serializer<SiteInspectionCreateHeavyVehicleRestrictionEnum>
    _$siteInspectionCreateHeavyVehicleRestrictionEnumSerializer =
    _$SiteInspectionCreateHeavyVehicleRestrictionEnumSerializer();

class _$SiteInspectionCreateHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<SiteInspectionCreateHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NO': 'NO',
    'YES': 'YES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NO': 'NO',
    'YES': 'YES',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SiteInspectionCreateHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'SiteInspectionCreateHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          SiteInspectionCreateHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SiteInspectionCreateHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SiteInspectionCreateHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SiteInspectionCreate extends SiteInspectionCreate {
  @override
  final String listingId;
  @override
  final String? listingVariantId;
  @override
  final String locationId;
  @override
  final SiteInspectionCreateHeavyVehicleRestrictionEnum?
      heavyVehicleRestriction;
  @override
  final String? alternateDropOffLocationId;
  @override
  final String? accessInstructions;
  @override
  final Date preferredDate;
  @override
  final String? notes;

  factory _$SiteInspectionCreate(
          [void Function(SiteInspectionCreateBuilder)? updates]) =>
      (SiteInspectionCreateBuilder()..update(updates))._build();

  _$SiteInspectionCreate._(
      {required this.listingId,
      this.listingVariantId,
      required this.locationId,
      this.heavyVehicleRestriction,
      this.alternateDropOffLocationId,
      this.accessInstructions,
      required this.preferredDate,
      this.notes})
      : super._();
  @override
  SiteInspectionCreate rebuild(
          void Function(SiteInspectionCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionCreateBuilder toBuilder() =>
      SiteInspectionCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionCreate &&
        listingId == other.listingId &&
        listingVariantId == other.listingVariantId &&
        locationId == other.locationId &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOffLocationId == other.alternateDropOffLocationId &&
        accessInstructions == other.accessInstructions &&
        preferredDate == other.preferredDate &&
        notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOffLocationId.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jc(_$hash, preferredDate.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionCreate')
          ..add('listingId', listingId)
          ..add('listingVariantId', listingVariantId)
          ..add('locationId', locationId)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOffLocationId', alternateDropOffLocationId)
          ..add('accessInstructions', accessInstructions)
          ..add('preferredDate', preferredDate)
          ..add('notes', notes))
        .toString();
  }
}

class SiteInspectionCreateBuilder
    implements Builder<SiteInspectionCreate, SiteInspectionCreateBuilder> {
  _$SiteInspectionCreate? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  SiteInspectionCreateHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  SiteInspectionCreateHeavyVehicleRestrictionEnum?
      get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          SiteInspectionCreateHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  String? _alternateDropOffLocationId;
  String? get alternateDropOffLocationId => _$this._alternateDropOffLocationId;
  set alternateDropOffLocationId(String? alternateDropOffLocationId) =>
      _$this._alternateDropOffLocationId = alternateDropOffLocationId;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  Date? _preferredDate;
  Date? get preferredDate => _$this._preferredDate;
  set preferredDate(Date? preferredDate) =>
      _$this._preferredDate = preferredDate;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  SiteInspectionCreateBuilder() {
    SiteInspectionCreate._defaults(this);
  }

  SiteInspectionCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _listingVariantId = $v.listingVariantId;
      _locationId = $v.locationId;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOffLocationId = $v.alternateDropOffLocationId;
      _accessInstructions = $v.accessInstructions;
      _preferredDate = $v.preferredDate;
      _notes = $v.notes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionCreate other) {
    _$v = other as _$SiteInspectionCreate;
  }

  @override
  void update(void Function(SiteInspectionCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionCreate build() => _build();

  _$SiteInspectionCreate _build() {
    final _$result = _$v ??
        _$SiteInspectionCreate._(
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'SiteInspectionCreate', 'listingId'),
          listingVariantId: listingVariantId,
          locationId: BuiltValueNullFieldError.checkNotNull(
              locationId, r'SiteInspectionCreate', 'locationId'),
          heavyVehicleRestriction: heavyVehicleRestriction,
          alternateDropOffLocationId: alternateDropOffLocationId,
          accessInstructions: accessInstructions,
          preferredDate: BuiltValueNullFieldError.checkNotNull(
              preferredDate, r'SiteInspectionCreate', 'preferredDate'),
          notes: notes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
