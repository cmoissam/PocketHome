//
//  RollerShutersViewController.swift
//  PocketHome
//
//  Created by Issam Lanouari on 18/10/2020.
//

import UIKit
import RxSwift

class RollerShutersViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var postitionValueLabel: UILabel!
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * -0.5)
        }
    }
    
    // MARK: - Properties
    
    private let viewModel: RollerShuterViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init(viewModel: RollerShuterViewModel) {
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
        
        updateRollerPosition(value: viewModel.position.value)
        
        slider
            .rx.controlEvent(.valueChanged)
            .withLatestFrom(slider.rx.value)
            .subscribe(onNext: { (value) in
                let intergerValue = Int(value)
                self.postitionValueLabel.text = "\(intergerValue)"
                self.viewModel.position.accept(intergerValue)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateRollerPosition(value: Int) {
        self.slider.value = Float(value)
        self.postitionValueLabel.text = "\(value)"
    }
    
}
