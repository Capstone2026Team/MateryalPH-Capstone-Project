// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_page_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryPageMetaDirectionEnum _$directoryPageMetaDirectionEnum_RECEIVED =
    const DirectoryPageMetaDirectionEnum._('RECEIVED');
const DirectoryPageMetaDirectionEnum _$directoryPageMetaDirectionEnum_WRITTEN =
    const DirectoryPageMetaDirectionEnum._('WRITTEN');

DirectoryPageMetaDirectionEnum _$directoryPageMetaDirectionEnumValueOf(
    String name) {
  switch (name) {
    case 'RECEIVED':
      return _$directoryPageMetaDirectionEnum_RECEIVED;
    case 'WRITTEN':
      return _$directoryPageMetaDirectionEnum_WRITTEN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryPageMetaDirectionEnum>
    _$directoryPageMetaDirectionEnumValues = BuiltSet<
        DirectoryPageMetaDirectionEnum>(const <DirectoryPageMetaDirectionEnum>[
  _$directoryPageMetaDirectionEnum_RECEIVED,
  _$directoryPageMetaDirectionEnum_WRITTEN,
]);

const DirectoryPageMetaTypeEnum _$directoryPageMetaTypeEnum_VENDOR =
    const DirectoryPageMetaTypeEnum._('VENDOR');
const DirectoryPageMetaTypeEnum _$directoryPageMetaTypeEnum_PRODUCT =
    const DirectoryPageMetaTypeEnum._('PRODUCT');

DirectoryPageMetaTypeEnum _$directoryPageMetaTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$directoryPageMetaTypeEnum_VENDOR;
    case 'PRODUCT':
      return _$directoryPageMetaTypeEnum_PRODUCT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryPageMetaTypeEnum> _$directoryPageMetaTypeEnumValues =
    BuiltSet<DirectoryPageMetaTypeEnum>(const <DirectoryPageMetaTypeEnum>[
  _$directoryPageMetaTypeEnum_VENDOR,
  _$directoryPageMetaTypeEnum_PRODUCT,
]);

Serializer<DirectoryPageMetaDirectionEnum>
    _$directoryPageMetaDirectionEnumSerializer =
    _$DirectoryPageMetaDirectionEnumSerializer();
Serializer<DirectoryPageMetaTypeEnum> _$directoryPageMetaTypeEnumSerializer =
    _$DirectoryPageMetaTypeEnumSerializer();

class _$DirectoryPageMetaDirectionEnumSerializer
    implements PrimitiveSerializer<DirectoryPageMetaDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RECEIVED': 'RECEIVED',
    'WRITTEN': 'WRITTEN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RECEIVED': 'RECEIVED',
    'WRITTEN': 'WRITTEN',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryPageMetaDirectionEnum];
  @override
  final String wireName = 'DirectoryPageMetaDirectionEnum';

  @override
  Object serialize(
          Serializers serializers, DirectoryPageMetaDirectionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryPageMetaDirectionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryPageMetaDirectionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryPageMetaTypeEnumSerializer
    implements PrimitiveSerializer<DirectoryPageMetaTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'PRODUCT': 'PRODUCT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'PRODUCT': 'PRODUCT',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryPageMetaTypeEnum];
  @override
  final String wireName = 'DirectoryPageMetaTypeEnum';

  @override
  Object serialize(Serializers serializers, DirectoryPageMetaTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryPageMetaTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryPageMetaTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryPageMeta extends DirectoryPageMeta {
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final int lastPage;
  @override
  final BuiltMap<String, int>? statusCounts;
  @override
  final bool? canModerate;
  @override
  final DirectoryPageMetaDirectionEnum? direction;
  @override
  final DirectoryPageMetaTypeEnum? type;

  factory _$DirectoryPageMeta(
          [void Function(DirectoryPageMetaBuilder)? updates]) =>
      (DirectoryPageMetaBuilder()..update(updates))._build();

  _$DirectoryPageMeta._(
      {required this.page,
      required this.perPage,
      required this.total,
      required this.lastPage,
      this.statusCounts,
      this.canModerate,
      this.direction,
      this.type})
      : super._();
  @override
  DirectoryPageMeta rebuild(void Function(DirectoryPageMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryPageMetaBuilder toBuilder() =>
      DirectoryPageMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryPageMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        lastPage == other.lastPage &&
        statusCounts == other.statusCounts &&
        canModerate == other.canModerate &&
        direction == other.direction &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, statusCounts.hashCode);
    _$hash = $jc(_$hash, canModerate.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryPageMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('lastPage', lastPage)
          ..add('statusCounts', statusCounts)
          ..add('canModerate', canModerate)
          ..add('direction', direction)
          ..add('type', type))
        .toString();
  }
}

class DirectoryPageMetaBuilder
    implements Builder<DirectoryPageMeta, DirectoryPageMetaBuilder> {
  _$DirectoryPageMeta? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  MapBuilder<String, int>? _statusCounts;
  MapBuilder<String, int> get statusCounts =>
      _$this._statusCounts ??= MapBuilder<String, int>();
  set statusCounts(MapBuilder<String, int>? statusCounts) =>
      _$this._statusCounts = statusCounts;

  bool? _canModerate;
  bool? get canModerate => _$this._canModerate;
  set canModerate(bool? canModerate) => _$this._canModerate = canModerate;

  DirectoryPageMetaDirectionEnum? _direction;
  DirectoryPageMetaDirectionEnum? get direction => _$this._direction;
  set direction(DirectoryPageMetaDirectionEnum? direction) =>
      _$this._direction = direction;

  DirectoryPageMetaTypeEnum? _type;
  DirectoryPageMetaTypeEnum? get type => _$this._type;
  set type(DirectoryPageMetaTypeEnum? type) => _$this._type = type;

  DirectoryPageMetaBuilder() {
    DirectoryPageMeta._defaults(this);
  }

  DirectoryPageMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _lastPage = $v.lastPage;
      _statusCounts = $v.statusCounts?.toBuilder();
      _canModerate = $v.canModerate;
      _direction = $v.direction;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryPageMeta other) {
    _$v = other as _$DirectoryPageMeta;
  }

  @override
  void update(void Function(DirectoryPageMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryPageMeta build() => _build();

  _$DirectoryPageMeta _build() {
    _$DirectoryPageMeta _$result;
    try {
      _$result = _$v ??
          _$DirectoryPageMeta._(
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'DirectoryPageMeta', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'DirectoryPageMeta', 'perPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'DirectoryPageMeta', 'total'),
            lastPage: BuiltValueNullFieldError.checkNotNull(
                lastPage, r'DirectoryPageMeta', 'lastPage'),
            statusCounts: _statusCounts?.build(),
            canModerate: canModerate,
            direction: direction,
            type: type,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statusCounts';
        _statusCounts?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryPageMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
