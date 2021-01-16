//
//  SpeedTimerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 17/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import AVFoundation
import Combine

class SpeedTimerViewController: BaseCenterViewController {

    // MARK: Variables

    var viewModel: SpeedTimerViewModel
    
    private let tableView = UITableView()
    private var cancelable = Set<AnyCancellable>()
    private var diffableDataSource: UITableViewDiffableDataSource<SpeedTableSection, String>?
    
    init(viewModel: SpeedTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Speed timer"
        
        view.addSubview(tableView)
        diffableDataSource = SpeedTimerDataSource(tableView: tableView,
                                                  cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
                                                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SpeedEventCell.reuseIdentifier(),
                                                                                                   for: indexPath) as? SpeedEventCell else {
                                                        return nil
                                                    }
                                                    cell.customize(content: SpeedEventCell.Content(name: value))
                                                    return cell
                                                  })
        
        tableView.register(SpeedEventCell.self, forCellReuseIdentifier: SpeedEventCell.reuseIdentifier())
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        viewModel.sections.sink { sections in
            self.makeSnapshotAndApply(sections: sections)
        }.store(in: &cancelable)
        
        viewModel.loadEvents()
    }
    
    private func makeSnapshotAndApply(sections: [SpeedTableSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SpeedTableSection, String>()
        snapshot.appendSections([])
        sections.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows.map { $0.name }, toSection: section)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}
