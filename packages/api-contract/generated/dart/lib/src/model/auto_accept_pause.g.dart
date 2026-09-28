// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_pause.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptPause extends AutoAcceptPause {
  @override
  final int lockVersion;

  factory _$AutoAcceptPause([void Function(AutoAcceptPauseBuilder)? updates]) =>
      (AutoAcceptPauseBuilder()..update(updates))._build();

  _$AutoAcceptPause._({required this.lockVersion}) : super._();
  @override
  AutoAcceptPause rebuild(void Function(AutoAcceptPauseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPauseBuilder toBuilder() => AutoAcceptPauseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPause && lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPause')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class AutoAcceptPauseBuilder
    implements Builder<AutoAcceptPause, AutoAcceptPauseBuilder> {
  _$AutoAcceptPause? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  AutoAcceptPauseBuilder() {
    AutoAcceptPause._defaults(this);
  }

  AutoAcceptPauseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPause other) {
    _$v = other as _$AutoAcceptPause;
  }

  @override
  void update(void Function(AutoAcceptPauseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPause build() => _build();

  _$AutoAcceptPause _build() {
    final _$result = _$v ??
        _$AutoAcceptPause._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AutoAcceptPause', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
