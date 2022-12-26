//
//  RickMortyViewModel.swift
//  RickMorty SwiftUI
//
//  Created by Dani on 25/12/22.
//

import Foundation
import Alamofire

class CharactersViewModel: ObservableObject {
    @Published var characters = [Character]()
    @Published var loading = false
    private var page = 1
    
    func fetchCharacters() {
        DispatchQueue.global(qos: .background).async {
            guard self.page != 43 else { return }
            let urlString = "https://rickandmortyapi.com/api/character?page=\(self.page)"
            AF.request(urlString).response { response in
                AF.request(urlString).response { response in
                    guard let data = response.data else { return }
                    let statusCode = response.response?.statusCode

                    let decoder = JSONDecoder()
                    do {
                        self.page += 1
                        let json: CharacterList = try decoder.decode(CharacterList.self, from: data)
                        DispatchQueue.main.async {
                            self.characters.append(contentsOf: json.results)
                        }
                    } catch {
                        print("Decode Error")
                    }
                }
            }
        }
    }
}



