//
//  LoginViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 29.05.2023.
//

import UIKit

final class LoginViewController: UIViewController {

    private var viewModel: LoginViewModelProtocol

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0.5
        view.backgroundColor = .lightGray
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
        login.backgroundColor = .systemGray5
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
        password.backgroundColor = .systemGray5
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
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        return button
    }()

    // MARK: - INIT
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else {
                print("???????\n")
                return
            }
            switch state {
            case .login(let user):
                print("Success Login")
                let listViewModel = ListViewModel(networkService: NetworkService(), user: user)
                let listViewController = ListViewController(viewModel: listViewModel)
                navigationController?.setViewControllers([listViewController], animated: true)
            case .initial:
                passwordTextField.text = ""
            case .lastUser(let login):
                loginTextField.text = login
            case .error(let error):
                alerting(title: "Error", message: error.rawValue, vc: self) { [weak self] _ in
                    self?.viewModel.updateState(viewInput: .errorCanceling)
                }
            }
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
        bindViewModel()
        viewModel.checkLastUser()
    }

    private func setupView() {
//        loginTextField.text = UserSettings.lastUser?.login
        view.backgroundColor = .systemGray4
        view.addSubview(stackView)
        view.addSubview(loginButton)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalToConstant: 100),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func loginDidTap() {
        viewModel.updateState(viewInput: .loginButtonDidTap(user: User(login: loginTextField.text ?? "",
                                                                       password: passwordTextField.text ?? "")))
//        let listViewModel = ListViewModel(networkService: NetworkService())
//        let listViewController = ListViewController(viewModel: listViewModel)
//        navigationController?.setViewControllers([listViewController], animated: true)
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
