//
//  QnAViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//
import UIKit
import SnapKit
import Then
import RxSwift

final class QnAViewController : BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.title = "자주 묻는 질문"
        $0.leftItem = [.close]
    }
    
    //MARK: - 본문
    private let titleLabel = UILabel().then {
        $0.text = "자주 묻는 질문이란?"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray450
    }

    private let describeView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .gray100
    }
    
    private let describeLabel = UILabel().then {
        $0.text = "주인장을 이용하며 생길 수 있는 궁금증을 조금이나마 해소해 드리기 위한 자주 묻는 질문 모음입니다. \n직접 문의 기능은 준비 중이니 양해 부탁드립니다."
        $0.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray450
    }
    
    //MARK: - 질문들
    private let questionImageView = UIImageView().then {
        $0.image = UIImage.Setting.questionLogo
    }
    
    private let questionLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
    }
    private let answerLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
        $0.numberOfLines = 0
    }
    private var arrowImageView = UIImageView().then {
        $0.image = UIImage.Setting.arrow
    }
    private var line = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ExpandableTableViewCell.self, forCellReuseIdentifier: ExpandableTableViewCell.id)
    }
    
    private var dataSource = Sections.sections
    private var disposeBag = DisposeBag()
    
    private func tapCloseButton() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(36)
            $0.left.equalToSuperview().offset(24)
        }
        describeView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(25)
            $0.height.equalTo(87)
        }
        describeLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(12)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(describeView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        view.addSubview(navigationView)
        view.addSubview(titleLabel)
        view.addSubview(describeView)
        describeView.addSubview(describeLabel)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        view.backgroundColor = .mainWhite
        setConstraint()
    }
    
    private func bindAction() {
        navigationView.itemActionRelay
            .subscribe(with: self) { owner, action in
                switch action {
                case .closeButtonTap:
                    owner.tapCloseButton()
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Extension
extension QnAViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.id, for: indexPath) as? ExpandableTableViewCell else { return UITableViewCell()}
        cell.set(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource[indexPath.row].isOpened.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

