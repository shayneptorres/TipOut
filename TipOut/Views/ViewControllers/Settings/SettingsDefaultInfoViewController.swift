//
//  SettingsDefaultInfoViewController.swift
//  TipOut
//
//  Created by Shayne Torres on 9/6/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

class SettingsDefaultInfoViewController: AppViewController {
    
    enum SegmentType: Int, CaseIterable {
        case server = 0
        case bar
        
        var displayName: String {
            switch self {
            case .server:
                return "Server"
            case .bar:
                return "Bar"
            }
        }
    }
    
    private var headerLabel = AppLabel()
    private var presetSegmentControl = UISegmentedControl()
    private let tipoutTableViewController = TipOutTableViewController()
    private let tipoutTableViewContainerView = UIView()
    private let presets: [TipPreset] = TipPreset.getDefaults().sorted(by: { $0.createdAt < $1.createdAt })
    
    var headerMessage: String? {
        didSet {
            self.headerLabel.text = self.headerMessage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icRefresh"), style: .done, target: self, action: #selector(self.onRefresh))
        
        self.view.addSubview(self.headerLabel)
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerMessage = "Below are the default Tipout Presets. These are here as an example of a real world Preset and how you can use this app. There are two examples here for reference to show who and how much a Server or a Bartender would tipout."
        self.headerLabel.numberOfLines = 0
        
        self.view.addSubview(self.presetSegmentControl)
        self.presetSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.presetSegmentControl.addTarget(self, action: #selector(self.onDidSelectSegment), for: .primaryActionTriggered)
        for type in SegmentType.allCases {
            self.presetSegmentControl.insertSegment(withTitle: type.displayName, at: type.rawValue, animated: true)
        }
        
        // Table View Controller
        self.view.addSubview(self.tipoutTableViewContainerView)
        self.tipoutTableViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.tipoutTableViewContainerView.addSubview(self.tipoutTableViewController.view)
        self.tipoutTableViewController.view.constrainEdgesToSuperView()
        self.addChild(self.tipoutTableViewController)
        if self.presets.count > 0 {
            self.tipoutTableViewController.preset = self.presets[0]
        }
        
        NSLayoutConstraint.activate([
            // Header label
            self.headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.headerLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.headerLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            self.headerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            // Segment Control
            self.presetSegmentControl.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 12),
            self.presetSegmentControl.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            self.presetSegmentControl.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            self.presetSegmentControl.heightAnchor.constraint(equalToConstant: 40),
            // Table view
            self.tipoutTableViewContainerView.topAnchor.constraint(equalTo: self.presetSegmentControl.bottomAnchor, constant: 8),
            self.tipoutTableViewContainerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.tipoutTableViewContainerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.tipoutTableViewContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presetSegmentControl.selectedSegmentIndex = 0
    }
    
    @objc func onRefresh() {
        let alertController = UIAlertController(title: "Restore Defaults", message: "Are you sure you want to restore the default presets? If they have been deleted, the default presets will be added back into your saved list of presets", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Restore", style: .default) { _ in
            DataManager.performChanges { context in
                for preset in self.presets {
                    preset.isArchived = false
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    @objc func onDidSelectSegment() {
        guard self.presets.count > 1, let segmentType = SegmentType(rawValue: self.presetSegmentControl.selectedSegmentIndex) else { return }
        
        switch segmentType {
        case .server:
            self.tipoutTableViewController.preset = self.presets[0]
        case .bar:
            self.tipoutTableViewController.preset = self.presets[1]
        }
    }
}
