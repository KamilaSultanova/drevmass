//
// SortingSelectViewController
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import PanModal

/// Protocol defining sorting selection delegate methods
protocol SortingSelectDelegate: AnyObject {
    func didSelect(sortingType: SortingType)
}

final class SortingSelectViewController: UIViewController, PanModalPresentable {
	
    // MARK: - Properties

	var longFormHeight: PanModalHeight = .intrinsicHeight
	var cornerRadius: CGFloat = 24
	var panModalBackgroundColor: UIColor = .appModalBackground
    weak var delegate: SortingSelectDelegate?
	
	var currentSorting: SortingType = .popular
	private let sortingTypes: [SortingType] = SortingType.allCases

    // MARK: - UI Elements
	
	var panScrollable: UIScrollView? {
		return nil
	}
	
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Сортировка"
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark90

        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.bounces = false

        tableView.register(SortingTypeCell.self, forCellReuseIdentifier: SortingTypeCell.identifier)

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

private extension SortingSelectViewController {
    func setupViews() {
		view.backgroundColor = .white
        view.addSubviews(titleLabel, tableView)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SortingSelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SortingTypeCell.identifier, for: indexPath) as? SortingTypeCell
        else {
            fatalError("Unable to find a cell with identifier \(SortingTypeCell.identifier)!")
        }
		
        let sortingType = sortingTypes[indexPath.row]

        cell.setData(sortingType: sortingType, text: sortingType.rawValue, selected: currentSorting == sortingType)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(sortingType: sortingTypes[indexPath.row])
		self.dismiss(animated: true)
    }
}
