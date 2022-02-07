import UIKit
import SnapKit

class CustomActivityIndicator: UIView {
    
    private var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        
        return loader
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElements()
    }
    
    // setup
    private func setupElements() {
        addSubview(loader)
        addSubview(myLabel)
        
        loader.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalToSuperview()
        }
        
        myLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loader.snp.bottom).offset(8)
        }
    }
    
    func showLoader() {
        loader.startAnimating()
        myLabel.text = "Loading..."
    }
    
    func hideLoader() {
        loader.stopAnimating()
        myLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
