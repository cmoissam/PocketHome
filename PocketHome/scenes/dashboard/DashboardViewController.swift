//
//  DashboardViewController.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import UIKit
import RxCocoa
import RxSwift

class DashboardViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var moduleTableView: UITableView!
    @IBOutlet weak var heatersSwitch: UISwitch!
    @IBOutlet weak var shuttersSwitch: UISwitch!
    @IBOutlet weak var lightsSwitch: UISwitch!
    
    // MARK: - Properties
    
    private let coordinator: AppRoutingLogic
    private let viewModel: DashboardViewModel
    
    // MARK: - Initializers
    
    init(
        coordinator: AppRoutingLogic,
        viewModel: DashboardViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModulesTableView()
        setupTypeSelectStackView()
        setUpAddButton()
        title = "Dashboard"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadModules()
    }

    // MARK: - Private methods
    
    private func pushModuleViewController(for id: Int, type: ProductType) {
        switch type {
        case .Heater:
            coordinator.showHeaterViewController(moduleId: id)
        case .RollerShutter:
            coordinator.showRollerShutterViewController(moduleId: id)
        case .Light:
            coordinator.showLighViewController(moduleId: id)
        }
    }
}

// MARK: - Binding Setup
extension DashboardViewController {
    
    private func setupModulesTableView() {
        moduleTableView.register(
            UINib(nibName: ModuleTableViewCell.Identifier, bundle: nil),
            forCellReuseIdentifier: ModuleTableViewCell.Identifier
        )
       
        viewModel.modulesPublisher.bind(
            to: moduleTableView.rx.items(
                cellIdentifier: ModuleTableViewCell.Identifier,
                cellType: ModuleTableViewCell.self)
        ) { [weak self] (row,module,cell) in
            let moduleTableViewCellViewModel =  ModuleTableViewCellViewModel(
                moduleId: module.moduleId,
                moduleIconName: module.productType.iconName,
                moduleName: module.moduleName
            )
            let deleteAction: (Int) -> Void = { [weak self] moduleId in
                self?.viewModel.deleteModule(for: moduleId)
            }
            cell.configure(
                viewModel: moduleTableViewCellViewModel,
                deleteAction: deleteAction
            )
        }.disposed(by: viewModel.disposeBag)
        
        moduleTableView.rx
            .modelSelected(DashboardDrawableModule.self)
            .subscribe(onNext:  { [weak self] module in
                self?.pushModuleViewController(for: module.moduleId, type: module.productType)
            })
            .disposed(by: viewModel.disposeBag)
    }

    private func setupTypeSelectStackView() {
        heatersSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(heatersSwitch.rx.value)
            .subscribe(onNext : { value in
                self.viewModel.heatersSelectedPublisher.accept(value)
            })
            .disposed(by: viewModel.disposeBag)
        shuttersSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(shuttersSwitch.rx.value)
            .subscribe(onNext : { value in
                self.viewModel.rollersSelectedPublisher.accept(value)
            })
            .disposed(by: viewModel.disposeBag)
        lightsSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(lightsSwitch.rx.value)
            .subscribe(onNext : { value in
                self.viewModel.lightsSelectedPublisher.accept(value)
            })
            .disposed(by: viewModel.disposeBag)
    }

}

// MARK: - NavBar
extension DashboardViewController {

    private func setUpAddButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "user"), for: .normal)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc
    func addTapped() {
        coordinator.showUserProfileViewController()
    }
}
