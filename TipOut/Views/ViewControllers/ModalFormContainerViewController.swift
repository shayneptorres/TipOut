//
//  ModalContainerViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class ModalFormContainerViewController: AppViewController {
    
    private let containerView = UIView()
    private var containerHeightConstraint: NSLayoutConstraint!
    private let viewControllerContainerView: UIView = UIView()
    var formViewController: AppFormViewController?
    private let buttonStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    func setContainer(viewController: AppFormViewController) {
        if self.formViewController != nil {
            self.formViewController?.view.removeFromSuperview()
            self.formViewController = nil
        }
        self.formViewController = viewController
        
        self.addChild(viewController)
        self.viewControllerContainerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // view controller
            viewController.view.topAnchor.constraint(equalTo: self.viewControllerContainerView.topAnchor),
            viewController.view.leftAnchor.constraint(equalTo: self.viewControllerContainerView.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: self.viewControllerContainerView.rightAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: self.viewControllerContainerView.bottomAnchor),
        ])
    }
    
    private func resetViewController() {
        if self.formViewController != nil {
            self.formViewController?.view.removeFromSuperview()
            self.formViewController = nil
        }
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        // Setup background
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        // Setup container view
        self.view.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.backgroundColor = .white
        // set corner radius
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.masksToBounds = true
        
        // setup view controller container view
        self.containerView.addSubview(self.viewControllerContainerView)
        self.viewControllerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup container button stack
        self.containerView.addSubview(self.buttonStack)
        self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
        let cancelButton = AppButton()
        cancelButton.appButtonType = .simpleButton(textColor: .white, bgColor: .lightGray)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.onCancel), for: .primaryActionTriggered)
        let affirmButton = AppButton()
        affirmButton.setTitle("Create", for: .normal)
        affirmButton.appButtonType = .simpleButton(textColor: .white, bgColor: System.theme.seconaryGreen)
        affirmButton.addTarget(self, action: #selector(self.onAffirm), for: .primaryActionTriggered)
        self.buttonStack.addArrangedSubview(cancelButton)
        self.buttonStack.addArrangedSubview(affirmButton)
        self.buttonStack.axis = .horizontal
        self.buttonStack.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            // Container View
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.containerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            self.containerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            // ViewController Container view
            self.viewControllerContainerView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.viewControllerContainerView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.viewControllerContainerView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            // Container Button Stack
            self.buttonStack.heightAnchor.constraint(equalToConstant: 45),
            self.buttonStack.topAnchor.constraint(equalTo: self.viewControllerContainerView.bottomAnchor),
            self.buttonStack.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.buttonStack.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            self.buttonStack.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
        ])
    }
    
    // MARK: - Actions
    @objc func onAffirm() {
        self.formViewController?.onAffirm()
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard !self.containerView.frame.contains(sender.location(in: self.view)) else { return }
        
        self.dismiss(animated: true, completion: {
            
        })
    }
    
}
