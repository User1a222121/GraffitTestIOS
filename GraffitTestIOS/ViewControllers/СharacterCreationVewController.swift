import UIKit
import SnapKit
import CoreData

class СharacterCreationVewController: UIViewController {
    
    // MARK: - Propirties
    var heroOrItemTag = 1
    var indexItem: Int?
    var indexHero: Int?
    private var modelDataURL: [ModelDataURL] = []
    private let networkService = NetworkService()
    private lazy var customActivityIndicator = CustomActivityIndicator()
    private let tableView = UITableView()
    var dataManager = DataManager()
    private var arrayItem: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        customActivityIndicator.showLoader()
        setupTableView()
        arrayItem = dataManager.obtainMainWeaponItem()
        networkService.request { (result) in
            switch result {
            case .success(let data):
                self.modelDataURL = data
            case .failure (let error):
                print("Error received requesting data: \(error.localizedDescription)")
                let alertVC = UIAlertController(
                            title: "Error",
                            message: "Error connecting to the server",
                            preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertVC.addAction(action)
                        self.present(alertVC, animated: true, completion: nil)
            }
            self.customActivityIndicator.hideLoader()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - func
    private func initializeView() {
        view.backgroundColor = .systemGreen
    }
    
    private func setupTableView() {
        tableView.frame = CGRect(x: 0.0, y: 0.0, width: 300.0, height: 800.0)
        tableView.separatorStyle = .singleLine
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        tableView.tableFooterView = customActivityIndicator
        view.addSubview(tableView)
        tableView.register(HeroCell.self, forCellReuseIdentifier: HeroCell.reuseId)
        tableView.register(WeaponCell.self, forCellReuseIdentifier: WeaponCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
}

// MARK: - extension UITableViewDelegate, UITableViewDataSource
extension СharacterCreationVewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counterRows = 0
        if heroOrItemTag == 0 {
            counterRows = modelDataURL.count
        } else if heroOrItemTag == 1 {
            counterRows = arrayItem.count
        }
        return counterRows
    }
    
    // MARK: -  cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.heroOrItemTag == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseId) as? HeroCell {
                
                cell.setDataModelInHeroCell(with: modelDataURL[indexPath.row])
                
                return cell
            }
        } else if self.heroOrItemTag == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: WeaponCell.reuseId) as? WeaponCell {
                
                cell.setDataModelInItemCell(with: arrayItem[indexPath.row])
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if heroOrItemTag == 0 {
            guard let indexHero = self.indexHero else { return }
            dataManager.updateDartCommand(with: nil, modelHero: modelDataURL[indexPath.row], indexHero: indexHero, indexItem: nil)
            
        } else if heroOrItemTag == 1 {
            guard let indexItem = self.indexItem, let indexHero = self.indexHero else { return }
            dataManager.updateDartCommand(with: arrayItem[indexPath.row], modelHero: nil, indexHero: indexHero, indexItem: indexItem)
        }
    }
}
