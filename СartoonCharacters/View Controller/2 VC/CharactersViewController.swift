//
//  CharactersViewController.swift
//  СartoonCharacters
//
//  Created by Николай Петров on 05.03.2022.
//

import UIKit

class CharactersViewController: UITableViewController {

    var jsonUrlRaM = "https://rickandmortyapi.com/api/character"
    
    var jsonCountCharacters: Character?
    
    private var characters: [DetailResult]?
    
    var page = 0
       
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
         
        cell.tag = indexPath.row
        let imageVC = ImageView()
        imageVC.cellTag = cell.tag
        imageVC.indexPath = indexPath
        
        let character = (characters?[indexPath.row])
        cell.configure(with: character, cell.tag)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("WIL DISPLAY")
//        guard let url = URL(string: characters?[indexPath.row].image ?? "") else { return }
//        print("WIL DISPLAY2")
//        guard let _ = ImageView().getCachedImage(url: url) else { return }
//        print("WIL DISPLAY3")
//        preLoadImage(indexPath)
//        
//    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

        
    func fetchDataRaM() {

        guard let url = URL(string: jsonUrlRaM ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
           
            do {
                self.characters = try JSONDecoder().decode([DetailResult].self, from: data)
                
                DispatchQueue.main.async {
                    //self.preLoadImage()
                    print("RELOAD")
                    self.tableView.reloadData()
                }
                print(self.characters ?? "Error characters")
            } catch let error {
                print(error)
            }
        }.resume()
        
        
    }
    
    func preLoadImage(_ index: IndexPath) {

        guard let url = characters?[index.row + 2].image else { return }
        print(url)
        guard let imgeUrl = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imgeUrl) { data, response, error in
            if let error = error { print(error); return }
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else {  return }

            if responseURL.absoluteString != url { return }

            DispatchQueue.main.async {
                //print(url)
                ImageView().saveImageToCache(data: data, response: response)
            }

        }.resume()

    }

}
