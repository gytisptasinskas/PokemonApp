//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Gytis Ptašinskas on 06/11/2023.
//

import UIKit

// UIImageView extension for asynchronous image loading
extension UIImageView {
    func load(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}

class PokemonDetailViewController: UIViewController {
    
    // MARK: - Properties
    var pokemonCard: Card?
    
    // MARK: - UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var nameLabel = UILabel()
    let imageView = UIImageView()
    var typeLabel = UILabel()
    var hpLabel = UILabel()
    var pokedexNumberLabel = UILabel()
    var subtypeLabel = UILabel()
    var supertypeLabel = UILabel()
    var rarityLabel = UILabel()
    var seriesLabel = UILabel()
    var setLabel = UILabel()
    var artistLabel = UILabel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupViews()
        configureWith(pokemonCard)
    }
    
    // MARK: - Setup Scroll View
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Setup Views
    func setupViews() {
        // Image view setup
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        // Helper function to create labels
        func createLabel() -> UILabel {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0 // Allows for multiple lines
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .left
            contentView.addSubview(label)
            return label
        }
        
        // Create all labels
        nameLabel = createLabel()
        typeLabel = createLabel()
        hpLabel = createLabel()
        pokedexNumberLabel = createLabel()
        subtypeLabel = createLabel()
        supertypeLabel = createLabel()
        rarityLabel = createLabel()
        seriesLabel = createLabel()
        setLabel = createLabel()
        artistLabel = createLabel()
        
        // Labels array to iterate through and setup constraints
        let labels = [nameLabel, typeLabel, hpLabel, pokedexNumberLabel, subtypeLabel, supertypeLabel, rarityLabel, seriesLabel, setLabel, artistLabel]
        
        // Initialize the previous bottom anchor to the imageView's bottom
        var previousBottomAnchor = imageView.bottomAnchor
        
        // Iterate through labels to setup constraints
        for label in labels {
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
            label.topAnchor.constraint(equalTo: previousBottomAnchor, constant: 10).isActive = true
            // Update the previous bottom anchor to the current label's bottom
            previousBottomAnchor = label.bottomAnchor
        }
        
        if let lastLabel = labels.last {
            lastLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        }
    }

    
    // MARK: - Configure View with Pokemon Card Data
    func configureWith(_ card: Card?) {
        guard let card = card else { return }
        
        nameLabel.text = "Name: \(card.name)"
        if let imageUrl = URL(string: card.imageURLHiRes) {
            imageView.load(url: imageUrl)
        }
        typeLabel.text = "Types: \(card.types?.joined(separator: ", ") ?? "N/A")"
        hpLabel.text = "HP: \(card.hp ?? "N/A")"
        pokedexNumberLabel.text = "Pokedex Number: \(card.nationalPokedexNumber.map(String.init) ?? "N/A")"
        subtypeLabel.text = "Subtype: \(card.subtype ?? "N/A")"
        supertypeLabel.text = "Supertype: \(card.supertype ?? "N/A")"
        rarityLabel.text = "Rarity: \(card.rarity ?? "N/A")"
        seriesLabel.text = "Series: \(card.series?.rawValue ?? "N/A")"
        setLabel.text = "Set: \(card.cardSet ?? "N/A")"
        artistLabel.text = "Artist: \(card.artist ?? "N/A")"
    }
}
