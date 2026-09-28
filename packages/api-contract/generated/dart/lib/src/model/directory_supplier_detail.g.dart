// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_supplier_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectorySupplierDetailTierEnum
    _$directorySupplierDetailTierEnum_DIRECTORY_SUPPLIER =
    const DirectorySupplierDetailTierEnum._('DIRECTORY_SUPPLIER');

DirectorySupplierDetailTierEnum _$directorySupplierDetailTierEnumValueOf(
    String name) {
  switch (name) {
    case 'DIRECTORY_SUPPLIER':
      return _$directorySupplierDetailTierEnum_DIRECTORY_SUPPLIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectorySupplierDetailTierEnum>
    _$directorySupplierDetailTierEnumValues = BuiltSet<
        DirectorySupplierDetailTierEnum>(const <DirectorySupplierDetailTierEnum>[
  _$directorySupplierDetailTierEnum_DIRECTORY_SUPPLIER,
]);

const DirectorySupplierDetailTierLabelEnum
    _$directorySupplierDetailTierLabelEnum_directorySupplier =
    const DirectorySupplierDetailTierLabelEnum._('directorySupplier');

DirectorySupplierDetailTierLabelEnum
    _$directorySupplierDetailTierLabelEnumValueOf(String name) {
  switch (name) {
    case 'directorySupplier':
      return _$directorySupplierDetailTierLabelEnum_directorySupplier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectorySupplierDetailTierLabelEnum>
    _$directorySupplierDetailTierLabelEnumValues = BuiltSet<
        DirectorySupplierDetailTierLabelEnum>(const <DirectorySupplierDetailTierLabelEnum>[
  _$directorySupplierDetailTierLabelEnum_directorySupplier,
]);

const DirectorySupplierDetailActionsEnum
    _$directorySupplierDetailActionsEnum_CALL =
    const DirectorySupplierDetailActionsEnum._('CALL');
const DirectorySupplierDetailActionsEnum
    _$directorySupplierDetailActionsEnum_OPEN_IN_MAPS =
    const DirectorySupplierDetailActionsEnum._('OPEN_IN_MAPS');
const DirectorySupplierDetailActionsEnum
    _$directorySupplierDetailActionsEnum_WEBSITE =
    const DirectorySupplierDetailActionsEnum._('WEBSITE');
const DirectorySupplierDetailActionsEnum
    _$directorySupplierDetailActionsEnum_SHARE =
    const DirectorySupplierDetailActionsEnum._('SHARE');

DirectorySupplierDetailActionsEnum _$directorySupplierDetailActionsEnumValueOf(
    String name) {
  switch (name) {
    case 'CALL':
      return _$directorySupplierDetailActionsEnum_CALL;
    case 'OPEN_IN_MAPS':
      return _$directorySupplierDetailActionsEnum_OPEN_IN_MAPS;
    case 'WEBSITE':
      return _$directorySupplierDetailActionsEnum_WEBSITE;
    case 'SHARE':
      return _$directorySupplierDetailActionsEnum_SHARE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectorySupplierDetailActionsEnum>
    _$directorySupplierDetailActionsEnumValues = BuiltSet<
        DirectorySupplierDetailActionsEnum>(const <DirectorySupplierDetailActionsEnum>[
  _$directorySupplierDetailActionsEnum_CALL,
  _$directorySupplierDetailActionsEnum_OPEN_IN_MAPS,
  _$directorySupplierDetailActionsEnum_WEBSITE,
  _$directorySupplierDetailActionsEnum_SHARE,
]);

Serializer<DirectorySupplierDetailTierEnum>
    _$directorySupplierDetailTierEnumSerializer =
    _$DirectorySupplierDetailTierEnumSerializer();
Serializer<DirectorySupplierDetailTierLabelEnum>
    _$directorySupplierDetailTierLabelEnumSerializer =
    _$DirectorySupplierDetailTierLabelEnumSerializer();
Serializer<DirectorySupplierDetailActionsEnum>
    _$directorySupplierDetailActionsEnumSerializer =
    _$DirectorySupplierDetailActionsEnumSerializer();

class _$DirectorySupplierDetailTierEnumSerializer
    implements PrimitiveSerializer<DirectorySupplierDetailTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DIRECTORY_SUPPLIER': 'DIRECTORY_SUPPLIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DIRECTORY_SUPPLIER': 'DIRECTORY_SUPPLIER',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectorySupplierDetailTierEnum];
  @override
  final String wireName = 'DirectorySupplierDetailTierEnum';

  @override
  Object serialize(
          Serializers serializers, DirectorySupplierDetailTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectorySupplierDetailTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectorySupplierDetailTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectorySupplierDetailTierLabelEnumSerializer
    implements PrimitiveSerializer<DirectorySupplierDetailTierLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'directorySupplier': 'Directory Supplier',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Directory Supplier': 'directorySupplier',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DirectorySupplierDetailTierLabelEnum
  ];
  @override
  final String wireName = 'DirectorySupplierDetailTierLabelEnum';

  @override
  Object serialize(
          Serializers serializers, DirectorySupplierDetailTierLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectorySupplierDetailTierLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectorySupplierDetailTierLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectorySupplierDetailActionsEnumSerializer
    implements PrimitiveSerializer<DirectorySupplierDetailActionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CALL': 'CALL',
    'OPEN_IN_MAPS': 'OPEN_IN_MAPS',
    'WEBSITE': 'WEBSITE',
    'SHARE': 'SHARE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CALL': 'CALL',
    'OPEN_IN_MAPS': 'OPEN_IN_MAPS',
    'WEBSITE': 'WEBSITE',
    'SHARE': 'SHARE',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectorySupplierDetailActionsEnum];
  @override
  final String wireName = 'DirectorySupplierDetailActionsEnum';

  @override
  Object serialize(
          Serializers serializers, DirectorySupplierDetailActionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectorySupplierDetailActionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectorySupplierDetailActionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectorySupplierDetail extends DirectorySupplierDetail {
  @override
  final String resultId;
  @override
  final DirectorySupplierDetailTierEnum tier;
  @override
  final DirectorySupplierDetailTierLabelEnum tierLabel;
  @override
  final String name;
  @override
  final String? formattedAddress;
  @override
  final MapPoint marker;
  @override
  final String? publicPhone;
  @override
  final String? websiteUri;
  @override
  final String? googleMapsUri;
  @override
  final BuiltList<String> openingHours;
  @override
  final GoogleRating? googleRating;
  @override
  final ProviderAttribution attribution;
  @override
  final DateTime fetchedAt;
  @override
  final BuiltList<DirectorySupplierDetailActionsEnum> actions;

  factory _$DirectorySupplierDetail(
          [void Function(DirectorySupplierDetailBuilder)? updates]) =>
      (DirectorySupplierDetailBuilder()..update(updates))._build();

  _$DirectorySupplierDetail._(
      {required this.resultId,
      required this.tier,
      required this.tierLabel,
      required this.name,
      this.formattedAddress,
      required this.marker,
      this.publicPhone,
      this.websiteUri,
      this.googleMapsUri,
      required this.openingHours,
      this.googleRating,
      required this.attribution,
      required this.fetchedAt,
      required this.actions})
      : super._();
  @override
  DirectorySupplierDetail rebuild(
          void Function(DirectorySupplierDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectorySupplierDetailBuilder toBuilder() =>
      DirectorySupplierDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectorySupplierDetail &&
        resultId == other.resultId &&
        tier == other.tier &&
        tierLabel == other.tierLabel &&
        name == other.name &&
        formattedAddress == other.formattedAddress &&
        marker == other.marker &&
        publicPhone == other.publicPhone &&
        websiteUri == other.websiteUri &&
        googleMapsUri == other.googleMapsUri &&
        openingHours == other.openingHours &&
        googleRating == other.googleRating &&
        attribution == other.attribution &&
        fetchedAt == other.fetchedAt &&
        actions == other.actions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resultId.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, tierLabel.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, marker.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, websiteUri.hashCode);
    _$hash = $jc(_$hash, googleMapsUri.hashCode);
    _$hash = $jc(_$hash, openingHours.hashCode);
    _$hash = $jc(_$hash, googleRating.hashCode);
    _$hash = $jc(_$hash, attribution.hashCode);
    _$hash = $jc(_$hash, fetchedAt.hashCode);
    _$hash = $jc(_$hash, actions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectorySupplierDetail')
          ..add('resultId', resultId)
          ..add('tier', tier)
          ..add('tierLabel', tierLabel)
          ..add('name', name)
          ..add('formattedAddress', formattedAddress)
          ..add('marker', marker)
          ..add('publicPhone', publicPhone)
          ..add('websiteUri', websiteUri)
          ..add('googleMapsUri', googleMapsUri)
          ..add('openingHours', openingHours)
          ..add('googleRating', googleRating)
          ..add('attribution', attribution)
          ..add('fetchedAt', fetchedAt)
          ..add('actions', actions))
        .toString();
  }
}

class DirectorySupplierDetailBuilder
    implements
        Builder<DirectorySupplierDetail, DirectorySupplierDetailBuilder> {
  _$DirectorySupplierDetail? _$v;

  String? _resultId;
  String? get resultId => _$this._resultId;
  set resultId(String? resultId) => _$this._resultId = resultId;

  DirectorySupplierDetailTierEnum? _tier;
  DirectorySupplierDetailTierEnum? get tier => _$this._tier;
  set tier(DirectorySupplierDetailTierEnum? tier) => _$this._tier = tier;

  DirectorySupplierDetailTierLabelEnum? _tierLabel;
  DirectorySupplierDetailTierLabelEnum? get tierLabel => _$this._tierLabel;
  set tierLabel(DirectorySupplierDetailTierLabelEnum? tierLabel) =>
      _$this._tierLabel = tierLabel;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  MapPointBuilder? _marker;
  MapPointBuilder get marker => _$this._marker ??= MapPointBuilder();
  set marker(MapPointBuilder? marker) => _$this._marker = marker;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

  String? _websiteUri;
  String? get websiteUri => _$this._websiteUri;
  set websiteUri(String? websiteUri) => _$this._websiteUri = websiteUri;

  String? _googleMapsUri;
  String? get googleMapsUri => _$this._googleMapsUri;
  set googleMapsUri(String? googleMapsUri) =>
      _$this._googleMapsUri = googleMapsUri;

  ListBuilder<String>? _openingHours;
  ListBuilder<String> get openingHours =>
      _$this._openingHours ??= ListBuilder<String>();
  set openingHours(ListBuilder<String>? openingHours) =>
      _$this._openingHours = openingHours;

  GoogleRatingBuilder? _googleRating;
  GoogleRatingBuilder get googleRating =>
      _$this._googleRating ??= GoogleRatingBuilder();
  set googleRating(GoogleRatingBuilder? googleRating) =>
      _$this._googleRating = googleRating;

  ProviderAttributionBuilder? _attribution;
  ProviderAttributionBuilder get attribution =>
      _$this._attribution ??= ProviderAttributionBuilder();
  set attribution(ProviderAttributionBuilder? attribution) =>
      _$this._attribution = attribution;

  DateTime? _fetchedAt;
  DateTime? get fetchedAt => _$this._fetchedAt;
  set fetchedAt(DateTime? fetchedAt) => _$this._fetchedAt = fetchedAt;

  ListBuilder<DirectorySupplierDetailActionsEnum>? _actions;
  ListBuilder<DirectorySupplierDetailActionsEnum> get actions =>
      _$this._actions ??= ListBuilder<DirectorySupplierDetailActionsEnum>();
  set actions(ListBuilder<DirectorySupplierDetailActionsEnum>? actions) =>
      _$this._actions = actions;

  DirectorySupplierDetailBuilder() {
    DirectorySupplierDetail._defaults(this);
  }

  DirectorySupplierDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resultId = $v.resultId;
      _tier = $v.tier;
      _tierLabel = $v.tierLabel;
      _name = $v.name;
      _formattedAddress = $v.formattedAddress;
      _marker = $v.marker.toBuilder();
      _publicPhone = $v.publicPhone;
      _websiteUri = $v.websiteUri;
      _googleMapsUri = $v.googleMapsUri;
      _openingHours = $v.openingHours.toBuilder();
      _googleRating = $v.googleRating?.toBuilder();
      _attribution = $v.attribution.toBuilder();
      _fetchedAt = $v.fetchedAt;
      _actions = $v.actions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectorySupplierDetail other) {
    _$v = other as _$DirectorySupplierDetail;
  }

  @override
  void update(void Function(DirectorySupplierDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectorySupplierDetail build() => _build();

  _$DirectorySupplierDetail _build() {
    _$DirectorySupplierDetail _$result;
    try {
      _$result = _$v ??
          _$DirectorySupplierDetail._(
            resultId: BuiltValueNullFieldError.checkNotNull(
                resultId, r'DirectorySupplierDetail', 'resultId'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'DirectorySupplierDetail', 'tier'),
            tierLabel: BuiltValueNullFieldError.checkNotNull(
                tierLabel, r'DirectorySupplierDetail', 'tierLabel'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'DirectorySupplierDetail', 'name'),
            formattedAddress: formattedAddress,
            marker: marker.build(),
            publicPhone: publicPhone,
            websiteUri: websiteUri,
            googleMapsUri: googleMapsUri,
            openingHours: openingHours.build(),
            googleRating: _googleRating?.build(),
            attribution: attribution.build(),
            fetchedAt: BuiltValueNullFieldError.checkNotNull(
                fetchedAt, r'DirectorySupplierDetail', 'fetchedAt'),
            actions: actions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'marker';
        marker.build();

        _$failedField = 'openingHours';
        openingHours.build();
        _$failedField = 'googleRating';
        _googleRating?.build();
        _$failedField = 'attribution';
        attribution.build();

        _$failedField = 'actions';
        actions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectorySupplierDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
