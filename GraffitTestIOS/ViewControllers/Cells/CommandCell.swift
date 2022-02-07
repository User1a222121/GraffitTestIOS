import UIKit
import SnapKit
import CoreData
import Kingfisher

class HeroView: UIView {

    // delegate
    public weak var delegate: HeroViewDelegate?

    // views
    let hero = UIButton(type: .custom)
    let stack = UIStackView()

    // MARK: - public func
    public func configure(with model: Hero) {
        if model.wrappedImageHero == "icon" {
            hero.setImage(UIImage(named: "icon"), for: .normal)
        } else {
            guard let url = URL(string: model.wrappedImageHero) else {return}
            
            hero.kf.setImage(with: url, for: .normal)
        }
        
        model.itemArray.reversed()
            .map { button(for: $0) }
            .forEach { stack.insertArrangedSubview(($0), at: 0) }
        
        let diff = (stack.subviews.count - model.itemArray.count)
        if diff > 0 {
            stack.arrangedSubviews.suffix(model.itemArray.count).forEach { $0.removeFromSuperview() }
        }
    }

    // MARK: - init
    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func buttons
    @objc private func buttonTappedDidPressHero(_ sender: UIButton) {
        delegate?.didPressHero(with: sender)
    }
    
    @objc private func buttonTappedDidPressHeroItem(_ sender: UIButton) {
        
        if let index = stack.arrangedSubviews.firstIndex(where: { $0 === sender }) {
            delegate?.didPressHeroItem(with: sender, index: index)
        }
    }
    
    // MARK: - func
    private func setupLayout() {
        hero.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(0)
            make.height.equalTo(self.snp.height).multipliedBy(0.65).priority(999)
        }

        stack.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(0)
            make.top.equalTo(hero.snp.bottom).offset(5)
        }
    }

    private func configureUI() {

        // Hero button
        hero.layer.cornerRadius = 15
        hero.imageView?.contentMode = .scaleAspectFill
        hero.clipsToBounds = true
        hero.addTarget(self, action: #selector(buttonTappedDidPressHero), for: .touchUpInside)

        addSubview(hero)

        // StackView
        stack.axis = .horizontal
        stack.spacing = 4.0
        stack.alignment = .fill
        stack.distribution = .fillEqually

        addSubview(stack)

        setupLayout()
    }

    private func button(for item: ItemHero) -> UIButton {
        let heroItem = UIButton(type: .custom)
        heroItem.layer.cornerRadius = 5
        heroItem.imageView?.contentMode = .scaleAspectFill
        heroItem.clipsToBounds = true
        heroItem.setImage(UIImage(named: item.wrappedImageWeapon), for: .normal)
        heroItem.addTarget(self, action: #selector(buttonTappedDidPressHeroItem(_:)), for: .touchUpInside)

        return heroItem
    }
}

class CommandCell: UITableViewCell {
    
    // MARK: - Propirties
    static let reuseId = "CommandCell"
    let commandNameLabel = UITextField()
    private var heroViews: [HeroView] = []
    
    // delegate
    public weak var delegate: DelegateProtocol?
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "CommandCell")
        configureUI()
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private func
    private func configureUI() {

        // Cell configure
        backgroundColor = .systemGray4
        layer.cornerRadius = 15

        // CommandNameLabel config
        commandNameLabel.layer.cornerRadius = 8
        commandNameLabel.textAlignment = .center
        commandNameLabel.clearButtonMode = .always
        commandNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        commandNameLabel.adjustsFontSizeToFitWidth = true
        commandNameLabel.returnKeyType = .done
        contentView.addSubview(commandNameLabel)
        commandNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20).priority(999)
            make.bottom.right.equalToSuperview().inset(10)
        }
    }
    
    private func prepareHeroViews(for count: Int) {
        
        let diff = (count - heroViews.count)
        if diff > 0 {
            var newViews: [HeroView] = []
            self.heroViews.forEach{$0.delegate = self}
            
            for _ in 0..<count {
                newViews.append(HeroView())
            }
            newViews.forEach{ contentView.addSubview($0) }
            heroViews.append(contentsOf: newViews)
            heroViews.forEach{$0.delegate = self}
        } else {
            heroViews.suffix(-diff).forEach { $0.removeFromSuperview() }
            heroViews.removeLast(-diff)
        }
    }

    private func configureHeroViewLayout(for count: Int) {
        switch count {
        case 0:
            heroViews[0].snp.makeConstraints { make in
                make.height.equalTo(contentView.snp.width).multipliedBy(0.40).priority(999)
                make.width.equalTo(heroViews[0].snp.height).multipliedBy(0.70).priority(999)
                make.top.left.bottom.equalToSuperview().inset(10)
            }
            
            heroViews[0].subviews[0].snp.makeConstraints { make in
                make.height.equalTo(heroViews[0].snp.height).multipliedBy(0.75)
            }
            
            commandNameLabel.snp.makeConstraints { make in
                make.left.equalTo(heroViews[0].snp.right).offset(10)
            }
            
        case 1:
            heroViews[1].snp.makeConstraints { make in
                make.height.equalTo(heroViews[0].snp.height).multipliedBy(0.74)
                make.width.equalTo(heroViews[0].snp.width).multipliedBy(0.65)
                make.top.equalToSuperview().inset(10)
                make.left.equalTo(heroViews[0].snp.right).offset(10)
            }
            
        case 2:
            heroViews[2].snp.makeConstraints { make in
                make.height.width.top.bottom.equalTo(heroViews[1])
                make.left.equalTo(heroViews[1].snp.right).offset(10)
            }
            
        case 3:
            heroViews[3].snp.makeConstraints { make in
                make.height.width.top.bottom.equalTo(heroViews[1])
                make.left.equalTo(heroViews[2].snp.right).offset(10)
                make.right.equalToSuperview().inset(10)
                make.bottom.equalTo(commandNameLabel.snp.top).offset(1)
            }
            
        default:
            print("error func configureHeroViewLayout (default)")
        }
    }
    
    // MARK: - setDataModelINCell
    func setDataModelINCommandCell(with model: CommandData) {

        let heroesCount = model.heroArray.count
        prepareHeroViews(for: heroesCount)

        for (i, heroView) in heroViews.enumerated() {
            guard model.heroArray.count > i else { break }

            let hero = model.heroArray[i]
            commandNameLabel.placeholder = model.wrappedCommandName
            heroView.configure(with: hero)
            configureHeroViewLayout(for: i)
        }
    }
}

// MARK: - extension HeroViewDelegate
extension CommandCell: HeroViewDelegate {
    
    func didPressHero(with sender: UIButton) {
        var counter = 0
        for view in heroViews {
            if view.hero == sender {
                delegate?.didPressHero(with: counter)
            }
            counter += 1
        }
    }
    
    func didPressHeroItem(with sender: UIButton, index: Int) {
        var counter = 0
        for view in heroViews {
            for viewButton in view.stack.arrangedSubviews {
                if viewButton == sender {
                    delegate?.didPressHeroItem(indexHero: counter, indexItem: index)
                }
            }
            counter += 1
        }
    }
}
