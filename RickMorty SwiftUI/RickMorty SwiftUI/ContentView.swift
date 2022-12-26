//
//  ContentView.swift
//  RickMorty SwiftUI
//
//  Created by Dani on 25/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CharactersViewModel()

    var body: some View {
        List(viewModel.characters, id: \.id) { character in
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

    var body: some View {
        HStack() {
            Text(character.name)
                .font(.headline)
            Spacer()
            AsyncImage(
                url: URL(string: character.image),
                content: { image in
                    image.resizable()
                        .frame(width: 50, height: 50)
                },
                placeholder: {
                    ProgressView()
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
