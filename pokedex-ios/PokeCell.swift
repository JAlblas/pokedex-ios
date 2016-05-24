//
//  PokeCell.swift
//  pokedex-ios
//
//  Created by EazySoft IOS Udvikler on 24/05/2016.
//  Copyright © 2016 JAlblas. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLabel.text = self.pokemon.name.capitalizedString
        thumbnail.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
