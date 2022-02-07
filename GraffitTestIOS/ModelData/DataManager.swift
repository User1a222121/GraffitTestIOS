import Foundation
import CoreData

class DataManager {
    
    static var shared = DataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GraffitTestIOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext : NSManagedObjectContext = persistentContainer.viewContext

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data delete support
    func deleteContext(with commandName: String) {
        
        let fetchRequest: NSFetchRequest<CommandData> = CommandData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "commandName == %@", commandName)
        guard let commandData = try? viewContext.fetch(fetchRequest) else { return }
        viewContext.delete(commandData.first!)
        
        do {
            try viewContext.save()
            
        } catch let error as NSError {
            print("ошибка удаления данный \(error.localizedDescription)")
        }
    }
    
    // MARK: - Core Data obtain support
    
    func obtainOrCreateCommandIfNeeded() throws ->  CommandData {
        
        if let draftCommand = try obtainIsDraft() {
            return draftCommand
        } else {
            let draftCommand = obtainMainCommand()
            return draftCommand
        }
    }
    
    func obtainIsDraft() throws ->  CommandData? {
        
        let fetchRequest: NSFetchRequest<CommandData> = CommandData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDraft == true")
        
        return try viewContext.fetch(fetchRequest).first
    }
    
    func obtainMainCommand() -> CommandData {
        
        let command = CommandData(commandName: "Название команды", isDraft: true, hero: [
            Hero(id: 1, imageHero: "icon", nameHero: "hero1", phraseHero: "", itemHero: [
                ItemHero(id: 1, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero1", context: viewContext),
                ItemHero(id: 2, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero2", context: viewContext),
                ItemHero(id: 3, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero3", context: viewContext)],
                context: viewContext),
            Hero(id: 2, imageHero: "icon", nameHero: "hero2", phraseHero: "", itemHero: [
                ItemHero(id: 1, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero1", context: viewContext),
                ItemHero(id: 2, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero2", context: viewContext)],
                context: viewContext),
            Hero(id: 3, imageHero: "icon", nameHero: "hero3", phraseHero: "", itemHero: [
                ItemHero(id: 1, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero1", context: viewContext),
                ItemHero(id: 2, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero2", context: viewContext)],
                context: viewContext),
            Hero(id: 4, imageHero: "icon", nameHero: "hero4", phraseHero: "", itemHero: [
                ItemHero(id: 1, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero1", context: viewContext),
                ItemHero(id: 2, damageWeapon: "", imageWeapon: "add", nameWeapon: "itemHero1", context: viewContext)],
                context: viewContext)], context: viewContext)

        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error save obtainMainCommand \(error.localizedDescription)")
        }
        return command
    }
    
    func obtainMainWeaponItem() -> [NSManagedObject] {
        
        var arrayItem: [NSManagedObject] = []
        let fetchRequest: NSFetchRequest<ItemWeapon> = ItemWeapon.fetchRequest()
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ItemWeapon", in: context)!
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let obtainItemData: [String: String] = ["Ak47": "+ 100",
                                                        "Colt": "+ 50",
                                                        "Armor": " - 50 damage",
                                                        "Lantern": "+ 10",
                                                        "Smoke": "+ 20",
                                                        "Tonfa": "+ 30"
                ]
                
                for item in obtainItemData {
                
                    let itemHero = NSManagedObject(entity: entity, insertInto: context)
                    itemHero.setValue(item.key, forKeyPath: "nameWeapon")
                    itemHero.setValue(item.key, forKeyPath: "imageWeapon")
                    itemHero.setValue(item.value, forKeyPath: "damageWeapon")
                
                    do {
                        try viewContext.save()
                    } catch let error {
                        print("======== Error save obtainMainWeaponItem \(error)")
                    }
                }
            }
            let results = try context.fetch(fetchRequest)
            for result in results as [NSManagedObject] {
                arrayItem.append(result)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return arrayItem
    }
    
    // MARK: - Core Data update support
    func updateDartCommand(with modelItem: NSManagedObject?, modelHero: ModelDataURL?, indexHero: Int, indexItem: Int?) {
        
        let fetchRequest: NSFetchRequest<CommandData> = CommandData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDraft == 1")
        
        do {
        guard let commandData = try viewContext.fetch(fetchRequest).first else { return }
            
            if indexItem == nil {
                commandData.heroArray[indexHero].imageHero = modelHero?.img
                commandData.heroArray[indexHero].nameHero = modelHero?.name
                commandData.heroArray[indexHero].phraseHero = modelHero?.nickname
            } else {
                guard let index = indexItem else {return}
                commandData.heroArray[indexHero].itemArray[index].imageWeapon = modelItem?.value(forKeyPath: "imageWeapon") as? String
                commandData.heroArray[indexHero].itemArray[index].nameWeapon = modelItem?.value(forKeyPath: "nameWeapon") as? String
                commandData.heroArray[indexHero].itemArray[index].damageWeapon = modelItem?.value(forKeyPath: "damageWeapon") as? String
            }
            
            do {
                try viewContext.save()
            } catch let error as NSError {
                print("error \(error.localizedDescription)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
