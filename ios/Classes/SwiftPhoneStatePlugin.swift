import Flutter
import UIKit

@available(iOS 10.0, *)
public class SwiftPhoneStateHandlerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let _: FlutterHandler = FlutterHandler(binding: registrar)
  }
}
