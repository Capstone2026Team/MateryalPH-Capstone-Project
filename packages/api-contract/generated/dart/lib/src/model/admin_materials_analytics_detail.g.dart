// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_materials_analytics_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMaterialsAnalyticsDetailAudienceEnum
    _$adminMaterialsAnalyticsDetailAudienceEnum_BUYER =
    const AdminMaterialsAnalyticsDetailAudienceEnum._('BUYER');
const AdminMaterialsAnalyticsDetailAudienceEnum
    _$adminMaterialsAnalyticsDetailAudienceEnum_VENDOR =
    const AdminMaterialsAnalyticsDetailAudienceEnum._('VENDOR');
const AdminMaterialsAnalyticsDetailAudienceEnum
    _$adminMaterialsAnalyticsDetailAudienceEnum_ADMIN =
    const AdminMaterialsAnalyticsDetailAudienceEnum._('ADMIN');

AdminMaterialsAnalyticsDetailAudienceEnum
    _$adminMaterialsAnalyticsDetailAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$adminMaterialsAnalyticsDetailAudienceEnum_BUYER;
    case 'VENDOR':
      return _$adminMaterialsAnalyticsDetailAudienceEnum_VENDOR;
    case 'ADMIN':
      return _$adminMaterialsAnalyticsDetailAudienceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMaterialsAnalyticsDetailAudienceEnum>
    _$adminMaterialsAnalyticsDetailAudienceEnumValues = BuiltSet<
        AdminMaterialsAnalyticsDetailAudienceEnum>(const <AdminMaterialsAnalyticsDetailAudienceEnum>[
  _$adminMaterialsAnalyticsDetailAudienceEnum_BUYER,
  _$adminMaterialsAnalyticsDetailAudienceEnum_VENDOR,
  _$adminMaterialsAnalyticsDetailAudienceEnum_ADMIN,
]);

const AdminMaterialsAnalyticsDetailSourceKindEnum
    _$adminMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING =
    const AdminMaterialsAnalyticsDetailSourceKindEnum._('PUBLIC_LISTING');

AdminMaterialsAnalyticsDetailSourceKindEnum
    _$adminMaterialsAnalyticsDetailSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$adminMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMaterialsAnalyticsDetailSourceKindEnum>
    _$adminMaterialsAnalyticsDetailSourceKindEnumValues = BuiltSet<
        AdminMaterialsAnalyticsDetailSourceKindEnum>(const <AdminMaterialsAnalyticsDetailSourceKindEnum>[
  _$adminMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<AdminMaterialsAnalyticsDetailAudienceEnum>
    _$adminMaterialsAnalyticsDetailAudienceEnumSerializer =
    _$AdminMaterialsAnalyticsDetailAudienceEnumSerializer();
Serializer<AdminMaterialsAnalyticsDetailSourceKindEnum>
    _$adminMaterialsAnalyticsDetailSourceKindEnumSerializer =
    _$AdminMaterialsAnalyticsDetailSourceKindEnumSerializer();

class _$AdminMaterialsAnalyticsDetailAudienceEnumSerializer
    implements PrimitiveSerializer<AdminMaterialsAnalyticsDetailAudienceEnum> {
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
    AdminMaterialsAnalyticsDetailAudienceEnum
  ];
  @override
  final String wireName = 'AdminMaterialsAnalyticsDetailAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          AdminMaterialsAnalyticsDetailAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminMaterialsAnalyticsDetailAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminMaterialsAnalyticsDetailAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminMaterialsAnalyticsDetailSourceKindEnumSerializer
    implements
        PrimitiveSerializer<AdminMaterialsAnalyticsDetailSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminMaterialsAnalyticsDetailSourceKindEnum
  ];
  @override
  final String wireName = 'AdminMaterialsAnalyticsDetailSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          AdminMaterialsAnalyticsDetailSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminMaterialsAnalyticsDetailSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminMaterialsAnalyticsDetailSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminMaterialsAnalyticsDetail extends AdminMaterialsAnalyticsDetail {
  @override
  final AdminMaterialsAnalyticsDetailAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final AdminMaterialsAnalyticsDetailSourceKindEnum sourceKind;
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
  final AdminMaterialsAnalyticsDetailGroup group;
  @override
  final BuiltList<ComparableVariant> variants;
  @override
  final BuiltList<AdminAnalyticsPoint> series;
  @override
  final bool canInspectSources;

  factory _$AdminMaterialsAnalyticsDetail(
          [void Function(AdminMaterialsAnalyticsDetailBuilder)? updates]) =>
      (AdminMaterialsAnalyticsDetailBuilder()..update(updates))._build();

  _$AdminMaterialsAnalyticsDetail._(
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
      required this.canInspectSources})
      : super._();
  @override
  AdminMaterialsAnalyticsDetail rebuild(
          void Function(AdminMaterialsAnalyticsDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMaterialsAnalyticsDetailBuilder toBuilder() =>
      AdminMaterialsAnalyticsDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMaterialsAnalyticsDetail &&
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
        canInspectSources == other.canInspectSources;
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
    _$hash = $jc(_$hash, canInspectSources.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMaterialsAnalyticsDetail')
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
          ..add('canInspectSources', canInspectSources))
        .toString();
  }
}

class AdminMaterialsAnalyticsDetailBuilder
    implements
        Builder<AdminMaterialsAnalyticsDetail,
            AdminMaterialsAnalyticsDetailBuilder> {
  _$AdminMaterialsAnalyticsDetail? _$v;

  AdminMaterialsAnalyticsDetailAudienceEnum? _audience;
  AdminMaterialsAnalyticsDetailAudienceEnum? get audience => _$this._audience;
  set audience(AdminMaterialsAnalyticsDetailAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  AdminMaterialsAnalyticsDetailSourceKindEnum? _sourceKind;
  AdminMaterialsAnalyticsDetailSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(AdminMaterialsAnalyticsDetailSourceKindEnum? sourceKind) =>
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

  AdminMaterialsAnalyticsDetailGroupBuilder? _group;
  AdminMaterialsAnalyticsDetailGroupBuilder get group =>
      _$this._group ??= AdminMaterialsAnalyticsDetailGroupBuilder();
  set group(AdminMaterialsAnalyticsDetailGroupBuilder? group) =>
      _$this._group = group;

  ListBuilder<ComparableVariant>? _variants;
  ListBuilder<ComparableVariant> get variants =>
      _$this._variants ??= ListBuilder<ComparableVariant>();
  set variants(ListBuilder<ComparableVariant>? variants) =>
      _$this._variants = variants;

  ListBuilder<AdminAnalyticsPoint>? _series;
  ListBuilder<AdminAnalyticsPoint> get series =>
      _$this._series ??= ListBuilder<AdminAnalyticsPoint>();
  set series(ListBuilder<AdminAnalyticsPoint>? series) =>
      _$this._series = series;

  bool? _canInspectSources;
  bool? get canInspectSources => _$this._canInspectSources;
  set canInspectSources(bool? canInspectSources) =>
      _$this._canInspectSources = canInspectSources;

  AdminMaterialsAnalyticsDetailBuilder() {
    AdminMaterialsAnalyticsDetail._defaults(this);
  }

  AdminMaterialsAnalyticsDetailBuilder get _$this {
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
      _canInspectSources = $v.canInspectSources;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMaterialsAnalyticsDetail other) {
    _$v = other as _$AdminMaterialsAnalyticsDetail;
  }

  @override
  void update(void Function(AdminMaterialsAnalyticsDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMaterialsAnalyticsDetail build() => _build();

  _$AdminMaterialsAnalyticsDetail _build() {
    _$AdminMaterialsAnalyticsDetail _$result;
    try {
      _$result = _$v ??
          _$AdminMaterialsAnalyticsDetail._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'AdminMaterialsAnalyticsDetail', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'AdminMaterialsAnalyticsDetail', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'AdminMaterialsAnalyticsDetail', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'AdminMaterialsAnalyticsDetail',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'AdminMaterialsAnalyticsDetail', 'explanation'),
            group: group.build(),
            variants: variants.build(),
            series: series.build(),
            canInspectSources: BuiltValueNullFieldError.checkNotNull(
                canInspectSources,
                r'AdminMaterialsAnalyticsDetail',
                'canInspectSources'),
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
            r'AdminMaterialsAnalyticsDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
