// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<MovieList.MainViewController>(storyboard: Main.self)
  }
  internal enum MovieDetail: StoryboardType {
    internal static let storyboardName = "MovieDetail"

    internal static let initialScene = InitialSceneType<MovieList.MovieDetailViewController>(storyboard: MovieDetail.self)
  }
  internal enum Movies: StoryboardType {
    internal static let storyboardName = "Movies"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Movies.self)

    internal static let moviesNavigationController = SceneType<UIKit.UINavigationController>(storyboard: Movies.self, identifier: "MoviesNavigationController")

    internal static let moviesTableViewController = SceneType<MovieList.MoviesTableViewController>(storyboard: Movies.self, identifier: "MoviesTableViewController")
  }
  internal enum NewCategory: StoryboardType {
    internal static let storyboardName = "NewCategory"

    internal static let initialScene = InitialSceneType<MovieList.NewCategoryTableViewController>(storyboard: NewCategory.self)
  }
  internal enum NewMovie: StoryboardType {
    internal static let storyboardName = "NewMovie"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: NewMovie.self)
  }
  internal enum Notification: StoryboardType {
    internal static let storyboardName = "Notification"

    internal static let initialScene = InitialSceneType<MovieList.NotificationViewController>(storyboard: Notification.self)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
