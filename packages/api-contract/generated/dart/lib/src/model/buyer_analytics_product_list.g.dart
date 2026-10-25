// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_product_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerAnalyticsProductListAudienceEnum
    _$buyerAnalyticsProductListAudienceEnum_BUYER =
    const BuyerAnalyticsProductListAudienceEnum._('BUYER');

BuyerAnalyticsProductListAudienceEnum
    _$buyerAnalyticsProductListAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$buyerAnalyticsProductListAudienceEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAnalyticsProductListAudienceEnum>
    _$buyerAnalyticsProductListAudienceEnumValues = BuiltSet<
        BuyerAnalyticsProductListAudienceEnum>(const <BuyerAnalyticsProductListAudienceEnum>[
  _$buyerAnalyticsProductListAudienceEnum_BUYER,
]);

const BuyerAnalyticsProductListSourceKindEnum
    _$buyerAnalyticsProductListSourceKindEnum_PUBLIC_LISTING =
    const BuyerAnalyticsProductListSourceKindEnum._('PUBLIC_LISTING');

BuyerAnalyticsProductListSourceKindEnum
    _$buyerAnalyticsProductListSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$buyerAnalyticsProductListSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAnalyticsProductListSourceKindEnum>
    _$buyerAnalyticsProductListSourceKindEnumValues = BuiltSet<
        BuyerAnalyticsProductListSourceKindEnum>(const <BuyerAnalyticsProductListSourceKindEnum>[
  _$buyerAnalyticsProductListSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<BuyerAnalyticsProductListAudienceEnum>
    _$buyerAnalyticsProductListAudienceEnumSerializer =
    _$BuyerAnalyticsProductListAudienceEnumSerializer();
Serializer<BuyerAnalyticsProductListSourceKindEnum>
    _$buyerAnalyticsProductListSourceKindEnumSerializer =
    _$BuyerAnalyticsProductListSourceKindEnumSerializer();

class _$BuyerAnalyticsProductListAudienceEnumSerializer
    implements PrimitiveSerializer<BuyerAnalyticsProductListAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerAnalyticsProductListAudienceEnum
  ];
  @override
  final String wireName = 'BuyerAnalyticsProductListAudienceEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerAnalyticsProductListAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAnalyticsProductListAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAnalyticsProductListAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAnalyticsProductListSourceKindEnumSerializer
    implements PrimitiveSerializer<BuyerAnalyticsProductListSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerAnalyticsProductListSourceKindEnum
  ];
  @override
  final String wireName = 'BuyerAnalyticsProductListSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerAnalyticsProductListSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAnalyticsProductListSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAnalyticsProductListSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAnalyticsProductList extends BuyerAnalyticsProductList {
  @override
  final BuyerAnalyticsProductListAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final BuyerAnalyticsProductListSourceKindEnum sourceKind;
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
  final BuiltList<BuyerAnalyticsCategorySummary> categories;
  @override
  final BuiltList<BuyerAnalyticsProductRow> items;
  @override
  final String? nextCursor;
  @override
  final int notYetComparableListings;

  factory _$BuyerAnalyticsProductList(
          [void Function(BuyerAnalyticsProductListBuilder)? updates]) =>
      (BuyerAnalyticsProductListBuilder()..update(updates))._build();

  _$BuyerAnalyticsProductList._(
      {required this.audience,
      required this.scope,
      required this.sourceKind,
      required this.dataset,
      required this.window,
      required this.currentAsOf,
      this.snapshot,
      required this.updateSchedule,
      required this.explanation,
      required this.categories,
      required this.items,
      this.nextCursor,
      required this.notYetComparableListings})
      : super._();
  @override
  BuyerAnalyticsProductList rebuild(
          void Function(BuyerAnalyticsProductListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsProductListBuilder toBuilder() =>
      BuyerAnalyticsProductListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsProductList &&
        audience == other.audience &&
        scope == other.scope &&
        sourceKind == other.sourceKind &&
        dataset == other.dataset &&
        window == other.window &&
        currentAsOf == other.currentAsOf &&
        snapshot == other.snapshot &&
        updateSchedule == other.updateSchedule &&
        explanation == other.explanation &&
        categories == other.categories &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        notYetComparableListings == other.notYetComparableListings;
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
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, notYetComparableListings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsProductList')
          ..add('audience', audience)
          ..add('scope', scope)
          ..add('sourceKind', sourceKind)
          ..add('dataset', dataset)
          ..add('window', window)
          ..add('currentAsOf', currentAsOf)
          ..add('snapshot', snapshot)
          ..add('updateSchedule', updateSchedule)
          ..add('explanation', explanation)
          ..add('categories', categories)
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('notYetComparableListings', notYetComparableListings))
        .toString();
  }
}

class BuyerAnalyticsProductListBuilder
    implements
        Builder<BuyerAnalyticsProductList, BuyerAnalyticsProductListBuilder> {
  _$BuyerAnalyticsProductList? _$v;

  BuyerAnalyticsProductListAudienceEnum? _audience;
  BuyerAnalyticsProductListAudienceEnum? get audience => _$this._audience;
  set audience(BuyerAnalyticsProductListAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  BuyerAnalyticsProductListSourceKindEnum? _sourceKind;
  BuyerAnalyticsProductListSourceKindEnum? get sourceKind => _$this._sourceKind;
  set sourceKind(BuyerAnalyticsProductListSourceKindEnum? sourceKind) =>
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

  ListBuilder<BuyerAnalyticsCategorySummary>? _categories;
  ListBuilder<BuyerAnalyticsCategorySummary> get categories =>
      _$this._categories ??= ListBuilder<BuyerAnalyticsCategorySummary>();
  set categories(ListBuilder<BuyerAnalyticsCategorySummary>? categories) =>
      _$this._categories = categories;

  ListBuilder<BuyerAnalyticsProductRow>? _items;
  ListBuilder<BuyerAnalyticsProductRow> get items =>
      _$this._items ??= ListBuilder<BuyerAnalyticsProductRow>();
  set items(ListBuilder<BuyerAnalyticsProductRow>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _notYetComparableListings;
  int? get notYetComparableListings => _$this._notYetComparableListings;
  set notYetComparableListings(int? notYetComparableListings) =>
      _$this._notYetComparableListings = notYetComparableListings;

  BuyerAnalyticsProductListBuilder() {
    BuyerAnalyticsProductList._defaults(this);
  }

  BuyerAnalyticsProductListBuilder get _$this {
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
      _categories = $v.categories.toBuilder();
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _notYetComparableListings = $v.notYetComparableListings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAnalyticsProductList other) {
    _$v = other as _$BuyerAnalyticsProductList;
  }

  @override
  void update(void Function(BuyerAnalyticsProductListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsProductList build() => _build();

  _$BuyerAnalyticsProductList _build() {
    _$BuyerAnalyticsProductList _$result;
    try {
      _$result = _$v ??
          _$BuyerAnalyticsProductList._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'BuyerAnalyticsProductList', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'BuyerAnalyticsProductList', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'BuyerAnalyticsProductList', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule, r'BuyerAnalyticsProductList', 'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'BuyerAnalyticsProductList', 'explanation'),
            categories: categories.build(),
            items: items.build(),
            nextCursor: nextCursor,
            notYetComparableListings: BuiltValueNullFieldError.checkNotNull(
                notYetComparableListings,
                r'BuyerAnalyticsProductList',
                'notYetComparableListings'),
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

        _$failedField = 'categories';
        categories.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerAnalyticsProductList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
