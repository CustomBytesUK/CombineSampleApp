//
//  UsersTableViewController.swift
//  CombineSampleApp
//
//  Created by Custom Bytes on 22/08/2020.
//  Copyright © 2020 Custom Bytes Ltd. All rights reserved.
//

import UIKit
import Combine

class UsersTableViewController: UITableViewController {

    private var viewModel: UsersViewModel
    private var subscriber: AnyCancellable?
    
    private let cellIdentifier = "cellIdentifier"
    
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = viewModel.title

        setupTableView()
        observeViewModel()
        fetchUsers()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        viewModel.fetchUsers()
    }
    
    private func observeViewModel() {
        subscriber = viewModel.usersSubject.sink(receiveCompletion: { (resultCompletion) in
            switch resultCompletion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    break
            }
        }, receiveValue: { [weak self] (users) in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        })
    }
    
    private func fetchUsers() {
        viewModel.fetchUsers()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.usersSubject.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.usersSubject.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
}
