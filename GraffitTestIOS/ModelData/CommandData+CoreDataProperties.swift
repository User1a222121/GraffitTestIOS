import Foundation
import CoreData

extension CommandData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommandData> {
        return NSFetchRequest<CommandData>(entityName: "CommandData")
    }

    @NSManaged public var commandName: String?
    @NSManaged public var isDraft: Bool
    @NSManaged public var hero: NSSet?
    
    public var wrappedCommandName: String {
        commandName ?? ""
    }
    
    public var heroArray: [Hero] {
        let set = hero as? Set<Hero> ?? []
        return set.sorted { $0.wrappedID.decimalValue < $1.wrappedID.decimalValue}
    }
    
    convenience init(commandName: String, isDraft: Bool, hero: NSSet, context: NSManagedObjectContext!) {
        self.init(context: context)
        self.commandName = commandName
        self.isDraft = isDraft
        self.hero = hero
    }
}

// MARK: Generated accessors for hero
extension CommandData {

    @objc(addHeroObject:)
    @NSManaged public func addToHero(_ value: Hero)

    @objc(removeHeroObject:)
    @NSManaged public func removeFromHero(_ value: Hero)

    @objc(addHero:)
    @NSManaged public func addToHero(_ values: NSSet)

    @objc(removeHero:)
    @NSManaged public func removeFromHero(_ values: NSSet)

}

extension CommandData : Identifiable {

}
