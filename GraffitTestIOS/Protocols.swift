import UIKit

protocol DelegateProtocol: AnyObject {
    
    func didPressHero(with indexHero: Int)
    func didPressHeroItem(indexHero: Int, indexItem: Int)
}

protocol HeroViewDelegate: AnyObject {
    
    func didPressHero(with: UIButton)
    func didPressHeroItem(with: UIButton ,index: Int)
}


