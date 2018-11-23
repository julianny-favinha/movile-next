// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Auto play
  internal static let autoPlay = L10n.tr("Localizable", "AUTO_PLAY")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "CANCEL")
  /// Category already exists.
  internal static let categoryExists = L10n.tr("Localizable", "CATEGORY_EXISTS")
  /// Color
  internal static let color = L10n.tr("Localizable", "COLOR")
  /// Some fields must be completed
  internal static let completeFields = L10n.tr("Localizable", "COMPLETE_FIELDS")
  /// Dark
  internal static let dark = L10n.tr("Localizable", "DARK")
  /// Edit movie
  internal static let editMovie = L10n.tr("Localizable", "EDIT_MOVIE")
  /// Field is empty.
  internal static let emptyField = L10n.tr("Localizable", "EMPTY_FIELD")
  /// Enter a category name
  internal static let enterCategoryName = L10n.tr("Localizable", "ENTER_CATEGORY_NAME")
  /// Light
  internal static let light = L10n.tr("Localizable", "LIGHT")
  /// Movies
  internal static let movies = L10n.tr("Localizable", "MOVIES")
  /// Name
  internal static let name = L10n.tr("Localizable", "NAME")
  /// New Category
  internal static let newCategory = L10n.tr("Localizable", "NEW_CATEGORY")
  /// OK
  internal static let ok = L10n.tr("Localizable", "OK")
  /// Oops!
  internal static let oops = L10n.tr("Localizable", "OOPS")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "SETTINGS")
  /// So much fun!
  internal static let soMuchFun = L10n.tr("Localizable", "SO_MUCH_FUN")
  /// Wait!
  internal static let wait = L10n.tr("Localizable", "WAIT")
  /// Watch now the movie
  internal static let watchNowTheMovie = L10n.tr("Localizable", "WATCH_NOW_THE_MOVIE")
  /// You don't have any categories yet. \nStart creating one in the + button above!
  internal static let zeroCategories = L10n.tr("Localizable", "ZERO_CATEGORIES")
  /// You don't have any movies yet. \nStart creating one in the + button above!
  internal static let zeroMovies = L10n.tr("Localizable", "ZERO_MOVIES")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
