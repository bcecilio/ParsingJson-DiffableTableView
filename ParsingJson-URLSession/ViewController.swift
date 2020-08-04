//
//  ViewController.swift
//  ParsingJson-URLSession
//
//  Created by Brendon Cecilio on 8/4/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Sections {
        case primary
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: DataSource!
    
    let apiClient = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Citi Bike Station"
        fetchData()
        configureDataSource()
    }
    
    private func fetchData() {
        apiClient.fetchData { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let stations):
                DispatchQueue.main.async {
                    self?.updateSnapshot(with: stations)
                }
            }
        }
    }
    
    private func updateSnapshot(with stations: [Station]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(stations, toSection: .primary)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, station) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)
            cell.textLabel?.text = station.name
            cell.detailTextLabel?.text = "Bike Capacity: \(station.capacity)"
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Station>()
        snapshot.appendSections([.primary])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// TODO: continue to implement in order to show the section header titles
// subclass UITableViewDiffableSource
class DataSource: UITableViewDiffableDataSource<ViewController.Sections, Station> {}
// implement UITableViewDiffable
