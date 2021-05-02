//
//  ViewController.swift
//  RickEtMortyAPI
//
//  Created by Julien DAVID on 27/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listCharacter : [SerieCharacter] = []

    public enum Section {
        case main
    }
    
    public enum Item : Hashable{
        case character(SerieCharacter)
    }
    
    private var differableDataSource: UICollectionViewDiffableDataSource<Section,Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        differableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let serieCharacter):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",for: indexPath)
                
                let nameTextLabel = UILabel(frame: CGRect(x: 150, y: 10, width: 250, height: 25))
                
                nameTextLabel.text = serieCharacter.name
                
                cell.contentView.addSubview(nameTextLabel)
                cell.setNeedsLayout()
                
                let statusTextLabel = UILabel(frame: CGRect(x: 150, y: 50, width: 250, height: 25))
                
                statusTextLabel.text = serieCharacter.status
                
                cell.contentView.addSubview(statusTextLabel)
                cell.setNeedsLayout()
                
                
                let imageview = UIImageView(frame: CGRect(x: 25, y: 0, width: 100, height: 100))
                
                imageview.loadImage(from: serieCharacter.imageURL) {
                    cell.contentView.addSubview(imageview)
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
    
    func performSearch(searchQuery: String?) {
        let filteredCharacter: [SerieCharacter]
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            filteredCharacter = listCharacter.filter { $0.contains(query: searchQuery) }
        } else {
            filteredCharacter = listCharacter
        }
        let snapshot = createSnapshot(serieCharacter: filteredCharacter)
        
        differableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        performSearch(searchQuery: nil)
    }
     */

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
                    self.listCharacter = result.results
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchQuery: searchText)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

