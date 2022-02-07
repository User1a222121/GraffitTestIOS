import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    // MARK: - Propirties
    private let tableView = UITableView(frame: .zero , style: .plain)
    var heroData: [Hero] = []
    
    // MARK: - viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        setupTableView()
    }
    
    // MARK: - func
    private func initializeView() {
        view.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        tableView.register(HeroCell.self, forCellReuseIdentifier: HeroCell.reuseId)
        tableView.register(WeaponCell.self, forCellReuseIdentifier: WeaponCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 5,
                                                                                            left: 16,
                                                                                            bottom: 0,
                                                                                            right: 16))
        }
    }
}

// MARK: - extension UITableViewDataSource, UITableViewDelegate
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row > 0 {
            return 70
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  heroData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !heroData.isEmpty{
            let sectionContent = heroData[section].itemHero!.count + 1
            return sectionContent
        } else {
            return 0
        }
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseId) as? HeroCell {
                if !heroData.isEmpty {
                    let data = heroData[indexPath.section]
                    cell.setDataModelInHeroCellforDetail(with: data)
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: WeaponCell.reuseId) as? WeaponCell {
                if !heroData.isEmpty {
                    let data = heroData[indexPath.section]
                    cell.setDataModelInItemCell(with: data.itemArray[indexPath.row - 1])
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        footerView.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(tableView.frame.size.width)
        }
        return footerView
    }
}
