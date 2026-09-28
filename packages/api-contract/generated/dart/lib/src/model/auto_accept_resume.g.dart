// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_resume.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptResume extends AutoAcceptResume {
  @override
  final int lockVersion;
  @override
  final String confirmedAllotmentQuantity;

  factory _$AutoAcceptResume(
          [void Function(AutoAcceptResumeBuilder)? updates]) =>
      (AutoAcceptResumeBuilder()..update(updates))._build();

  _$AutoAcceptResume._(
      {required this.lockVersion, required this.confirmedAllotmentQuantity})
      : super._();
  @override
  AutoAcceptResume rebuild(void Function(AutoAcceptResumeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptResumeBuilder toBuilder() =>
      AutoAcceptResumeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptResume &&
        lockVersion == other.lockVersion &&
        confirmedAllotmentQuantity == other.confirmedAllotmentQuantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, confirmedAllotmentQuantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptResume')
          ..add('lockVersion', lockVersion)
          ..add('confirmedAllotmentQuantity', confirmedAllotmentQuantity))
        .toString();
  }
}

class AutoAcceptResumeBuilder
    implements Builder<AutoAcceptResume, AutoAcceptResumeBuilder> {
  _$AutoAcceptResume? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _confirmedAllotmentQuantity;
  String? get confirmedAllotmentQuantity => _$this._confirmedAllotmentQuantity;
  set confirmedAllotmentQuantity(String? confirmedAllotmentQuantity) =>
      _$this._confirmedAllotmentQuantity = confirmedAllotmentQuantity;

  AutoAcceptResumeBuilder() {
    AutoAcceptResume._defaults(this);
  }

  AutoAcceptResumeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _confirmedAllotmentQuantity = $v.confirmedAllotmentQuantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptResume other) {
    _$v = other as _$AutoAcceptResume;
  }

  @override
  void update(void Function(AutoAcceptResumeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptResume build() => _build();

  _$AutoAcceptResume _build() {
    final _$result = _$v ??
        _$AutoAcceptResume._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AutoAcceptResume', 'lockVersion'),
          confirmedAllotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              confirmedAllotmentQuantity,
              r'AutoAcceptResume',
              'confirmedAllotmentQuantity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
