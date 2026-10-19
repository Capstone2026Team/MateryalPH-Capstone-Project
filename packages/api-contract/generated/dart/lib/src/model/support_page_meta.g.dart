// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_page_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportPageMeta extends SupportPageMeta {
  @override
  final String? nextCursor;
  @override
  final String? correlationId;

  factory _$SupportPageMeta([void Function(SupportPageMetaBuilder)? updates]) =>
      (SupportPageMetaBuilder()..update(updates))._build();

  _$SupportPageMeta._({this.nextCursor, this.correlationId}) : super._();
  @override
  SupportPageMeta rebuild(void Function(SupportPageMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportPageMetaBuilder toBuilder() => SupportPageMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportPageMeta &&
        nextCursor == other.nextCursor &&
        correlationId == other.correlationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportPageMeta')
          ..add('nextCursor', nextCursor)
          ..add('correlationId', correlationId))
        .toString();
  }
}

class SupportPageMetaBuilder
    implements Builder<SupportPageMeta, SupportPageMetaBuilder> {
  _$SupportPageMeta? _$v;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  SupportPageMetaBuilder() {
    SupportPageMeta._defaults(this);
  }

  SupportPageMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextCursor = $v.nextCursor;
      _correlationId = $v.correlationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportPageMeta other) {
    _$v = other as _$SupportPageMeta;
  }

  @override
  void update(void Function(SupportPageMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportPageMeta build() => _build();

  _$SupportPageMeta _build() {
    final _$result = _$v ??
        _$SupportPageMeta._(
          nextCursor: nextCursor,
          correlationId: correlationId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
