// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_alternative_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnum_CATALOG =
    const WorkPackageAlternativePageStatusEnum._('CATALOG');
const WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnum_NO_SUITABLE_ALTERNATIVE =
    const WorkPackageAlternativePageStatusEnum._('NO_SUITABLE_ALTERNATIVE');
const WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnum_COVERED =
    const WorkPackageAlternativePageStatusEnum._('COVERED');
const WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnum_UNLISTED =
    const WorkPackageAlternativePageStatusEnum._('UNLISTED');

WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnumValueOf(String name) {
  switch (name) {
    case 'CATALOG':
      return _$workPackageAlternativePageStatusEnum_CATALOG;
    case 'NO_SUITABLE_ALTERNATIVE':
      return _$workPackageAlternativePageStatusEnum_NO_SUITABLE_ALTERNATIVE;
    case 'COVERED':
      return _$workPackageAlternativePageStatusEnum_COVERED;
    case 'UNLISTED':
      return _$workPackageAlternativePageStatusEnum_UNLISTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageAlternativePageStatusEnum>
    _$workPackageAlternativePageStatusEnumValues = BuiltSet<
        WorkPackageAlternativePageStatusEnum>(const <WorkPackageAlternativePageStatusEnum>[
  _$workPackageAlternativePageStatusEnum_CATALOG,
  _$workPackageAlternativePageStatusEnum_NO_SUITABLE_ALTERNATIVE,
  _$workPackageAlternativePageStatusEnum_COVERED,
  _$workPackageAlternativePageStatusEnum_UNLISTED,
]);

const WorkPackageAlternativePageRadiusKmEnum
    _$workPackageAlternativePageRadiusKmEnum_number50 =
    const WorkPackageAlternativePageRadiusKmEnum._('number50');

WorkPackageAlternativePageRadiusKmEnum
    _$workPackageAlternativePageRadiusKmEnumValueOf(String name) {
  switch (name) {
    case 'number50':
      return _$workPackageAlternativePageRadiusKmEnum_number50;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageAlternativePageRadiusKmEnum>
    _$workPackageAlternativePageRadiusKmEnumValues = BuiltSet<
        WorkPackageAlternativePageRadiusKmEnum>(const <WorkPackageAlternativePageRadiusKmEnum>[
  _$workPackageAlternativePageRadiusKmEnum_number50,
]);

Serializer<WorkPackageAlternativePageStatusEnum>
    _$workPackageAlternativePageStatusEnumSerializer =
    _$WorkPackageAlternativePageStatusEnumSerializer();
Serializer<WorkPackageAlternativePageRadiusKmEnum>
    _$workPackageAlternativePageRadiusKmEnumSerializer =
    _$WorkPackageAlternativePageRadiusKmEnumSerializer();

class _$WorkPackageAlternativePageStatusEnumSerializer
    implements PrimitiveSerializer<WorkPackageAlternativePageStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CATALOG': 'CATALOG',
    'NO_SUITABLE_ALTERNATIVE': 'NO_SUITABLE_ALTERNATIVE',
    'COVERED': 'COVERED',
    'UNLISTED': 'UNLISTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CATALOG': 'CATALOG',
    'NO_SUITABLE_ALTERNATIVE': 'NO_SUITABLE_ALTERNATIVE',
    'COVERED': 'COVERED',
    'UNLISTED': 'UNLISTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageAlternativePageStatusEnum
  ];
  @override
  final String wireName = 'WorkPackageAlternativePageStatusEnum';

  @override
  Object serialize(
          Serializers serializers, WorkPackageAlternativePageStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageAlternativePageStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageAlternativePageStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageAlternativePageRadiusKmEnumSerializer
    implements PrimitiveSerializer<WorkPackageAlternativePageRadiusKmEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number50': 50,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    50: 'number50',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageAlternativePageRadiusKmEnum
  ];
  @override
  final String wireName = 'WorkPackageAlternativePageRadiusKmEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageAlternativePageRadiusKmEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageAlternativePageRadiusKmEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageAlternativePageRadiusKmEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageAlternativePage extends WorkPackageAlternativePage {
  @override
  final BuiltMap<String, JsonObject?> line;
  @override
  final WorkPackageAlternativePageStatusEnum status;
  @override
  final String neededQuantity;
  @override
  final WorkPackageAlternativePageExcluded excluded;
  @override
  final String? locationId;
  @override
  final WorkPackageAlternativePageRadiusKmEnum radiusKm;
  @override
  final BuiltList<WorkPackageAlternative> items;
  @override
  final int page;
  @override
  final bool hasMore;
  @override
  final int total;

  factory _$WorkPackageAlternativePage(
          [void Function(WorkPackageAlternativePageBuilder)? updates]) =>
      (WorkPackageAlternativePageBuilder()..update(updates))._build();

  _$WorkPackageAlternativePage._(
      {required this.line,
      required this.status,
      required this.neededQuantity,
      required this.excluded,
      this.locationId,
      required this.radiusKm,
      required this.items,
      required this.page,
      required this.hasMore,
      required this.total})
      : super._();
  @override
  WorkPackageAlternativePage rebuild(
          void Function(WorkPackageAlternativePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageAlternativePageBuilder toBuilder() =>
      WorkPackageAlternativePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageAlternativePage &&
        line == other.line &&
        status == other.status &&
        neededQuantity == other.neededQuantity &&
        excluded == other.excluded &&
        locationId == other.locationId &&
        radiusKm == other.radiusKm &&
        items == other.items &&
        page == other.page &&
        hasMore == other.hasMore &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, line.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, neededQuantity.hashCode);
    _$hash = $jc(_$hash, excluded.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageAlternativePage')
          ..add('line', line)
          ..add('status', status)
          ..add('neededQuantity', neededQuantity)
          ..add('excluded', excluded)
          ..add('locationId', locationId)
          ..add('radiusKm', radiusKm)
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore)
          ..add('total', total))
        .toString();
  }
}

class WorkPackageAlternativePageBuilder
    implements
        Builder<WorkPackageAlternativePage, WorkPackageAlternativePageBuilder> {
  _$WorkPackageAlternativePage? _$v;

  MapBuilder<String, JsonObject?>? _line;
  MapBuilder<String, JsonObject?> get line =>
      _$this._line ??= MapBuilder<String, JsonObject?>();
  set line(MapBuilder<String, JsonObject?>? line) => _$this._line = line;

  WorkPackageAlternativePageStatusEnum? _status;
  WorkPackageAlternativePageStatusEnum? get status => _$this._status;
  set status(WorkPackageAlternativePageStatusEnum? status) =>
      _$this._status = status;

  String? _neededQuantity;
  String? get neededQuantity => _$this._neededQuantity;
  set neededQuantity(String? neededQuantity) =>
      _$this._neededQuantity = neededQuantity;

  WorkPackageAlternativePageExcludedBuilder? _excluded;
  WorkPackageAlternativePageExcludedBuilder get excluded =>
      _$this._excluded ??= WorkPackageAlternativePageExcludedBuilder();
  set excluded(WorkPackageAlternativePageExcludedBuilder? excluded) =>
      _$this._excluded = excluded;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  WorkPackageAlternativePageRadiusKmEnum? _radiusKm;
  WorkPackageAlternativePageRadiusKmEnum? get radiusKm => _$this._radiusKm;
  set radiusKm(WorkPackageAlternativePageRadiusKmEnum? radiusKm) =>
      _$this._radiusKm = radiusKm;

  ListBuilder<WorkPackageAlternative>? _items;
  ListBuilder<WorkPackageAlternative> get items =>
      _$this._items ??= ListBuilder<WorkPackageAlternative>();
  set items(ListBuilder<WorkPackageAlternative>? items) =>
      _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  WorkPackageAlternativePageBuilder() {
    WorkPackageAlternativePage._defaults(this);
  }

  WorkPackageAlternativePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _line = $v.line.toBuilder();
      _status = $v.status;
      _neededQuantity = $v.neededQuantity;
      _excluded = $v.excluded.toBuilder();
      _locationId = $v.locationId;
      _radiusKm = $v.radiusKm;
      _items = $v.items.toBuilder();
      _page = $v.page;
      _hasMore = $v.hasMore;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageAlternativePage other) {
    _$v = other as _$WorkPackageAlternativePage;
  }

  @override
  void update(void Function(WorkPackageAlternativePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageAlternativePage build() => _build();

  _$WorkPackageAlternativePage _build() {
    _$WorkPackageAlternativePage _$result;
    try {
      _$result = _$v ??
          _$WorkPackageAlternativePage._(
            line: line.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WorkPackageAlternativePage', 'status'),
            neededQuantity: BuiltValueNullFieldError.checkNotNull(
                neededQuantity,
                r'WorkPackageAlternativePage',
                'neededQuantity'),
            excluded: excluded.build(),
            locationId: locationId,
            radiusKm: BuiltValueNullFieldError.checkNotNull(
                radiusKm, r'WorkPackageAlternativePage', 'radiusKm'),
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'WorkPackageAlternativePage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'WorkPackageAlternativePage', 'hasMore'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'WorkPackageAlternativePage', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'line';
        line.build();

        _$failedField = 'excluded';
        excluded.build();

        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageAlternativePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
