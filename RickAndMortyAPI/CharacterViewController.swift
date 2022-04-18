//
//  CharacterViewController.swift
//  RickAndMortyAPI
//
//  Created by Sungur on 17.04.2022.
//

import UIKit

class CharacterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterSpecies: UILabel!
    @IBOutlet weak var characterGender: UILabel!
    @IBOutlet weak var characterStatus: UILabel!
    @IBOutlet weak var characterLastLocation: UILabel!
    @IBOutlet weak var characterNumberOfEpisodes: UILabel!
    
    weak var vc: ViewController?
    var results: Results?
    static let shared = CharacterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterName.text = "Name: \((results?.name)!)"
        characterSpecies.text = "Species: \((results?.species)!)"
        characterGender.text = "Gender: \((results?.gender)!)"
        characterStatus.text = "Status: \((results?.status)!)"
        characterNumberOfEpisodes.text = "Episodes: \((results?.episode.count)!)"
        characterLastLocation.numberOfLines = 0
        characterLastLocation.text = "Last known location: \((results?.location.name)!)"
        
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        
        if let url = URL(string: results!.image) {
            URLSession.shared.dataTask(with: url) { data, _, err in
                guard let data = data, err == nil else {return}
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
        // Do any additional setup after loading the view.
    }
    
}

struct CharacterViewModel {
    var name: String
    var species: String
    var gender: String
    
}
