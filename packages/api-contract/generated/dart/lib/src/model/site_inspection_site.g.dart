// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_site.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionSite extends SiteInspectionSite {
  @override
  final String locationId;
  @override
  final String? label;
  @override
  final String kind;
  @override
  final String? formattedAddress;

  factory _$SiteInspectionSite(
          [void Function(SiteInspectionSiteBuilder)? updates]) =>
      (SiteInspectionSiteBuilder()..update(updates))._build();

  _$SiteInspectionSite._(
      {required this.locationId,
      this.label,
      required this.kind,
      this.formattedAddress})
      : super._();
  @override
  SiteInspectionSite rebuild(
          void Function(SiteInspectionSiteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionSiteBuilder toBuilder() =>
      SiteInspectionSiteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionSite &&
        locationId == other.locationId &&
        label == other.label &&
        kind == other.kind &&
        formattedAddress == other.formattedAddress;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionSite')
          ..add('locationId', locationId)
          ..add('label', label)
          ..add('kind', kind)
          ..add('formattedAddress', formattedAddress))
        .toString();
  }
}

class SiteInspectionSiteBuilder
    implements Builder<SiteInspectionSite, SiteInspectionSiteBuilder> {
  _$SiteInspectionSite? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  SiteInspectionSiteBuilder() {
    SiteInspectionSite._defaults(this);
  }

  SiteInspectionSiteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _label = $v.label;
      _kind = $v.kind;
      _formattedAddress = $v.formattedAddress;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionSite other) {
    _$v = other as _$SiteInspectionSite;
  }

  @override
  void update(void Function(SiteInspectionSiteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionSite build() => _build();

  _$SiteInspectionSite _build() {
    final _$result = _$v ??
        _$SiteInspectionSite._(
          locationId: BuiltValueNullFieldError.checkNotNull(
              locationId, r'SiteInspectionSite', 'locationId'),
          label: label,
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'SiteInspectionSite', 'kind'),
          formattedAddress: formattedAddress,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
