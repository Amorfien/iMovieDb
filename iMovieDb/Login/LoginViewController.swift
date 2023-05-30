//
//  LoginViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 29.05.2023.
//

import UIKit

final class LoginViewController: UIViewController {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.backgroundColor = .systemGray5
        view.distribution = .fillProportionally
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loginTextField: TextFieldWithPadding = {
        let login = TextFieldWithPadding()
        login.placeholder = "Login"
        login.keyboardType = .emailAddress
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.tag = 0
        login.returnKeyType = .continue
        login.delegate = self
        return login
    }()

    private lazy var passwordTextField: TextFieldWithPadding = {
        let password = TextFieldWithPadding()
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.tag = 1
        password.returnKeyType = .done
        password.delegate = self
        return password
    }()

    private lazy var loginButton: LoginButton = {
        let button = LoginButton()
        button.setTitle("Login", for: .normal)
        // TODO: - disable button
//        button.isEnabled = false
        button.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
    }

    private func setupView() {
        view.backgroundColor = .systemGray4
        view.addSubview(stackView)
        view.addSubview(loginButton)
        stackView.addArrangedSubview(loginTextField)
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(passwordTextField)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalToConstant: 100),

            lineView.heightAnchor.constraint(equalToConstant: 0.5),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func loginDidTap() {
        let listViewModel = ListViewModel(networkService: NetworkService())
        let listViewController = ListViewController(loginTitle: loginTextField.text!, viewModel: listViewModel)
//        navigationController?.pushViewController(listViewController, animated: true)
        navigationController?.setViewControllers([listViewController], animated: true)
    }
    //  MARK: hide keyboard by tap
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }


}

extension LoginViewController: UITextFieldDelegate {
    // скрывать кнопку ЛогИн при пустых полях
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !loginTextField.text!.isEmpty && passwordTextField.text!.count > 3 {
            loginButton.isEnabled = true
            loginButton.isSelected = false
        } else {
            loginButton.isEnabled = false
        }
    }
    // реакция на кнопку return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
            return true
        } else {
            hideKeyboard()
            return true
        }
    }
}
