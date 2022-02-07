import UIKit
import SnapKit
import Kingfisher

class HeroCell: UITableViewCell {
    
    // MARK: - Propirties
    static let reuseId = "HeroCell"
    private var downloadTask: DownloadTask?
    
    // views
    let imageHero = UIImageView()
    let nameLabel = UILabel()
    let phraseLabel = UILabel()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "HeroCell")
        
        configureImageHero()
        configureNameLabel()
        configurePhraseLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    private func configureImageHero() {
        
        imageHero.layer.cornerRadius = 15
        imageHero.image = (UIImage(named: "icon"))
        imageHero.clipsToBounds = true
        imageHero.contentMode = .scaleAspectFill
        contentView.addSubview(imageHero)
        imageHero.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.30).priority(999)
            make.width.equalTo(imageHero.snp.height).multipliedBy(0.90)
        }
    }
    
    private func configureNameLabel() {
        
        nameLabel.text = ""
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(10)
            make.left.equalTo(imageHero.snp.right).offset(10)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
    }
    
    private func configurePhraseLabel() {
        
        phraseLabel.text = ""
        phraseLabel.textAlignment = .left
        phraseLabel.numberOfLines = 3
        phraseLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(phraseLabel)
        phraseLabel.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(10)
            make.left.equalTo(imageHero.snp.right).offset(10)
            make.height.equalToSuperview().multipliedBy(0.50)
        }
    }
    
    func setDataModelInHeroCell(with model: ModelDataURL) {
        
        guard let url = URL(string: model.img) else {return}
        imageHero.kf.indicatorType = .activity
        downloadTask = KF.url(url)
                .set(to: imageHero)
        self.nameLabel.text = model.name
        self.phraseLabel.text = "The catchphrase of this hero is \"\(model.nickname)\""
    }
    
    func setDataModelInHeroCellforDetail(with model: Hero) {
        
        guard let url = URL(string: model.wrappedImageHero) else {return}
        imageHero.kf.indicatorType = .activity
        downloadTask = KF.url(url)
                .set(to: imageHero)
        self.nameLabel.text = model.wrappedNameHero
        self.phraseLabel.text = "The catchphrase of this hero is \"\(model.wrappedPhraseHero)\""  
    }
}

