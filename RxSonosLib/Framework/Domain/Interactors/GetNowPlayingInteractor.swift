//
//  GetNowPlayingInteractor.swift
//  Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import RxSSDP

open class GetNowPlayingValues: RequestValues {
    let group: Group
    
    public init(group: Group) {
        self.group = group
    }
}

open class GetNowPlayingInteractor: BaseInteractor<GetNowPlayingValues, Track?>  {
    
    let transportRepository: TransportRepository
    
    public init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    override func buildInteractorObservable(requestValues: GetNowPlayingValues?) -> Observable<Track?> {
        
        guard let masterRoom = requestValues?.group.master else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return transportRepository
            .getNowPlaying(for: masterRoom)
    }
}
