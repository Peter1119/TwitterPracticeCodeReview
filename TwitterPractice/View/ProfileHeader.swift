//
//  ProfileHeader.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/11.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOptions)
}

class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    var user: User? {
        didSet { configure() }
    }
    weak var delegate: ProfileHeaderDelegate?
    private let filterBar = ProfileFillterView()
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than on lin for test purposes"
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 following"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0 followers"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        filterBar.delegate = self
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor, 
                         height: 50)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             height: 108)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: containerView.bottomAnchor,
                                left: leftAnchor,
                                paddingTop: -24,
                                paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor,
                                       right: rightAnchor,
                                       paddingTop: 12,
                                       paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel,
                                                             usernameLabel,
                                                             bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 8,
                               paddingLeft: 12,
                               paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,
                                                         followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor,
                           left: leftAnchor,
                           paddingTop: 8,
                           paddingLeft: 12)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }

    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    @objc func handleFollowersTapped() {
    }
    @objc func handleFollowingTapped() {
    }
    // MARK: - Helpers

    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        profileImageView.sd_setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followersString
        followersLabel.attributedText = viewModel.followingString
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}

// MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFillterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}
