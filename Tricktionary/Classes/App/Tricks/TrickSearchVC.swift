//
//  TrickSearchVC.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 19/01/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Combine

class TrickSearchVC: BaseCenterViewController {

    // MARK: - Variables
    private let tableView = UITableView()

    var filteredTricks: MutableProperty<[BaseTrick]> = MutableProperty<[BaseTrick]>([BaseTrick]())
    var onSelectTrick: ((String) -> Void)?
    var completed: [String] = []
    private var keyboardCancelable = Set<AnyCancellable>()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }

    // MARK: - Content
    private func setupContent() {
        bind()
        view.addSubview(tableView)

        filteredTricks.producer.startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: TrickLevelCell.reuseIdentifier())
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        keyboardHeight.sink { [unowned self] bottom in
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }.store(in: &keyboardCancelable)
    }
}

// Table view
extension TrickSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTricks.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrickLevelCell.reuseIdentifier(), for: indexPath) as? TrickLevelCell else {
            return UITableViewCell()
        }
        let trick = filteredTricks.value[indexPath.row]
        cell.customize(with: TrickLevelCell.Content(title: trick.name, levels: [
            .ijru: trick.levels?.ijru.level ?? ""
        ], isDone: completed.contains(trick.id ?? "")))
        return cell
    }
}

extension TrickSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectTrick?(filteredTricks.value[indexPath.row].name)
    }
}
