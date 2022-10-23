//
//  UploadTweetViewModel.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/22.
//

import Foundation

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholerText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    init(config: UPloadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholerText = "What's happening"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholerText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
