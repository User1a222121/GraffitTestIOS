import UIKit
import SnapKit
import CoreData

class WeaponCell: UITableViewCell {
    
    // MARK: - Propirties
    static let reuseId = "WeaponCell"
    
    // views
    private let imageWeapon = UIImageView()
    private let nameWeaponLabel = UILabel()
    private let damageWeaponLabel = UILabel()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "WeaponCell")
        
        configureImageHero()
        configureNameLabel()
        configurePhraseLabel()
        
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    func setDataModelInItemCell(with model: NSManagedObject) {
        
        imageWeapon.image = UIImage(named: model.value(forKeyPath: "imageWeapon") as! String)
        nameWeaponLabel.text = model.value(forKeyPath: "nameWeapon") as? String
        damageWeaponLabel.text = model.value(forKeyPath: "damageWeapon") as? String
    }
    
    func setDataModelInItemCellforDetail(with model: NSManagedObject) {
        
        imageWeapon.image = UIImage(named: model.value(forKeyPath: "imageWeapon") as! String)
        nameWeaponLabel.text = model.value(forKeyPath: "nameWeapon") as? String
        damageWeaponLabel.text = model.value(forKeyPath: "damageWeapon") as? String
    }
    
    private func configureImageHero() {
        
        imageWeapon.layer.cornerRadius = 15
        imageWeapon.clipsToBounds = true
        imageWeapon.contentMode = .scaleAspectFill
        contentView.addSubview(imageWeapon)
        imageWeapon.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.30).priority(999)
            make.width.equalTo(imageWeapon.snp.height).multipliedBy(1)
        }
    }
    
    private func configureNameLabel() {
        nameWeaponLabel.textAlignment = .left
        contentView.addSubview(nameWeaponLabel)
        nameWeaponLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(10)
            make.left.equalTo(imageWeapon.snp.right).offset(10)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
    }
    
    private func configurePhraseLabel() {
        damageWeaponLabel.textAlignment = .left
        damageWeaponLabel.numberOfLines = 3
        damageWeaponLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(damageWeaponLabel)
        damageWeaponLabel.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(10)
            make.left.equalTo(imageWeapon.snp.right).offset(10)
            make.height.equalToSuperview().multipliedBy(0.50)
        }
    }
}

