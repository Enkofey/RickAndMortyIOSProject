//
//  detailView.swift
//  RickEtMortyAPI
//
//  Created by Julien DAVID on 30/04/2021.
//

import UIKit

class DetailViewController : UIViewController {
    
    var delegate : DetailViewDelegate?
    var item : SerieCharacter?
    
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var speciesCharacter: UILabel!
    @IBOutlet weak var statusCharacter: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item{
            imageCharacter.loadImage(from: item.imageURL, completion: nil)
            nameCharacter.text = item.name
            statusCharacter.text = item.status
            speciesCharacter.text = item.species
        }
    }
    
}
protocol DetailViewDelegate : class {
}
