//
//  ViewController.swift
//  RickEtMortyAPI
//
//  Created by Julien DAVID on 27/01/2021.
//

import UIKit

class ViewController: UITableViewController {

    public enum Section {
        case main
    }
    
    public enum Item : Hashable{
        case character(SerieCharacter)
    }
    
    private var differableDataSource: UITableViewDiffableDataSource<Section,Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        differableDataSource = UITableViewDiffableDataSource<Section,Item>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .character(let serieCharacter):
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
                cell.textLabel?.text = serieCharacter.name
                cell.imageView?.loadImage(from: serieCharacter.imageURL){
                    cell.setNeedsLayout()
                }
                return cell
            }
        })
        let snapshot = createSnapshot(serieCharacter: [])
        differableDataSource.apply(snapshot)
        
        fetchAPI()
        // Do any additional setup after loading the view.
    }
    private func createSnapshot(serieCharacter: [SerieCharacter])->NSDiffableDataSourceSnapshot<Section,Item>{
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        let items = serieCharacter.map(Item.character)
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }

    private func fetchAPI(){
        let url = URL(string: "https://rickandmortyapi.com/api/character/")!
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error{
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else{
                return
            }
            guard let mimeType = httpResponse.mimeType,
                  mimeType == "application/json" else{
                return
            }
            guard let data = data else{
                return
            }
            do{
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(Result.self , from: data)
                
                DispatchQueue.main.async {
                    let snapshot = self.createSnapshot(serieCharacter: result.results)
                    self.differableDataSource.apply(snapshot)
                }
                
            }catch{
                print(error)
            }
        }
        task.resume()
    }

}

