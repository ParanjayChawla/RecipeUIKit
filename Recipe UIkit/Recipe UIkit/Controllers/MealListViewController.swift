//
//  MealListViewController.swift
//  Recipe
//
//  Created by Jay Chawla on 4/16/23.
//

import Foundation
import UIKit

class MealListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var meals: [MealDetail] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dessert"
        setupTableView()
        fetchMeals()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: MealTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchMeals() {
        NetworkManager.shared.fetchMeals(for: "Dessert") { completion in
            switch completion {
            case .success(let meals):
                self.meals = meals
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    return 
                }
            case .failure(let error):
                print("Failed to fetch meals: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MealListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.reuseIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("Failed to dequeue MealTableViewCell")
        }
        let meal = meals[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: meal)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MealListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        let detailViewController = DetailViewController()
        
        detailViewController.meal = meal
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
