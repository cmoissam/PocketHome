//
//  ModuleTableViewCell.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import UIKit
import RxCocoa
import RxSwift

class ModuleTableViewCell: UITableViewCell {
    
    static let Identifier = "ModuleTableViewCell"
    
    @IBOutlet weak var moduleIconView: UIImageView!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var moduleNameLabel: UILabel!
    
    private var viewModel: ModuleTableViewCellViewModel? {
        didSet {
            self.updateUI()
        }
    }
    private var deleteAction: ((_ moduleId: Int) -> Void)?
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.rx.tap.bind { [weak self] in
            guard let safeViewModel = self?.viewModel else {
                debugPrint("cannot update UI with nil viewModel")
                return
            }
            self?.deleteAction?(safeViewModel.moduleId)
        }.disposed(by: disposeBag)
    }

    func configure(
        viewModel: ModuleTableViewCellViewModel,
        deleteAction: @escaping (_ moduleId: Int) -> Void
    ) {
        self.deleteAction = deleteAction
        self.viewModel = viewModel
    }
    private func updateUI() {
        guard let safeViewModel = self.viewModel else {
            debugPrint("cannot update UI with nil viewModel")
            return
        }
        moduleNameLabel.text = safeViewModel.moduleName
        moduleIconView.image = UIImage(named: safeViewModel.moduleIconName)
    }
}

struct ModuleTableViewCellViewModel {
    let moduleId: Int
    let moduleIconName: String
    let moduleName: String
}
