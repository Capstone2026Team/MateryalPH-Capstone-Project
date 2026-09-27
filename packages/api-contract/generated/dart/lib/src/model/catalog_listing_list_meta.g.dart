// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogListingListMetaScopeEnum
    _$catalogListingListMetaScopeEnum_ORGANIZATION =
    const CatalogListingListMetaScopeEnum._('ORGANIZATION');
const CatalogListingListMetaScopeEnum
    _$catalogListingListMetaScopeEnum_ASSIGNED_ONLY =
    const CatalogListingListMetaScopeEnum._('ASSIGNED_ONLY');

CatalogListingListMetaScopeEnum _$catalogListingListMetaScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'ORGANIZATION':
      return _$catalogListingListMetaScopeEnum_ORGANIZATION;
    case 'ASSIGNED_ONLY':
      return _$catalogListingListMetaScopeEnum_ASSIGNED_ONLY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogListingListMetaScopeEnum>
    _$catalogListingListMetaScopeEnumValues = BuiltSet<
        CatalogListingListMetaScopeEnum>(const <CatalogListingListMetaScopeEnum>[
  _$catalogListingListMetaScopeEnum_ORGANIZATION,
  _$catalogListingListMetaScopeEnum_ASSIGNED_ONLY,
]);

Serializer<CatalogListingListMetaScopeEnum>
    _$catalogListingListMetaScopeEnumSerializer =
    _$CatalogListingListMetaScopeEnumSerializer();

class _$CatalogListingListMetaScopeEnumSerializer
    implements PrimitiveSerializer<CatalogListingListMetaScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORGANIZATION': 'ORGANIZATION',
    'ASSIGNED_ONLY': 'ASSIGNED_ONLY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORGANIZATION': 'ORGANIZATION',
    'ASSIGNED_ONLY': 'ASSIGNED_ONLY',
  };

  @override
  final Iterable<Type> types = const <Type>[CatalogListingListMetaScopeEnum];
  @override
  final String wireName = 'CatalogListingListMetaScopeEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogListingListMetaScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogListingListMetaScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogListingListMetaScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogListingListMeta extends CatalogListingListMeta {
  @override
  final int? currentPage;
  @override
  final int? lastPage;
  @override
  final int? total;
  @override
  final CatalogListingListMetaScopeEnum? scope;
  @override
  final BuiltMap<String, int>? statusCounts;
  @override
  final int? activeOutOfStock;

  factory _$CatalogListingListMeta(
          [void Function(CatalogListingListMetaBuilder)? updates]) =>
      (CatalogListingListMetaBuilder()..update(updates))._build();

  _$CatalogListingListMeta._(
      {this.currentPage,
      this.lastPage,
      this.total,
      this.scope,
      this.statusCounts,
      this.activeOutOfStock})
      : super._();
  @override
  CatalogListingListMeta rebuild(
          void Function(CatalogListingListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingListMetaBuilder toBuilder() =>
      CatalogListingListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingListMeta &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        total == other.total &&
        scope == other.scope &&
        statusCounts == other.statusCounts &&
        activeOutOfStock == other.activeOutOfStock;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, statusCounts.hashCode);
    _$hash = $jc(_$hash, activeOutOfStock.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingListMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('total', total)
          ..add('scope', scope)
          ..add('statusCounts', statusCounts)
          ..add('activeOutOfStock', activeOutOfStock))
        .toString();
  }
}

class CatalogListingListMetaBuilder
    implements Builder<CatalogListingListMeta, CatalogListingListMetaBuilder> {
  _$CatalogListingListMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  CatalogListingListMetaScopeEnum? _scope;
  CatalogListingListMetaScopeEnum? get scope => _$this._scope;
  set scope(CatalogListingListMetaScopeEnum? scope) => _$this._scope = scope;

  MapBuilder<String, int>? _statusCounts;
  MapBuilder<String, int> get statusCounts =>
      _$this._statusCounts ??= MapBuilder<String, int>();
  set statusCounts(MapBuilder<String, int>? statusCounts) =>
      _$this._statusCounts = statusCounts;

  int? _activeOutOfStock;
  int? get activeOutOfStock => _$this._activeOutOfStock;
  set activeOutOfStock(int? activeOutOfStock) =>
      _$this._activeOutOfStock = activeOutOfStock;

  CatalogListingListMetaBuilder() {
    CatalogListingListMeta._defaults(this);
  }

  CatalogListingListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _scope = $v.scope;
      _statusCounts = $v.statusCounts?.toBuilder();
      _activeOutOfStock = $v.activeOutOfStock;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingListMeta other) {
    _$v = other as _$CatalogListingListMeta;
  }

  @override
  void update(void Function(CatalogListingListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingListMeta build() => _build();

  _$CatalogListingListMeta _build() {
    _$CatalogListingListMeta _$result;
    try {
      _$result = _$v ??
          _$CatalogListingListMeta._(
            currentPage: currentPage,
            lastPage: lastPage,
            total: total,
            scope: scope,
            statusCounts: _statusCounts?.build(),
            activeOutOfStock: activeOutOfStock,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statusCounts';
        _statusCounts?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogListingListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
