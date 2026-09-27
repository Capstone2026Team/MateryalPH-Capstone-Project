// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicStoreProfileEffectiveSourceEnum
    _$publicStoreProfileEffectiveSourceEnum_WEEKLY =
    const PublicStoreProfileEffectiveSourceEnum._('WEEKLY');
const PublicStoreProfileEffectiveSourceEnum
    _$publicStoreProfileEffectiveSourceEnum_DATE_OVERRIDE =
    const PublicStoreProfileEffectiveSourceEnum._('DATE_OVERRIDE');

PublicStoreProfileEffectiveSourceEnum
    _$publicStoreProfileEffectiveSourceEnumValueOf(String name) {
  switch (name) {
    case 'WEEKLY':
      return _$publicStoreProfileEffectiveSourceEnum_WEEKLY;
    case 'DATE_OVERRIDE':
      return _$publicStoreProfileEffectiveSourceEnum_DATE_OVERRIDE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicStoreProfileEffectiveSourceEnum>
    _$publicStoreProfileEffectiveSourceEnumValues = BuiltSet<
        PublicStoreProfileEffectiveSourceEnum>(const <PublicStoreProfileEffectiveSourceEnum>[
  _$publicStoreProfileEffectiveSourceEnum_WEEKLY,
  _$publicStoreProfileEffectiveSourceEnum_DATE_OVERRIDE,
]);

const PublicStoreProfileTimeZoneEnum
    _$publicStoreProfileTimeZoneEnum_asiaSlashManila =
    const PublicStoreProfileTimeZoneEnum._('asiaSlashManila');

PublicStoreProfileTimeZoneEnum _$publicStoreProfileTimeZoneEnumValueOf(
    String name) {
  switch (name) {
    case 'asiaSlashManila':
      return _$publicStoreProfileTimeZoneEnum_asiaSlashManila;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicStoreProfileTimeZoneEnum>
    _$publicStoreProfileTimeZoneEnumValues = BuiltSet<
        PublicStoreProfileTimeZoneEnum>(const <PublicStoreProfileTimeZoneEnum>[
  _$publicStoreProfileTimeZoneEnum_asiaSlashManila,
]);

Serializer<PublicStoreProfileEffectiveSourceEnum>
    _$publicStoreProfileEffectiveSourceEnumSerializer =
    _$PublicStoreProfileEffectiveSourceEnumSerializer();
Serializer<PublicStoreProfileTimeZoneEnum>
    _$publicStoreProfileTimeZoneEnumSerializer =
    _$PublicStoreProfileTimeZoneEnumSerializer();

class _$PublicStoreProfileEffectiveSourceEnumSerializer
    implements PrimitiveSerializer<PublicStoreProfileEffectiveSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WEEKLY': 'WEEKLY',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WEEKLY': 'WEEKLY',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicStoreProfileEffectiveSourceEnum
  ];
  @override
  final String wireName = 'PublicStoreProfileEffectiveSourceEnum';

  @override
  Object serialize(
          Serializers serializers, PublicStoreProfileEffectiveSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicStoreProfileEffectiveSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicStoreProfileEffectiveSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicStoreProfileTimeZoneEnumSerializer
    implements PrimitiveSerializer<PublicStoreProfileTimeZoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'asiaSlashManila': 'Asia/Manila',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Asia/Manila': 'asiaSlashManila',
  };

  @override
  final Iterable<Type> types = const <Type>[PublicStoreProfileTimeZoneEnum];
  @override
  final String wireName = 'PublicStoreProfileTimeZoneEnum';

  @override
  Object serialize(
          Serializers serializers, PublicStoreProfileTimeZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicStoreProfileTimeZoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicStoreProfileTimeZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicStoreProfile extends PublicStoreProfile {
  @override
  final String id;
  @override
  final bool vacationMode;
  @override
  final String publicStoreName;
  @override
  final String? description;
  @override
  final String? publicEmail;
  @override
  final String? publicPhone;
  @override
  final BuiltList<StoreOperatingDay> operatingSchedule;
  @override
  final StoreOperatingDay? effectiveToday;
  @override
  final Date effectiveDate;
  @override
  final PublicStoreProfileEffectiveSourceEnum effectiveSource;
  @override
  final PublicStoreProfileTimeZoneEnum timeZone;

  factory _$PublicStoreProfile(
          [void Function(PublicStoreProfileBuilder)? updates]) =>
      (PublicStoreProfileBuilder()..update(updates))._build();

  _$PublicStoreProfile._(
      {required this.id,
      required this.vacationMode,
      required this.publicStoreName,
      this.description,
      this.publicEmail,
      this.publicPhone,
      required this.operatingSchedule,
      this.effectiveToday,
      required this.effectiveDate,
      required this.effectiveSource,
      required this.timeZone})
      : super._();
  @override
  PublicStoreProfile rebuild(
          void Function(PublicStoreProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicStoreProfileBuilder toBuilder() =>
      PublicStoreProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicStoreProfile &&
        id == other.id &&
        vacationMode == other.vacationMode &&
        publicStoreName == other.publicStoreName &&
        description == other.description &&
        publicEmail == other.publicEmail &&
        publicPhone == other.publicPhone &&
        operatingSchedule == other.operatingSchedule &&
        effectiveToday == other.effectiveToday &&
        effectiveDate == other.effectiveDate &&
        effectiveSource == other.effectiveSource &&
        timeZone == other.timeZone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, publicStoreName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, publicEmail.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, operatingSchedule.hashCode);
    _$hash = $jc(_$hash, effectiveToday.hashCode);
    _$hash = $jc(_$hash, effectiveDate.hashCode);
    _$hash = $jc(_$hash, effectiveSource.hashCode);
    _$hash = $jc(_$hash, timeZone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicStoreProfile')
          ..add('id', id)
          ..add('vacationMode', vacationMode)
          ..add('publicStoreName', publicStoreName)
          ..add('description', description)
          ..add('publicEmail', publicEmail)
          ..add('publicPhone', publicPhone)
          ..add('operatingSchedule', operatingSchedule)
          ..add('effectiveToday', effectiveToday)
          ..add('effectiveDate', effectiveDate)
          ..add('effectiveSource', effectiveSource)
          ..add('timeZone', timeZone))
        .toString();
  }
}

class PublicStoreProfileBuilder
    implements Builder<PublicStoreProfile, PublicStoreProfileBuilder> {
  _$PublicStoreProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  String? _publicStoreName;
  String? get publicStoreName => _$this._publicStoreName;
  set publicStoreName(String? publicStoreName) =>
      _$this._publicStoreName = publicStoreName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

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

  StoreOperatingDayBuilder? _effectiveToday;
  StoreOperatingDayBuilder get effectiveToday =>
      _$this._effectiveToday ??= StoreOperatingDayBuilder();
  set effectiveToday(StoreOperatingDayBuilder? effectiveToday) =>
      _$this._effectiveToday = effectiveToday;

  Date? _effectiveDate;
  Date? get effectiveDate => _$this._effectiveDate;
  set effectiveDate(Date? effectiveDate) =>
      _$this._effectiveDate = effectiveDate;

  PublicStoreProfileEffectiveSourceEnum? _effectiveSource;
  PublicStoreProfileEffectiveSourceEnum? get effectiveSource =>
      _$this._effectiveSource;
  set effectiveSource(PublicStoreProfileEffectiveSourceEnum? effectiveSource) =>
      _$this._effectiveSource = effectiveSource;

  PublicStoreProfileTimeZoneEnum? _timeZone;
  PublicStoreProfileTimeZoneEnum? get timeZone => _$this._timeZone;
  set timeZone(PublicStoreProfileTimeZoneEnum? timeZone) =>
      _$this._timeZone = timeZone;

  PublicStoreProfileBuilder() {
    PublicStoreProfile._defaults(this);
  }

  PublicStoreProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _vacationMode = $v.vacationMode;
      _publicStoreName = $v.publicStoreName;
      _description = $v.description;
      _publicEmail = $v.publicEmail;
      _publicPhone = $v.publicPhone;
      _operatingSchedule = $v.operatingSchedule.toBuilder();
      _effectiveToday = $v.effectiveToday?.toBuilder();
      _effectiveDate = $v.effectiveDate;
      _effectiveSource = $v.effectiveSource;
      _timeZone = $v.timeZone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicStoreProfile other) {
    _$v = other as _$PublicStoreProfile;
  }

  @override
  void update(void Function(PublicStoreProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicStoreProfile build() => _build();

  _$PublicStoreProfile _build() {
    _$PublicStoreProfile _$result;
    try {
      _$result = _$v ??
          _$PublicStoreProfile._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PublicStoreProfile', 'id'),
            vacationMode: BuiltValueNullFieldError.checkNotNull(
                vacationMode, r'PublicStoreProfile', 'vacationMode'),
            publicStoreName: BuiltValueNullFieldError.checkNotNull(
                publicStoreName, r'PublicStoreProfile', 'publicStoreName'),
            description: description,
            publicEmail: publicEmail,
            publicPhone: publicPhone,
            operatingSchedule: operatingSchedule.build(),
            effectiveToday: _effectiveToday?.build(),
            effectiveDate: BuiltValueNullFieldError.checkNotNull(
                effectiveDate, r'PublicStoreProfile', 'effectiveDate'),
            effectiveSource: BuiltValueNullFieldError.checkNotNull(
                effectiveSource, r'PublicStoreProfile', 'effectiveSource'),
            timeZone: BuiltValueNullFieldError.checkNotNull(
                timeZone, r'PublicStoreProfile', 'timeZone'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operatingSchedule';
        operatingSchedule.build();
        _$failedField = 'effectiveToday';
        _effectiveToday?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicStoreProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
