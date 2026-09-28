// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_allotment_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptAllotmentUpdate extends AutoAcceptAllotmentUpdate {
  @override
  final int lockVersion;
  @override
  final String allotmentQuantity;

  factory _$AutoAcceptAllotmentUpdate(
          [void Function(AutoAcceptAllotmentUpdateBuilder)? updates]) =>
      (AutoAcceptAllotmentUpdateBuilder()..update(updates))._build();

  _$AutoAcceptAllotmentUpdate._(
      {required this.lockVersion, required this.allotmentQuantity})
      : super._();
  @override
  AutoAcceptAllotmentUpdate rebuild(
          void Function(AutoAcceptAllotmentUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptAllotmentUpdateBuilder toBuilder() =>
      AutoAcceptAllotmentUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptAllotmentUpdate &&
        lockVersion == other.lockVersion &&
        allotmentQuantity == other.allotmentQuantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, allotmentQuantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptAllotmentUpdate')
          ..add('lockVersion', lockVersion)
          ..add('allotmentQuantity', allotmentQuantity))
        .toString();
  }
}

class AutoAcceptAllotmentUpdateBuilder
    implements
        Builder<AutoAcceptAllotmentUpdate, AutoAcceptAllotmentUpdateBuilder> {
  _$AutoAcceptAllotmentUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _allotmentQuantity;
  String? get allotmentQuantity => _$this._allotmentQuantity;
  set allotmentQuantity(String? allotmentQuantity) =>
      _$this._allotmentQuantity = allotmentQuantity;

  AutoAcceptAllotmentUpdateBuilder() {
    AutoAcceptAllotmentUpdate._defaults(this);
  }

  AutoAcceptAllotmentUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _allotmentQuantity = $v.allotmentQuantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptAllotmentUpdate other) {
    _$v = other as _$AutoAcceptAllotmentUpdate;
  }

  @override
  void update(void Function(AutoAcceptAllotmentUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptAllotmentUpdate build() => _build();

  _$AutoAcceptAllotmentUpdate _build() {
    final _$result = _$v ??
        _$AutoAcceptAllotmentUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AutoAcceptAllotmentUpdate', 'lockVersion'),
          allotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              allotmentQuantity,
              r'AutoAcceptAllotmentUpdate',
              'allotmentQuantity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
