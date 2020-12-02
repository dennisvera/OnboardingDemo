//
//  OnboardingViewController.swift
//  Audible
//
//  Created by Dennis Vera on 11/29/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController, UICollectionViewDelegateFlowLayout {

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
    return button
  }()

  private let nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Next", for: .normal)
    button.setTitleColor(.orange, for: .normal)
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
  }

  // MARK: - Helper Methods

  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
  }
}

// MARK: - UICollectionView Data Source

extension OnboardingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return onBoardingPages.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == onBoardingPages.count {
      guard let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoginCollectionViewCell.reuseIdentifier,
                                                               for: indexPath) as? LoginCollectionViewCell else {
                                                                fatalError("Unable to Dequeue Cell.") }

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

extension OnboardingViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: view.frame.height)
  }
}

// MARK: - UIScrollView Delegate

extension OnboardingViewController {

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
    pageControl.currentPage = pageNumber

    // Animate constraints when you reach the login screen (last page)
    if pageNumber == onBoardingPages.count {
      nextButtonTopAnchor.constant = -80
      skipButtonTopAnchor.constant = -80
      pageControlBotttomAnchor.constant = 60
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
