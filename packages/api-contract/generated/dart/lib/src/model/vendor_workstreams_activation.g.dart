// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_workstreams_activation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWorkstreamsActivation extends VendorWorkstreamsActivation {
  @override
  final String status;
  @override
  final String? holdCode;

  factory _$VendorWorkstreamsActivation(
          [void Function(VendorWorkstreamsActivationBuilder)? updates]) =>
      (VendorWorkstreamsActivationBuilder()..update(updates))._build();

  _$VendorWorkstreamsActivation._({required this.status, this.holdCode})
      : super._();
  @override
  VendorWorkstreamsActivation rebuild(
          void Function(VendorWorkstreamsActivationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWorkstreamsActivationBuilder toBuilder() =>
      VendorWorkstreamsActivationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWorkstreamsActivation &&
        status == other.status &&
        holdCode == other.holdCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, holdCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorWorkstreamsActivation')
          ..add('status', status)
          ..add('holdCode', holdCode))
        .toString();
  }
}

class VendorWorkstreamsActivationBuilder
    implements
        Builder<VendorWorkstreamsActivation,
            VendorWorkstreamsActivationBuilder> {
  _$VendorWorkstreamsActivation? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _holdCode;
  String? get holdCode => _$this._holdCode;
  set holdCode(String? holdCode) => _$this._holdCode = holdCode;

  VendorWorkstreamsActivationBuilder() {
    VendorWorkstreamsActivation._defaults(this);
  }

  VendorWorkstreamsActivationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _holdCode = $v.holdCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorWorkstreamsActivation other) {
    _$v = other as _$VendorWorkstreamsActivation;
  }

  @override
  void update(void Function(VendorWorkstreamsActivationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWorkstreamsActivation build() => _build();

  _$VendorWorkstreamsActivation _build() {
    final _$result = _$v ??
        _$VendorWorkstreamsActivation._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorWorkstreamsActivation', 'status'),
          holdCode: holdCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
