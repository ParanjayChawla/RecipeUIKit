//
//  MealTableViewCell.swift
//  Custom table view cell that displays a meal's name and image.
//  Recipe
//
//  Created by Jay Chawla on 4/13/23.
//

import Foundation

import UIKit

class MealTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "MealTableViewCell"
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mealNameLabel)
        contentView.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            thumbnailImageView.widthAnchor.constraint(equalToConstant: 30.0),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 30.0),
            
            mealNameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            mealNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mealNameLabel.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Public Methods
    
    func configure(with meal: MealDetail) {
        mealNameLabel.text = meal.strMeal
        let imageUrlString = meal.strMealThumb
        ImageLoader.downloadImage(from: imageUrlString!) { image in
            if let image = image {
                // we can only use UIImage.image in Main thread
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            } else {
                print("Error: Image \(String(describing: imageUrlString)) is nil")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        mealNameLabel.text = nil
    }
    
}
