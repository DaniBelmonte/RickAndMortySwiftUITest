//
//  ContentView.swift
//  RickMorty SwiftUI
//
//  Created by Dani on 25/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CharactersViewModel()
    @State private var selectedGender: String = "all"

    var body: some View {
        VStack {
            Picker(selection: $selectedGender, label: Text("Filter by gender")) {
                Text("All").tag("all")
                Text("Male").tag("Male")
                Text("Female").tag("Female")
                Text("unknown").tag("unknown")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            List(viewModel.characters.filter { character in
                selectedGender == "all" || character.gender == selectedGender
            }, id: \.id) { character in
                CharacterRow(character: character)
                    .onAppear {
                        if character.id == viewModel.characters.last?.id {
                            viewModel.fetchCharacters()
                        }
                    }
            }
            .onAppear(perform: viewModel.fetchCharacters)
            .overlay(activityIndicator)
        }
    }

    private var activityIndicator: some View {
        Group {
            if viewModel.loading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

struct CharacterRow: View {
    let character: Character
    @State private var image: UIImage?

    var body: some View {
        HStack {
            Text(character.name)
                .font(.headline)
            Spacer()
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if image == nil {
                loadImage()
            }
        }
    }

    private func loadImage() {
        guard let url = URL(string: character.image) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
