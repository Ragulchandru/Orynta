// lib/features/notes/domain/models/smart_filter.dart
//
// Orynta 2.0 — Notes Smart Filter Types

enum SmartFilter {
  allNotes,
  favorites,
  pinned,
  archived,
  attachments,
  checklists,
  recentlyEdited;
  
  String get label {
    switch (this) {
      case SmartFilter.allNotes:
        return 'All';
      case SmartFilter.favorites:
        return 'Favorites';
      case SmartFilter.pinned:
        return 'Pinned';
      case SmartFilter.archived:
        return 'Archived';
      case SmartFilter.attachments:
        return 'Attachments';
      case SmartFilter.checklists:
        return 'Checklists';
      case SmartFilter.recentlyEdited:
        return 'Recently Edited';
    }
  }
}
