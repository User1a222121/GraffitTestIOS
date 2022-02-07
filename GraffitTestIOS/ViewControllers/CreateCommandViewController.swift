import UIKit
import SnapKit
import CoreData

class CreateCommandViewController: UIViewController {
    
    // MARK: - Views
    private let tableView = UITableView(frame: .zero , style: .plain)
    private var alertController = UIAlertController()
    private let headerView = UIView()
    private let headerLabel = UILabel()
    private let headerButton = UIButton(type: .system)
    
    // MARK: - Propirties
    var dataManager = DataManager()
    private var command: CommandData?
    var textInLabel = "Теперь можно приступить к подбору героев для твоей команды. Или подбери героев случайным образом"
    
    // MARK: - viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        setupTableView()
        
        do {
            self.command = try dataManager.obtainOrCreateCommandIfNeeded()
        } catch let error as NSError {
            print("ошибка получения данных из core data (Draft Command) \(error.localizedDescription)")
        }
    }
    
    // MARK: - func
    private func initializeView() {
        view.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
   
    // MARK: - func button
    @objc func saveTapped() {
        
        let viewContext = dataManager.viewContext
        let fetchRequest: NSFetchRequest<CommandData> = CommandData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDraft == 1")
        
        do {
        guard let commandData = try viewContext.fetch(fetchRequest).first else { return }
            
            commandData.isDraft = false
            
            do {
                try viewContext.save()
            } catch let error {
                print("Error save draft command \(error.localizedDescription)")
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - func
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        tableView.register(CommandCell.self, forCellReuseIdentifier: CommandCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16))
        }
    }
    
    func setupSelectionAlert(with HeroOrItem: String, with vc: UIViewController) {
        
        self.alertController = UIAlertController(title: HeroOrItem, message: nil, preferredStyle: .alert)
        alertController.setValue(vc, forKey: "contentViewController")
        let selectAction = UIAlertAction(title: "Выбрать", style: .default) {[unowned self] _ in
            self.tableView.reloadData()
          }
        alertController.addAction(selectAction)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any,
                                                           attribute: NSLayoutConstraint.Attribute.height,
                                                           relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil,
                                                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                           multiplier: 1, constant: self.view.frame.height * 0.70)
        alertController.view.addConstraint(height)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func randomCommandButton() {
        
        guard let command = self.command else { return }
        var modelDataURL: [ModelDataURL] = []
        let arrayItem: [NSManagedObject] = dataManager.obtainMainWeaponItem()
        
        let networkService = NetworkService()
        networkService.request { (result) in
            switch result {
            case .success(let data):
                modelDataURL = data
                for heroCounter in 0..<command.heroArray.count {
                    let randomHero = Int.random(in: 0..<modelDataURL.count)
                    let dataModelURL = modelDataURL[randomHero]
                    self.dataManager.updateDartCommand(with: nil, modelHero: dataModelURL, indexHero: heroCounter, indexItem: nil)
                    
                    for itemCounter in 0..<command.heroArray[heroCounter].itemArray.count {
                        let randomItem = Int.random(in: 0..<arrayItem.count)
                        let dataItem = arrayItem[randomItem]
                        self.dataManager.updateDartCommand(with: dataItem, modelHero: nil, indexHero: heroCounter, indexItem: itemCounter)
                    }
                }
                self.tableView.reloadData()
            case .failure (let error):
                print("Error received requesting data: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - extension UITableViewDataSource, UITableViewDelegate
extension CreateCommandViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: -  cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommandCell.reuseId) as? CommandCell {
            
            cell.commandNameLabel.delegate = self
            cell.delegate = self
            
            if let command = self.command {
            cell.setDataModelINCommandCell(with: command)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        headerView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalTo(tableView.frame.size.width)
        }
        
        headerLabel.text = textInLabel
        headerLabel.font = UIFont.systemFont(ofSize: 22)
        headerLabel.numberOfLines = 0
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        headerButton.backgroundColor = UIColor(red: 54/255, green: 219/255, blue: 224/225, alpha: 1)
        headerButton.setTitle("Случайный подбор", for: .normal)
        headerButton.setTitleColor(.black, for: .normal)
        headerButton.layer.cornerRadius = 20
        headerView.addSubview(headerButton)
        headerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(80)
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        headerButton.addTarget(self, action: #selector(randomCommandButton), for: .touchUpInside)
        
        return headerView
    }
}

//MARK: - Extension UITextFieldDelegate
extension CreateCommandViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let viewContext = dataManager.viewContext
        let fetchRequest: NSFetchRequest<CommandData> = CommandData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDraft == 1")
        
        do {
        guard let commandData = try viewContext.fetch(fetchRequest).first else { return }
            commandData.commandName = textField.text
            do {
                try viewContext.save()
            } catch let error as NSError{
                print("Error save draft command \(error.localizedDescription)")
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

// MARK: - extension DelegateProtocol
extension CreateCommandViewController: DelegateProtocol {
    
    @objc func didPressHero(with indexHero: Int) {
        
        let vc = СharacterCreationVewController()
        vc.heroOrItemTag = 0
        vc.indexHero = indexHero
        vc.dataManager = dataManager
        self.setupSelectionAlert(with: "Вебери героя", with: vc)
    }
    
    @objc func didPressHeroItem(indexHero: Int, indexItem: Int) {
        
        let vc = СharacterCreationVewController()
        vc.heroOrItemTag = 1
        vc.indexItem = indexItem
        vc.indexHero = indexHero
        vc.dataManager = dataManager
        self.setupSelectionAlert(with: "Вебери оружие", with: vc)
    }
}

