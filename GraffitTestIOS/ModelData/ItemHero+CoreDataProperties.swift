import Foundation
import CoreData


extension ItemHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemHero> {
        return NSFetchRequest<ItemHero>(entityName: "ItemHero")
    }

    @NSManaged public var id: NSNumber
    @NSManaged public var damageWeapon: String?
    @NSManaged public var imageWeapon: String?
    @NSManaged public var nameWeapon: String?
    @NSManaged public var hero: Hero?
    
    public var wrappedDamageWeapon: String {
        damageWeapon ?? ""
    }
    public var wrappedImageWeapon: String {
        imageWeapon ?? ""
    }
    public var wrappedNameWeapon: String {
        nameWeapon ?? ""
    }
    public var wrappedID: NSNumber {
        id.self
    }
    
    convenience init(id: NSNumber, damageWeapon: String, imageWeapon: String, nameWeapon: String, context: NSManagedObjectContext!) {
        self.init(context: context)
        self.id = id
        self.damageWeapon = damageWeapon
        self.imageWeapon = imageWeapon
        self.nameWeapon = nameWeapon
    }

}

extension ItemHero : Identifiable {

}
