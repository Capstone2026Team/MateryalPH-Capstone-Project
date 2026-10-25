import 'discovery_models.dart';

enum SupplierListView { verified, directory, favorites }

enum SupplierListSort { nearest, farthest, highestRating, lowestRating }

List<SupplierListView> availableSupplierViews(DiscoveryFilters filters) => [
  if (filters.includeVerified) SupplierListView.verified,
  if (filters.includeDirectory && !filters.tierSpecific)
    SupplierListView.directory,
  SupplierListView.favorites,
];

extension SupplierListViewLabel on SupplierListView {
  String get label => switch (this) {
    SupplierListView.verified => 'Verified',
    SupplierListView.directory => 'Directory',
    SupplierListView.favorites => 'Favorites',
  };
}

extension SupplierListSortLabel on SupplierListSort {
  String label(SupplierListView view) => switch (this) {
    SupplierListSort.nearest => 'Nearest first',
    SupplierListSort.farthest => 'Farthest first',
    SupplierListSort.highestRating =>
      view == SupplierListView.directory
          ? 'Google rating: high to low'
          : 'VPS: high to low',
    SupplierListSort.lowestRating =>
      view == SupplierListView.directory
          ? 'Google rating: low to high'
          : 'VPS: low to high',
  };

  String get shortLabel => switch (this) {
    SupplierListSort.nearest => 'Nearest',
    SupplierListSort.farthest => 'Farthest',
    SupplierListSort.highestRating => 'Highest rated',
    SupplierListSort.lowestRating => 'Lowest rated',
  };
}

/// A presentation of the complete discovery set. Never mutates server order, eligibility or scores.
/// Google ratings are sorted only within Directory; Verified/Favorites use published VPS only, so a
/// Directory Favorite sorts after rated Verified Favorites by distance.
List<SupplierResultView> browseSuppliers(
  Iterable<SupplierResultView> items, {
  required SupplierListView view,
  required SupplierListSort sort,
  String query = '',
}) {
  final words = query.toLowerCase().trim().split(RegExp(r'\s+'));
  final visible = items.where((item) {
    final inView = switch (view) {
      SupplierListView.verified => item.isVerified,
      SupplierListView.directory => !item.isVerified,
      SupplierListView.favorites => item.isFavorite,
    };
    final name = item.name.toLowerCase();
    return inView && words.every(name.contains);
  }).toList();
  int stableOrder(SupplierResultView a, SupplierResultView b) {
    final distance = a.distanceMeters.compareTo(b.distanceMeters);
    if (distance != 0) return distance;
    return a.resultId.compareTo(b.resultId);
  }

  double? rating(SupplierResultView item) {
    if (item.isVerified && item.scoreKind != ScoreKind.vps) return null;
    // VPS and Google ratings are different scales: in Favorites, Directory entries follow by distance.
    if (!item.isVerified && view != SupplierListView.directory) return null;
    final value = double.tryParse(
      item.isVerified ? item.scoreValue ?? '' : item.googleRating ?? '',
    );
    return value != null && value.isFinite && value >= 0 && value <= 5
        ? value
        : null;
  }

  visible.sort((a, b) {
    if (sort == SupplierListSort.nearest) return stableOrder(a, b);
    if (sort == SupplierListSort.farthest) {
      final distance = b.distanceMeters.compareTo(a.distanceMeters);
      return distance != 0 ? distance : a.resultId.compareTo(b.resultId);
    }
    final aRating = rating(a);
    final bRating = rating(b);
    if (aRating == null && bRating != null) return 1;
    if (aRating != null && bRating == null) return -1;
    if (aRating != null && bRating != null) {
      final comparison = sort == SupplierListSort.highestRating
          ? bRating.compareTo(aRating)
          : aRating.compareTo(bRating);
      if (comparison != 0) return comparison;
    }
    return stableOrder(a, b);
  });
  return visible;
}
