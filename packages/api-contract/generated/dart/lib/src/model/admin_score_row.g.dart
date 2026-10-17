// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_score_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminScoreRow extends AdminScoreRow {
  @override
  final String vendorId;
  @override
  final String storeName;
  @override
  final PublicScores scores;
  @override
  final String? crr;
  @override
  final String? frr;
  @override
  final BuiltMap<String, JsonObject?> sampleCounts;
  @override
  final int activeSuppressions;
  @override
  final int activeExclusions;

  factory _$AdminScoreRow([void Function(AdminScoreRowBuilder)? updates]) =>
      (AdminScoreRowBuilder()..update(updates))._build();

  _$AdminScoreRow._(
      {required this.vendorId,
      required this.storeName,
      required this.scores,
      this.crr,
      this.frr,
      required this.sampleCounts,
      required this.activeSuppressions,
      required this.activeExclusions})
      : super._();
  @override
  AdminScoreRow rebuild(void Function(AdminScoreRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminScoreRowBuilder toBuilder() => AdminScoreRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminScoreRow &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        scores == other.scores &&
        crr == other.crr &&
        frr == other.frr &&
        sampleCounts == other.sampleCounts &&
        activeSuppressions == other.activeSuppressions &&
        activeExclusions == other.activeExclusions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, scores.hashCode);
    _$hash = $jc(_$hash, crr.hashCode);
    _$hash = $jc(_$hash, frr.hashCode);
    _$hash = $jc(_$hash, sampleCounts.hashCode);
    _$hash = $jc(_$hash, activeSuppressions.hashCode);
    _$hash = $jc(_$hash, activeExclusions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminScoreRow')
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('scores', scores)
          ..add('crr', crr)
          ..add('frr', frr)
          ..add('sampleCounts', sampleCounts)
          ..add('activeSuppressions', activeSuppressions)
          ..add('activeExclusions', activeExclusions))
        .toString();
  }
}

class AdminScoreRowBuilder
    implements Builder<AdminScoreRow, AdminScoreRowBuilder> {
  _$AdminScoreRow? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  PublicScoresBuilder? _scores;
  PublicScoresBuilder get scores => _$this._scores ??= PublicScoresBuilder();
  set scores(PublicScoresBuilder? scores) => _$this._scores = scores;

  String? _crr;
  String? get crr => _$this._crr;
  set crr(String? crr) => _$this._crr = crr;

  String? _frr;
  String? get frr => _$this._frr;
  set frr(String? frr) => _$this._frr = frr;

  MapBuilder<String, JsonObject?>? _sampleCounts;
  MapBuilder<String, JsonObject?> get sampleCounts =>
      _$this._sampleCounts ??= MapBuilder<String, JsonObject?>();
  set sampleCounts(MapBuilder<String, JsonObject?>? sampleCounts) =>
      _$this._sampleCounts = sampleCounts;

  int? _activeSuppressions;
  int? get activeSuppressions => _$this._activeSuppressions;
  set activeSuppressions(int? activeSuppressions) =>
      _$this._activeSuppressions = activeSuppressions;

  int? _activeExclusions;
  int? get activeExclusions => _$this._activeExclusions;
  set activeExclusions(int? activeExclusions) =>
      _$this._activeExclusions = activeExclusions;

  AdminScoreRowBuilder() {
    AdminScoreRow._defaults(this);
  }

  AdminScoreRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _scores = $v.scores.toBuilder();
      _crr = $v.crr;
      _frr = $v.frr;
      _sampleCounts = $v.sampleCounts.toBuilder();
      _activeSuppressions = $v.activeSuppressions;
      _activeExclusions = $v.activeExclusions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminScoreRow other) {
    _$v = other as _$AdminScoreRow;
  }

  @override
  void update(void Function(AdminScoreRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminScoreRow build() => _build();

  _$AdminScoreRow _build() {
    _$AdminScoreRow _$result;
    try {
      _$result = _$v ??
          _$AdminScoreRow._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'AdminScoreRow', 'vendorId'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'AdminScoreRow', 'storeName'),
            scores: scores.build(),
            crr: crr,
            frr: frr,
            sampleCounts: sampleCounts.build(),
            activeSuppressions: BuiltValueNullFieldError.checkNotNull(
                activeSuppressions, r'AdminScoreRow', 'activeSuppressions'),
            activeExclusions: BuiltValueNullFieldError.checkNotNull(
                activeExclusions, r'AdminScoreRow', 'activeExclusions'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scores';
        scores.build();

        _$failedField = 'sampleCounts';
        sampleCounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminScoreRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
