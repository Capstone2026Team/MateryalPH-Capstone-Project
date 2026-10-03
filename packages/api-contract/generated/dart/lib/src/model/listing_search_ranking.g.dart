// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_ranking.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingSearchRanking extends ListingSearchRanking {
  @override
  final RankingWeightSet weights;
  @override
  final bool personalized;
  @override
  final RankingWeightSet defaultWeights;
  @override
  final BuiltList<String> tieBreakers;

  factory _$ListingSearchRanking(
          [void Function(ListingSearchRankingBuilder)? updates]) =>
      (ListingSearchRankingBuilder()..update(updates))._build();

  _$ListingSearchRanking._(
      {required this.weights,
      required this.personalized,
      required this.defaultWeights,
      required this.tieBreakers})
      : super._();
  @override
  ListingSearchRanking rebuild(
          void Function(ListingSearchRankingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchRankingBuilder toBuilder() =>
      ListingSearchRankingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchRanking &&
        weights == other.weights &&
        personalized == other.personalized &&
        defaultWeights == other.defaultWeights &&
        tieBreakers == other.tieBreakers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weights.hashCode);
    _$hash = $jc(_$hash, personalized.hashCode);
    _$hash = $jc(_$hash, defaultWeights.hashCode);
    _$hash = $jc(_$hash, tieBreakers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingSearchRanking')
          ..add('weights', weights)
          ..add('personalized', personalized)
          ..add('defaultWeights', defaultWeights)
          ..add('tieBreakers', tieBreakers))
        .toString();
  }
}

class ListingSearchRankingBuilder
    implements Builder<ListingSearchRanking, ListingSearchRankingBuilder> {
  _$ListingSearchRanking? _$v;

  RankingWeightSetBuilder? _weights;
  RankingWeightSetBuilder get weights =>
      _$this._weights ??= RankingWeightSetBuilder();
  set weights(RankingWeightSetBuilder? weights) => _$this._weights = weights;

  bool? _personalized;
  bool? get personalized => _$this._personalized;
  set personalized(bool? personalized) => _$this._personalized = personalized;

  RankingWeightSetBuilder? _defaultWeights;
  RankingWeightSetBuilder get defaultWeights =>
      _$this._defaultWeights ??= RankingWeightSetBuilder();
  set defaultWeights(RankingWeightSetBuilder? defaultWeights) =>
      _$this._defaultWeights = defaultWeights;

  ListBuilder<String>? _tieBreakers;
  ListBuilder<String> get tieBreakers =>
      _$this._tieBreakers ??= ListBuilder<String>();
  set tieBreakers(ListBuilder<String>? tieBreakers) =>
      _$this._tieBreakers = tieBreakers;

  ListingSearchRankingBuilder() {
    ListingSearchRanking._defaults(this);
  }

  ListingSearchRankingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weights = $v.weights.toBuilder();
      _personalized = $v.personalized;
      _defaultWeights = $v.defaultWeights.toBuilder();
      _tieBreakers = $v.tieBreakers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingSearchRanking other) {
    _$v = other as _$ListingSearchRanking;
  }

  @override
  void update(void Function(ListingSearchRankingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchRanking build() => _build();

  _$ListingSearchRanking _build() {
    _$ListingSearchRanking _$result;
    try {
      _$result = _$v ??
          _$ListingSearchRanking._(
            weights: weights.build(),
            personalized: BuiltValueNullFieldError.checkNotNull(
                personalized, r'ListingSearchRanking', 'personalized'),
            defaultWeights: defaultWeights.build(),
            tieBreakers: tieBreakers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weights';
        weights.build();

        _$failedField = 'defaultWeights';
        defaultWeights.build();
        _$failedField = 'tieBreakers';
        tieBreakers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingSearchRanking', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
