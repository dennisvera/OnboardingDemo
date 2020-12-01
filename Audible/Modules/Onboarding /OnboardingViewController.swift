//
//  OnboardingViewController.swift
//  Audible
//
//  Created by Dennis Vera on 11/29/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {

  // MARK: - Properties

  private var collectionView: UICollectionView!

  private lazy var pageController: UIPageControl = {
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
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
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
    pageController.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(collectionView)
    view.addSubview(pageController)
    view.addSubview(skipButton)
    view.addSubview(nextButton)

    NSLayoutConstraint.activate([
      // Skip Button
      skipButton.widthAnchor.constraint(equalToConstant: 40),
      skipButton.heightAnchor.constraint(equalToConstant: 40),
      skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),

      // Next Button
      nextButton.widthAnchor.constraint(equalToConstant: 40),
      nextButton.heightAnchor.constraint(equalToConstant: 40),
      nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

      // Collection View
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      // Page Controller
      pageController.heightAnchor.constraint(equalToConstant: 40),
      pageController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageController.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageController.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  // MARK: - UICollection View Layout

  private func createCollectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
      return self.createLayoutSection()
    }

    let config = UICollectionViewCompositionalLayoutConfiguration()
    layout.configuration = config

    return layout
  }

  private func createLayoutSection() -> NSCollectionLayoutSection {
    // Item
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging

    return section
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

extension OnboardingViewController: UICollectionViewDelegate {}

// MARK: - UIScrollView Delegate

extension OnboardingViewController {

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
    print(pageNumber)
    pageController.currentPage = pageNumber
  }
}
