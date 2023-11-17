//
//  PortfolioDataHandler.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 17/11/23.
//

import CoreData

class PortfolioDataHandler {
    private let container: NSPersistentContainer
    private let containerName = "Portfolio"
    private let entityName = "Portfolio"
    
    @Published var savedEntities: [Portfolio] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        print("Loading CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
            self.getPortfolio()
        }
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            amount > 0
            ? update(entity: entity, amount: amount)
            : remove(entity: entity)
        } else {
            add(coin, amount: amount)
        }
        
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        
        print("Fetching CoreData Entity - Portfolio")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Error Fetching CoreData Entity - Portfolio: \(error)")
        }
    }
    
    private func add(_ coin: Coin, amount: Double) {
        print("Creating new Coin Entity")
        let entity = Portfolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.currentHoldings = amount
        
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to CoreData: \(error)")
        }
    }
    
    private func update(entity: Portfolio, amount: Double) {
        entity.currentHoldings = amount
        applyChanges()
    }
    
    private func remove(entity: Portfolio) {
        container.viewContext.delete(entity)
    }
    
    private func applyChanges() {
        print("Saving and Refreshing Data")
        save()
        getPortfolio()
    }
    
}
