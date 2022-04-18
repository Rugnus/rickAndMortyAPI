//
//  ViewController.swift
//  RickAndMortyAPI
//
//  Created by Sungur on 17.04.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        return table
    }()
    
    private var results = [Results]()
    private var character: Results?
    private var viewModels = [CharacterTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rick and Morty"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getCharacters { [weak self] result in
            switch result{
            case .success(let results):
                self?.results = results
                self?.viewModels = results.compactMap({
                    CharacterTableViewCellViewModel(
                        title: $0.name,
                        subtitle: $0.species,
                        imageURL: URL(string: $0.image)
                    )
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterTableViewCell.identifier,
            for: indexPath
        ) as? CharacterTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        self.character = results[indexPath.row]
        performSegue(withIdentifier: "showCharacter", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "showCharacter" else {return}
//        guard let destination = segue.destination as? CharacterViewController else {return}
        if let destination = segue.destination as? CharacterViewController {
            destination.results = self.character
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

