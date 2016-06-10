//
//  Pokemon.swift
//  pokedex-ios
//
//  Created by EazySoft IOS Udvikler on 24/05/2016.
//  Copyright © 2016 JAlblas. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private(set) var name: String
    private(set) var pokedexId: Int
    private(set) var description: String!
    private(set) var type: String!
    private(set) var defense: String!
    private(set) var height: String!
    private(set) var weight: String!
    private(set) var attack: String!
    private(set) var nextEvolutionText: String!
    private(set) var nextEvolutionId: String!
    private(set) var nextEvolutionLevel: String!
    private(set) var pokemonUrl: String!
    
    init(name: String, pokedexId: Int) {
        self.name = name
        self.pokedexId = pokedexId
        
        pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    

    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self.weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self.height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self.attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self.defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self.type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self.type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self.type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"]  {
                        let url = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, url).responseJSON { response in
                            let desResult = response.result
                            if let descDict = desResult.value as? NSDictionary {
                                
                                if let description = descDict["description"] as? String {
                                    self.description = description
                                }
                            }
                            
                            completed()
                        }

                    }
                } else {
                    self.description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Can't support mega pokemon, api uses it so filter out
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self.nextEvolutionId = num
                                self.nextEvolutionText = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self.nextEvolutionLevel = "\(level)"
                                }
                            }
                        }
                        
                    }
                    
                    
                }

                
            }
            
        }
    }
}