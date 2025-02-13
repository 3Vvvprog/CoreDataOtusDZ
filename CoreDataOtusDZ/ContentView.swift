//
//  ContentView.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                
                LazyVGrid(columns: [.init(.flexible(minimum: 0, maximum: 1000))]) {
                    if viewModel.characters.isEmpty {
                        ProgressView()
                    }else {
                        ForEach(viewModel.characters) { character in
                            ItemRaw(character: character)
                                .environmentObject(viewModel)
                                .onAppear {
                                    if character.id == viewModel.characters.last?.id && viewModel.hasMoreData {
                                        viewModel.loadCharacters()
                                        print(character.id, viewModel.characters.last?.id)
                                        
                                    }
                                }
                        }
                    }
                }
            }
        }
        .onAppear {
            if viewModel.characters.isEmpty {
                viewModel.loadCharacters()
            }
        }
    }
    
    

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
        .environmentObject(ViewModel())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
