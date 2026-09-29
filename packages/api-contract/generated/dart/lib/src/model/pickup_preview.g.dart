// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PickupPreview extends PickupPreview {
  @override
  final PublicAddressSummary? address;
  @override
  final SupplierOpenStatus? openStatus;
  @override
  final String notice;

  factory _$PickupPreview([void Function(PickupPreviewBuilder)? updates]) =>
      (PickupPreviewBuilder()..update(updates))._build();

  _$PickupPreview._({this.address, this.openStatus, required this.notice})
      : super._();
  @override
  PickupPreview rebuild(void Function(PickupPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PickupPreviewBuilder toBuilder() => PickupPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PickupPreview &&
        address == other.address &&
        openStatus == other.openStatus &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, openStatus.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PickupPreview')
          ..add('address', address)
          ..add('openStatus', openStatus)
          ..add('notice', notice))
        .toString();
  }
}

class PickupPreviewBuilder
    implements Builder<PickupPreview, PickupPreviewBuilder> {
  _$PickupPreview? _$v;

  PublicAddressSummaryBuilder? _address;
  PublicAddressSummaryBuilder get address =>
      _$this._address ??= PublicAddressSummaryBuilder();
  set address(PublicAddressSummaryBuilder? address) =>
      _$this._address = address;

  SupplierOpenStatusBuilder? _openStatus;
  SupplierOpenStatusBuilder get openStatus =>
      _$this._openStatus ??= SupplierOpenStatusBuilder();
  set openStatus(SupplierOpenStatusBuilder? openStatus) =>
      _$this._openStatus = openStatus;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  PickupPreviewBuilder() {
    PickupPreview._defaults(this);
  }

  PickupPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _address = $v.address?.toBuilder();
      _openStatus = $v.openStatus?.toBuilder();
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PickupPreview other) {
    _$v = other as _$PickupPreview;
  }

  @override
  void update(void Function(PickupPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PickupPreview build() => _build();

  _$PickupPreview _build() {
    _$PickupPreview _$result;
    try {
      _$result = _$v ??
          _$PickupPreview._(
            address: _address?.build(),
            openStatus: _openStatus?.build(),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'PickupPreview', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        _address?.build();
        _$failedField = 'openStatus';
        _openStatus?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PickupPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
