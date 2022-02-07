import Foundation
import CoreData


extension ItemWeapon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemWeapon> {
        return NSFetchRequest<ItemWeapon>(entityName: "ItemWeapon")
    }

    @NSManaged public var damageWeapon: String?
    @NSManaged public var imageWeapon: String?
    @NSManaged public var nameWeapon: String?

}

extension ItemWeapon : Identifiable {

}
