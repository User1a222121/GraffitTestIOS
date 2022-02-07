import UIKit
import SnapKit
import CoreData

class SelectCommandViewController: UIViewController {
    
    // MARK: - Propirties
    private let tableView = UITableView(frame: .zero , style: .plain)
    var dataManager = DataManager()
    private var commandData: [CommandData] = []
    private var filterCommandData: [CommandData] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        setupTableView()
        setupSearchBar()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataModel()
    }
    
    // MARK: - func
    private func initializeView() {
        view.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "trash"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(alertDelAllCommand))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        tableView.register(CommandCell.self, forCellReuseIdentifier: CommandCell.reuseId)
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
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func loadDataModel(){
        let fetchRequest: NSFetchRequest<CommandData> = CommandData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDraft == 0")
        let viewContext = dataManager.viewContext
        do {
            self.commandData = try viewContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch all command data \(error.localizedDescription)")
        }
    }
    
    @objc private func alertDelAllCommand() {
        let alert = UIAlertController(title: "Удалить все команды?",
                                      message: nil,
                                      preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Удалить", style: .default) {(alert) in
            
            for commandName in self.commandData {
                self.dataManager.deleteContext(with: "\(commandName.wrappedCommandName)")
            }
            
            self.commandData.removeAll()
            self.tableView.reloadData()
        }
        let cencelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(clearAction)
        alert.addAction(cencelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - extension UITableViewDelegate, UITableViewDataSource
extension SelectCommandViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterCommandData.count
        }
        return commandData.isEmpty ? 0 : commandData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommandCell.reuseId) as? CommandCell {
            
            cell.layer.borderColor = CGColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
            cell.layer.borderWidth = 1
            cell.commandNameLabel.isEnabled = false
            
            let data: CommandData
            if isFiltering {
                data = filterCommandData[indexPath.row]
            } else {
                data = commandData[indexPath.row]
            }
            cell.setDataModelINCommandCell(with: data)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        if isFiltering {
            vc.heroData = filterCommandData[indexPath.row].heroArray
        } else {
            vc.heroData = commandData[indexPath.row].heroArray
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let commandData = self.commandData[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (_, _, _) in
            
            self.dataManager.deleteContext(with: "\(commandData.wrappedCommandName)")
            if self.isFiltering {
                self.filterCommandData.remove(at: indexPath.row)
            } else {
                self.commandData.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let commandData = self.commandData[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { (_, _, _) in

            commandData.isDraft = true
            do {
                try self.dataManager.viewContext.save()
            } catch let error {
                print("Error save itemHero \(error)")
            }
            let vc = CreateCommandViewController()
            vc.textInLabel = "Внеси изменения в свою команду"
            vc.navigationItem.setHidesBackButton(true, animated: true)
            vc.dataManager = self.dataManager
            self.navigationController?.pushViewController(vc, animated: true)
        }
        editAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

// MARK: extension UISearchResultsUpdating
extension SelectCommandViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filterCommandData = commandData.filter({ (data: CommandData) in
            return data.commandName!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

// MARK: extension UISearchBarDelegate
extension SelectCommandViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}


