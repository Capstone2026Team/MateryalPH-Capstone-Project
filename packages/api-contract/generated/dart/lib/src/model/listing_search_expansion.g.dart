// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_expansion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingSearchExpansion extends ListingSearchExpansion {
  @override
  final int? suggestedRadiusKm;
  @override
  final bool requiresConfirmation;

  factory _$ListingSearchExpansion(
          [void Function(ListingSearchExpansionBuilder)? updates]) =>
      (ListingSearchExpansionBuilder()..update(updates))._build();

  _$ListingSearchExpansion._(
      {this.suggestedRadiusKm, required this.requiresConfirmation})
      : super._();
  @override
  ListingSearchExpansion rebuild(
          void Function(ListingSearchExpansionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchExpansionBuilder toBuilder() =>
      ListingSearchExpansionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchExpansion &&
        suggestedRadiusKm == other.suggestedRadiusKm &&
        requiresConfirmation == other.requiresConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, suggestedRadiusKm.hashCode);
    _$hash = $jc(_$hash, requiresConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingSearchExpansion')
          ..add('suggestedRadiusKm', suggestedRadiusKm)
          ..add('requiresConfirmation', requiresConfirmation))
        .toString();
  }
}

class ListingSearchExpansionBuilder
    implements Builder<ListingSearchExpansion, ListingSearchExpansionBuilder> {
  _$ListingSearchExpansion? _$v;

  int? _suggestedRadiusKm;
  int? get suggestedRadiusKm => _$this._suggestedRadiusKm;
  set suggestedRadiusKm(int? suggestedRadiusKm) =>
      _$this._suggestedRadiusKm = suggestedRadiusKm;

  bool? _requiresConfirmation;
  bool? get requiresConfirmation => _$this._requiresConfirmation;
  set requiresConfirmation(bool? requiresConfirmation) =>
      _$this._requiresConfirmation = requiresConfirmation;

  ListingSearchExpansionBuilder() {
    ListingSearchExpansion._defaults(this);
  }

  ListingSearchExpansionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _suggestedRadiusKm = $v.suggestedRadiusKm;
      _requiresConfirmation = $v.requiresConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingSearchExpansion other) {
    _$v = other as _$ListingSearchExpansion;
  }

  @override
  void update(void Function(ListingSearchExpansionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchExpansion build() => _build();

  _$ListingSearchExpansion _build() {
    final _$result = _$v ??
        _$ListingSearchExpansion._(
          suggestedRadiusKm: suggestedRadiusKm,
          requiresConfirmation: BuiltValueNullFieldError.checkNotNull(
              requiresConfirmation,
              r'ListingSearchExpansion',
              'requiresConfirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
