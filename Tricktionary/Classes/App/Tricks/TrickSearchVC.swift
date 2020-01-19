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
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

// Table view
extension TrickSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTricks.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredTricks.value[indexPath.row].name
        return cell
    }
}

extension TrickSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectTrick?(filteredTricks.value[indexPath.row].name)
    }
}
