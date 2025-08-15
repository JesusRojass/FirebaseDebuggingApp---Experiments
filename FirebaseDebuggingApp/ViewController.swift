//
//  ViewController.swift
//  FirebaseDebuggingApp
//
//  Created by jose.valente on 12/08/25.
//

import UIKit

final class ViewController: UIViewController {
    
    private let infoLabel = UILabel()
    private let blockSwitch = UISwitch()
    private let blockButton = UIButton(type: .system)
    private let bgHelpLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PerfReproApp"
        view.backgroundColor = .systemBackground
        
        infoLabel.numberOfLines = 0
        infoLabel.text = "Repro Tools:\n• Simulate BG Fetch (Debug ▶ Simulate Background Fetch)\n• Lock device during cold launch\n• Toggle to block main thread after active."
        
        blockSwitch.isOn = false
        blockButton.setTitle("Block 2s at activation (toggle)", for: .normal)
        blockButton.addTarget(self, action: #selector(toggleBlock), for: .touchUpInside)
        
        bgHelpLabel.numberOfLines = 0
        bgHelpLabel.textColor = .secondaryLabel
        bgHelpLabel.text = "Tip: Add -FIRDebugEnabled to see 'App start trace stop' in logs."
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, blockButton, blockSwitch, bgHelpLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LaunchMetrics.shared.markFirstFrameDrawn()
        
        if blockSwitch.isOn {
            NSLog("[PerfRepro] Simulating main-thread block (2s) on first frame")
            let start = CFAbsoluteTimeGetCurrent()
            while CFAbsoluteTimeGetCurrent() - start < 2.0 { /* busy wait */ }
            NSLog("[PerfRepro] Done blocking")
        }
    }
    
    @objc private func toggleBlock() {
        blockSwitch.setOn(!blockSwitch.isOn, animated: true)
    }
}
