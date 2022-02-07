import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Views
    private let label = UILabel()
    private let buttonCreateCommand = UIButton(type: .system)
    private let buttonOverviewCommand = UIButton(type: .system)
    private let dataManager = DataManager()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    // MARK: - func
    private func initializeView() {
        view.backgroundColor = UIColor(red: 235/255, green: 236/255, blue: 240/255, alpha: 1)
        label.text = "Хочешь спасти мир?! Одному это может оказаться не под силу! Собери свою команду и вперед!"
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(80)
        }
        
        buttonCreateCommand.backgroundColor = UIColor(red: 54/255, green: 219/255, blue: 224/225, alpha: 1)
        buttonCreateCommand.setTitle("Создать команду", for: .normal)
        buttonCreateCommand.setTitleColor(.black, for: .normal)
        buttonCreateCommand.layer.cornerRadius = 20
        buttonCreateCommand.addTarget(self, action: #selector(buttonTappedCreateCommand), for: .touchUpInside)
        view.addSubview(buttonCreateCommand)
        buttonCreateCommand.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(80)
            make.top.equalTo(label.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
        
        buttonOverviewCommand.backgroundColor = UIColor(red: 54/255, green: 219/255, blue: 224/225, alpha: 1)
        buttonOverviewCommand.setTitle("Выбрать команду", for: .normal)
        buttonOverviewCommand.setTitleColor(.black, for: .normal)
        buttonOverviewCommand.layer.cornerRadius = 20
        buttonOverviewCommand.addTarget(self, action: #selector(buttonTappedOverviewSaveCommand), for: .touchUpInside)
        view.addSubview(buttonOverviewCommand)
        buttonOverviewCommand.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(80)
            make.top.equalTo(buttonCreateCommand.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - func button
    @objc private func buttonTappedCreateCommand() {
        let vc = CreateCommandViewController()
        vc.dataManager = dataManager
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func buttonTappedOverviewSaveCommand() {
        let vc = SelectCommandViewController()
        vc.dataManager = dataManager
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
