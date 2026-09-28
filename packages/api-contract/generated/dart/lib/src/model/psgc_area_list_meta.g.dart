// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_area_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PsgcAreaListMetaStatusEnum _$psgcAreaListMetaStatusEnum_AVAILABLE =
    const PsgcAreaListMetaStatusEnum._('AVAILABLE');
const PsgcAreaListMetaStatusEnum
    _$psgcAreaListMetaStatusEnum_NO_ACTIVE_PSGC_VERSION =
    const PsgcAreaListMetaStatusEnum._('NO_ACTIVE_PSGC_VERSION');
const PsgcAreaListMetaStatusEnum _$psgcAreaListMetaStatusEnum_PARENT_UNKNOWN =
    const PsgcAreaListMetaStatusEnum._('PARENT_UNKNOWN');

PsgcAreaListMetaStatusEnum _$psgcAreaListMetaStatusEnumValueOf(String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$psgcAreaListMetaStatusEnum_AVAILABLE;
    case 'NO_ACTIVE_PSGC_VERSION':
      return _$psgcAreaListMetaStatusEnum_NO_ACTIVE_PSGC_VERSION;
    case 'PARENT_UNKNOWN':
      return _$psgcAreaListMetaStatusEnum_PARENT_UNKNOWN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PsgcAreaListMetaStatusEnum> _$psgcAreaListMetaStatusEnumValues =
    BuiltSet<PsgcAreaListMetaStatusEnum>(const <PsgcAreaListMetaStatusEnum>[
  _$psgcAreaListMetaStatusEnum_AVAILABLE,
  _$psgcAreaListMetaStatusEnum_NO_ACTIVE_PSGC_VERSION,
  _$psgcAreaListMetaStatusEnum_PARENT_UNKNOWN,
]);

Serializer<PsgcAreaListMetaStatusEnum> _$psgcAreaListMetaStatusEnumSerializer =
    _$PsgcAreaListMetaStatusEnumSerializer();

class _$PsgcAreaListMetaStatusEnumSerializer
    implements PrimitiveSerializer<PsgcAreaListMetaStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'NO_ACTIVE_PSGC_VERSION': 'NO_ACTIVE_PSGC_VERSION',
    'PARENT_UNKNOWN': 'PARENT_UNKNOWN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'NO_ACTIVE_PSGC_VERSION': 'NO_ACTIVE_PSGC_VERSION',
    'PARENT_UNKNOWN': 'PARENT_UNKNOWN',
  };

  @override
  final Iterable<Type> types = const <Type>[PsgcAreaListMetaStatusEnum];
  @override
  final String wireName = 'PsgcAreaListMetaStatusEnum';

  @override
  Object serialize(Serializers serializers, PsgcAreaListMetaStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PsgcAreaListMetaStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PsgcAreaListMetaStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PsgcAreaListMeta extends PsgcAreaListMeta {
  @override
  final String? correlationId;
  @override
  final String? psgcVersion;
  @override
  final int page;
  @override
  final bool hasMore;
  @override
  final PsgcAreaListMetaStatusEnum status;

  factory _$PsgcAreaListMeta(
          [void Function(PsgcAreaListMetaBuilder)? updates]) =>
      (PsgcAreaListMetaBuilder()..update(updates))._build();

  _$PsgcAreaListMeta._(
      {this.correlationId,
      this.psgcVersion,
      required this.page,
      required this.hasMore,
      required this.status})
      : super._();
  @override
  PsgcAreaListMeta rebuild(void Function(PsgcAreaListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcAreaListMetaBuilder toBuilder() =>
      PsgcAreaListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcAreaListMeta &&
        correlationId == other.correlationId &&
        psgcVersion == other.psgcVersion &&
        page == other.page &&
        hasMore == other.hasMore &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, psgcVersion.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PsgcAreaListMeta')
          ..add('correlationId', correlationId)
          ..add('psgcVersion', psgcVersion)
          ..add('page', page)
          ..add('hasMore', hasMore)
          ..add('status', status))
        .toString();
  }
}

class PsgcAreaListMetaBuilder
    implements Builder<PsgcAreaListMeta, PsgcAreaListMetaBuilder> {
  _$PsgcAreaListMeta? _$v;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  String? _psgcVersion;
  String? get psgcVersion => _$this._psgcVersion;
  set psgcVersion(String? psgcVersion) => _$this._psgcVersion = psgcVersion;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  PsgcAreaListMetaStatusEnum? _status;
  PsgcAreaListMetaStatusEnum? get status => _$this._status;
  set status(PsgcAreaListMetaStatusEnum? status) => _$this._status = status;

  PsgcAreaListMetaBuilder() {
    PsgcAreaListMeta._defaults(this);
  }

  PsgcAreaListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _correlationId = $v.correlationId;
      _psgcVersion = $v.psgcVersion;
      _page = $v.page;
      _hasMore = $v.hasMore;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PsgcAreaListMeta other) {
    _$v = other as _$PsgcAreaListMeta;
  }

  @override
  void update(void Function(PsgcAreaListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcAreaListMeta build() => _build();

  _$PsgcAreaListMeta _build() {
    final _$result = _$v ??
        _$PsgcAreaListMeta._(
          correlationId: correlationId,
          psgcVersion: psgcVersion,
          page: BuiltValueNullFieldError.checkNotNull(
              page, r'PsgcAreaListMeta', 'page'),
          hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore, r'PsgcAreaListMeta', 'hasMore'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PsgcAreaListMeta', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
