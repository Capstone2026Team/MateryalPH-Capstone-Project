// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tin_reveal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTinReveal extends VendorTinReveal {
  @override
  final String tin;

  factory _$VendorTinReveal([void Function(VendorTinRevealBuilder)? updates]) =>
      (VendorTinRevealBuilder()..update(updates))._build();

  _$VendorTinReveal._({required this.tin}) : super._();
  @override
  VendorTinReveal rebuild(void Function(VendorTinRevealBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTinRevealBuilder toBuilder() => VendorTinRevealBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTinReveal && tin == other.tin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTinReveal')..add('tin', tin))
        .toString();
  }
}

class VendorTinRevealBuilder
    implements Builder<VendorTinReveal, VendorTinRevealBuilder> {
  _$VendorTinReveal? _$v;

  String? _tin;
  String? get tin => _$this._tin;
  set tin(String? tin) => _$this._tin = tin;

  VendorTinRevealBuilder() {
    VendorTinReveal._defaults(this);
  }

  VendorTinRevealBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tin = $v.tin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTinReveal other) {
    _$v = other as _$VendorTinReveal;
  }

  @override
  void update(void Function(VendorTinRevealBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTinReveal build() => _build();

  _$VendorTinReveal _build() {
    final _$result = _$v ??
        _$VendorTinReveal._(
          tin: BuiltValueNullFieldError.checkNotNull(
              tin, r'VendorTinReveal', 'tin'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
