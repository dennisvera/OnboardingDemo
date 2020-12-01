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

  private let pageController: UIPageControl = {
    let pageController = UIPageControl()
    pageController.numberOfPages = 3
    pageController.pageIndicatorTintColor = .lightGray
    pageController.currentPageIndicatorTintColor = .orange
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
    collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
      skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

      // Next Button
      nextButton.widthAnchor.constraint(equalToConstant: 40),
      nextButton.heightAnchor.constraint(equalToConstant: 40),
      nextButton.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 12),
      nextButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -10),

      // Collection View
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      // Page Controller
      pageController.heightAnchor.constraint(equalToConstant: 40),
      pageController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      pageController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageController.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    return onBoardingPages.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingCollectionViewCell

    let onboardingPage = onBoardingPages[indexPath.item]

    cell.configure(with: onboardingPage)
    return cell
  }
}

// MARK: - UICollectionView Delegate

extension OnboardingViewController: UICollectionViewDelegate {}
