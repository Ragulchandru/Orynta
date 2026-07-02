// lib/core/design_system/icons/app_icons.dart
//
// Orynta 2.0 — Icon Tokens
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Centralizing icon references in one file provides:
//   • Easy icon swaps — change one constant to update all usage
//   • Consistent icon style (rounded vs sharp vs outlined)
//   • Searchable semantic names instead of hunting for the right Icon()
//
// Style: Material Symbols / Icons — Rounded variant.
// Rounded corners feel friendlier and match Orynta's premium-yet-approachable
// design language.
//
// For each feature section, BOTH outlined (inactive) and filled/rounded
// (active) variants are provided.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   Icon(AppIcons.notes)
//   Icon(isActive ? AppIcons.notesActive : AppIcons.notes)
//   Icon(AppIcons.settings, size: AppDimensions.iconMd)

import 'package:flutter/material.dart';

/// Named icon constants grouped by feature area for Orynta 2.0.
abstract final class AppIcons {
  // ─── Navigation — Bottom Bar ──────────────────────────────────────────────

  /// Today / Dashboard — outlined (inactive)
  static const IconData today = Icons.today_outlined;

  /// Today / Dashboard — filled (active)
  static const IconData todayActive = Icons.today_rounded;

  /// Notes — outlined (inactive)
  static const IconData notes = Icons.sticky_note_2_outlined;

  /// Notes — filled (active)
  static const IconData notesActive = Icons.sticky_note_2_rounded;

  /// Planner — outlined (inactive)
  static const IconData planner = Icons.calendar_month_outlined;

  /// Planner — filled (active)
  static const IconData plannerActive = Icons.calendar_month_rounded;

  /// Insights / Analytics — outlined (inactive)
  static const IconData insights = Icons.insights_outlined;

  /// Insights / Analytics — filled (active)
  static const IconData insightsActive = Icons.insights_rounded;

  /// Dashboard — outlined
  static const IconData dashboard = Icons.dashboard_outlined;

  /// Dashboard — filled
  static const IconData dashboardActive = Icons.dashboard_rounded;

  // ─── Navigation — Side / Drawer ───────────────────────────────────────────

  /// Analytics screen
  static const IconData analytics = Icons.bar_chart_rounded;

  /// Settings screen
  static const IconData settings = Icons.settings_outlined;

  /// Settings — active
  static const IconData settingsActive = Icons.settings_rounded;

  // ─── Notes Feature ────────────────────────────────────────────────────────

  /// Create new note
  static const IconData noteAdd = Icons.note_add_outlined;

  /// Note edit / pen
  static const IconData noteEdit = Icons.edit_outlined;

  /// Note title / heading
  static const IconData noteTitle = Icons.title_rounded;

  /// Archive note
  static const IconData archive = Icons.archive_outlined;

  /// Archive — filled
  static const IconData archiveActive = Icons.archive_rounded;

  /// Trash / delete note (moved to trash)
  static const IconData trash = Icons.delete_outline_rounded;

  /// Trash — filled
  static const IconData trashActive = Icons.delete_rounded;

  /// Restore from trash
  static const IconData restore = Icons.restore_from_trash_outlined;

  /// Delete permanently
  static const IconData deletePermanent = Icons.delete_forever_outlined;

  // ─── Planner Feature ──────────────────────────────────────────────────────

  /// Create task
  static const IconData taskAdd = Icons.add_task_outlined;

  /// Task complete / checkbox unchecked
  static const IconData taskUnchecked = Icons.radio_button_unchecked_rounded;

  /// Task complete / checkbox checked
  static const IconData taskChecked = Icons.check_circle_rounded;

  /// Checklist / multi-task
  static const IconData checklist = Icons.checklist_rounded;

  /// Priority / flag
  static const IconData priority = Icons.flag_outlined;

  /// Priority — filled
  static const IconData priorityActive = Icons.flag_rounded;

  /// Due date
  static const IconData dueDate = Icons.event_outlined;

  /// Subtask
  static const IconData subtask = Icons.subdirectory_arrow_right_rounded;

  // ─── Calendar Feature ─────────────────────────────────────────────────────

  /// Calendar
  static const IconData calendar = Icons.calendar_today_outlined;

  /// Calendar — filled
  static const IconData calendarActive = Icons.calendar_today_rounded;

  /// Calendar view month
  static const IconData calendarMonth = Icons.calendar_month_outlined;

  /// Calendar week view
  static const IconData calendarWeek = Icons.view_week_outlined;

  /// Upcoming / agenda
  static const IconData agenda = Icons.view_agenda_outlined;

  // ─── Reminders ────────────────────────────────────────────────────────────

  /// Reminder / bell — inactive
  static const IconData reminder = Icons.notifications_outlined;

  /// Reminder / bell — active
  static const IconData reminderActive = Icons.notifications_rounded;

  /// Reminder off
  static const IconData reminderOff = Icons.notifications_off_outlined;

  /// Alarm
  static const IconData alarm = Icons.alarm_rounded;

  // ─── Habits ───────────────────────────────────────────────────────────────

  /// Habit / repeat
  static const IconData habit = Icons.repeat_rounded;

  /// Streak / fire
  static const IconData streak = Icons.local_fire_department_outlined;

  /// Streak — active
  static const IconData streakActive = Icons.local_fire_department_rounded;

  // ─── Focus ────────────────────────────────────────────────────────────────

  /// Focus / timer
  static const IconData focus = Icons.timer_outlined;

  /// Focus — active
  static const IconData focusActive = Icons.timer_rounded;

  /// Focus session start
  static const IconData focusPlay = Icons.play_circle_outlined;

  /// Focus session pause
  static const IconData focusPause = Icons.pause_circle_outlined;

  /// Focus session stop
  static const IconData focusStop = Icons.stop_circle_outlined;

  // ─── Actions ──────────────────────────────────────────────────────────────

  /// Search
  static const IconData search = Icons.search_rounded;

  /// Search — active / filled
  static const IconData searchActive = Icons.manage_search_rounded;

  /// Pin / pinned
  static const IconData pin = Icons.push_pin_outlined;

  /// Pin — active/filled
  static const IconData pinActive = Icons.push_pin_rounded;

  /// Favorite / star — inactive
  static const IconData favorite = Icons.star_outline_rounded;

  /// Favorite / star — active
  static const IconData favoriteActive = Icons.star_rounded;

  /// Share
  static const IconData share = Icons.share_outlined;

  /// Export
  static const IconData export = Icons.ios_share_rounded;

  /// Import
  static const IconData import = Icons.download_for_offline_outlined;

  /// Add / create
  static const IconData add = Icons.add_rounded;

  /// Close / dismiss
  static const IconData close = Icons.close_rounded;

  /// Back arrow
  static const IconData back = Icons.arrow_back_rounded;

  /// Forward arrow
  static const IconData forward = Icons.arrow_forward_rounded;

  /// Chevron right (navigate)
  static const IconData chevronRight = Icons.chevron_right_rounded;

  /// Chevron left
  static const IconData chevronLeft = Icons.chevron_left_rounded;

  /// Chevron down (expand)
  static const IconData chevronDown = Icons.expand_more_rounded;

  /// Chevron up (collapse)
  static const IconData chevronUp = Icons.expand_less_rounded;

  /// More options (kebab / vertical)
  static const IconData more = Icons.more_vert_rounded;

  /// More options (horizontal)
  static const IconData moreHorizontal = Icons.more_horiz_rounded;

  /// Edit / pencil
  static const IconData edit = Icons.edit_rounded;

  /// Delete
  static const IconData delete = Icons.delete_outline_rounded;

  /// Copy
  static const IconData copy = Icons.copy_rounded;

  /// Cut
  static const IconData cut = Icons.content_cut_rounded;

  /// Paste
  static const IconData paste = Icons.content_paste_rounded;

  /// Undo
  static const IconData undo = Icons.undo_rounded;

  /// Redo
  static const IconData redo = Icons.redo_rounded;

  /// Select all
  static const IconData selectAll = Icons.select_all_rounded;

  // ─── Organization ─────────────────────────────────────────────────────────

  /// Folder
  static const IconData folder = Icons.folder_outlined;

  /// Folder — active
  static const IconData folderActive = Icons.folder_rounded;

  /// Tag / label
  static const IconData tag = Icons.label_outlined;

  /// Tag — active
  static const IconData tagActive = Icons.label_rounded;

  /// Category
  static const IconData category = Icons.category_outlined;

  /// Sort
  static const IconData sort = Icons.sort_rounded;

  /// Filter
  static const IconData filter = Icons.filter_list_rounded;

  /// Grid view
  static const IconData gridView = Icons.grid_view_rounded;

  /// List view
  static const IconData listView = Icons.view_list_rounded;

  // ─── Media & Attachments ──────────────────────────────────────────────────

  /// Image / photo
  static const IconData image = Icons.image_outlined;

  /// Image — filled
  static const IconData imageActive = Icons.image_rounded;

  /// Camera
  static const IconData camera = Icons.camera_alt_outlined;

  /// Attachment
  static const IconData attachment = Icons.attach_file_rounded;

  /// Audio / mic
  static const IconData audio = Icons.mic_outlined;

  /// Drawing / sketch
  static const IconData draw = Icons.draw_outlined;

  // ─── Settings & Security ──────────────────────────────────────────────────

  /// Lock / security
  static const IconData lock = Icons.lock_outlined;

  /// Lock — active
  static const IconData lockActive = Icons.lock_rounded;

  /// Unlock
  static const IconData unlock = Icons.lock_open_outlined;

  /// Fingerprint
  static const IconData biometric = Icons.fingerprint_rounded;

  /// Backup
  static const IconData backup = Icons.backup_outlined;

  /// Backup — active
  static const IconData backupActive = Icons.backup_rounded;

  /// Sync
  static const IconData sync = Icons.sync_rounded;

  /// Cloud
  static const IconData cloud = Icons.cloud_outlined;

  /// Cloud done
  static const IconData cloudDone = Icons.cloud_done_outlined;

  // ─── Status / Feedback ────────────────────────────────────────────────────

  /// Check / success
  static const IconData check = Icons.check_rounded;

  /// Check circle
  static const IconData checkCircle = Icons.check_circle_outline_rounded;

  /// Check circle — filled
  static const IconData checkCircleActive = Icons.check_circle_rounded;

  /// Error / warning
  static const IconData error = Icons.error_outline_rounded;

  /// Info
  static const IconData info = Icons.info_outline_rounded;

  /// Warning triangle
  static const IconData warning = Icons.warning_amber_rounded;

  // ─── Misc UI ──────────────────────────────────────────────────────────────

  /// Color palette
  static const IconData colorPalette = Icons.palette_outlined;

  /// Moon / dark mode
  static const IconData darkMode = Icons.dark_mode_outlined;

  /// Sun / light mode
  static const IconData lightMode = Icons.light_mode_outlined;

  /// System / auto
  static const IconData systemMode = Icons.brightness_auto_rounded;

  /// Text / font
  static const IconData textFormat = Icons.text_format_rounded;

  /// Bold
  static const IconData bold = Icons.format_bold_rounded;

  /// Italic
  static const IconData italic = Icons.format_italic_rounded;

  /// Underline
  static const IconData underline = Icons.format_underlined_rounded;

  /// Bullet list
  static const IconData bulletList = Icons.format_list_bulleted_rounded;

  /// Numbered list
  static const IconData numberedList = Icons.format_list_numbered_rounded;

  /// Heading
  static const IconData heading = Icons.title_rounded;

  /// Quote
  static const IconData quote = Icons.format_quote_rounded;
}
