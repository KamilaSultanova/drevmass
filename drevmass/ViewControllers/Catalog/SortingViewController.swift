//
//  SortingViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 18.03.2024.
//

import UIKit
import PanModal
import SnapKit

protocol SortingViewControllerDelegate: AnyObject {
    func didSelectSortingType(_ sortingType: SortingType)
}

class SortingViewController: UIViewController, PanModalPresentable {
    
    // MARK: - UI Elements
    
    weak var delegate: SortingViewControllerDelegate?
    
    var selectedSortingType: SortingType = .popular
    
    private var sortingArray: [SortingType] = [.popular, .lowToHighPrice , .highToLowPrice]
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
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
    
    private lazy var tableview: SelfSizingTableView = {
        let tableview = SelfSizingTableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(SortingTableViewCell.self, forCellReuseIdentifier: "SortingCell")
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupUI()
        setupConstraints()
    }
    
    func setupUI(){
        view.addSubviews(titleLabel, tableview)
    }
    
    func setupConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
}

extension SortingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortingCell", for: indexPath) as! SortingTableViewCell
        
        let sortingType = sortingArray[indexPath.row]
        
        let isSelected = sortingType == selectedSortingType
        cell.setData(with: sortingType, selected: isSelected)

        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = sortingArray[indexPath.row]
        delegate?.didSelectSortingType(selectedType)
        self.dismiss(animated: true)
    }

}
