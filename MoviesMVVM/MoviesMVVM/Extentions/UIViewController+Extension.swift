// UIViewController+Extension.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

// Универсальный алерт
extension UIViewController {
    func showAlert(title: String?, message: String?, actionTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertControllerAction = UIAlertAction(title: actionTitle, style: .cancel, handler: handler)
        alertController.addAction(alertControllerAction)
        present(alertController, animated: true)
    }

    func showApiKeyAlert(title: String?, message: String?, actionTitle: String, handler: ((String) -> Void)?) {
        let actionController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            guard let key = actionController.textFields?.first?.text else { return }
            handler?(key)
        }
        actionController.addTextField(configurationHandler: nil)
        actionController.addAction(alertAction)
        present(actionController, animated: true, completion: nil)
    }
}
