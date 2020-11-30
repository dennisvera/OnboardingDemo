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

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    setupCollectionView()
  }

  // MARK: - Helper Methods

  private func setupCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

  private func setupView() {
    view.backgroundColor = .white
  }
}

// MARK: - UICollectionView Data Source

extension OnboardingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingCollectionViewCell
    return cell
  }
}

// MARK: - UICollectionView Delegate

extension OnboardingViewController: UICollectionViewDelegate {}
