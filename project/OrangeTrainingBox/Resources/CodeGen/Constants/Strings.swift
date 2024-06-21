// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Ble {
    internal enum Connection {
      /// Please go to your settings to authorize Baah to use Bluetooth
      internal static let bleAuthorize = L10n.tr("Localizable", "Ble.Connection.BleAuthorize", fallback: "Please go to your settings to authorize Baah to use Bluetooth")
      /// Activate Bluetooth to connect to the BaahBox
      internal static let bleSwitchON = L10n.tr("Localizable", "Ble.Connection.BleSwitchON", fallback: "Activate Bluetooth to connect to the BaahBox")
      /// Please select a BaahBox in the list below
      internal static let description = L10n.tr("Localizable", "Ble.Connection.Description", fallback: "Please select a BaahBox in the list below")
      /// Connect your BaahBox
      internal static let header = L10n.tr("Localizable", "Ble.Connection.Header", fallback: "Connect your BaahBox")
      /// Please select your BaahBox and start practicing
      internal static let popupTitle = L10n.tr("Localizable", "Ble.Connection.PopupTitle", fallback: "Please select your BaahBox and start practicing")
      /// Connection settings
      internal static let title = L10n.tr("Localizable", "Ble.Connection.Title", fallback: "Connection settings")
    }
  }
  internal enum Dashboard {
    /// Select your game
    internal static let header = L10n.tr("Localizable", "Dashboard.header", fallback: "Select your game")
    /// Baah!
    internal static let title = L10n.tr("Localizable", "Dashboard.title", fallback: "Baah!")
  }
  internal enum Game {
    /// Great !
    internal static let congrats = L10n.tr("Localizable", "Game.Congrats", fallback: "Great !")
    /// Let's play !
    internal static let go = L10n.tr("Localizable", "Game.Go", fallback: "Let's play !")
    /// Hop !
    internal static let hop = L10n.tr("Localizable", "Game.Hop", fallback: "Hop !")
    /// Keep going !
    internal static let keepGoing = L10n.tr("Localizable", "Game.KeepGoing", fallback: "Keep going !")
    /// Ooops!
    internal static let oops = L10n.tr("Localizable", "Game.Oops", fallback: "Ooops!")
    /// Restart
    internal static let reStart = L10n.tr("Localizable", "Game.ReStart", fallback: "Restart")
    /// Start
    internal static let start = L10n.tr("Localizable", "Game.Start", fallback: "Start")
    /// Stop
    internal static let stop = L10n.tr("Localizable", "Game.Stop", fallback: "Stop")
    /// Try again
    internal static let tryAgain = L10n.tr("Localizable", "Game.TryAgain", fallback: "Try again")
    /// Wahoo !
    internal static let wahoo = L10n.tr("Localizable", "Game.Wahoo", fallback: "Wahoo !")
    /// Well done !
    internal static let wellDone = L10n.tr("Localizable", "Game.WellDone", fallback: "Well done !")
    /// You won !
    internal static let win = L10n.tr("Localizable", "Game.Win", fallback: "You won !")
    internal enum Balloon {
      /// Blow me up !
      internal static let title = L10n.tr("Localizable", "Game.Balloon.title", fallback: "Blow me up !")
      internal enum Congrats {
        /// Whaoooo !
        internal static let first = L10n.tr("Localizable", "Game.Balloon.congrats.first", fallback: "Whaoooo !")
        /// Great !!!
        internal static let second = L10n.tr("Localizable", "Game.Balloon.congrats.second", fallback: "Great !!!")
      }
      internal enum Text {
        /// Almost there !
        internal static let almostDone = L10n.tr("Localizable", "Game.Balloon.text.almostDone", fallback: "Almost there !")
        /// Well Done !
        internal static let congrats = L10n.tr("Localizable", "Game.Balloon.text.congrats", fallback: "Well Done !")
        /// Inflate the balloon
        internal static let first = L10n.tr("Localizable", "Game.Balloon.text.first", fallback: "Inflate the balloon")
        /// Let's go !
        internal static let letsGo = L10n.tr("Localizable", "Game.Balloon.text.letsGo", fallback: "Let's go !")
        /// with the joystick up
        internal static let secondJoystick = L10n.tr("Localizable", "Game.Balloon.text.secondJoystick", fallback: "with the joystick up")
        /// by contracting your muscle
        internal static let secondMuscle = L10n.tr("Localizable", "Game.Balloon.text.secondMuscle", fallback: "by contracting your muscle")
      }
    }
    internal enum Frog {
      /// Slurp !
      internal static let title = L10n.tr("Localizable", "Game.Frog.title", fallback: "Slurp !")
    }
    internal enum Sheep {
      /// Jump, Sheep, Jump !
      internal static let title = L10n.tr("Localizable", "Game.Sheep.title", fallback: "Jump, Sheep, Jump !")
      internal enum Score {
        internal enum Pending {
          /// You jumped over %d fences out of %d !
          internal static func many(_ p1: Int, _ p2: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.pending.many", p1, p2, fallback: "You jumped over %d fences out of %d !")
          }
          /// You jumped over 1 fence out of %d !
          internal static func one(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.pending.one", p1, fallback: "You jumped over 1 fence out of %d !")
          }
        }
        internal enum Result {
          /// You forgot to jump over the fence !
          internal static let allMissed = L10n.tr("Localizable", "Game.Sheep.score.result.allMissed", fallback: "You forgot to jump over the fence !")
          /// You only jumped %d fences out of %d !
          internal static func notEnough(_ p1: Int, _ p2: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.result.notEnough", p1, p2, fallback: "You only jumped %d fences out of %d !")
          }
          /// You jumped over all the fences !
          internal static let win = L10n.tr("Localizable", "Game.Sheep.score.result.win", fallback: "You jumped over all the fences !")
        }
        internal enum Start {
          /// Try to jump over %d fences
          internal static func many(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.start.many", p1, fallback: "Try to jump over %d fences")
          }
          /// Try to jump over 1 fence
          internal static let one = L10n.tr("Localizable", "Game.Sheep.score.start.one", fallback: "Try to jump over 1 fence")
        }
      }
      internal enum Text {
        /// Land before the next fence !
        internal static let goDown = L10n.tr("Localizable", "Game.Sheep.text.goDown", fallback: "Land before the next fence !")
        internal enum Jump {
          /// Make the sheep jump over the fences
          internal static let first = L10n.tr("Localizable", "Game.Sheep.text.Jump.first", fallback: "Make the sheep jump over the fences")
          /// by contracting your muscle
          internal static let second = L10n.tr("Localizable", "Game.Sheep.text.Jump.second", fallback: "by contracting your muscle")
          /// with the joystick up
          internal static let secondJoystick = L10n.tr("Localizable", "Game.Sheep.text.Jump.secondJoystick", fallback: "with the joystick up")
        }
      }
    }
    internal enum Space {
      /// Space Battle !
      internal static let title = L10n.tr("Localizable", "Game.Space.title", fallback: "Space Battle !")
      internal enum Button {
        /// Continue
        internal static let keepGoing = L10n.tr("Localizable", "Game.Space.button.keepGoing", fallback: "Continue")
      }
      internal enum Text {
        /// Try to avoid collisions
        internal static let first = L10n.tr("Localizable", "Game.Space.text.first", fallback: "Try to avoid collisions")
        /// by moving the joystick
        internal static let secondJoystick = L10n.tr("Localizable", "Game.Space.text.secondJoystick", fallback: "by moving the joystick")
        /// by contracting your left or right muscle
        internal static let secondMuscle = L10n.tr("Localizable", "Game.Space.text.secondMuscle", fallback: "by contracting your left or right muscle")
      }
    }
    internal enum Star {
      /// Make the star shine
      internal static let header = L10n.tr("Localizable", "Game.Star.header", fallback: "Make the star shine")
      /// with the joystick up
      internal static let subHeaderJoystick = L10n.tr("Localizable", "Game.Star.subHeaderJoystick", fallback: "with the joystick up")
      /// by contracting your muscle
      internal static let subHeaderMuscle = L10n.tr("Localizable", "Game.Star.subHeaderMuscle", fallback: "by contracting your muscle")
      /// Twinkle twinkle !
      internal static let title = L10n.tr("Localizable", "Game.Star.title", fallback: "Twinkle twinkle !")
      internal enum Text {
        /// Great !!!
        internal static let congrats = L10n.tr("Localizable", "Game.Star.text.congrats", fallback: "Great !!!")
        /// Keep going !
        internal static let keepGoing = L10n.tr("Localizable", "Game.Star.text.keepGoing", fallback: "Keep going !")
      }
    }
  }
  internal enum GeneralParameters {
    internal enum Section {
      internal enum Demo {
        /// Demo mode
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Demo.item1", fallback: "Demo mode")
        /// Select the mode
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Demo.subtitle", fallback: "Select the mode")
        /// Demo mode
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Demo.title", fallback: "Demo mode")
      }
      internal enum Detection {
        /// Sets the threshold to detect the pressure
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Detection.subtitle", fallback: "Sets the threshold to detect the pressure")
        /// Pressure detection threshold
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Detection.title", fallback: "Pressure detection threshold")
      }
      internal enum Muscle {
        /// Muscle 1
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.item1", fallback: "Muscle 1")
        /// Muscle 2
        internal static let item2 = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.item2", fallback: "Muscle 2")
        /// Select the muscle(s) you like to work with
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.subtitle", fallback: "Select the muscle(s) you like to work with")
        /// Working muscle
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.title", fallback: "Working muscle")
      }
      internal enum Sensitivity {
        /// Sensitivity
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Sensitivity.item1", fallback: "Sensitivity")
        /// Sets the sensitivity of the sensors
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Sensitivity.subtitle", fallback: "Sets the sensitivity of the sensors")
        /// Sensitivity
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Sensitivity.title", fallback: "Sensitivity")
      }
      internal enum Sensor {
        /// Sensor
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Sensor.item1", fallback: "Sensor")
        /// Select the sensor you are using
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Sensor.subtitle", fallback: "Select the sensor you are using")
        /// Sensor type
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Sensor.title", fallback: "Sensor type")
      }
    }
    internal enum Header {
      /// General
      internal static let title = L10n.tr("Localizable", "GeneralParameters.header.title", fallback: "General")
    }
  }
  internal enum Generic {
    /// Activate
    internal static let activate = L10n.tr("Localizable", "Generic.Activate", fallback: "Activate")
    /// Bluetooth
    internal static let ble = L10n.tr("Localizable", "Generic.ble", fallback: "Bluetooth")
    /// Both
    internal static let both = L10n.tr("Localizable", "Generic.both", fallback: "Both")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Generic.Cancel", fallback: "Cancel")
    /// Connection
    internal static let connect = L10n.tr("Localizable", "Generic.Connect", fallback: "Connection")
    /// Disconnect
    internal static let disconnect = L10n.tr("Localizable", "Generic.Disconnect", fallback: "Disconnect")
    /// DONE
    internal static let end = L10n.tr("Localizable", "Generic.End", fallback: "DONE")
    ///  Fast
    internal static let fast = L10n.tr("Localizable", "Generic.fast", fallback: " Fast")
    /// High
    internal static let high = L10n.tr("Localizable", "Generic.high", fallback: "High")
    /// Left
    internal static let `left` = L10n.tr("Localizable", "Generic.left", fallback: "Left")
    /// Low
    internal static let low = L10n.tr("Localizable", "Generic.low", fallback: "Low")
    /// Medium
    internal static let medium = L10n.tr("Localizable", "Generic.medium", fallback: "Medium")
    /// No
    internal static let no = L10n.tr("Localizable", "Generic.No", fallback: "No")
    /// OK
    internal static let ok = L10n.tr("Localizable", "Generic.Ok", fallback: "OK")
    /// Regular
    internal static let regular = L10n.tr("Localizable", "Generic.regular", fallback: "Regular")
    /// Right
    internal static let `right` = L10n.tr("Localizable", "Generic.right", fallback: "Right")
    /// Save
    internal static let save = L10n.tr("Localizable", "Generic.Save", fallback: "Save")
    /// Slow
    internal static let slow = L10n.tr("Localizable", "Generic.slow", fallback: "Slow")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "Generic.Yes", fallback: "Yes")
  }
  internal enum MainParameters {
    /// About
    internal static let about = L10n.tr("Localizable", "MainParameters.about", fallback: "About")
    /// Connection
    internal static let connection = L10n.tr("Localizable", "MainParameters.connection", fallback: "Connection")
    /// General
    internal static let general = L10n.tr("Localizable", "MainParameters.general", fallback: "General")
    internal enum Connection {
      /// Connection settings
      internal static let title = L10n.tr("Localizable", "MainParameters.connection.title", fallback: "Connection settings")
    }
    internal enum Games {
      /// Inflate the balloon
      internal static let balloon = L10n.tr("Localizable", "MainParameters.games.balloon", fallback: "Inflate the balloon")
      /// Jump, Sheep, Jump !
      internal static let sheep = L10n.tr("Localizable", "MainParameters.games.sheep", fallback: "Jump, Sheep, Jump !")
      /// Space Battle
      internal static let spaceShip = L10n.tr("Localizable", "MainParameters.games.spaceShip", fallback: "Space Battle")
      /// Make the star shine
      internal static let star = L10n.tr("Localizable", "MainParameters.games.star", fallback: "Make the star shine")
      /// Eat the flies
      internal static let taud = L10n.tr("Localizable", "MainParameters.games.taud", fallback: "Eat the flies")
      /// Game settings
      internal static let title = L10n.tr("Localizable", "MainParameters.games.title", fallback: "Game settings")
    }
    internal enum General {
      /// Global settings
      internal static let title = L10n.tr("Localizable", "MainParameters.general.title", fallback: "Global settings")
    }
    internal enum Header {
      /// Parameters
      internal static let title = L10n.tr("Localizable", "MainParameters.header.title", fallback: "Parameters")
    }
  }
  internal enum Notif {
    internal enum Ble {
      /// kBLEPeripheralAuthorizationNotification
      internal static let authorization = L10n.tr("Localizable", "Notif.BLE.Authorization", fallback: "kBLEPeripheralAuthorizationNotification")
      /// kBLEPeripheralConnectionNotification
      internal static let connection = L10n.tr("Localizable", "Notif.BLE.Connection", fallback: "kBLEPeripheralConnectionNotification")
      /// kBLEDataReceivedNotification
      internal static let dataReceived = L10n.tr("Localizable", "Notif.BLE.DataReceived", fallback: "kBLEDataReceivedNotification")
      /// kBLEPeripheralDisconnectionNotification
      internal static let disconnection = L10n.tr("Localizable", "Notif.BLE.Disconnection", fallback: "kBLEPeripheralDisconnectionNotification")
      /// kBLEPeripheralDiscoveryNotification
      internal static let discovery = L10n.tr("Localizable", "Notif.BLE.Discovery", fallback: "kBLEPeripheralDiscoveryNotification")
      /// kBLEUPNotification
      internal static let down = L10n.tr("Localizable", "Notif.BLE.Down", fallback: "kBLEUPNotification")
      /// kBLEUPNotification
      internal static let up = L10n.tr("Localizable", "Notif.BLE.Up", fallback: "kBLEUPNotification")
    }
    internal enum Parameter {
      /// kParameterUpdate
      internal static let update = L10n.tr("Localizable", "Notif.Parameter.update", fallback: "kParameterUpdate")
    }
  }
  internal enum Parameters {
    internal enum Global {
      /// Working muscle
      internal static let muscle = L10n.tr("Localizable", "Parameters.Global.muscle", fallback: "Working muscle")
      /// Sensitivity
      internal static let sensitivity = L10n.tr("Localizable", "Parameters.Global.sensitivity", fallback: "Sensitivity")
      /// Threshold level
      internal static let threshold = L10n.tr("Localizable", "Parameters.Global.threshold", fallback: "Threshold level")
      /// Global parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Global.title", fallback: "Global parameters")
      internal enum Sensor {
        /// Button
        internal static let button = L10n.tr("Localizable", "Parameters.Global.sensor.button", fallback: "Button")
        /// Joystick
        internal static let joystick = L10n.tr("Localizable", "Parameters.Global.sensor.joystick", fallback: "Joystick")
        /// Muscle
        internal static let muscle = L10n.tr("Localizable", "Parameters.Global.sensor.muscle", fallback: "Muscle")
      }
    }
    internal enum Sheep {
      /// Number of fences
      internal static let fence = L10n.tr("Localizable", "Parameters.Sheep.fence", fallback: "Number of fences")
      /// Speed
      internal static let speed = L10n.tr("Localizable", "Parameters.Sheep.speed", fallback: "Speed")
      /// Saute-Mouton game parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Sheep.title", fallback: "Saute-Mouton game parameters")
    }
    internal enum Ship {
      /// Particles
      internal static let explosionStyle = L10n.tr("Localizable", "Parameters.Ship.explosionStyle", fallback: "Particles")
      /// Number of ships
      internal static let number = L10n.tr("Localizable", "Parameters.Ship.number", fallback: "Number of ships")
      /// Speed of asteroids
      internal static let speed = L10n.tr("Localizable", "Parameters.Ship.speed", fallback: "Speed of asteroids")
      /// Space Battle game parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Ship.title", fallback: "Space Battle game parameters")
    }
    internal enum Taud {
      /// Number of flies
      internal static let number = L10n.tr("Localizable", "Parameters.Taud.number", fallback: "Number of flies")
      /// Automatic shoots
      internal static let shootStyle = L10n.tr("Localizable", "Parameters.Taud.shootStyle", fallback: "Automatic shoots")
      /// Time during which the fly does not move
      internal static let time = L10n.tr("Localizable", "Parameters.Taud.time", fallback: "Time during which the fly does not move")
      /// %@ s
      internal static func timeValue(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Parameters.Taud.timeValue", String(describing: p1), fallback: "%@ s")
      }
      /// Taud game parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Taud.title", fallback: "Taud game parameters")
    }
  }
  internal enum Settings {
    internal enum About {
      /// Orange Property. All rights reserved.
      internal static let copyright = L10n.tr("Localizable", "Settings.About.Copyright", fallback: "Orange Property. All rights reserved.")
      /// Legal Notices
      internal static let legalNotices = L10n.tr("Localizable", "Settings.About.LegalNotices", fallback: "Legal Notices")
      /// Terms of Use
      internal static let termsOfUse = L10n.tr("Localizable", "Settings.About.TermsOfUse", fallback: "Terms of Use")
      /// About
      internal static let title = L10n.tr("Localizable", "Settings.About.title", fallback: "About")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
