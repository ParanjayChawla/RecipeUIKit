//
//  MealDetailViewController.swift
//  Recipe
//
//  Created by Jay Chawla on 4/16/23.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var meal: MealDetail?
    var mealFull: MealDetail?
    
    lazy var sv: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView : UIStackView = {
        let t = UIStackView()
        t.distribution = .fill
        t.spacing = 16
        t.axis = .vertical
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mealInstructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mealIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        DispatchQueue.main.async {
            self.fetchMeals()
        }
        
        setupViews()
        updateViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func setupViews() {
        view.addSubview(sv)
        sv.addSubview(containerView)
        containerView.addArrangedSubview(mealImageView)
        
        containerView.addArrangedSubview(mealNameLabel)
        containerView.addArrangedSubview(instructionsLabel)
        containerView.addArrangedSubview(mealIngredientLabel)
        containerView.addArrangedSubview(ingredientLabel)
        containerView.addArrangedSubview(mealInstructionsLabel)
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            sv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            sv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: sv.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: sv.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: sv.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: sv.bottomAnchor),
            
            mealImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            mealImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            mealNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mealNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
        sv.addConstraints([NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: sv, attribute: .width, multiplier: 1, constant: 0)])
    }
    
    private func updateViews() {
        guard let meal = meal else { return }
        
        mealImageView.image = UIImage(named: "mealPlaceholder")
        
        let imageUrlString = meal.strMealThumb
        ImageLoader.downloadImage(from: imageUrlString!) { image in
            if let image = image {
                self.mealImageView.image = image
            } else {
                print("Error: Image \(String(describing: imageUrlString)) is nil")
            }
        }
        instructionsLabel.text = "Ingredients"
        ingredientLabel.text = "Instructions"
        mealNameLabel.text = meal.strMeal
        mealInstructionsLabel.text = mealFull?.strInstructions!.replacingOccurrences(of: "\r\n", with: "\n \n")
        mealIngredientLabel.text = mealFull?.displayString!
    }
    private func fetchMeals() {
        NetworkManager.shared.fetchMealDetails(for: meal!.idMeal) { completion in
            switch completion {
            case .success(let meals):
                self.mealFull = meals.meals[0]
                DispatchQueue.main.async {
                    self.updateViews()
                }
                
            case .failure(let error):
                print("Failed to fetch meals: \(error.localizedDescription)")
            }
        }
    }
    
    
}
