// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_blocker.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogBlocker extends CatalogBlocker {
  @override
  final String key;
  @override
  final String step;
  @override
  final String reason;

  factory _$CatalogBlocker([void Function(CatalogBlockerBuilder)? updates]) =>
      (CatalogBlockerBuilder()..update(updates))._build();

  _$CatalogBlocker._(
      {required this.key, required this.step, required this.reason})
      : super._();
  @override
  CatalogBlocker rebuild(void Function(CatalogBlockerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogBlockerBuilder toBuilder() => CatalogBlockerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogBlocker &&
        key == other.key &&
        step == other.step &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogBlocker')
          ..add('key', key)
          ..add('step', step)
          ..add('reason', reason))
        .toString();
  }
}

class CatalogBlockerBuilder
    implements Builder<CatalogBlocker, CatalogBlockerBuilder> {
  _$CatalogBlocker? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _step;
  String? get step => _$this._step;
  set step(String? step) => _$this._step = step;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CatalogBlockerBuilder() {
    CatalogBlocker._defaults(this);
  }

  CatalogBlockerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _step = $v.step;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogBlocker other) {
    _$v = other as _$CatalogBlocker;
  }

  @override
  void update(void Function(CatalogBlockerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogBlocker build() => _build();

  _$CatalogBlocker _build() {
    final _$result = _$v ??
        _$CatalogBlocker._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'CatalogBlocker', 'key'),
          step: BuiltValueNullFieldError.checkNotNull(
              step, r'CatalogBlocker', 'step'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CatalogBlocker', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
