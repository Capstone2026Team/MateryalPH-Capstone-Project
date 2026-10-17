// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_vendor_card.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingVendorCard extends ListingVendorCard {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final ScoreLabel scoreLabel;
  @override
  final bool vacationMode;
  @override
  final BuiltList<PublicBadge>? badges;

  factory _$ListingVendorCard(
          [void Function(ListingVendorCardBuilder)? updates]) =>
      (ListingVendorCardBuilder()..update(updates))._build();

  _$ListingVendorCard._(
      {required this.id,
      required this.name,
      this.logoUrl,
      required this.scoreLabel,
      required this.vacationMode,
      this.badges})
      : super._();
  @override
  ListingVendorCard rebuild(void Function(ListingVendorCardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingVendorCardBuilder toBuilder() =>
      ListingVendorCardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingVendorCard &&
        id == other.id &&
        name == other.name &&
        logoUrl == other.logoUrl &&
        scoreLabel == other.scoreLabel &&
        vacationMode == other.vacationMode &&
        badges == other.badges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, scoreLabel.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingVendorCard')
          ..add('id', id)
          ..add('name', name)
          ..add('logoUrl', logoUrl)
          ..add('scoreLabel', scoreLabel)
          ..add('vacationMode', vacationMode)
          ..add('badges', badges))
        .toString();
  }
}

class ListingVendorCardBuilder
    implements Builder<ListingVendorCard, ListingVendorCardBuilder> {
  _$ListingVendorCard? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  ScoreLabelBuilder? _scoreLabel;
  ScoreLabelBuilder get scoreLabel =>
      _$this._scoreLabel ??= ScoreLabelBuilder();
  set scoreLabel(ScoreLabelBuilder? scoreLabel) =>
      _$this._scoreLabel = scoreLabel;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  ListBuilder<PublicBadge>? _badges;
  ListBuilder<PublicBadge> get badges =>
      _$this._badges ??= ListBuilder<PublicBadge>();
  set badges(ListBuilder<PublicBadge>? badges) => _$this._badges = badges;

  ListingVendorCardBuilder() {
    ListingVendorCard._defaults(this);
  }

  ListingVendorCardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _logoUrl = $v.logoUrl;
      _scoreLabel = $v.scoreLabel.toBuilder();
      _vacationMode = $v.vacationMode;
      _badges = $v.badges?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingVendorCard other) {
    _$v = other as _$ListingVendorCard;
  }

  @override
  void update(void Function(ListingVendorCardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingVendorCard build() => _build();

  _$ListingVendorCard _build() {
    _$ListingVendorCard _$result;
    try {
      _$result = _$v ??
          _$ListingVendorCard._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ListingVendorCard', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ListingVendorCard', 'name'),
            logoUrl: logoUrl,
            scoreLabel: scoreLabel.build(),
            vacationMode: BuiltValueNullFieldError.checkNotNull(
                vacationMode, r'ListingVendorCard', 'vacationMode'),
            badges: _badges?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scoreLabel';
        scoreLabel.build();

        _$failedField = 'badges';
        _badges?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingVendorCard', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
