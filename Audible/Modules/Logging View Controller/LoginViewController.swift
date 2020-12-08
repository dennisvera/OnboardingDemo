//
//  LoginViewController.swift
//  Audible
//
//  Created by Dennis Vera on 11/29/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {

  func finishLoggingIn()
}

final class LoginViewController: UIViewController, UICollectionViewDelegateFlowLayout {

  // MARK: - Properties

  private var collectionView: UICollectionView!

  private lazy var pageControl: UIPageControl = {
    let pageController = UIPageControl()
    pageController.pageIndicatorTintColor = .lightGray
    pageController.currentPageIndicatorTintColor = .orange
    pageController.numberOfPages = onBoardingPages.count + 1
    return pageController
  }()

  // MARK: -

  private let skipButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Skip", for: .normal)
    button.setTitleColor(.orange, for: .normal)
    button.addTarget(self, action: #selector(skipToLoginPage), for: .touchUpInside)
    return button
  }()

  private let nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Next", for: .normal)
    button.setTitleColor(.orange, for: .normal)
    button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    return button
  }()

  // MARK: -

  private var skipButtonTopAnchor: NSLayoutConstraint!
  private var nextButtonTopAnchor: NSLayoutConstraint!
  private var pageControlBotttomAnchor: NSLayoutConstraint!

  // MARK: -

  private let onBoardingPages: [Onboarding] = {
    let firstPage = Onboarding(title: "Share a great listen",
                               subTitle: "It's free to send your books to the people in your life. Every recipient's first book is on us.",
                               imageName: "page1")
    let secondPage = Onboarding(title: "Send from your library",
                                subTitle: "Tap the More menu next to any book. Choose \"Send this Book\"",
                                imageName: "page2")
    let thirdPage = Onboarding(title: "Send from the player",
                               subTitle: "Tap the More menu in the upper corner. Choose \"Send this Book\"",
                               imageName: "page3")

    return [firstPage, secondPage, thirdPage]
  }()

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCollectionView()
    setupView()
    registerForKeyboardNotifications()
  }

  // MARK: - Helper Methods

  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.dataSource = self
    collectionView.delegate = self

    collectionView.register(OnboardingCollectionViewCell.self,
                            forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier)

    collectionView.register(LoginCollectionViewCell.self,
                            forCellWithReuseIdentifier: LoginCollectionViewCell.reuseIdentifier)
  }

  private func setupView() {
    view.backgroundColor = .white

    skipButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    pageControl.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(collectionView)
    view.addSubview(pageControl)
    view.addSubview(skipButton)
    view.addSubview(nextButton)

    skipButtonTopAnchor = skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    pageControlBotttomAnchor = pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    NSLayoutConstraint.activate([
      // Skip Button
      skipButtonTopAnchor,
      skipButton.widthAnchor.constraint(equalToConstant: 40),
      skipButton.heightAnchor.constraint(equalToConstant: 40),
      skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),

      // Next Button
      nextButtonTopAnchor,
      nextButton.widthAnchor.constraint(equalToConstant: 40),
      nextButton.heightAnchor.constraint(equalToConstant: 40),
      nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

      // Collection View
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      // Page Controller
      pageControlBotttomAnchor,
      pageControl.heightAnchor.constraint(equalToConstant: 40),
      pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    // Set Tap Gesture
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
  }

  // MARK: -

  @objc private func handleViewTap() {
    view.endEditing(true)
  }

  @objc private func nextPage() {
    // Check if we are on the last page and return
    if pageControl.currentPage == onBoardingPages.count { return }

    // Check if we are on the second to last page and animate constraints
    if pageControl.currentPage == onBoardingPages.count - 1 {
      updateButtonsAndPageControlConstraintsOffScreen()

      UIView.animate(withDuration: 0.4,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
                      self.view.layoutIfNeeded()
      }, completion: nil)
    }

    // Advance to the next page
    let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    // Update the CurrentPage as we move to the next
    pageControl.currentPage += 1
  }

  @objc private func skipToLoginPage() {
    // Set Current Page to the second to last page
    pageControl.currentPage = onBoardingPages.count - 1

    // Then move to the last page
    nextPage()
  }

  private func updateButtonsAndPageControlConstraintsOffScreen() {
    nextButtonTopAnchor.constant = -60
    skipButtonTopAnchor.constant = -60
    pageControlBotttomAnchor.constant = 60
  }

  // MARK: - Notifications

  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  @objc private func keyboardWillShow() {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    let yCoordinate: CGFloat = UIDevice.current.orientation.isLandscape ? -110 : -50
                    self.view.frame = CGRect(x: 0,
                                             y: yCoordinate,
                                             width: self.view.frame.width,
                                             height: self.view.frame.height)
    }, completion: nil)
  }

  @objc private func keyboardWillHide() {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.width,
                                             height: self.view.frame.height)
    }, completion: nil)
  }
}

// MARK: - UICollectionView Data Source

extension LoginViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return onBoardingPages.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == onBoardingPages.count {
      guard let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginCollectionViewCell.reuseIdentifier,
                                                               for: indexPath) as? LoginCollectionViewCell else {
                                                                fatalError("Unable to Dequeue Cell.") }
      loginCell.delegate = self

      return loginCell
    }
    
    guard let onboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier,
                                                                  for: indexPath) as? OnboardingCollectionViewCell else {
                                                                    fatalError("Unable to Dequeue Cell.") }

    let onboardingPage = onBoardingPages[indexPath.item]

    onboardingCell.configure(with: onboardingPage)

    return onboardingCell
  }
}

// MARK: - UICollectionView Delegate

extension LoginViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: view.frame.height)
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()

    let indextPath = IndexPath(item: pageControl.currentPage, section: 0)

    DispatchQueue.main.async {
      self.collectionView.scrollToItem(at: indextPath, at: .centeredHorizontally, animated: true)
      self.collectionView.reloadData()
    }
  }
}

// MARK: - UIScrollView Delegate

extension LoginViewController {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
    pageControl.currentPage = pageNumber

    // Animate constraints when you reach the login screen (last page)
    if pageNumber == onBoardingPages.count {
      updateButtonsAndPageControlConstraintsOffScreen()
    } else {
      nextButtonTopAnchor.constant = 0
      skipButtonTopAnchor.constant = 0
      pageControlBotttomAnchor.constant = 0
    }

    UIView.animate(withDuration: 0.4,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: - Loggin ViewController Delegate

extension LoginViewController: LoginViewControllerDelegate {

  func finishLoggingIn() {
    dismiss(animated: true)

    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
    mainNavigationController.viewControllers = [HomeViewController()]

    UserDefaults.standard.setIsLoggedIn(value: true)
  }
}
