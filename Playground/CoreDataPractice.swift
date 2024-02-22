//
//  CoreDataPractice.swift
//  Playground
//
//  Created by Jason on 2024/2/22.
//

import SwiftUI
import CoreData

// View - UI
// Model - data point
// ViewModel - manages the data for a view
@Observable
class CoreDataViewModel {
    
    let container: NSPersistentContainer
    var savedEntities: [FruitEntity] = [] // <- serves as a publisher for subscribed view to update its UI
    
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("error loading core data. \(error)")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits() {
        withAnimation {
            let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
            
            do {
                savedEntities = try container.viewContext.fetch(request)
            } catch {
                print("\(error)")
            }
        }
    }
    
    func addFruit(name: String) {
        withAnimation {
            let newFruit = FruitEntity(context: container.viewContext)
            newFruit.name = name
            saveData()
        }
    }
    
    func deleteFruit(indexSet: IndexSet) {
        withAnimation {
            guard let index = indexSet.first else { return }
            let entity = savedEntities[index]
            container.viewContext.delete(entity)
            saveData()
        }
    }
    
    func updateFruit(_ entity: FruitEntity) {
        withAnimation {
            let currentName = entity.name ?? ""
            let newName = currentName + "!"
            entity.name = newName
            saveData()
        }
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchFruits()  // <- call this function to update data into the publisher
        } catch {
            print("error saving. \(error)")
        }
        
    }
    
}

struct CoreDataPractice: View {
    @State var vm = CoreDataViewModel()
    @State var textFieldText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                TextField("add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                Button(action: {
                    guard !textFieldText.isEmpty else { return }
                    vm.addFruit(name: textFieldText)
                    textFieldText = ""
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .padding()
                
                List {
                    ForEach(vm.savedEntities) { entity in
                        Text(entity.name ?? "NO NAME")
                            .onTapGesture {
                                vm.updateFruit(entity)
                            }
                    }
                    .onDelete(perform: vm.deleteFruit)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
    }
}

#Preview {
    CoreDataPractice()
}
