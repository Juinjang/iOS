//
//  QnAViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//
import UIKit
import SnapKit
import Then

class QnAViewController : UIViewController {
    var closeButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"X"), for: .normal)
        $0.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
    }
    @objc
    func tapCloseButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    var useLabel = UILabel().then {
        $0.text = "자주 묻는 질문"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        //$0.textColor = UIColor(named: "500")
    }
    //MARK: - 본문
    var titleLabel = UILabel().then {
        $0.text = "자주 묻는 질문이란?"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "300")
    }

    var describeView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(named: "100")
    }
    var describeLabel = UILabel().then {
        $0.text = "주인장을 이용하며 생길 수 있는 궁금증을 조금이나마 해소해 드리기 위한 자주 묻는 질문 모음입니다. \n직접 문의 기능은 준비 중이니 양해 부탁드립니다."
        $0.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "300")
    }
    
    //MARK: - 질문들
    var questionImageView = UIImageView().then {
        $0.image = UIImage(named:"question")
    }
    var questionLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    var answerLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
        $0.numberOfLines = 0
    }
    var arrowImageView = UIImageView().then {
        $0.image = UIImage(named:"arrow")
    }
    var line = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    
    let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ExpandableTableViewCell.self, forCellReuseIdentifier: ExpandableTableViewCell.id)
       // $0.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
    }
    
    var dataSource = Section.sections
    
    func setConstraint() {
        closeButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17.16)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(12)
        }
        useLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(82.16)
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
        view.addSubview(closeButton)
        view.addSubview(useLabel)
        view.addSubview(titleLabel)
        view.addSubview(describeView)
        describeView.addSubview(describeLabel)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        view.backgroundColor = .white
        setConstraint()
    }
}

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

