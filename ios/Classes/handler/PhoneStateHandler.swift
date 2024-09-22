//
//  PhoneStateHandlerHandler.swift
//  phone_state
//
//  Created by Andrea Mainella on 28/02/22.
//

import Foundation
import CallKit

@available(iOS 10.0, *)
class PhoneStateHandlerHandler: NSObject, FlutterStreamHandler, CXCallObserverDelegate{
    
    private var _eventSink: FlutterEventSink?
    private var callObserver = CXCallObserver()
    
    override init() {
        super.init()
        callObserver.setDelegate(self, queue: nil)
    }
    
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        var status = PhoneStateHandlerStatus.NOTHING
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            status = PhoneStateHandlerStatus.CALL_INCOMING
        } else if (call.isOutgoing == false && call.hasConnected == true && call.hasEnded == false)
                    || (call.hasConnected == true && call.hasEnded == false && call.isOnHold == false) {
            status = PhoneStateHandlerStatus.CALL_STARTED
        } else if call.isOutgoing == false && call.hasEnded == true {
            status = PhoneStateHandlerStatus.CALL_ENDED
        } else {
            status = PhoneStateHandlerStatus.NOTHING
        }
        // Map
        if(_eventSink != nil) { _eventSink!(
            [
                "status": status.rawValue,
                "phoneNumber": nil // cannot get phone number on iOS
            ]
        ) }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
    
}
