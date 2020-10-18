//
//  LightsViewController.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import UIKit
import RxSwift

class LightsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var modeSwitch: UISwitch!
    @IBOutlet private weak var intensitySlider: UISlider!
    @IBOutlet private weak var intensityStackView: UIStackView!
    @IBOutlet private weak var intensityValueLabel: UILabel!
    
    // MARK: - Properties
    
    private let viewModel: LightViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init(viewModel: LightViewModel) {
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
        updateIntensityValue(value: viewModel.intensity.value)
        
        modeSwitch.rx.value <-> viewModel.mode
        
        viewModel.mode.subscribe(onNext: { [weak self] value in
            if value {
                self?.intensityStackView.isHidden = false
            } else {
                self?.intensityStackView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        
        intensitySlider
            .rx.value
            .subscribe(onNext: { [weak self] (value) in
                let integerValue = Int(value)
                self?.intensityValueLabel.text = "\(integerValue)"
                self?.viewModel.intensity.accept(integerValue)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateIntensityValue(value: Int) {
        self.intensitySlider.value = Float(value)
        self.intensityValueLabel.text = "\(value)"
    }
}
