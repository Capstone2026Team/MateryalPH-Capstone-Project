// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_alternative_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnum_CATALOG =
    const WorkPackageAlternativePageStatusEnum._('CATALOG');
const WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnum_UNLISTED =
    const WorkPackageAlternativePageStatusEnum._('UNLISTED');

WorkPackageAlternativePageStatusEnum
    _$workPackageAlternativePageStatusEnumValueOf(String name) {
  switch (name) {
    case 'CATALOG':
      return _$workPackageAlternativePageStatusEnum_CATALOG;
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
  _$workPackageAlternativePageStatusEnum_UNLISTED,
]);

Serializer<WorkPackageAlternativePageStatusEnum>
    _$workPackageAlternativePageStatusEnumSerializer =
    _$WorkPackageAlternativePageStatusEnumSerializer();

class _$WorkPackageAlternativePageStatusEnumSerializer
    implements PrimitiveSerializer<WorkPackageAlternativePageStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CATALOG': 'CATALOG',
    'UNLISTED': 'UNLISTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CATALOG': 'CATALOG',
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

class _$WorkPackageAlternativePage extends WorkPackageAlternativePage {
  @override
  final BuiltMap<String, JsonObject?> line;
  @override
  final WorkPackageAlternativePageStatusEnum status;
  @override
  final String? locationId;
  @override
  final int radiusKm;
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

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

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
