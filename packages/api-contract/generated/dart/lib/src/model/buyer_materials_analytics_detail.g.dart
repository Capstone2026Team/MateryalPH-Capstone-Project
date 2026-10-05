// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_materials_analytics_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerMaterialsAnalyticsDetailAudienceEnum
    _$buyerMaterialsAnalyticsDetailAudienceEnum_BUYER =
    const BuyerMaterialsAnalyticsDetailAudienceEnum._('BUYER');
const BuyerMaterialsAnalyticsDetailAudienceEnum
    _$buyerMaterialsAnalyticsDetailAudienceEnum_VENDOR =
    const BuyerMaterialsAnalyticsDetailAudienceEnum._('VENDOR');
const BuyerMaterialsAnalyticsDetailAudienceEnum
    _$buyerMaterialsAnalyticsDetailAudienceEnum_ADMIN =
    const BuyerMaterialsAnalyticsDetailAudienceEnum._('ADMIN');

BuyerMaterialsAnalyticsDetailAudienceEnum
    _$buyerMaterialsAnalyticsDetailAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$buyerMaterialsAnalyticsDetailAudienceEnum_BUYER;
    case 'VENDOR':
      return _$buyerMaterialsAnalyticsDetailAudienceEnum_VENDOR;
    case 'ADMIN':
      return _$buyerMaterialsAnalyticsDetailAudienceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMaterialsAnalyticsDetailAudienceEnum>
    _$buyerMaterialsAnalyticsDetailAudienceEnumValues = BuiltSet<
        BuyerMaterialsAnalyticsDetailAudienceEnum>(const <BuyerMaterialsAnalyticsDetailAudienceEnum>[
  _$buyerMaterialsAnalyticsDetailAudienceEnum_BUYER,
  _$buyerMaterialsAnalyticsDetailAudienceEnum_VENDOR,
  _$buyerMaterialsAnalyticsDetailAudienceEnum_ADMIN,
]);

const BuyerMaterialsAnalyticsDetailSourceKindEnum
    _$buyerMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING =
    const BuyerMaterialsAnalyticsDetailSourceKindEnum._('PUBLIC_LISTING');

BuyerMaterialsAnalyticsDetailSourceKindEnum
    _$buyerMaterialsAnalyticsDetailSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$buyerMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMaterialsAnalyticsDetailSourceKindEnum>
    _$buyerMaterialsAnalyticsDetailSourceKindEnumValues = BuiltSet<
        BuyerMaterialsAnalyticsDetailSourceKindEnum>(const <BuyerMaterialsAnalyticsDetailSourceKindEnum>[
  _$buyerMaterialsAnalyticsDetailSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<BuyerMaterialsAnalyticsDetailAudienceEnum>
    _$buyerMaterialsAnalyticsDetailAudienceEnumSerializer =
    _$BuyerMaterialsAnalyticsDetailAudienceEnumSerializer();
Serializer<BuyerMaterialsAnalyticsDetailSourceKindEnum>
    _$buyerMaterialsAnalyticsDetailSourceKindEnumSerializer =
    _$BuyerMaterialsAnalyticsDetailSourceKindEnumSerializer();

class _$BuyerMaterialsAnalyticsDetailAudienceEnumSerializer
    implements PrimitiveSerializer<BuyerMaterialsAnalyticsDetailAudienceEnum> {
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
    BuyerMaterialsAnalyticsDetailAudienceEnum
  ];
  @override
  final String wireName = 'BuyerMaterialsAnalyticsDetailAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMaterialsAnalyticsDetailAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMaterialsAnalyticsDetailAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMaterialsAnalyticsDetailAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMaterialsAnalyticsDetailSourceKindEnumSerializer
    implements
        PrimitiveSerializer<BuyerMaterialsAnalyticsDetailSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerMaterialsAnalyticsDetailSourceKindEnum
  ];
  @override
  final String wireName = 'BuyerMaterialsAnalyticsDetailSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMaterialsAnalyticsDetailSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMaterialsAnalyticsDetailSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMaterialsAnalyticsDetailSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMaterialsAnalyticsDetail extends BuyerMaterialsAnalyticsDetail {
  @override
  final BuyerMaterialsAnalyticsDetailAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final BuyerMaterialsAnalyticsDetailSourceKindEnum sourceKind;
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
  final BuyerMaterialsAnalyticsDetailGroup group;
  @override
  final BuiltList<ComparableVariant> variants;
  @override
  final BuiltList<BuyerAnalyticsPoint> series;

  factory _$BuyerMaterialsAnalyticsDetail(
          [void Function(BuyerMaterialsAnalyticsDetailBuilder)? updates]) =>
      (BuyerMaterialsAnalyticsDetailBuilder()..update(updates))._build();

  _$BuyerMaterialsAnalyticsDetail._(
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
      required this.series})
      : super._();
  @override
  BuyerMaterialsAnalyticsDetail rebuild(
          void Function(BuyerMaterialsAnalyticsDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMaterialsAnalyticsDetailBuilder toBuilder() =>
      BuyerMaterialsAnalyticsDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMaterialsAnalyticsDetail &&
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
        series == other.series;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMaterialsAnalyticsDetail')
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
          ..add('series', series))
        .toString();
  }
}

class BuyerMaterialsAnalyticsDetailBuilder
    implements
        Builder<BuyerMaterialsAnalyticsDetail,
            BuyerMaterialsAnalyticsDetailBuilder> {
  _$BuyerMaterialsAnalyticsDetail? _$v;

  BuyerMaterialsAnalyticsDetailAudienceEnum? _audience;
  BuyerMaterialsAnalyticsDetailAudienceEnum? get audience => _$this._audience;
  set audience(BuyerMaterialsAnalyticsDetailAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  BuyerMaterialsAnalyticsDetailSourceKindEnum? _sourceKind;
  BuyerMaterialsAnalyticsDetailSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(BuyerMaterialsAnalyticsDetailSourceKindEnum? sourceKind) =>
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

  BuyerMaterialsAnalyticsDetailGroupBuilder? _group;
  BuyerMaterialsAnalyticsDetailGroupBuilder get group =>
      _$this._group ??= BuyerMaterialsAnalyticsDetailGroupBuilder();
  set group(BuyerMaterialsAnalyticsDetailGroupBuilder? group) =>
      _$this._group = group;

  ListBuilder<ComparableVariant>? _variants;
  ListBuilder<ComparableVariant> get variants =>
      _$this._variants ??= ListBuilder<ComparableVariant>();
  set variants(ListBuilder<ComparableVariant>? variants) =>
      _$this._variants = variants;

  ListBuilder<BuyerAnalyticsPoint>? _series;
  ListBuilder<BuyerAnalyticsPoint> get series =>
      _$this._series ??= ListBuilder<BuyerAnalyticsPoint>();
  set series(ListBuilder<BuyerAnalyticsPoint>? series) =>
      _$this._series = series;

  BuyerMaterialsAnalyticsDetailBuilder() {
    BuyerMaterialsAnalyticsDetail._defaults(this);
  }

  BuyerMaterialsAnalyticsDetailBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMaterialsAnalyticsDetail other) {
    _$v = other as _$BuyerMaterialsAnalyticsDetail;
  }

  @override
  void update(void Function(BuyerMaterialsAnalyticsDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMaterialsAnalyticsDetail build() => _build();

  _$BuyerMaterialsAnalyticsDetail _build() {
    _$BuyerMaterialsAnalyticsDetail _$result;
    try {
      _$result = _$v ??
          _$BuyerMaterialsAnalyticsDetail._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'BuyerMaterialsAnalyticsDetail', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'BuyerMaterialsAnalyticsDetail', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'BuyerMaterialsAnalyticsDetail', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'BuyerMaterialsAnalyticsDetail',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'BuyerMaterialsAnalyticsDetail', 'explanation'),
            group: group.build(),
            variants: variants.build(),
            series: series.build(),
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
            r'BuyerMaterialsAnalyticsDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
