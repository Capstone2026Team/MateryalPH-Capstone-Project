// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_quotation_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamQuotationPerformance extends VendorTeamQuotationPerformance {
  @override
  final int drafts;
  @override
  final int published;
  @override
  final int accepted;

  factory _$VendorTeamQuotationPerformance(
          [void Function(VendorTeamQuotationPerformanceBuilder)? updates]) =>
      (VendorTeamQuotationPerformanceBuilder()..update(updates))._build();

  _$VendorTeamQuotationPerformance._(
      {required this.drafts, required this.published, required this.accepted})
      : super._();
  @override
  VendorTeamQuotationPerformance rebuild(
          void Function(VendorTeamQuotationPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamQuotationPerformanceBuilder toBuilder() =>
      VendorTeamQuotationPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamQuotationPerformance &&
        drafts == other.drafts &&
        published == other.published &&
        accepted == other.accepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, drafts.hashCode);
    _$hash = $jc(_$hash, published.hashCode);
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamQuotationPerformance')
          ..add('drafts', drafts)
          ..add('published', published)
          ..add('accepted', accepted))
        .toString();
  }
}

class VendorTeamQuotationPerformanceBuilder
    implements
        Builder<VendorTeamQuotationPerformance,
            VendorTeamQuotationPerformanceBuilder> {
  _$VendorTeamQuotationPerformance? _$v;

  int? _drafts;
  int? get drafts => _$this._drafts;
  set drafts(int? drafts) => _$this._drafts = drafts;

  int? _published;
  int? get published => _$this._published;
  set published(int? published) => _$this._published = published;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  VendorTeamQuotationPerformanceBuilder() {
    VendorTeamQuotationPerformance._defaults(this);
  }

  VendorTeamQuotationPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _drafts = $v.drafts;
      _published = $v.published;
      _accepted = $v.accepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamQuotationPerformance other) {
    _$v = other as _$VendorTeamQuotationPerformance;
  }

  @override
  void update(void Function(VendorTeamQuotationPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamQuotationPerformance build() => _build();

  _$VendorTeamQuotationPerformance _build() {
    final _$result = _$v ??
        _$VendorTeamQuotationPerformance._(
          drafts: BuiltValueNullFieldError.checkNotNull(
              drafts, r'VendorTeamQuotationPerformance', 'drafts'),
          published: BuiltValueNullFieldError.checkNotNull(
              published, r'VendorTeamQuotationPerformance', 'published'),
          accepted: BuiltValueNullFieldError.checkNotNull(
              accepted, r'VendorTeamQuotationPerformance', 'accepted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
