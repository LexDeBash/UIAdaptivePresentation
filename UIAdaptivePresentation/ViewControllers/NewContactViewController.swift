//
//  NewContactViewController.swift
//  UIAdaptivePresentation
//
//  Created by Alexey Efimov on 04/10/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import UIKit

protocol NewContactViewControllerDelegate {
    func saveContact(_ contact: String)
}

class NewContactViewController: UIViewController {

    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    var delegate: NewContactViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentationController?.delegate = self
        
        firstNameTextField.addTarget(
            self,
            action: #selector(firstNameTextFieldDidChanged),
            for: .editingChanged
        )
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        let fullName = "\(firstName) \(lastName)"
        DataManager.shared.saveContact(fullName)
        delegate.saveContact(fullName)
        dismiss(animated: true)
    }
    
    @IBAction func canceButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func firstNameTextFieldDidChanged() {
        guard let firstName = firstNameTextField.text else { return }
        doneButton.isEnabled = !firstName.isEmpty ? true : false
        isModalInPresentation = !firstName.isEmpty ? true : false
    }
    
    private func showAlertSheet() {
        let alertSheet = UIAlertController(title: "Blah", message: "Blah-blah-blah", preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save Contact", style: .default) { _ in
            guard let firstName = self.firstNameTextField.text else { return }
            guard let lastName = self.lastNameTextField.text else { return }
            let fullName = "\(firstName) \(lastName)"
            DataManager.shared.saveContact(fullName)
            self.delegate.saveContact(fullName)
            self.dismiss(animated: true)
        }
        
        let deleteContact = UIAlertAction(title: "Delete Contact", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertSheet.addAction(saveAction)
        alertSheet.addAction(deleteContact)
        alertSheet.addAction(cancelAction)
        
        present(alertSheet, animated: true)
    }
}

extension NewContactViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if doneButton.isEnabled {
            showAlertSheet()
        }
    }
}
