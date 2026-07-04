// lib/features/notes/domain/models/sort_option.dart
//
// Orynta 2.0 — Notes Sort Options

enum SortOption {
  recentlyUpdated,
  oldest,
  alphabetical,
  color,
  favorites,
  pinned;

  String get label {
    switch (this) {
      case SortOption.recentlyUpdated:
        return 'Recently Updated';
      case SortOption.oldest:
        return 'Oldest';
      case SortOption.alphabetical:
        return 'Alphabetical (A-Z)';
      case SortOption.color:
        return 'Color Group';
      case SortOption.favorites:
        return 'Favorites First';
      case SortOption.pinned:
        return 'Pinned First';
    }
  }
}
