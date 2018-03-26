//
//  RoomRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class RoomRepositoryImpl: RoomRepository {
    
    func getRoom(device: SSDPDevice) -> Observable<Room>? {
        guard device.isSonosDevice else { return nil }
        
        let locationUrl = device.ip.appendingPathComponent(device.location)
        return GetDeviceDescriptionNetwork(location: locationUrl, usn: device.usn)
            .executeRequest()
            .map(self.mapDataToRoom(device: device))
    }
    
    fileprivate func mapDataToRoom(device: SSDPDevice) -> ((Data) throws -> Room) {
        return { data in
            guard let xml = AEXMLDocument.create(data),
                let description = DeviceDescription.map(xml) else {
                    #if DEBUG
                    print(String(data: data, encoding: .utf8)!)
                    #endif
                    throw NSError.sonosLibNoDataError()
            }
            return Room(ssdpDevice: device, deviceDescription: description)
        }
    }
    
}