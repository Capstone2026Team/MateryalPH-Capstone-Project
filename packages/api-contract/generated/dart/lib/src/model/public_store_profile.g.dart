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

const PublicStoreProfileHoursStatusEnum
    _$publicStoreProfileHoursStatusEnum_AVAILABLE =
    const PublicStoreProfileHoursStatusEnum._('AVAILABLE');
const PublicStoreProfileHoursStatusEnum
    _$publicStoreProfileHoursStatusEnum_UNAVAILABLE =
    const PublicStoreProfileHoursStatusEnum._('UNAVAILABLE');

PublicStoreProfileHoursStatusEnum _$publicStoreProfileHoursStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$publicStoreProfileHoursStatusEnum_AVAILABLE;
    case 'UNAVAILABLE':
      return _$publicStoreProfileHoursStatusEnum_UNAVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicStoreProfileHoursStatusEnum>
    _$publicStoreProfileHoursStatusEnumValues = BuiltSet<
        PublicStoreProfileHoursStatusEnum>(const <PublicStoreProfileHoursStatusEnum>[
  _$publicStoreProfileHoursStatusEnum_AVAILABLE,
  _$publicStoreProfileHoursStatusEnum_UNAVAILABLE,
]);

const PublicStoreProfileHoursUnavailableReasonEnum
    _$publicStoreProfileHoursUnavailableReasonEnum_SCHEDULE_NOT_AVAILABLE =
    const PublicStoreProfileHoursUnavailableReasonEnum._(
        'SCHEDULE_NOT_AVAILABLE');

PublicStoreProfileHoursUnavailableReasonEnum
    _$publicStoreProfileHoursUnavailableReasonEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULE_NOT_AVAILABLE':
      return _$publicStoreProfileHoursUnavailableReasonEnum_SCHEDULE_NOT_AVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicStoreProfileHoursUnavailableReasonEnum>
    _$publicStoreProfileHoursUnavailableReasonEnumValues = BuiltSet<
        PublicStoreProfileHoursUnavailableReasonEnum>(const <PublicStoreProfileHoursUnavailableReasonEnum>[
  _$publicStoreProfileHoursUnavailableReasonEnum_SCHEDULE_NOT_AVAILABLE,
]);

Serializer<PublicStoreProfileEffectiveSourceEnum>
    _$publicStoreProfileEffectiveSourceEnumSerializer =
    _$PublicStoreProfileEffectiveSourceEnumSerializer();
Serializer<PublicStoreProfileTimeZoneEnum>
    _$publicStoreProfileTimeZoneEnumSerializer =
    _$PublicStoreProfileTimeZoneEnumSerializer();
Serializer<PublicStoreProfileHoursStatusEnum>
    _$publicStoreProfileHoursStatusEnumSerializer =
    _$PublicStoreProfileHoursStatusEnumSerializer();
Serializer<PublicStoreProfileHoursUnavailableReasonEnum>
    _$publicStoreProfileHoursUnavailableReasonEnumSerializer =
    _$PublicStoreProfileHoursUnavailableReasonEnumSerializer();

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

class _$PublicStoreProfileHoursStatusEnumSerializer
    implements PrimitiveSerializer<PublicStoreProfileHoursStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'UNAVAILABLE': 'UNAVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'UNAVAILABLE': 'UNAVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[PublicStoreProfileHoursStatusEnum];
  @override
  final String wireName = 'PublicStoreProfileHoursStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PublicStoreProfileHoursStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicStoreProfileHoursStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicStoreProfileHoursStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicStoreProfileHoursUnavailableReasonEnumSerializer
    implements
        PrimitiveSerializer<PublicStoreProfileHoursUnavailableReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULE_NOT_AVAILABLE': 'SCHEDULE_NOT_AVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULE_NOT_AVAILABLE': 'SCHEDULE_NOT_AVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicStoreProfileHoursUnavailableReasonEnum
  ];
  @override
  final String wireName = 'PublicStoreProfileHoursUnavailableReasonEnum';

  @override
  Object serialize(Serializers serializers,
          PublicStoreProfileHoursUnavailableReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicStoreProfileHoursUnavailableReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicStoreProfileHoursUnavailableReasonEnum.valueOf(
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
  @override
  final String? logoUrl;
  @override
  final String? bannerUrl;
  @override
  final PublicAddressSummary address;
  @override
  final String? supplierType;
  @override
  final BuiltList<String> niches;
  @override
  final String? fulfillmentMethod;
  @override
  final ScoreLabel scoreLabel;
  @override
  final PublicStoreProfileHoursStatusEnum hoursStatus;
  @override
  final BuiltList<StoreHoursDay> week;
  @override
  final StoreOpenNow openNow;
  @override
  final bool allClosed;
  @override
  final DateTime hoursAsOf;
  @override
  final String hoursNotice;
  @override
  final PublicStoreProfileHoursUnavailableReasonEnum? hoursUnavailableReason;

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
      required this.timeZone,
      this.logoUrl,
      this.bannerUrl,
      required this.address,
      this.supplierType,
      required this.niches,
      this.fulfillmentMethod,
      required this.scoreLabel,
      required this.hoursStatus,
      required this.week,
      required this.openNow,
      required this.allClosed,
      required this.hoursAsOf,
      required this.hoursNotice,
      this.hoursUnavailableReason})
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
        timeZone == other.timeZone &&
        logoUrl == other.logoUrl &&
        bannerUrl == other.bannerUrl &&
        address == other.address &&
        supplierType == other.supplierType &&
        niches == other.niches &&
        fulfillmentMethod == other.fulfillmentMethod &&
        scoreLabel == other.scoreLabel &&
        hoursStatus == other.hoursStatus &&
        week == other.week &&
        openNow == other.openNow &&
        allClosed == other.allClosed &&
        hoursAsOf == other.hoursAsOf &&
        hoursNotice == other.hoursNotice &&
        hoursUnavailableReason == other.hoursUnavailableReason;
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
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, bannerUrl.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, supplierType.hashCode);
    _$hash = $jc(_$hash, niches.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, scoreLabel.hashCode);
    _$hash = $jc(_$hash, hoursStatus.hashCode);
    _$hash = $jc(_$hash, week.hashCode);
    _$hash = $jc(_$hash, openNow.hashCode);
    _$hash = $jc(_$hash, allClosed.hashCode);
    _$hash = $jc(_$hash, hoursAsOf.hashCode);
    _$hash = $jc(_$hash, hoursNotice.hashCode);
    _$hash = $jc(_$hash, hoursUnavailableReason.hashCode);
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
          ..add('timeZone', timeZone)
          ..add('logoUrl', logoUrl)
          ..add('bannerUrl', bannerUrl)
          ..add('address', address)
          ..add('supplierType', supplierType)
          ..add('niches', niches)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('scoreLabel', scoreLabel)
          ..add('hoursStatus', hoursStatus)
          ..add('week', week)
          ..add('openNow', openNow)
          ..add('allClosed', allClosed)
          ..add('hoursAsOf', hoursAsOf)
          ..add('hoursNotice', hoursNotice)
          ..add('hoursUnavailableReason', hoursUnavailableReason))
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

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _bannerUrl;
  String? get bannerUrl => _$this._bannerUrl;
  set bannerUrl(String? bannerUrl) => _$this._bannerUrl = bannerUrl;

  PublicAddressSummaryBuilder? _address;
  PublicAddressSummaryBuilder get address =>
      _$this._address ??= PublicAddressSummaryBuilder();
  set address(PublicAddressSummaryBuilder? address) =>
      _$this._address = address;

  String? _supplierType;
  String? get supplierType => _$this._supplierType;
  set supplierType(String? supplierType) => _$this._supplierType = supplierType;

  ListBuilder<String>? _niches;
  ListBuilder<String> get niches => _$this._niches ??= ListBuilder<String>();
  set niches(ListBuilder<String>? niches) => _$this._niches = niches;

  String? _fulfillmentMethod;
  String? get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(String? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ScoreLabelBuilder? _scoreLabel;
  ScoreLabelBuilder get scoreLabel =>
      _$this._scoreLabel ??= ScoreLabelBuilder();
  set scoreLabel(ScoreLabelBuilder? scoreLabel) =>
      _$this._scoreLabel = scoreLabel;

  PublicStoreProfileHoursStatusEnum? _hoursStatus;
  PublicStoreProfileHoursStatusEnum? get hoursStatus => _$this._hoursStatus;
  set hoursStatus(PublicStoreProfileHoursStatusEnum? hoursStatus) =>
      _$this._hoursStatus = hoursStatus;

  ListBuilder<StoreHoursDay>? _week;
  ListBuilder<StoreHoursDay> get week =>
      _$this._week ??= ListBuilder<StoreHoursDay>();
  set week(ListBuilder<StoreHoursDay>? week) => _$this._week = week;

  StoreOpenNowBuilder? _openNow;
  StoreOpenNowBuilder get openNow => _$this._openNow ??= StoreOpenNowBuilder();
  set openNow(StoreOpenNowBuilder? openNow) => _$this._openNow = openNow;

  bool? _allClosed;
  bool? get allClosed => _$this._allClosed;
  set allClosed(bool? allClosed) => _$this._allClosed = allClosed;

  DateTime? _hoursAsOf;
  DateTime? get hoursAsOf => _$this._hoursAsOf;
  set hoursAsOf(DateTime? hoursAsOf) => _$this._hoursAsOf = hoursAsOf;

  String? _hoursNotice;
  String? get hoursNotice => _$this._hoursNotice;
  set hoursNotice(String? hoursNotice) => _$this._hoursNotice = hoursNotice;

  PublicStoreProfileHoursUnavailableReasonEnum? _hoursUnavailableReason;
  PublicStoreProfileHoursUnavailableReasonEnum? get hoursUnavailableReason =>
      _$this._hoursUnavailableReason;
  set hoursUnavailableReason(
          PublicStoreProfileHoursUnavailableReasonEnum?
              hoursUnavailableReason) =>
      _$this._hoursUnavailableReason = hoursUnavailableReason;

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
      _logoUrl = $v.logoUrl;
      _bannerUrl = $v.bannerUrl;
      _address = $v.address.toBuilder();
      _supplierType = $v.supplierType;
      _niches = $v.niches.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _scoreLabel = $v.scoreLabel.toBuilder();
      _hoursStatus = $v.hoursStatus;
      _week = $v.week.toBuilder();
      _openNow = $v.openNow.toBuilder();
      _allClosed = $v.allClosed;
      _hoursAsOf = $v.hoursAsOf;
      _hoursNotice = $v.hoursNotice;
      _hoursUnavailableReason = $v.hoursUnavailableReason;
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
            logoUrl: logoUrl,
            bannerUrl: bannerUrl,
            address: address.build(),
            supplierType: supplierType,
            niches: niches.build(),
            fulfillmentMethod: fulfillmentMethod,
            scoreLabel: scoreLabel.build(),
            hoursStatus: BuiltValueNullFieldError.checkNotNull(
                hoursStatus, r'PublicStoreProfile', 'hoursStatus'),
            week: week.build(),
            openNow: openNow.build(),
            allClosed: BuiltValueNullFieldError.checkNotNull(
                allClosed, r'PublicStoreProfile', 'allClosed'),
            hoursAsOf: BuiltValueNullFieldError.checkNotNull(
                hoursAsOf, r'PublicStoreProfile', 'hoursAsOf'),
            hoursNotice: BuiltValueNullFieldError.checkNotNull(
                hoursNotice, r'PublicStoreProfile', 'hoursNotice'),
            hoursUnavailableReason: hoursUnavailableReason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operatingSchedule';
        operatingSchedule.build();
        _$failedField = 'effectiveToday';
        _effectiveToday?.build();

        _$failedField = 'address';
        address.build();

        _$failedField = 'niches';
        niches.build();

        _$failedField = 'scoreLabel';
        scoreLabel.build();

        _$failedField = 'week';
        week.build();
        _$failedField = 'openNow';
        openNow.build();
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
