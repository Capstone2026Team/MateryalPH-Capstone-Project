// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_materials_analytics_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMaterialsAnalyticsListAudienceEnum
    _$adminMaterialsAnalyticsListAudienceEnum_BUYER =
    const AdminMaterialsAnalyticsListAudienceEnum._('BUYER');
const AdminMaterialsAnalyticsListAudienceEnum
    _$adminMaterialsAnalyticsListAudienceEnum_VENDOR =
    const AdminMaterialsAnalyticsListAudienceEnum._('VENDOR');
const AdminMaterialsAnalyticsListAudienceEnum
    _$adminMaterialsAnalyticsListAudienceEnum_ADMIN =
    const AdminMaterialsAnalyticsListAudienceEnum._('ADMIN');

AdminMaterialsAnalyticsListAudienceEnum
    _$adminMaterialsAnalyticsListAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$adminMaterialsAnalyticsListAudienceEnum_BUYER;
    case 'VENDOR':
      return _$adminMaterialsAnalyticsListAudienceEnum_VENDOR;
    case 'ADMIN':
      return _$adminMaterialsAnalyticsListAudienceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMaterialsAnalyticsListAudienceEnum>
    _$adminMaterialsAnalyticsListAudienceEnumValues = BuiltSet<
        AdminMaterialsAnalyticsListAudienceEnum>(const <AdminMaterialsAnalyticsListAudienceEnum>[
  _$adminMaterialsAnalyticsListAudienceEnum_BUYER,
  _$adminMaterialsAnalyticsListAudienceEnum_VENDOR,
  _$adminMaterialsAnalyticsListAudienceEnum_ADMIN,
]);

const AdminMaterialsAnalyticsListSourceKindEnum
    _$adminMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING =
    const AdminMaterialsAnalyticsListSourceKindEnum._('PUBLIC_LISTING');

AdminMaterialsAnalyticsListSourceKindEnum
    _$adminMaterialsAnalyticsListSourceKindEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC_LISTING':
      return _$adminMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMaterialsAnalyticsListSourceKindEnum>
    _$adminMaterialsAnalyticsListSourceKindEnumValues = BuiltSet<
        AdminMaterialsAnalyticsListSourceKindEnum>(const <AdminMaterialsAnalyticsListSourceKindEnum>[
  _$adminMaterialsAnalyticsListSourceKindEnum_PUBLIC_LISTING,
]);

Serializer<AdminMaterialsAnalyticsListAudienceEnum>
    _$adminMaterialsAnalyticsListAudienceEnumSerializer =
    _$AdminMaterialsAnalyticsListAudienceEnumSerializer();
Serializer<AdminMaterialsAnalyticsListSourceKindEnum>
    _$adminMaterialsAnalyticsListSourceKindEnumSerializer =
    _$AdminMaterialsAnalyticsListSourceKindEnumSerializer();

class _$AdminMaterialsAnalyticsListAudienceEnumSerializer
    implements PrimitiveSerializer<AdminMaterialsAnalyticsListAudienceEnum> {
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
    AdminMaterialsAnalyticsListAudienceEnum
  ];
  @override
  final String wireName = 'AdminMaterialsAnalyticsListAudienceEnum';

  @override
  Object serialize(Serializers serializers,
          AdminMaterialsAnalyticsListAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminMaterialsAnalyticsListAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminMaterialsAnalyticsListAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminMaterialsAnalyticsListSourceKindEnumSerializer
    implements PrimitiveSerializer<AdminMaterialsAnalyticsListSourceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC_LISTING': 'PUBLIC_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminMaterialsAnalyticsListSourceKindEnum
  ];
  @override
  final String wireName = 'AdminMaterialsAnalyticsListSourceKindEnum';

  @override
  Object serialize(Serializers serializers,
          AdminMaterialsAnalyticsListSourceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminMaterialsAnalyticsListSourceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminMaterialsAnalyticsListSourceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminMaterialsAnalyticsList extends AdminMaterialsAnalyticsList {
  @override
  final AdminMaterialsAnalyticsListAudienceEnum audience;
  @override
  final BuiltMap<String, JsonObject?> scope;
  @override
  final AdminMaterialsAnalyticsListSourceKindEnum sourceKind;
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
  final BuiltList<AdminAnalyticsRow> items;
  @override
  final String? nextCursor;

  factory _$AdminMaterialsAnalyticsList(
          [void Function(AdminMaterialsAnalyticsListBuilder)? updates]) =>
      (AdminMaterialsAnalyticsListBuilder()..update(updates))._build();

  _$AdminMaterialsAnalyticsList._(
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
  AdminMaterialsAnalyticsList rebuild(
          void Function(AdminMaterialsAnalyticsListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMaterialsAnalyticsListBuilder toBuilder() =>
      AdminMaterialsAnalyticsListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMaterialsAnalyticsList &&
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
    return (newBuiltValueToStringHelper(r'AdminMaterialsAnalyticsList')
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

class AdminMaterialsAnalyticsListBuilder
    implements
        Builder<AdminMaterialsAnalyticsList,
            AdminMaterialsAnalyticsListBuilder> {
  _$AdminMaterialsAnalyticsList? _$v;

  AdminMaterialsAnalyticsListAudienceEnum? _audience;
  AdminMaterialsAnalyticsListAudienceEnum? get audience => _$this._audience;
  set audience(AdminMaterialsAnalyticsListAudienceEnum? audience) =>
      _$this._audience = audience;

  MapBuilder<String, JsonObject?>? _scope;
  MapBuilder<String, JsonObject?> get scope =>
      _$this._scope ??= MapBuilder<String, JsonObject?>();
  set scope(MapBuilder<String, JsonObject?>? scope) => _$this._scope = scope;

  AdminMaterialsAnalyticsListSourceKindEnum? _sourceKind;
  AdminMaterialsAnalyticsListSourceKindEnum? get sourceKind =>
      _$this._sourceKind;
  set sourceKind(AdminMaterialsAnalyticsListSourceKindEnum? sourceKind) =>
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

  ListBuilder<AdminAnalyticsRow>? _items;
  ListBuilder<AdminAnalyticsRow> get items =>
      _$this._items ??= ListBuilder<AdminAnalyticsRow>();
  set items(ListBuilder<AdminAnalyticsRow>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminMaterialsAnalyticsListBuilder() {
    AdminMaterialsAnalyticsList._defaults(this);
  }

  AdminMaterialsAnalyticsListBuilder get _$this {
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
  void replace(AdminMaterialsAnalyticsList other) {
    _$v = other as _$AdminMaterialsAnalyticsList;
  }

  @override
  void update(void Function(AdminMaterialsAnalyticsListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMaterialsAnalyticsList build() => _build();

  _$AdminMaterialsAnalyticsList _build() {
    _$AdminMaterialsAnalyticsList _$result;
    try {
      _$result = _$v ??
          _$AdminMaterialsAnalyticsList._(
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'AdminMaterialsAnalyticsList', 'audience'),
            scope: scope.build(),
            sourceKind: BuiltValueNullFieldError.checkNotNull(
                sourceKind, r'AdminMaterialsAnalyticsList', 'sourceKind'),
            dataset: dataset.build(),
            window: window.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'AdminMaterialsAnalyticsList', 'currentAsOf'),
            snapshot: _snapshot?.build(),
            updateSchedule: BuiltValueNullFieldError.checkNotNull(
                updateSchedule,
                r'AdminMaterialsAnalyticsList',
                'updateSchedule'),
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'AdminMaterialsAnalyticsList', 'explanation'),
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
            r'AdminMaterialsAnalyticsList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
