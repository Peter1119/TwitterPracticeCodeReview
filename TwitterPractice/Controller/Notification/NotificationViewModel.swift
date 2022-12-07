//
//  NotificationSampleViewModel.swift
//  TwitterPractice
//
//  Created by Sh Hong on 2022/12/07.
//

import Foundation
import RxSwift
import RxCocoa

class NotificationViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let cellSelected = PublishRelay<Int>()
    }
    
    struct Output {
        let notificationCellModels: Observable<[NotificationCellModel]>
        let endRefresh: Observable<Void>
        let moveToTweetView: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let notificationCellModels = BehaviorRelay<[NotificationCellModel]>(value: [])
        let endRefresh = PublishRelay<Void>()
        
        NotificationService.shared.fetchNotificationRx()
            .map { notifications in
                notifications.map { noti -> NotificationCellModel in
                    return NotificationCellModel(notification: noti)
                }
            }
            .bind(to: notificationCellModels)
            .disposed(by: disposeBag)
        
        input.cellSelected
            .map { row -> Int in
                let tweetId = notificationCellModels.value[row].tweetId
                return tweetId
            }
            .bind { id in
                TweetService.shared.fetchTweet(withTweetID: "\(id)") {
                    jsdlkfaj;slda
                }
            }
        
        return Output(notificationCellModels: notificationCellModels.asObservable(),
                      endRefresh: endRefresh.asObservable(),
                      moveToTweetView: )
    }
    
    let input = Input()
    lazy var output = transform(input: input)
}
