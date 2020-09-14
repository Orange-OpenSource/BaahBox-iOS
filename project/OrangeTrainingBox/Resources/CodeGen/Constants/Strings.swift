// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Ble {
    internal enum Connection {
      /// Please go to your settings to authorize Baah to use Bluetooth
      internal static let bleAuthorize = L10n.tr("Localizable", "Ble.Connection.BleAuthorize")
      /// Activate Bluetooth to connect to the BaahBox
      internal static let bleSwitchON = L10n.tr("Localizable", "Ble.Connection.BleSwitchON")
      /// Please select a BaahBox in the list below
      internal static let description = L10n.tr("Localizable", "Ble.Connection.Description")
      /// Connect your BaahBox
      internal static let header = L10n.tr("Localizable", "Ble.Connection.Header")
      /// Please select your BaahBox and start practicing
      internal static let popupTitle = L10n.tr("Localizable", "Ble.Connection.PopupTitle")
      /// Connection settings
      internal static let title = L10n.tr("Localizable", "Ble.Connection.Title")
    }
  }

  internal enum Dashboard {
    /// Select your game
    internal static let header = L10n.tr("Localizable", "Dashboard.header")
    /// Baah!
    internal static let title = L10n.tr("Localizable", "Dashboard.title")
  }

  internal enum Game {
    /// Great !
    internal static let congrats = L10n.tr("Localizable", "Game.Congrats")
    /// Let's play !
    internal static let go = L10n.tr("Localizable", "Game.Go")
    /// Hop !
    internal static let hop = L10n.tr("Localizable", "Game.Hop")
    /// Keep going !
    internal static let keepGoing = L10n.tr("Localizable", "Game.KeepGoing")
    /// Ooops!
    internal static let oops = L10n.tr("Localizable", "Game.Oops")
    /// Restart
    internal static let reStart = L10n.tr("Localizable", "Game.ReStart")
    /// Start
    internal static let start = L10n.tr("Localizable", "Game.Start")
    /// Stop
    internal static let stop = L10n.tr("Localizable", "Game.Stop")
    /// Try again
    internal static let tryAgain = L10n.tr("Localizable", "Game.TryAgain")
    /// Wahoo !
    internal static let wahoo = L10n.tr("Localizable", "Game.Wahoo")
    /// Well done !
    internal static let wellDone = L10n.tr("Localizable", "Game.WellDone")
    /// You won !
    internal static let win = L10n.tr("Localizable", "Game.Win")
    internal enum Balloon {
      /// Blow me up !
      internal static let title = L10n.tr("Localizable", "Game.Balloon.title")
      internal enum Congrats {
        /// Whaoooo !
        internal static let first = L10n.tr("Localizable", "Game.Balloon.congrats.first")
        /// Great !!!
        internal static let second = L10n.tr("Localizable", "Game.Balloon.congrats.second")
      }
      internal enum Text {
        /// Almost there !
        internal static let almostDone = L10n.tr("Localizable", "Game.Balloon.text.almostDone")
        /// Well Done !
        internal static let congrats = L10n.tr("Localizable", "Game.Balloon.text.congrats")
        /// Inflate the balloon
        internal static let first = L10n.tr("Localizable", "Game.Balloon.text.first")
        /// Let's go !
        internal static let letsGo = L10n.tr("Localizable", "Game.Balloon.text.letsGo")
        /// with the joystick up
        internal static let secondJoystick = L10n.tr("Localizable", "Game.Balloon.text.secondJoystick")
        /// by contracting your muscle
        internal static let secondMuscle = L10n.tr("Localizable", "Game.Balloon.text.secondMuscle")
      }
    }
    internal enum Frog {
      /// Slurp !
      internal static let title = L10n.tr("Localizable", "Game.Frog.title")
    }
    internal enum Sheep {
      /// Jump, Sheep, Jump !
      internal static let title = L10n.tr("Localizable", "Game.Sheep.title")
      internal enum Score {
        internal enum Pending {
          /// You jumped over %d fences out of %d 
          internal static func many(_ p1: Int, _ p2: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.pending.many", p1, p2)
          }
          /// You jumped over 1 fence out of %d 
          internal static func one(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.pending.one", p1)
          }
        }
        internal enum Result {
          /// You only jumped %d fences out of %d!
          internal static func notEnough(_ p1: Int, _ p2: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.result.notEnough", p1, p2)
          }
          /// You jumped over all the fences !
          internal static let win = L10n.tr("Localizable", "Game.Sheep.score.result.win")
        }
        internal enum Start {
          /// Try to jump over %d fences
          internal static func many(_ p1: Int) -> String {
            return L10n.tr("Localizable", "Game.Sheep.score.start.many", p1)
          }
          /// Try to jump over 1 fence
          internal static let one = L10n.tr("Localizable", "Game.Sheep.score.start.one")
        }
      }
      internal enum Text {
        internal enum Jump {
          /// Make the sheep jump over the fences
          internal static let first = L10n.tr("Localizable", "Game.Sheep.text.Jump.first")
          /// by contracting your muscle
          internal static let second = L10n.tr("Localizable", "Game.Sheep.text.Jump.second")
          /// with the joystick up
          internal static let secondJoystick = L10n.tr("Localizable", "Game.Sheep.text.Jump.secondJoystick")
        }
      }
    }
    internal enum Space {
      /// Space Battle !
      internal static let title = L10n.tr("Localizable", "Game.Space.title")
      internal enum Button {
        /// Continue
        internal static let keepGoing = L10n.tr("Localizable", "Game.Space.button.keepGoing")
      }
      internal enum Text {
        /// Try to avoid collisions
        internal static let first = L10n.tr("Localizable", "Game.Space.text.first")
        /// by moving the joystick
        internal static let secondJoystick = L10n.tr("Localizable", "Game.Space.text.secondJoystick")
        /// by contracting your left and right muscles
        internal static let secondMuscle = L10n.tr("Localizable", "Game.Space.text.secondMuscle")
      }
    }
    internal enum Star {
      /// Make the star shine
      internal static let header = L10n.tr("Localizable", "Game.Star.header")
      /// with the joystick up
      internal static let subHeaderJoystick = L10n.tr("Localizable", "Game.Star.subHeaderJoystick")
      /// by contracting your muscle
      internal static let subHeaderMuscle = L10n.tr("Localizable", "Game.Star.subHeaderMuscle")
      /// Twinkle twinkle !
      internal static let title = L10n.tr("Localizable", "Game.Star.title")
      internal enum Text {
        /// Great !!!
        internal static let congrats = L10n.tr("Localizable", "Game.Star.text.congrats")
        /// Keep going !
        internal static let keepGoing = L10n.tr("Localizable", "Game.Star.text.keepGoing")
      }
    }
  }

  internal enum GeneralParameters {
    internal enum Section {
      internal enum Demo {
        /// Demo mode
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Demo.item1")
        /// Select the mode
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Demo.subtitle")
        /// Demo mode
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Demo.title")
      }
      internal enum Detection {
        /// Sets the threshold to detect the pressure
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Detection.subtitle")
        /// Pressure detection threshold
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Detection.title")
      }
      internal enum Muscle {
        /// Muscle 1
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.item1")
        /// Muscle 2
        internal static let item2 = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.item2")
        /// Select the muscle(s) you like to work with
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.subtitle")
        /// Working muscle
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Muscle.title")
      }
      internal enum Sensitivity {
        /// Sensitivity
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Sensitivity.item1")
        /// Sets the sensitivity of the sensors
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Sensitivity.subtitle")
        /// Sensitivity
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Sensitivity.title")
      }
      internal enum Sensor {
        /// Sensor
        internal static let item1 = L10n.tr("Localizable", "GeneralParameters.Section.Sensor.item1")
        /// Select the sensor you are using
        internal static let subtitle = L10n.tr("Localizable", "GeneralParameters.Section.Sensor.subtitle")
        /// Sensor type
        internal static let title = L10n.tr("Localizable", "GeneralParameters.Section.Sensor.title")
      }
    }
    internal enum Header {
      /// General
      internal static let title = L10n.tr("Localizable", "GeneralParameters.header.title")
    }
  }

  internal enum Generic {
    /// Activate
    internal static let activate = L10n.tr("Localizable", "Generic.Activate")
    /// Bluetooth
    internal static let ble = L10n.tr("Localizable", "Generic.ble")
    /// Both
    internal static let both = L10n.tr("Localizable", "Generic.both")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Generic.Cancel")
    /// Connection
    internal static let connect = L10n.tr("Localizable", "Generic.Connect")
    /// Disconnect
    internal static let disconnect = L10n.tr("Localizable", "Generic.Disconnect")
    /// DONE
    internal static let end = L10n.tr("Localizable", "Generic.End")
    ///  Fast
    internal static let fast = L10n.tr("Localizable", "Generic.fast")
    /// High
    internal static let high = L10n.tr("Localizable", "Generic.high")
    /// Left
    internal static let `left` = L10n.tr("Localizable", "Generic.left")
    /// Low
    internal static let low = L10n.tr("Localizable", "Generic.low")
    /// Medium
    internal static let medium = L10n.tr("Localizable", "Generic.medium")
    /// No
    internal static let no = L10n.tr("Localizable", "Generic.No")
    /// OK
    internal static let ok = L10n.tr("Localizable", "Generic.Ok")
    /// Regular
    internal static let regular = L10n.tr("Localizable", "Generic.regular")
    /// Right
    internal static let `right` = L10n.tr("Localizable", "Generic.right")
    /// Save
    internal static let save = L10n.tr("Localizable", "Generic.Save")
    /// Slow
    internal static let slow = L10n.tr("Localizable", "Generic.slow")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "Generic.Yes")
  }

  internal enum MainParameters {
    /// Connection
    internal static let connection = L10n.tr("Localizable", "MainParameters.connection")
    /// General
    internal static let general = L10n.tr("Localizable", "MainParameters.general")
    internal enum Connection {
      /// Connection settings
      internal static let title = L10n.tr("Localizable", "MainParameters.connection.title")
    }
    internal enum Games {
      /// Inflate the balloon
      internal static let balloon = L10n.tr("Localizable", "MainParameters.games.balloon")
      /// Jump, Sheep, Jump !
      internal static let sheep = L10n.tr("Localizable", "MainParameters.games.sheep")
      /// Space Battle
      internal static let spaceShip = L10n.tr("Localizable", "MainParameters.games.spaceShip")
      /// Make the star shine
      internal static let star = L10n.tr("Localizable", "MainParameters.games.star")
      /// Eat the flies
      internal static let taud = L10n.tr("Localizable", "MainParameters.games.taud")
      /// Game settings
      internal static let title = L10n.tr("Localizable", "MainParameters.games.title")
    }
    internal enum General {
      /// Global settings
      internal static let title = L10n.tr("Localizable", "MainParameters.general.title")
    }
    internal enum Header {
      /// Parameters
      internal static let title = L10n.tr("Localizable", "MainParameters.header.title")
    }
  }

  internal enum Notif {
    internal enum Ble {
      /// kBLEPeripheralAuthorizationNotification
      internal static let authorization = L10n.tr("Localizable", "Notif.BLE.Authorization")
      /// kBLEPeripheralConnectionNotification
      internal static let connection = L10n.tr("Localizable", "Notif.BLE.Connection")
      /// kBLEDataReceivedNotification
      internal static let dataReceived = L10n.tr("Localizable", "Notif.BLE.DataReceived")
      /// kBLEPeripheralDisconnectionNotification
      internal static let disconnection = L10n.tr("Localizable", "Notif.BLE.Disconnection")
      /// kBLEPeripheralDiscoveryNotification
      internal static let discovery = L10n.tr("Localizable", "Notif.BLE.Discovery")
      /// kBLEUPNotification
      internal static let down = L10n.tr("Localizable", "Notif.BLE.Down")
      /// kBLEUPNotification
      internal static let up = L10n.tr("Localizable", "Notif.BLE.Up")
    }
    internal enum Parameter {
      /// kParameterUpdate
      internal static let update = L10n.tr("Localizable", "Notif.Parameter.update")
    }
  }

  internal enum Parameters {
    internal enum Global {
      /// Working muscle
      internal static let muscle = L10n.tr("Localizable", "Parameters.Global.muscle")
      /// Sensitivity
      internal static let sensitivity = L10n.tr("Localizable", "Parameters.Global.sensitivity")
      /// Threshold level
      internal static let threshold = L10n.tr("Localizable", "Parameters.Global.threshold")
      /// Global parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Global.title")
      internal enum Sensor {
        /// Button
        internal static let button = L10n.tr("Localizable", "Parameters.Global.sensor.button")
        /// Joystick
        internal static let joystick = L10n.tr("Localizable", "Parameters.Global.sensor.joystick")
        /// Muscle
        internal static let muscle = L10n.tr("Localizable", "Parameters.Global.sensor.muscle")
      }
    }
    internal enum Sheep {
      /// Number of fences
      internal static let fence = L10n.tr("Localizable", "Parameters.Sheep.fence")
      /// Speed
      internal static let speed = L10n.tr("Localizable", "Parameters.Sheep.speed")
      /// Saute-Mouton game parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Sheep.title")
    }
    internal enum Ship {
      /// Particles
      internal static let explosionStyle = L10n.tr("Localizable", "Parameters.Ship.explosionStyle")
      /// Number of ships
      internal static let number = L10n.tr("Localizable", "Parameters.Ship.number")
      /// Speed of asteroids
      internal static let speed = L10n.tr("Localizable", "Parameters.Ship.speed")
      /// Space Battle game parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Ship.title")
    }
    internal enum Taud {
      /// Number of flies
      internal static let number = L10n.tr("Localizable", "Parameters.Taud.number")
      /// Automatic shoots
      internal static let shootStyle = L10n.tr("Localizable", "Parameters.Taud.shootStyle")
      /// Time during which the fly does not move
      internal static let time = L10n.tr("Localizable", "Parameters.Taud.time")
      /// %@ s
      internal static func timeValue(_ p1: String) -> String {
        return L10n.tr("Localizable", "Parameters.Taud.timeValue", p1)
      }
      /// Taud game parameters
      internal static let title = L10n.tr("Localizable", "Parameters.Taud.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
