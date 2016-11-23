//
//  PairingInterfaceController.swift
//  Migla
//
//  Created by Giedrius Stanevičius on 2016-11-23.
//  Copyright © 2016 Migla. All rights reserved.
//

import Foundation

public class PairingInterfaceController: UserNotificationActionHandler {
    
    private static let deviceIdProperty = "com.migla.pairinginterfacecontroller.deviceId"
    
    public static func handleAction(for notification: NSUserNotification, context: UserNotificationContext) {
        
        guard let deviceId = notification.userInfo?[deviceIdProperty] as? Device.Id else {
            fatalError("User info with device id property expected to be provided for pairing notification")
        }
        
        switch notification.activationType {
        case .actionButtonClicked:
            context.deviceManager.device(withId: deviceId)?.acceptPairing()
            break
        default:
            context.deviceManager.device(withId: deviceId)?.declinePairing()
            break
        }
    }
    
    public static func showPairingNotification(for device: Device) {
        let notification = NSUserNotification(actionHandlerClass: PairingInterfaceController.self)
        var userInfo = notification.userInfo
        userInfo?[deviceIdProperty] = device.id
        notification.userInfo = userInfo
        notification.title = device.name
        notification.informativeText = "Do you want to pair this device?"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasActionButton = true
        notification.actionButtonTitle = "Pair"
        notification.otherButtonTitle = "Decline"
        notification.identifier = "com.migla.pairinginterfacecontroller.device.\(device.id)"
        NSUserNotificationCenter.default.scheduleNotification(notification)
        
        Timer.scheduledTimer(withTimeInterval: DefaultPairingHandler.pairingTimoutInterval, repeats: false) { _ in
            NSUserNotificationCenter.default.removeDeliveredNotification(notification)
        }
    }
    
}
