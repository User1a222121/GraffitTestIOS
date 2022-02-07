import Foundation
import CoreData


extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var imageHero: String?
    @NSManaged public var nameHero: String?
    @NSManaged public var phraseHero: String?
    @NSManaged public var commandData: CommandData?
    @NSManaged public var itemHero: NSSet?
    
    public var wrappedImageHero: String {
        imageHero ?? ""
    }
    public var wrappedNameHero: String {
        nameHero ?? ""
    }
    public var wrappedPhraseHero: String {
        phraseHero ?? ""
    }
    public var wrappedID: NSNumber {
        id ?? 0
    }
    
    public var itemArray: [ItemHero] {
        let set = itemHero as? Set<ItemHero> ?? []
        return set.sorted { $0.wrappedID.doubleValue < $1.wrappedID.doubleValue }

    }
    
    convenience init(id: NSNumber, imageHero: String, nameHero: String, phraseHero: String, itemHero: NSSet, context: NSManagedObjectContext!) {
        self.init(context: context)
        self.id = id
        self.imageHero = imageHero
        self.nameHero = nameHero
        self.phraseHero = phraseHero
        self.itemHero = itemHero
    }
}

// MARK: Generated accessors for itemHero
extension Hero {

    @objc(addItemHeroObject:)
    @NSManaged public func addToItemHero(_ value: ItemHero)

    @objc(removeItemHeroObject:)
    @NSManaged public func removeFromItemHero(_ value: ItemHero)

    @objc(addItemHero:)
    @NSManaged public func addToItemHero(_ values: NSSet)

    @objc(removeItemHero:)
    @NSManaged public func removeFromItemHero(_ values: NSSet)

}

extension Hero : Identifiable {

}
