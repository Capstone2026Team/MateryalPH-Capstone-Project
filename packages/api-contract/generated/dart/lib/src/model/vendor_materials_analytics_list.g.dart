// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_materials_analytics_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorMaterialsAnalyticsListAudienceEnum
    _$vendorMaterialsAnalyticsListAudienceEnum_BUYER =
    const VendorMaterialsAnalyticsListAudienceEnum._('BUYER');
const VendorMaterialsAnalyticsListAudienceEnum
    _$vendorMaterialsAnalyticsListAudienceEnum_VENDOR =
    const VendorMaterialsAnalyticsListAudienceEnum._('VENDOR');
const VendorMaterialsAnalyticsListAudienceEnum
    _$vendorMaterialsAnalyticsListAudienceEnum_ADMIN =
    const VendorMaterialsAnalyticsListAudienceEnum._('ADMIN');

VendorMaterialsAnalyticsListAudienceEnum
    _$vendorMaterialsAnalyticsListAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$vendorMaterialsAnalyticsListAudienceEnum_BUYER;
    case 'VENDOR':
      return _$vendorMaterialsAnalyticsListAudienceEnum_VENDOR;
    case 'ADMIN':
      return _$vendorMaterialsAnalyticsListAudienceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorMaterialsAnalyticsListAudienceEnum>
    _$vendorMaterialsAnalyticsListAudienceEnumValues = BuiltSet<
        VendorMaterialsAnalyticsListAudienceEnum>(const <VendorMaterialsAnalyticsListAudienceEnum>[
  _$vendorMaterialsAnalyticsListAudienceEnum_BUYER,
  _$vendorMaterialsAnalyticsListAudienceEnum_VENDOR,
  _$vendorMaterialsAnalyticsListAudienceEnum_ADMIN,
]);

const VendorMaterialsAnalyticsListSourceKindEnum
    _$vendorMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING =
    const VendorMaterialsAnalyticsListSourceKindEnum._('PUBLIC_LISTING');

VendorMaterialsAnalyticsListSourceKindEnum
    _$vendorMaterialsAnalyticsListSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$vendorMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorMaterialsAnalyticsListSourceKindEnum>
    _$vendorMaterialsAnalyticsListSourceKindEnumValues = BuiltSet<
        VendorMaterialsAnalyticsListSourceKindEnum>(const <VendorMaterialsAnalyticsListSourceKindEnum>[
  _$vendorMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<VendorMaterialsAnalyticsListAudienceEnum>
    _$vendorMaterialsAnalyticsListAudienceEnumSerializer =
    _$VendorMaterialsAnalyticsListAudienceEnumSerializer();
Serializer<VendorMaterialsAnalyticsListSourceKindEnum>
    _$vendorMaterialsAnalyticsListSourceKindEnumSerializer =
    _$VendorMaterialsAnalyticsListSourceKindEnumSerializer();

class _$VendorMaterialsAnalyticsListAudienceEnumSerializer
    implements PrimitiveSerializer<VendorMaterialsAnalyticsListAudienceEnum> {
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
    VendorMaterialsAnalyticsListAudienceEnum
  ];
  @override
  final String wireName = 'VendorMaterialsAnalyticsListAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          VendorMaterialsAnalyticsListAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorMaterialsAnalyticsListAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorMaterialsAnalyticsListAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorMaterialsAnalyticsListSourceKindEnumSerializer
    implements PrimitiveSerializer<VendorMaterialsAnalyticsListSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorMaterialsAnalyticsListSourceKindEnum
  ];
  @override
  final String wireName = 'VendorMaterialsAnalyticsListSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          VendorMaterialsAnalyticsListSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorMaterialsAnalyticsListSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorMaterialsAnalyticsListSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorMaterialsAnalyticsList extends VendorMaterialsAnalyticsList {
  @override
  final VendorMaterialsAnalyticsListAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final VendorMaterialsAnalyticsListSourceKindEnum sourceKind;
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
  final BuiltList<VendorAnalyticsRow> items;
  @override
  final String? nextCursor;

  factory _$VendorMaterialsAnalyticsList(
          [void Function(VendorMaterialsAnalyticsListBuilder)? updates]) =>
      (VendorMaterialsAnalyticsListBuilder()..update(updates))._build();

  _$VendorMaterialsAnalyticsList._(
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
  VendorMaterialsAnalyticsList rebuild(
          void Function(VendorMaterialsAnalyticsListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorMaterialsAnalyticsListBuilder toBuilder() =>
      VendorMaterialsAnalyticsListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorMaterialsAnalyticsList &&
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
    return (newBuiltValueToStringHelper(r'VendorMaterialsAnalyticsList')
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

class VendorMaterialsAnalyticsListBuilder
    implements
        Builder<VendorMaterialsAnalyticsList,
            VendorMaterialsAnalyticsListBuilder> {
  _$VendorMaterialsAnalyticsList? _$v;

  VendorMaterialsAnalyticsListAudienceEnum? _audience;
  VendorMaterialsAnalyticsListAudienceEnum? get audience => _$this._audience;
  set audience(VendorMaterialsAnalyticsListAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  VendorMaterialsAnalyticsListSourceKindEnum? _sourceKind;
  VendorMaterialsAnalyticsListSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(VendorMaterialsAnalyticsListSourceKindEnum? sourceKind) =>
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

  ListBuilder<VendorAnalyticsRow>? _items;
  ListBuilder<VendorAnalyticsRow> get items =>
      _$this._items ??= ListBuilder<VendorAnalyticsRow>();
  set items(ListBuilder<VendorAnalyticsRow>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  VendorMaterialsAnalyticsListBuilder() {
    VendorMaterialsAnalyticsList._defaults(this);
  }

  VendorMaterialsAnalyticsListBuilder get _$this {
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
  void replace(VendorMaterialsAnalyticsList other) {
    _$v = other as _$VendorMaterialsAnalyticsList;
  }

  @override
  void update(void Function(VendorMaterialsAnalyticsListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorMaterialsAnalyticsList build() => _build();

  _$VendorMaterialsAnalyticsList _build() {
    _$VendorMaterialsAnalyticsList _$result;
    try {
      _$result = _$v ??
          _$VendorMaterialsAnalyticsList._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'VendorMaterialsAnalyticsList', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'VendorMaterialsAnalyticsList', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'VendorMaterialsAnalyticsList', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'VendorMaterialsAnalyticsList',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'VendorMaterialsAnalyticsList', 'explanation'),
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
            r'VendorMaterialsAnalyticsList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
