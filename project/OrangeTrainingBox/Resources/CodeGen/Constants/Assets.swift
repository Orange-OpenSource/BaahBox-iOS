// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let beurkGreen = ColorAsset(name: "Colors/BeurkGreen")
    internal static let blueGreen = ColorAsset(name: "Colors/BlueGreen")
    internal static let greenDash = ColorAsset(name: "Colors/GreenDash")
    internal static let greyGreen = ColorAsset(name: "Colors/GreyGreen")
    internal static let lightGreen = ColorAsset(name: "Colors/LightGreen")
    internal static let orange = ColorAsset(name: "Colors/Orange")
    internal static let pinky = ColorAsset(name: "Colors/Pinky")
    internal static let violet = ColorAsset(name: "Colors/Violet")
  }
  internal enum Dashboard {
    internal static let balloonMenu = ImageAsset(name: "Dashboard/balloon_menu")
    internal static let battery14 = ImageAsset(name: "Dashboard/battery14")
    internal static let battery34 = ImageAsset(name: "Dashboard/battery34")
    internal static let batteryEmpty = ImageAsset(name: "Dashboard/batteryEmpty")
    internal static let batteryFull = ImageAsset(name: "Dashboard/batteryFull")
    internal static let bluetooth = ImageAsset(name: "Dashboard/bluetooth")
    internal static let capteur = ImageAsset(name: "Dashboard/capteur")
    internal static let connectionHand = ImageAsset(name: "Dashboard/connectionHand")
    internal static let deconnectionHand = ImageAsset(name: "Dashboard/deconnectionHand")
    internal static let demo = ImageAsset(name: "Dashboard/demo")
    internal static let joystick = ImageAsset(name: "Dashboard/joystick")
    internal static let muscle = ImageAsset(name: "Dashboard/muscle")
    internal static let settingsIcon = ImageAsset(name: "Dashboard/settings_icon")
    internal static let sheepMenu = ImageAsset(name: "Dashboard/sheep_menu")
    internal static let spaceshipMenu = ImageAsset(name: "Dashboard/spaceship_menu")
    internal static let starMenu = ImageAsset(name: "Dashboard/star_menu")
    internal static let tick = ImageAsset(name: "Dashboard/tick")
    internal static let toadMenu = ImageAsset(name: "Dashboard/toad_menu")
  }
  internal enum Games {
    internal enum BalloonGame {
      internal static let balloon00 = ImageAsset(name: "Games/BalloonGame/balloon_00")
      internal static let balloon01 = ImageAsset(name: "Games/BalloonGame/balloon_01")
      internal static let balloon02 = ImageAsset(name: "Games/BalloonGame/balloon_02")
      internal static let balloon03 = ImageAsset(name: "Games/BalloonGame/balloon_03")
      internal static let balloon04 = ImageAsset(name: "Games/BalloonGame/balloon_04")
      internal static let balloonHub = ImageAsset(name: "Games/BalloonGame/balloon_hub")
      internal static let blownBallon = ImageAsset(name: "Games/BalloonGame/blown_ballon")
      internal static let pschiitBalloon = ImageAsset(name: "Games/BalloonGame/pschiit_balloon")
    }
    internal enum CrapaudGame {
      internal static let crapaud = ImageAsset(name: "Games/CrapaudGame/crapaud")
      internal static let crapaudCompteurMouchePlein = ImageAsset(name: "Games/CrapaudGame/crapaud_compteur_mouche_plein")
      internal static let crapaudCompteurMoucheVide = ImageAsset(name: "Games/CrapaudGame/crapaud_compteur_mouche_vide")
      internal static let crapaudLangue = ImageAsset(name: "Games/CrapaudGame/crapaud_langue")
      internal static let crapaudMouche = ImageAsset(name: "Games/CrapaudGame/crapaud_mouche")
      internal static let fly = ImageAsset(name: "Games/CrapaudGame/fly")
      internal static let flyPoint0 = ImageAsset(name: "Games/CrapaudGame/fly_point_0")
      internal static let flyPoint1 = ImageAsset(name: "Games/CrapaudGame/fly_point_1")
      internal static let toad = ImageAsset(name: "Games/CrapaudGame/toad")
      internal static let toadBlink = ImageAsset(name: "Games/CrapaudGame/toad_blink")
      internal static let toadMenu = ImageAsset(name: "Games/CrapaudGame/toad_menu")
      internal static let tongue = ImageAsset(name: "Games/CrapaudGame/tongue")
    }
    internal enum SheepGame {
      internal static let bigSheep = ImageAsset(name: "Games/SheepGame/bigSheep")
      internal static let bigSheep2 = ImageAsset(name: "Games/SheepGame/bigSheep2")
      internal static let sheep1 = ImageAsset(name: "Games/SheepGame/sheep1")
      internal static let sheep2 = ImageAsset(name: "Games/SheepGame/sheep2")
      internal static let sheepBang = ImageAsset(name: "Games/SheepGame/sheep_bang")
      internal static let sheepBim = ImageAsset(name: "Games/SheepGame/sheep_bim")
      internal static let sheepBump = ImageAsset(name: "Games/SheepGame/sheep_bump")
      internal static let sheepGate = ImageAsset(name: "Games/SheepGame/sheep_gate")
      internal static let sheepGround = ImageAsset(name: "Games/SheepGame/sheep_ground")
      internal static let sheepJump = ImageAsset(name: "Games/SheepGame/sheep_jump")
    }
    internal enum SpaceshipGame {
      internal static let crash = ImageAsset(name: "Games/SpaceshipGame/crash")
      internal static let meteor00 = ImageAsset(name: "Games/SpaceshipGame/meteor_00")
      internal static let meteor01 = ImageAsset(name: "Games/SpaceshipGame/meteor_01")
      internal static let meteor02 = ImageAsset(name: "Games/SpaceshipGame/meteor_02")
      internal static let meteor03 = ImageAsset(name: "Games/SpaceshipGame/meteor_03")
      internal static let meteor04 = ImageAsset(name: "Games/SpaceshipGame/meteor_04")
      internal static let meteor05 = ImageAsset(name: "Games/SpaceshipGame/meteor_05")
      internal static let spaceLife = ImageAsset(name: "Games/SpaceshipGame/space_life")
      internal static let spaceStar = ImageAsset(name: "Games/SpaceshipGame/space_star")
      internal static let spaceshipLeft = ImageAsset(name: "Games/SpaceshipGame/spaceship_left")
      internal static let spaceshipNml = ImageAsset(name: "Games/SpaceshipGame/spaceship_nml")
      internal static let spaceshipRight = ImageAsset(name: "Games/SpaceshipGame/spaceship_right")
    }
    internal enum StarGame {
      internal static let starBlur = ImageAsset(name: "Games/StarGame/star_blur")
      internal static let starLow = ImageAsset(name: "Games/StarGame/star_low")
    }
  }
  internal static let splashscreenBaah = ImageAsset(name: "splashscreen_baah")
  internal static let splashscreenBaah2 = ImageAsset(name: "splashscreen_baah2")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
