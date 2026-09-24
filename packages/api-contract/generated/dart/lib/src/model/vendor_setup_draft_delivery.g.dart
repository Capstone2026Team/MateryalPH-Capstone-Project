// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup_draft_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorSetupDraftDelivery extends VendorSetupDraftDelivery {
  @override
  final int? maximumDistanceKm;
  @override
  final String? coverageNotes;

  factory _$VendorSetupDraftDelivery(
          [void Function(VendorSetupDraftDeliveryBuilder)? updates]) =>
      (VendorSetupDraftDeliveryBuilder()..update(updates))._build();

  _$VendorSetupDraftDelivery._({this.maximumDistanceKm, this.coverageNotes})
      : super._();
  @override
  VendorSetupDraftDelivery rebuild(
          void Function(VendorSetupDraftDeliveryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupDraftDeliveryBuilder toBuilder() =>
      VendorSetupDraftDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetupDraftDelivery &&
        maximumDistanceKm == other.maximumDistanceKm &&
        coverageNotes == other.coverageNotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maximumDistanceKm.hashCode);
    _$hash = $jc(_$hash, coverageNotes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorSetupDraftDelivery')
          ..add('maximumDistanceKm', maximumDistanceKm)
          ..add('coverageNotes', coverageNotes))
        .toString();
  }
}

class VendorSetupDraftDeliveryBuilder
    implements
        Builder<VendorSetupDraftDelivery, VendorSetupDraftDeliveryBuilder> {
  _$VendorSetupDraftDelivery? _$v;

  int? _maximumDistanceKm;
  int? get maximumDistanceKm => _$this._maximumDistanceKm;
  set maximumDistanceKm(int? maximumDistanceKm) =>
      _$this._maximumDistanceKm = maximumDistanceKm;

  String? _coverageNotes;
  String? get coverageNotes => _$this._coverageNotes;
  set coverageNotes(String? coverageNotes) =>
      _$this._coverageNotes = coverageNotes;

  VendorSetupDraftDeliveryBuilder() {
    VendorSetupDraftDelivery._defaults(this);
  }

  VendorSetupDraftDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maximumDistanceKm = $v.maximumDistanceKm;
      _coverageNotes = $v.coverageNotes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorSetupDraftDelivery other) {
    _$v = other as _$VendorSetupDraftDelivery;
  }

  @override
  void update(void Function(VendorSetupDraftDeliveryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetupDraftDelivery build() => _build();

  _$VendorSetupDraftDelivery _build() {
    final _$result = _$v ??
        _$VendorSetupDraftDelivery._(
          maximumDistanceKm: maximumDistanceKm,
          coverageNotes: coverageNotes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
