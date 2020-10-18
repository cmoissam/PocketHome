//
//  HeatersViewController.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import UIKit
import RxSwift

class HeatersViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var modeSwitch: UISwitch!
    @IBOutlet private weak var temperatureSlider: UISlider!
    @IBOutlet private weak var temperatureStackView: UIStackView!
    @IBOutlet private weak var temperatureValueLabel: UILabel!
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: HeaterViewModel
    
    // MARK: - Initializers
    
    init(viewModel: HeaterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.productName
        setUpBindings()
    }
    
    
    // MARK: - Private methods
    
    private func setUpBindings() {
        updateTemperatureValue(value: viewModel.temperature.value)
        
        temperatureSlider
            .rx.value
            .subscribe(onNext: { [weak self] (value) in
                let fixedValue = roundf(value / 0.5) * 0.5
                self?.updateTemperatureValue(value: fixedValue)
                self?.viewModel.temperature.accept(fixedValue)
                
            })
            .disposed(by: disposeBag)
        
        modeSwitch.rx.value <-> viewModel.mode
        
        viewModel.mode.subscribe(onNext: { [weak self] value in
            if value {
                self?.temperatureStackView.isHidden = false
            } else {
                self?.temperatureStackView.isHidden = true
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateTemperatureValue(value: Float) {
        self.temperatureSlider.value = value
        self.temperatureValueLabel.text = "\(value)"
    }
}
