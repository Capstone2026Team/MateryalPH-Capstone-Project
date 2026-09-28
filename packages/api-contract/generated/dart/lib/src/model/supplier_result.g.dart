// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupplierResult extends SupplierResult {
  @override
  final String resultId;
  @override
  final SupplierTier tier;
  @override
  final String tierLabel;
  @override
  final int rank;
  @override
  final String name;
  @override
  final MapPoint marker;
  @override
  final int distanceMeters;
  @override
  final ScoreLabel scoreLabel;
  @override
  final bool isFavorite;
  @override
  final VerifiedVendorSummary? vendor;
  @override
  final DirectorySupplierSummary? directory;

  factory _$SupplierResult([void Function(SupplierResultBuilder)? updates]) =>
      (SupplierResultBuilder()..update(updates))._build();

  _$SupplierResult._(
      {required this.resultId,
      required this.tier,
      required this.tierLabel,
      required this.rank,
      required this.name,
      required this.marker,
      required this.distanceMeters,
      required this.scoreLabel,
      required this.isFavorite,
      this.vendor,
      this.directory})
      : super._();
  @override
  SupplierResult rebuild(void Function(SupplierResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupplierResultBuilder toBuilder() => SupplierResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupplierResult &&
        resultId == other.resultId &&
        tier == other.tier &&
        tierLabel == other.tierLabel &&
        rank == other.rank &&
        name == other.name &&
        marker == other.marker &&
        distanceMeters == other.distanceMeters &&
        scoreLabel == other.scoreLabel &&
        isFavorite == other.isFavorite &&
        vendor == other.vendor &&
        directory == other.directory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resultId.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, tierLabel.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, marker.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, scoreLabel.hashCode);
    _$hash = $jc(_$hash, isFavorite.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, directory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupplierResult')
          ..add('resultId', resultId)
          ..add('tier', tier)
          ..add('tierLabel', tierLabel)
          ..add('rank', rank)
          ..add('name', name)
          ..add('marker', marker)
          ..add('distanceMeters', distanceMeters)
          ..add('scoreLabel', scoreLabel)
          ..add('isFavorite', isFavorite)
          ..add('vendor', vendor)
          ..add('directory', directory))
        .toString();
  }
}

class SupplierResultBuilder
    implements Builder<SupplierResult, SupplierResultBuilder> {
  _$SupplierResult? _$v;

  String? _resultId;
  String? get resultId => _$this._resultId;
  set resultId(String? resultId) => _$this._resultId = resultId;

  SupplierTier? _tier;
  SupplierTier? get tier => _$this._tier;
  set tier(SupplierTier? tier) => _$this._tier = tier;

  String? _tierLabel;
  String? get tierLabel => _$this._tierLabel;
  set tierLabel(String? tierLabel) => _$this._tierLabel = tierLabel;

  int? _rank;
  int? get rank => _$this._rank;
  set rank(int? rank) => _$this._rank = rank;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MapPointBuilder? _marker;
  MapPointBuilder get marker => _$this._marker ??= MapPointBuilder();
  set marker(MapPointBuilder? marker) => _$this._marker = marker;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  ScoreLabelBuilder? _scoreLabel;
  ScoreLabelBuilder get scoreLabel =>
      _$this._scoreLabel ??= ScoreLabelBuilder();
  set scoreLabel(ScoreLabelBuilder? scoreLabel) =>
      _$this._scoreLabel = scoreLabel;

  bool? _isFavorite;
  bool? get isFavorite => _$this._isFavorite;
  set isFavorite(bool? isFavorite) => _$this._isFavorite = isFavorite;

  VerifiedVendorSummaryBuilder? _vendor;
  VerifiedVendorSummaryBuilder get vendor =>
      _$this._vendor ??= VerifiedVendorSummaryBuilder();
  set vendor(VerifiedVendorSummaryBuilder? vendor) => _$this._vendor = vendor;

  DirectorySupplierSummaryBuilder? _directory;
  DirectorySupplierSummaryBuilder get directory =>
      _$this._directory ??= DirectorySupplierSummaryBuilder();
  set directory(DirectorySupplierSummaryBuilder? directory) =>
      _$this._directory = directory;

  SupplierResultBuilder() {
    SupplierResult._defaults(this);
  }

  SupplierResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resultId = $v.resultId;
      _tier = $v.tier;
      _tierLabel = $v.tierLabel;
      _rank = $v.rank;
      _name = $v.name;
      _marker = $v.marker.toBuilder();
      _distanceMeters = $v.distanceMeters;
      _scoreLabel = $v.scoreLabel.toBuilder();
      _isFavorite = $v.isFavorite;
      _vendor = $v.vendor?.toBuilder();
      _directory = $v.directory?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupplierResult other) {
    _$v = other as _$SupplierResult;
  }

  @override
  void update(void Function(SupplierResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupplierResult build() => _build();

  _$SupplierResult _build() {
    _$SupplierResult _$result;
    try {
      _$result = _$v ??
          _$SupplierResult._(
            resultId: BuiltValueNullFieldError.checkNotNull(
                resultId, r'SupplierResult', 'resultId'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'SupplierResult', 'tier'),
            tierLabel: BuiltValueNullFieldError.checkNotNull(
                tierLabel, r'SupplierResult', 'tierLabel'),
            rank: BuiltValueNullFieldError.checkNotNull(
                rank, r'SupplierResult', 'rank'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'SupplierResult', 'name'),
            marker: marker.build(),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'SupplierResult', 'distanceMeters'),
            scoreLabel: scoreLabel.build(),
            isFavorite: BuiltValueNullFieldError.checkNotNull(
                isFavorite, r'SupplierResult', 'isFavorite'),
            vendor: _vendor?.build(),
            directory: _directory?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'marker';
        marker.build();

        _$failedField = 'scoreLabel';
        scoreLabel.build();

        _$failedField = 'vendor';
        _vendor?.build();
        _$failedField = 'directory';
        _directory?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SupplierResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
