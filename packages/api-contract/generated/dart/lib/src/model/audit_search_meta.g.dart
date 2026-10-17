// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_search_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditSearchMeta extends AuditSearchMeta {
  @override
  final String? nextCursor;
  @override
  final int? pageSize;
  @override
  final bool? canViewDetail;
  @override
  final bool? canExport;

  factory _$AuditSearchMeta([void Function(AuditSearchMetaBuilder)? updates]) =>
      (AuditSearchMetaBuilder()..update(updates))._build();

  _$AuditSearchMeta._(
      {this.nextCursor, this.pageSize, this.canViewDetail, this.canExport})
      : super._();
  @override
  AuditSearchMeta rebuild(void Function(AuditSearchMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditSearchMetaBuilder toBuilder() => AuditSearchMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditSearchMeta &&
        nextCursor == other.nextCursor &&
        pageSize == other.pageSize &&
        canViewDetail == other.canViewDetail &&
        canExport == other.canExport;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, canViewDetail.hashCode);
    _$hash = $jc(_$hash, canExport.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditSearchMeta')
          ..add('nextCursor', nextCursor)
          ..add('pageSize', pageSize)
          ..add('canViewDetail', canViewDetail)
          ..add('canExport', canExport))
        .toString();
  }
}

class AuditSearchMetaBuilder
    implements Builder<AuditSearchMeta, AuditSearchMetaBuilder> {
  _$AuditSearchMeta? _$v;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  bool? _canViewDetail;
  bool? get canViewDetail => _$this._canViewDetail;
  set canViewDetail(bool? canViewDetail) =>
      _$this._canViewDetail = canViewDetail;

  bool? _canExport;
  bool? get canExport => _$this._canExport;
  set canExport(bool? canExport) => _$this._canExport = canExport;

  AuditSearchMetaBuilder() {
    AuditSearchMeta._defaults(this);
  }

  AuditSearchMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextCursor = $v.nextCursor;
      _pageSize = $v.pageSize;
      _canViewDetail = $v.canViewDetail;
      _canExport = $v.canExport;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditSearchMeta other) {
    _$v = other as _$AuditSearchMeta;
  }

  @override
  void update(void Function(AuditSearchMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditSearchMeta build() => _build();

  _$AuditSearchMeta _build() {
    final _$result = _$v ??
        _$AuditSearchMeta._(
          nextCursor: nextCursor,
          pageSize: pageSize,
          canViewDetail: canViewDetail,
          canExport: canExport,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
