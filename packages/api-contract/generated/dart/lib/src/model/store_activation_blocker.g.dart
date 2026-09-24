// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_activation_blocker.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StoreActivationBlocker extends StoreActivationBlocker {
  @override
  final String key;
  @override
  final int condition;
  @override
  final String reason;

  factory _$StoreActivationBlocker(
          [void Function(StoreActivationBlockerBuilder)? updates]) =>
      (StoreActivationBlockerBuilder()..update(updates))._build();

  _$StoreActivationBlocker._(
      {required this.key, required this.condition, required this.reason})
      : super._();
  @override
  StoreActivationBlocker rebuild(
          void Function(StoreActivationBlockerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreActivationBlockerBuilder toBuilder() =>
      StoreActivationBlockerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreActivationBlocker &&
        key == other.key &&
        condition == other.condition &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, condition.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreActivationBlocker')
          ..add('key', key)
          ..add('condition', condition)
          ..add('reason', reason))
        .toString();
  }
}

class StoreActivationBlockerBuilder
    implements Builder<StoreActivationBlocker, StoreActivationBlockerBuilder> {
  _$StoreActivationBlocker? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  int? _condition;
  int? get condition => _$this._condition;
  set condition(int? condition) => _$this._condition = condition;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  StoreActivationBlockerBuilder() {
    StoreActivationBlocker._defaults(this);
  }

  StoreActivationBlockerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _condition = $v.condition;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreActivationBlocker other) {
    _$v = other as _$StoreActivationBlocker;
  }

  @override
  void update(void Function(StoreActivationBlockerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreActivationBlocker build() => _build();

  _$StoreActivationBlocker _build() {
    final _$result = _$v ??
        _$StoreActivationBlocker._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'StoreActivationBlocker', 'key'),
          condition: BuiltValueNullFieldError.checkNotNull(
              condition, r'StoreActivationBlocker', 'condition'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'StoreActivationBlocker', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
