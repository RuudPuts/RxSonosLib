//
//  GroupViewController.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 13/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSonosLib

class GroupViewController: UIViewController {
    
    var model: GroupViewModel!
    
    @IBOutlet var queueTableView: UITableView!
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupDescription: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressTime: UILabel!
    @IBOutlet var remainingTime: UILabel!
    @IBOutlet var volumeSlider: UISlider!
    
    private let disposeBag = DisposeBag()
    internal var router: GroupRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupName()
        self.setupTransportState()
        self.setupGroupProgress()
        self.setupQueueTableViewItems()
        self.setupQueueCellTapHandling()
        self.setupNowPlaying()
        self.setupVolumeHandler()
    }
    
    fileprivate func setupName() {
        model.name
            .asObservable()
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupNowPlaying() {
        self.resetTrack()
        
        model.nowPlayingInteractor
            .subscribe(onNext: { [weak self] (track) in
            self?.bind(track: TrackViewModel(track: track))
        }, onError: { (error) in
            print(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupVolumeHandler() {
        model
            .volumeInteractor
            .filter({ _ in return !self.volumeSlider.isTouchInside })
            .subscribe(onNext: { [weak self] (volume) in
                self?.volumeSlider.value = Float(volume) / 100.0
            }, onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        volumeSlider
            .rx
            .value
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ _ in return self.volumeSlider.isTouchInside })
            .flatMap({ [weak self] (newVolume) -> Observable<Void> in
                guard let strongSelf = self else { return Observable.just(()) }
                return SonosInteractor
                    .provideSetVolumeInteractor()
                    .get(values: SetVolumeValues(group: strongSelf.model.group, volume: Int(newVolume * 100.0)))
            })
            .subscribe(onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupTransportState() {
        model.transportStateInteractor
            .subscribe(onNext: { (state) in
            print(state.rawValue)
        }, onError: { (error) in
            print(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupGroupProgress() {
        model.groupProgressInteractor
            .subscribe(onNext: { [weak self] (progress) in
            self?.progressTime.text = progress.timeString
            self?.remainingTime.text = progress.remainingTimeString
            self?.progressView.progress = progress.progress
        }, onError: { (error) in
            print(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupQueueTableViewItems() {
        
        queueTableView.register(UINib(nibName: String(describing: QueueTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: QueueTableViewCell.identifier)
        
         model
            .queueInteractor
            .bind(to: queueTableView.rx.items(cellIdentifier: QueueTableViewCell.identifier, cellType: QueueTableViewCell.self)) { (row, track, cell) in
                cell.model = QueueViewModel(track: track)
            }
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupQueueCellTapHandling() {
        
    }
    
    fileprivate func bind(track: TrackViewModel) {
        self.groupDescription.text = track.description
        
        track.image
            .bind(to: groupImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    fileprivate func resetTrack() {
        self.groupDescription.text = "-"
        self.progressTime.text = nil
        self.remainingTime.text = nil
        self.progressView.progress = 0
        self.groupImageView.image = nil
    }

}
