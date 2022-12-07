//
//  NotificationController.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/04.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationViewController: UIViewController, ViewModelBindable {
    var disposeBag = DisposeBag()
    var viewModel: NotificationViewModel!

    let tableView = UITableView()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        fetchNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Bind View Model
    func bindViewModel() {
        viewModel.output.notificationCellModels
            .bind(to: tableView.rx.items(
                cellIdentifier: NotificationCell.defaultReuseIdentifier,
                cellType: NotificationCell.self)) { row, element, cell in
                    cell.bind(element)
                }
                .disposed(by: disposeBag)
        
        viewModel.output.endRefresh
            .bind {
                self.tableView.refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        viewModel.output.moveToTweetView
            .bind { tweet in
                let controller = TweetController(tweet: tweet)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected
            .map(\.row)
            .bind(to: viewModel.input.cellSelected)
            .disposed(by: disposeBag)
    }
    // MARK: - Selectors

    @objc func handleRefresh() {
//        refreshControl?.beginRefreshing()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

//extension NotificationController {
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let notification = notifications[indexPath.row]
//        guard let tweetID = notification.tweetID else { return }
//
//        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
//            let controller = TweetController(tweet: tweet)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
//}
// MARK: - NotificationCellDelegate

extension NotificationViewController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
//        guard let user = cell.notification?.user else { return }
//
//        if user.isFollowed {
//            UserService.shared.unfollowUser(uid: user.uid) { _, _ in
//                cell.notification?.user.isFollowed = false
//            }
//        } else {
//            UserService.shared.followUser(uid: user.uid) { _, _ in
//                cell.notification?.user.isFollowed = true
//            }
//        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
//        guard let user = cell.notification?.user else { return }
//        let controller = ProfileController(user: user)
//        navigationController?.pushViewController(controller, animated: true)
    }
}
