// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_materials_analytics_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorMaterialsAnalyticsDetailAudienceEnum
    _$vendorMaterialsAnalyticsDetailAudienceEnum_BUYER =
    const VendorMaterialsAnalyticsDetailAudienceEnum._('BUYER');
const VendorMaterialsAnalyticsDetailAudienceEnum
    _$vendorMaterialsAnalyticsDetailAudienceEnum_VENDOR =
    const VendorMaterialsAnalyticsDetailAudienceEnum._('VENDOR');
const VendorMaterialsAnalyticsDetailAudienceEnum
    _$vendorMaterialsAnalyticsDetailAudienceEnum_ADMIN =
    const VendorMaterialsAnalyticsDetailAudienceEnum._('ADMIN');

VendorMaterialsAnalyticsDetailAudienceEnum
    _$vendorMaterialsAnalyticsDetailAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$vendorMaterialsAnalyticsDetailAudienceEnum_BUYER;
    case 'VENDOR':
      return _$vendorMaterialsAnalyticsDetailAudienceEnum_VENDOR;
    case 'ADMIN':
      return _$vendorMaterialsAnalyticsDetailAudienceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorMaterialsAnalyticsDetailAudienceEnum>
    _$vendorMaterialsAnalyticsDetailAudienceEnumValues = BuiltSet<
        VendorMaterialsAnalyticsDetailAudienceEnum>(const <VendorMaterialsAnalyticsDetailAudienceEnum>[
  _$vendorMaterialsAnalyticsDetailAudienceEnum_BUYER,
  _$vendorMaterialsAnalyticsDetailAudienceEnum_VENDOR,
  _$vendorMaterialsAnalyticsDetailAudienceEnum_ADMIN,
]);

const VendorMaterialsAnalyticsDetailSourceKindEnum
    _$vendorMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING =
    const VendorMaterialsAnalyticsDetailSourceKindEnum._('PUBLIC_LISTING');

VendorMaterialsAnalyticsDetailSourceKindEnum
    _$vendorMaterialsAnalyticsDetailSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$vendorMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorMaterialsAnalyticsDetailSourceKindEnum>
    _$vendorMaterialsAnalyticsDetailSourceKindEnumValues = BuiltSet<
        VendorMaterialsAnalyticsDetailSourceKindEnum>(const <VendorMaterialsAnalyticsDetailSourceKindEnum>[
  _$vendorMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<VendorMaterialsAnalyticsDetailAudienceEnum>
    _$vendorMaterialsAnalyticsDetailAudienceEnumSerializer =
    _$VendorMaterialsAnalyticsDetailAudienceEnumSerializer();
Serializer<VendorMaterialsAnalyticsDetailSourceKindEnum>
    _$vendorMaterialsAnalyticsDetailSourceKindEnumSerializer =
    _$VendorMaterialsAnalyticsDetailSourceKindEnumSerializer();

class _$VendorMaterialsAnalyticsDetailAudienceEnumSerializer
    implements PrimitiveSerializer<VendorMaterialsAnalyticsDetailAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorMaterialsAnalyticsDetailAudienceEnum
  ];
  @override
  final String wireName = 'VendorMaterialsAnalyticsDetailAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          VendorMaterialsAnalyticsDetailAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorMaterialsAnalyticsDetailAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorMaterialsAnalyticsDetailAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorMaterialsAnalyticsDetailSourceKindEnumSerializer
    implements
        PrimitiveSerializer<VendorMaterialsAnalyticsDetailSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorMaterialsAnalyticsDetailSourceKindEnum
  ];
  @override
  final String wireName = 'VendorMaterialsAnalyticsDetailSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          VendorMaterialsAnalyticsDetailSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorMaterialsAnalyticsDetailSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorMaterialsAnalyticsDetailSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorMaterialsAnalyticsDetail extends VendorMaterialsAnalyticsDetail {
  @override
  final VendorMaterialsAnalyticsDetailAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final VendorMaterialsAnalyticsDetailSourceKindEnum sourceKind;
  @override
  final DatasetLabel dataset;
  @override
  final AnalyticsWindow window;
  @override
  final DateTime currentAsOf;
  @override
  final AnalyticsSnapshotRef? snapshot;
  @override
  final String updateSchedule;
  @override
  final String explanation;
  @override
  final VendorMaterialsAnalyticsDetailGroup group;
  @override
  final BuiltList<ComparableVariant> variants;
  @override
  final BuiltList<VendorAnalyticsPoint> series;
  @override
  final bool canEditOwnListing;

  factory _$VendorMaterialsAnalyticsDetail(
          [void Function(VendorMaterialsAnalyticsDetailBuilder)? updates]) =>
      (VendorMaterialsAnalyticsDetailBuilder()..update(updates))._build();

  _$VendorMaterialsAnalyticsDetail._(
      {required this.audience,
      required this.scope,
      required this.sourceKind,
      required this.dataset,
      required this.window,
      required this.currentAsOf,
      this.snapshot,
      required this.updateSchedule,
      required this.explanation,
      required this.group,
      required this.variants,
      required this.series,
      required this.canEditOwnListing})
      : super._();
  @override
  VendorMaterialsAnalyticsDetail rebuild(
          void Function(VendorMaterialsAnalyticsDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorMaterialsAnalyticsDetailBuilder toBuilder() =>
      VendorMaterialsAnalyticsDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorMaterialsAnalyticsDetail &&
        audience == other.audience &&
        scope == other.scope &&
        sourceKind == other.sourceKind &&
        dataset == other.dataset &&
        window == other.window &&
        currentAsOf == other.currentAsOf &&
        snapshot == other.snapshot &&
        updateSchedule == other.updateSchedule &&
        explanation == other.explanation &&
        group == other.group &&
        variants == other.variants &&
        series == other.series &&
        canEditOwnListing == other.canEditOwnListing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, sourceKind.hashCode);
    _$hash = $jc(_$hash, dataset.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, snapshot.hashCode);
    _$hash = $jc(_$hash, updateSchedule.hashCode);
    _$hash = $jc(_$hash, explanation.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jc(_$hash, canEditOwnListing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorMaterialsAnalyticsDetail')
          ..add('audience', audience)
          ..add('scope', scope)
          ..add('sourceKind', sourceKind)
          ..add('dataset', dataset)
          ..add('window', window)
          ..add('currentAsOf', currentAsOf)
          ..add('snapshot', snapshot)
          ..add('updateSchedule', updateSchedule)
          ..add('explanation', explanation)
          ..add('group', group)
          ..add('variants', variants)
          ..add('series', series)
          ..add('canEditOwnListing', canEditOwnListing))
        .toString();
  }
}

class VendorMaterialsAnalyticsDetailBuilder
    implements
        Builder<VendorMaterialsAnalyticsDetail,
            VendorMaterialsAnalyticsDetailBuilder> {
  _$VendorMaterialsAnalyticsDetail? _$v;

  VendorMaterialsAnalyticsDetailAudienceEnum? _audience;
  VendorMaterialsAnalyticsDetailAudienceEnum? get audience => _$this._audience;
  set audience(VendorMaterialsAnalyticsDetailAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  VendorMaterialsAnalyticsDetailSourceKindEnum? _sourceKind;
  VendorMaterialsAnalyticsDetailSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(VendorMaterialsAnalyticsDetailSourceKindEnum? sourceKind) =>
      _$this._sourceKind = sourceKind;

  DatasetLabelBuilder? _dataset;
  DatasetLabelBuilder get dataset => _$this._dataset ??= DatasetLabelBuilder();
  set dataset(DatasetLabelBuilder? dataset) => _$this._dataset = dataset;

  AnalyticsWindowBuilder? _window;
  AnalyticsWindowBuilder get window =>
      _$this._window ??= AnalyticsWindowBuilder();
  set window(AnalyticsWindowBuilder? window) => _$this._window = window;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  AnalyticsSnapshotRefBuilder? _snapshot;
  AnalyticsSnapshotRefBuilder get snapshot =>
      _$this._snapshot ??= AnalyticsSnapshotRefBuilder();
  set snapshot(AnalyticsSnapshotRefBuilder? snapshot) =>
      _$this._snapshot = snapshot;

  String? _updateSchedule;
  String? get updateSchedule => _$this._updateSchedule;
  set updateSchedule(String? updateSchedule) =>
      _$this._updateSchedule = updateSchedule;

  String? _explanation;
  String? get explanation => _$this._explanation;
  set explanation(String? explanation) => _$this._explanation = explanation;

  VendorMaterialsAnalyticsDetailGroupBuilder? _group;
  VendorMaterialsAnalyticsDetailGroupBuilder get group =>
      _$this._group ??= VendorMaterialsAnalyticsDetailGroupBuilder();
  set group(VendorMaterialsAnalyticsDetailGroupBuilder? group) =>
      _$this._group = group;

  ListBuilder<ComparableVariant>? _variants;
  ListBuilder<ComparableVariant> get variants =>
      _$this._variants ??= ListBuilder<ComparableVariant>();
  set variants(ListBuilder<ComparableVariant>? variants) =>
      _$this._variants = variants;

  ListBuilder<VendorAnalyticsPoint>? _series;
  ListBuilder<VendorAnalyticsPoint> get series =>
      _$this._series ??= ListBuilder<VendorAnalyticsPoint>();
  set series(ListBuilder<VendorAnalyticsPoint>? series) =>
      _$this._series = series;

  bool? _canEditOwnListing;
  bool? get canEditOwnListing => _$this._canEditOwnListing;
  set canEditOwnListing(bool? canEditOwnListing) =>
      _$this._canEditOwnListing = canEditOwnListing;

  VendorMaterialsAnalyticsDetailBuilder() {
    VendorMaterialsAnalyticsDetail._defaults(this);
  }

  VendorMaterialsAnalyticsDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audience = $v.audience;
      _scope = $v.scope.toBuilder();
      _sourceKind = $v.sourceKind;
      _dataset = $v.dataset.toBuilder();
      _window = $v.window.toBuilder();
      _currentAsOf = $v.currentAsOf;
      _snapshot = $v.snapshot?.toBuilder();
      _updateSchedule = $v.updateSchedule;
      _explanation = $v.explanation;
      _group = $v.group.toBuilder();
      _variants = $v.variants.toBuilder();
      _series = $v.series.toBuilder();
      _canEditOwnListing = $v.canEditOwnListing;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorMaterialsAnalyticsDetail other) {
    _$v = other as _$VendorMaterialsAnalyticsDetail;
  }

  @override
  void update(void Function(VendorMaterialsAnalyticsDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorMaterialsAnalyticsDetail build() => _build();

  _$VendorMaterialsAnalyticsDetail _build() {
    _$VendorMaterialsAnalyticsDetail _$result;
    try {
      _$result = _$v ??
          _$VendorMaterialsAnalyticsDetail._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'VendorMaterialsAnalyticsDetail', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'VendorMaterialsAnalyticsDetail', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'VendorMaterialsAnalyticsDetail', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'VendorMaterialsAnalyticsDetail',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'VendorMaterialsAnalyticsDetail', 'explanation'),
            group: group.build(),
            variants: variants.build(),
            series: series.build(),
            canEditOwnListing: BuiltValueNullFieldError.checkNotNull(
                canEditOwnListing,
                r'VendorMaterialsAnalyticsDetail',
                'canEditOwnListing'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();

        _$failedField = 'dataset';
        dataset.build();
        _$failedField = 'window';
        window.build();

        _$failedField = 'snapshot';
        _snapshot?.build();

        _$failedField = 'group';
        group.build();
        _$failedField = 'variants';
        variants.build();
        _$failedField = 'series';
        series.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorMaterialsAnalyticsDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
