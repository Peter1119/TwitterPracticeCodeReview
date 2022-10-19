//
//  TweetHeader.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/19.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    // MARK: - Properties
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
