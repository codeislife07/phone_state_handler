//
//  FlutterHandler.swift
//  phone_state
//
//  Created by Andrea Mainella on 28/02/22.
//

import Foundation

@available(iOS 10.0, *)
class FlutterHandler{
    private let PhoneStateHandlerChannel: FlutterEventChannel
    
    init(binding: FlutterPluginRegistrar) {
        PhoneStateHandlerChannel = FlutterEventChannel(
            name: Constants.EVENT_CHANNEL,
            binaryMessenger: binding.messenger());
        
        PhoneStateHandlerChannel.setStreamHandler(PhoneStateHandlerHandler())
    }
    
    public func dispose(){
        PhoneStateHandlerChannel.setStreamHandler(nil)
    }
}
