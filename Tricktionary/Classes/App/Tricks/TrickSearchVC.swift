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

class TrickSearchVC: UIViewController {

    // MARK: - Variables
    private let tableView = UITableView()

    var filteredTricks: MutableProperty<[BaseTrick]> = MutableProperty<[BaseTrick]>([BaseTrick]())
    var onSelectTrick: ((String) -> Void)?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }

    // MARK: - Content
    private func setupContent() {
        view.addSubview(tableView)

        filteredTricks.producer.startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// Table view
extension TrickSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTricks.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchCell()
        var levels = "IJRU: \(filteredTricks.value[indexPath.row].levels?.ijru.level ?? "-")"
        levels += "\tIRSF: \(filteredTricks.value[indexPath.row].levels?.irsf.level ?? "-")"
        levels += "\tWJR: \(filteredTricks.value[indexPath.row].levels?.wjr.level ?? "-")"
        cell.customize(with: filteredTricks.value[indexPath.row].name,
                       level: "Level \(filteredTricks.value[indexPath.row].level)",
            levels: levels)
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
