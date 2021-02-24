//
//  ImageLoad.swift
//  RickEtMortyAPI
//
//  Created by Julien DAVID on 27/01/2021.
//

import UIKit

extension UIImageView{
    func loadImage(from url : URL, completion : (() -> Void)?){
        let task = URLSession.shared.dataTask(with: url){(data,URLResponse,error) in
            guard error == nil,
                  let httpReponse = URLResponse as? HTTPURLResponse,
                  (200...299).contains(httpReponse.statusCode),
                  let data = data else{
                    return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion?()
            }
        }
        task.resume()
    }
}
