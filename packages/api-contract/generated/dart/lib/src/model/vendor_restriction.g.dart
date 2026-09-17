// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_restriction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorRestriction extends VendorRestriction {
  @override
  final String reason;

  factory _$VendorRestriction(
          [void Function(VendorRestrictionBuilder)? updates]) =>
      (VendorRestrictionBuilder()..update(updates))._build();

  _$VendorRestriction._({required this.reason}) : super._();
  @override
  VendorRestriction rebuild(void Function(VendorRestrictionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorRestrictionBuilder toBuilder() =>
      VendorRestrictionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorRestriction && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorRestriction')
          ..add('reason', reason))
        .toString();
  }
}

class VendorRestrictionBuilder
    implements Builder<VendorRestriction, VendorRestrictionBuilder> {
  _$VendorRestriction? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  VendorRestrictionBuilder() {
    VendorRestriction._defaults(this);
  }

  VendorRestrictionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorRestriction other) {
    _$v = other as _$VendorRestriction;
  }

  @override
  void update(void Function(VendorRestrictionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorRestriction build() => _build();

  _$VendorRestriction _build() {
    final _$result = _$v ??
        _$VendorRestriction._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'VendorRestriction', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
