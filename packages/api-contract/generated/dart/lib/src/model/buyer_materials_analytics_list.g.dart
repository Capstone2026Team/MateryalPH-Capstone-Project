// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_materials_analytics_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerMaterialsAnalyticsListAudienceEnum
    _$buyerMaterialsAnalyticsListAudienceEnum_BUYER =
    const BuyerMaterialsAnalyticsListAudienceEnum._('BUYER');
const BuyerMaterialsAnalyticsListAudienceEnum
    _$buyerMaterialsAnalyticsListAudienceEnum_VENDOR =
    const BuyerMaterialsAnalyticsListAudienceEnum._('VENDOR');
const BuyerMaterialsAnalyticsListAudienceEnum
    _$buyerMaterialsAnalyticsListAudienceEnum_ADMIN =
    const BuyerMaterialsAnalyticsListAudienceEnum._('ADMIN');

BuyerMaterialsAnalyticsListAudienceEnum
    _$buyerMaterialsAnalyticsListAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$buyerMaterialsAnalyticsListAudienceEnum_BUYER;
    case 'VENDOR':
      return _$buyerMaterialsAnalyticsListAudienceEnum_VENDOR;
    case 'ADMIN':
      return _$buyerMaterialsAnalyticsListAudienceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMaterialsAnalyticsListAudienceEnum>
    _$buyerMaterialsAnalyticsListAudienceEnumValues = BuiltSet<
        BuyerMaterialsAnalyticsListAudienceEnum>(const <BuyerMaterialsAnalyticsListAudienceEnum>[
  _$buyerMaterialsAnalyticsListAudienceEnum_BUYER,
  _$buyerMaterialsAnalyticsListAudienceEnum_VENDOR,
  _$buyerMaterialsAnalyticsListAudienceEnum_ADMIN,
]);

const BuyerMaterialsAnalyticsListSourceKindEnum
    _$buyerMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING =
    const BuyerMaterialsAnalyticsListSourceKindEnum._('PUBLIC_LISTING');

BuyerMaterialsAnalyticsListSourceKindEnum
    _$buyerMaterialsAnalyticsListSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$buyerMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMaterialsAnalyticsListSourceKindEnum>
    _$buyerMaterialsAnalyticsListSourceKindEnumValues = BuiltSet<
        BuyerMaterialsAnalyticsListSourceKindEnum>(const <BuyerMaterialsAnalyticsListSourceKindEnum>[
  _$buyerMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<BuyerMaterialsAnalyticsListAudienceEnum>
    _$buyerMaterialsAnalyticsListAudienceEnumSerializer =
    _$BuyerMaterialsAnalyticsListAudienceEnumSerializer();
Serializer<BuyerMaterialsAnalyticsListSourceKindEnum>
    _$buyerMaterialsAnalyticsListSourceKindEnumSerializer =
    _$BuyerMaterialsAnalyticsListSourceKindEnumSerializer();

class _$BuyerMaterialsAnalyticsListAudienceEnumSerializer
    implements PrimitiveSerializer<BuyerMaterialsAnalyticsListAudienceEnum> {
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
    BuyerMaterialsAnalyticsListAudienceEnum
  ];
  @override
  final String wireName = 'BuyerMaterialsAnalyticsListAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMaterialsAnalyticsListAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMaterialsAnalyticsListAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMaterialsAnalyticsListAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMaterialsAnalyticsListSourceKindEnumSerializer
    implements PrimitiveSerializer<BuyerMaterialsAnalyticsListSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerMaterialsAnalyticsListSourceKindEnum
  ];
  @override
  final String wireName = 'BuyerMaterialsAnalyticsListSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMaterialsAnalyticsListSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMaterialsAnalyticsListSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMaterialsAnalyticsListSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMaterialsAnalyticsList extends BuyerMaterialsAnalyticsList {
  @override
  final BuyerMaterialsAnalyticsListAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final BuyerMaterialsAnalyticsListSourceKindEnum sourceKind;
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
  final BuiltList<BuyerAnalyticsRow> items;
  @override
  final String? nextCursor;

  factory _$BuyerMaterialsAnalyticsList(
          [void Function(BuyerMaterialsAnalyticsListBuilder)? updates]) =>
      (BuyerMaterialsAnalyticsListBuilder()..update(updates))._build();

  _$BuyerMaterialsAnalyticsList._(
      {required this.audience,
      required this.scope,
      required this.sourceKind,
      required this.dataset,
      required this.window,
      required this.currentAsOf,
      this.snapshot,
      required this.updateSchedule,
      required this.explanation,
      required this.items,
      this.nextCursor})
      : super._();
  @override
  BuyerMaterialsAnalyticsList rebuild(
          void Function(BuyerMaterialsAnalyticsListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMaterialsAnalyticsListBuilder toBuilder() =>
      BuyerMaterialsAnalyticsListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMaterialsAnalyticsList &&
        audience == other.audience &&
        scope == other.scope &&
        sourceKind == other.sourceKind &&
        dataset == other.dataset &&
        window == other.window &&
        currentAsOf == other.currentAsOf &&
        snapshot == other.snapshot &&
        updateSchedule == other.updateSchedule &&
        explanation == other.explanation &&
        items == other.items &&
        nextCursor == other.nextCursor;
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
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMaterialsAnalyticsList')
          ..add('audience', audience)
          ..add('scope', scope)
          ..add('sourceKind', sourceKind)
          ..add('dataset', dataset)
          ..add('window', window)
          ..add('currentAsOf', currentAsOf)
          ..add('snapshot', snapshot)
          ..add('updateSchedule', updateSchedule)
          ..add('explanation', explanation)
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class BuyerMaterialsAnalyticsListBuilder
    implements
        Builder<BuyerMaterialsAnalyticsList,
            BuyerMaterialsAnalyticsListBuilder> {
  _$BuyerMaterialsAnalyticsList? _$v;

  BuyerMaterialsAnalyticsListAudienceEnum? _audience;
  BuyerMaterialsAnalyticsListAudienceEnum? get audience => _$this._audience;
  set audience(BuyerMaterialsAnalyticsListAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  BuyerMaterialsAnalyticsListSourceKindEnum? _sourceKind;
  BuyerMaterialsAnalyticsListSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(BuyerMaterialsAnalyticsListSourceKindEnum? sourceKind) =>
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

  ListBuilder<BuyerAnalyticsRow>? _items;
  ListBuilder<BuyerAnalyticsRow> get items =>
      _$this._items ??= ListBuilder<BuyerAnalyticsRow>();
  set items(ListBuilder<BuyerAnalyticsRow>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  BuyerMaterialsAnalyticsListBuilder() {
    BuyerMaterialsAnalyticsList._defaults(this);
  }

  BuyerMaterialsAnalyticsListBuilder get _$this {
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
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMaterialsAnalyticsList other) {
    _$v = other as _$BuyerMaterialsAnalyticsList;
  }

  @override
  void update(void Function(BuyerMaterialsAnalyticsListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMaterialsAnalyticsList build() => _build();

  _$BuyerMaterialsAnalyticsList _build() {
    _$BuyerMaterialsAnalyticsList _$result;
    try {
      _$result = _$v ??
          _$BuyerMaterialsAnalyticsList._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'BuyerMaterialsAnalyticsList', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'BuyerMaterialsAnalyticsList', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'BuyerMaterialsAnalyticsList', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'BuyerMaterialsAnalyticsList',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'BuyerMaterialsAnalyticsList', 'explanation'),
            items: items.build(),
            nextCursor: nextCursor,
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

        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerMaterialsAnalyticsList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
