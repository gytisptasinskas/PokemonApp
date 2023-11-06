//
//  PokemonViewController.swift
//  PokemonApp
//
//  Created by Gytis Ptašinskas on 06/11/2023.
//

import UIKit

class PokemonTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var pokemon: [Card] = []
    var filteredPokemon: [Card] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPokemonData()
        setupSearchController()
    }
    
    func loadPokemonData(){
            let jsonUrl = "https://api.pokemontcg.io/v1/cards"
            guard let url = URL(string:jsonUrl) else { return }
            
            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true
            
            URLSession(configuration: config).dataTask(with: request){
                data,response,error in
                if error != nil{
                    print((error?.localizedDescription)!)
                }
                dump(response)
                
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                
                do{
                    let jsonData = try JSONDecoder().decode(Pokemon.self,from:data)
                    dump(jsonData)
                    self.pokemon = jsonData.cards
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }catch{
                    print("error::::",error)
                }
            }.resume()
            
        }
    
    // MARK: - Setup Search Controller
    func setupSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon by Type"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPokemon = pokemon.filter { (card: Card) -> Bool in
            return card.types?.contains(where: { $0.localizedCaseInsensitiveContains(searchText) }) ?? false
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredPokemon.count : pokemon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pokemonCard = isFiltering ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        cell.textLabel?.text = pokemonCard.name
        cell.detailTextLabel?.text = pokemonCard.types?.joined(separator: ", ")
        return cell
    }
    
    // MARK: - Helper Method for Search Controller
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PokemonDetailViewController()
        detailVC.pokemonCard = pokemon[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
