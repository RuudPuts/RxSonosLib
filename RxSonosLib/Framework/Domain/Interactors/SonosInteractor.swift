//
//  SonosInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

open class SonosInteractor {
    
    static public func provideGroupsInteractor() -> GetGroupsInteractor {
        return GetGroupsInteractor(ssdpRepository: RepositoryInjection.provideSSDPRepository(), roomRepository: RepositoryInjection.provideRoomRepository(), groupRepository: RepositoryInjection.provideGroupRepository())
    }
    
}