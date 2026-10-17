// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SiteInspectionStatusEnum _$siteInspectionStatusEnum_REQUESTED =
    const SiteInspectionStatusEnum._('REQUESTED');
const SiteInspectionStatusEnum _$siteInspectionStatusEnum_SCHEDULED =
    const SiteInspectionStatusEnum._('SCHEDULED');
const SiteInspectionStatusEnum _$siteInspectionStatusEnum_COMPLETED =
    const SiteInspectionStatusEnum._('COMPLETED');
const SiteInspectionStatusEnum _$siteInspectionStatusEnum_DECLINED =
    const SiteInspectionStatusEnum._('DECLINED');
const SiteInspectionStatusEnum _$siteInspectionStatusEnum_CANCELLED =
    const SiteInspectionStatusEnum._('CANCELLED');

SiteInspectionStatusEnum _$siteInspectionStatusEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$siteInspectionStatusEnum_REQUESTED;
    case 'SCHEDULED':
      return _$siteInspectionStatusEnum_SCHEDULED;
    case 'COMPLETED':
      return _$siteInspectionStatusEnum_COMPLETED;
    case 'DECLINED':
      return _$siteInspectionStatusEnum_DECLINED;
    case 'CANCELLED':
      return _$siteInspectionStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SiteInspectionStatusEnum> _$siteInspectionStatusEnumValues =
    BuiltSet<SiteInspectionStatusEnum>(const <SiteInspectionStatusEnum>[
  _$siteInspectionStatusEnum_REQUESTED,
  _$siteInspectionStatusEnum_SCHEDULED,
  _$siteInspectionStatusEnum_COMPLETED,
  _$siteInspectionStatusEnum_DECLINED,
  _$siteInspectionStatusEnum_CANCELLED,
]);

Serializer<SiteInspectionStatusEnum> _$siteInspectionStatusEnumSerializer =
    _$SiteInspectionStatusEnumSerializer();

class _$SiteInspectionStatusEnumSerializer
    implements PrimitiveSerializer<SiteInspectionStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUESTED': 'REQUESTED',
    'SCHEDULED': 'SCHEDULED',
    'COMPLETED': 'COMPLETED',
    'DECLINED': 'DECLINED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUESTED': 'REQUESTED',
    'SCHEDULED': 'SCHEDULED',
    'COMPLETED': 'COMPLETED',
    'DECLINED': 'DECLINED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[SiteInspectionStatusEnum];
  @override
  final String wireName = 'SiteInspectionStatusEnum';

  @override
  Object serialize(Serializers serializers, SiteInspectionStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SiteInspectionStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SiteInspectionStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SiteInspection extends SiteInspection {
  @override
  final String id;
  @override
  final SiteInspectionStatusEnum status;
  @override
  final int lockVersion;
  @override
  final SiteInspectionListing listing;
  @override
  final SiteInspectionVariant? variant;
  @override
  final SiteInspectionSite site;
  @override
  final Date preferredDate;
  @override
  final String? buyerNotes;
  @override
  final DateTime? scheduledFor;
  @override
  final String? vendorNote;
  @override
  final String? measuredVolumeM3;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? closedAt;
  @override
  final bool free;
  @override
  final SiteInspectionActions actions;

  factory _$SiteInspection([void Function(SiteInspectionBuilder)? updates]) =>
      (SiteInspectionBuilder()..update(updates))._build();

  _$SiteInspection._(
      {required this.id,
      required this.status,
      required this.lockVersion,
      required this.listing,
      this.variant,
      required this.site,
      required this.preferredDate,
      this.buyerNotes,
      this.scheduledFor,
      this.vendorNote,
      this.measuredVolumeM3,
      required this.requestedAt,
      this.closedAt,
      required this.free,
      required this.actions})
      : super._();
  @override
  SiteInspection rebuild(void Function(SiteInspectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionBuilder toBuilder() => SiteInspectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspection &&
        id == other.id &&
        status == other.status &&
        lockVersion == other.lockVersion &&
        listing == other.listing &&
        variant == other.variant &&
        site == other.site &&
        preferredDate == other.preferredDate &&
        buyerNotes == other.buyerNotes &&
        scheduledFor == other.scheduledFor &&
        vendorNote == other.vendorNote &&
        measuredVolumeM3 == other.measuredVolumeM3 &&
        requestedAt == other.requestedAt &&
        closedAt == other.closedAt &&
        free == other.free &&
        actions == other.actions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, listing.hashCode);
    _$hash = $jc(_$hash, variant.hashCode);
    _$hash = $jc(_$hash, site.hashCode);
    _$hash = $jc(_$hash, preferredDate.hashCode);
    _$hash = $jc(_$hash, buyerNotes.hashCode);
    _$hash = $jc(_$hash, scheduledFor.hashCode);
    _$hash = $jc(_$hash, vendorNote.hashCode);
    _$hash = $jc(_$hash, measuredVolumeM3.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, free.hashCode);
    _$hash = $jc(_$hash, actions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspection')
          ..add('id', id)
          ..add('status', status)
          ..add('lockVersion', lockVersion)
          ..add('listing', listing)
          ..add('variant', variant)
          ..add('site', site)
          ..add('preferredDate', preferredDate)
          ..add('buyerNotes', buyerNotes)
          ..add('scheduledFor', scheduledFor)
          ..add('vendorNote', vendorNote)
          ..add('measuredVolumeM3', measuredVolumeM3)
          ..add('requestedAt', requestedAt)
          ..add('closedAt', closedAt)
          ..add('free', free)
          ..add('actions', actions))
        .toString();
  }
}

class SiteInspectionBuilder
    implements Builder<SiteInspection, SiteInspectionBuilder> {
  _$SiteInspection? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SiteInspectionStatusEnum? _status;
  SiteInspectionStatusEnum? get status => _$this._status;
  set status(SiteInspectionStatusEnum? status) => _$this._status = status;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  SiteInspectionListingBuilder? _listing;
  SiteInspectionListingBuilder get listing =>
      _$this._listing ??= SiteInspectionListingBuilder();
  set listing(SiteInspectionListingBuilder? listing) =>
      _$this._listing = listing;

  SiteInspectionVariantBuilder? _variant;
  SiteInspectionVariantBuilder get variant =>
      _$this._variant ??= SiteInspectionVariantBuilder();
  set variant(SiteInspectionVariantBuilder? variant) =>
      _$this._variant = variant;

  SiteInspectionSiteBuilder? _site;
  SiteInspectionSiteBuilder get site =>
      _$this._site ??= SiteInspectionSiteBuilder();
  set site(SiteInspectionSiteBuilder? site) => _$this._site = site;

  Date? _preferredDate;
  Date? get preferredDate => _$this._preferredDate;
  set preferredDate(Date? preferredDate) =>
      _$this._preferredDate = preferredDate;

  String? _buyerNotes;
  String? get buyerNotes => _$this._buyerNotes;
  set buyerNotes(String? buyerNotes) => _$this._buyerNotes = buyerNotes;

  DateTime? _scheduledFor;
  DateTime? get scheduledFor => _$this._scheduledFor;
  set scheduledFor(DateTime? scheduledFor) =>
      _$this._scheduledFor = scheduledFor;

  String? _vendorNote;
  String? get vendorNote => _$this._vendorNote;
  set vendorNote(String? vendorNote) => _$this._vendorNote = vendorNote;

  String? _measuredVolumeM3;
  String? get measuredVolumeM3 => _$this._measuredVolumeM3;
  set measuredVolumeM3(String? measuredVolumeM3) =>
      _$this._measuredVolumeM3 = measuredVolumeM3;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  bool? _free;
  bool? get free => _$this._free;
  set free(bool? free) => _$this._free = free;

  SiteInspectionActionsBuilder? _actions;
  SiteInspectionActionsBuilder get actions =>
      _$this._actions ??= SiteInspectionActionsBuilder();
  set actions(SiteInspectionActionsBuilder? actions) =>
      _$this._actions = actions;

  SiteInspectionBuilder() {
    SiteInspection._defaults(this);
  }

  SiteInspectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _lockVersion = $v.lockVersion;
      _listing = $v.listing.toBuilder();
      _variant = $v.variant?.toBuilder();
      _site = $v.site.toBuilder();
      _preferredDate = $v.preferredDate;
      _buyerNotes = $v.buyerNotes;
      _scheduledFor = $v.scheduledFor;
      _vendorNote = $v.vendorNote;
      _measuredVolumeM3 = $v.measuredVolumeM3;
      _requestedAt = $v.requestedAt;
      _closedAt = $v.closedAt;
      _free = $v.free;
      _actions = $v.actions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspection other) {
    _$v = other as _$SiteInspection;
  }

  @override
  void update(void Function(SiteInspectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspection build() => _build();

  _$SiteInspection _build() {
    _$SiteInspection _$result;
    try {
      _$result = _$v ??
          _$SiteInspection._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SiteInspection', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'SiteInspection', 'status'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'SiteInspection', 'lockVersion'),
            listing: listing.build(),
            variant: _variant?.build(),
            site: site.build(),
            preferredDate: BuiltValueNullFieldError.checkNotNull(
                preferredDate, r'SiteInspection', 'preferredDate'),
            buyerNotes: buyerNotes,
            scheduledFor: scheduledFor,
            vendorNote: vendorNote,
            measuredVolumeM3: measuredVolumeM3,
            requestedAt: BuiltValueNullFieldError.checkNotNull(
                requestedAt, r'SiteInspection', 'requestedAt'),
            closedAt: closedAt,
            free: BuiltValueNullFieldError.checkNotNull(
                free, r'SiteInspection', 'free'),
            actions: actions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listing';
        listing.build();
        _$failedField = 'variant';
        _variant?.build();
        _$failedField = 'site';
        site.build();

        _$failedField = 'actions';
        actions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SiteInspection', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
