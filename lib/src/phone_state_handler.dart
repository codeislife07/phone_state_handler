import 'package:flutter/services.dart';
import 'package:phone_state_handler/src/utils/constants.dart';
import 'package:phone_state_handler/src/utils/phone_state_status.dart';

/// This class is used to store the current phone state
///
/// To listen to the phone state change, use the [stream] getter
class PhoneStateHandler {
  /// The current phone state
  PhoneStateHandlerStatus status;

  /// The number of the caller. NOT WORKING ON IOS
  String? number;

  PhoneStateHandler._({required this.status, this.number});

  /// This method allows you to create a [PhoneStateHandler] object with the status [PhoneStateHandlerStatus.NOTHING]
  ///
  /// Use for initializing your [PhoneStateHandler] object
  factory PhoneStateHandler.nothing() =>
      PhoneStateHandler._(status: PhoneStateHandlerStatus.NOTHING);

  static const EventChannel _eventChannel =
      EventChannel(Constants.EVENT_CHANNEL);

  /// This method allows you to have a stream of the system phone state change
  static Stream<PhoneStateHandler> get stream {
    return _eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => PhoneStateHandler._(
              status: PhoneStateHandlerStatus.values.firstWhere(
                  (element) => element.name == event['status'] as String),
              number: event['phoneNumber'],
            ));
  }
}
