//
//  ToSViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit

class ToSViewController: UIViewController {
    
    lazy var guideLabel = UILabel().then {
        $0.text = "주인장 서비스의\n이용 약관에 동의해 주세요"
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.textColor = UIColor(named: "normalText")
        $0.font = .pretendard(size: 24, weight: .bold)
        $0.asColor(targetString: "이용 약관", color: UIColor(named: "mainOrange"))
    }
    
    lazy var guideDetailLabel = UILabel().then {
        $0.text = "원활한 서비스 이용을 위해 약관 동의가 필요해요."
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textGray")
        $0.font = .pretendard(size: 16, weight: .medium)
    }
    
    lazy var agreeToAllTermsView = UIView().then {
        $0.backgroundColor = UIColor(named: "lightBackgroundOrange")
        $0.layer.cornerRadius = 10
    }
    
    lazy var checkButton = UIButton().then {
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "check-off"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    lazy var allAgreeLabel = UILabel().then {
        $0.text = "약관 모두 동의하기"
        $0.textColor = UIColor(named: "textBlack")
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.isUserInteractionEnabled = true // 터치 이벤트 활성화
    }
    
    var isChecked = false {
        didSet {
            // 체크 버튼이 눌릴 때마다 리로드
            itemtableView.reloadData()
        }
    }
    
    lazy var itemtableView = UITableView().then {
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(ToSItemTableViewCell.self, forCellReuseIdentifier: ToSItemTableViewCell.identifier)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.backgroundColor = UIColor(named: "lightGray")
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        itemtableView.delegate = self
        itemtableView.dataSource = self
        setNavigationBar()
        addSubViews()
        setupLayout()
        setCheckButton()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCell(_:)), name: NSNotification.Name("UpdateCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCheckButtonChecked), name: NSNotification.Name("CheckButtonChecked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCheckButtonUnchecked), name: NSNotification.Name("CheckButtonUnchecked"), object: nil)
    }
    
    func setCheckButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(agreeLabelTapped))
        allAgreeLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func agreeLabelTapped(sender: UITapGestureRecognizer) {
        // 동의하기 버튼을 클릭한 것처럼 처리
        checkButton.sendActions(for: .touchUpInside)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func addSubViews() {
        [guideLabel,
         guideDetailLabel,
         agreeToAllTermsView,
         itemtableView,
         nextButton].forEach { view.addSubview($0) }
        [checkButton, allAgreeLabel].forEach { agreeToAllTermsView.addSubview($0) }
    }
    
    func setupLayout() {
        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.04 * view.bounds.height)
            $0.leading.equalTo(24)
        }

        // 안내 상세 Label
        guideDetailLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(0.06 * view.bounds.height)
            $0.height.lessThanOrEqualTo(0.08 * view.bounds.height)
            $0.leading.equalTo(24)
        }
        
        // 약관 모두 동의 Container View
        agreeToAllTermsView.snp.makeConstraints {
            $0.top.equalTo(guideDetailLabel.snp.bottom).offset(151)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(63)
        }
        
        // 약관 모두 동의 Button
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        checkButton.bringSubviewToFront(agreeToAllTermsView)
        
        // 약관 모두 동의 Label
        allAgreeLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        // 약관 동의 tableView
        itemtableView.snp.makeConstraints {
            $0.height.equalTo(189)
            $0.top.equalTo(agreeToAllTermsView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }

        // 다음으로 Button
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-33)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(52)
        }
    }
    
    @objc func backButtonTapped() {
        let SignupPopupVC = SignupPopupViewController()
        SignupPopupVC.modalPresentationStyle = .overCurrentContext
        present(SignupPopupVC, animated: false, completion: nil)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let setNickNameVC = SetNickNameViewController()
        setNickNameVC.modalPresentationStyle = .fullScreen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(setNickNameVC, animated: true)
    }
    
    func updateCheckButtonImages() {
        if isChecked {
            checkButton.setImage(UIImage(named: "check-on"), for: .normal)
            nextButton.backgroundColor = UIColor(named: "textBlack")
            nextButton.isEnabled = true
        } else {
            checkButton.setImage(UIImage(named: "check-off"), for: .normal)
            nextButton.backgroundColor = UIColor(named: "lightGray")
            nextButton.isEnabled = false
        }
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        isChecked = !isChecked
        updateCheckButtonImages()
    }
    
    @objc func updateCell(_ notification: Notification) {
        if let tag = notification.object as? Int,
           let indexPath = indexPathForTag(tag),
           let tosCell = itemtableView.cellForRow(at: indexPath) as? ToSItemTableViewCell {
            tosCell.checkButton.isSelected.toggle()
            tosCell.checkButton.setImage(UIImage(named: "record-check-on"), for: .normal)
        }
    }

    @objc func handleCheckButtonChecked() {
        areAllTermsChecked()
        isEssentialTermsChecked()
    }
    
    @objc func handleCheckButtonUnchecked() {
        areNotAllTermsChecked()
    }
    
    func areAllTermsChecked() {
        for i in 0..<termsOfService.count {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = itemtableView.cellForRow(at: indexPath) as? ToSItemTableViewCell
            if let cell, !cell.checkButton.isSelected {
                return
            }
        }
        // 모든 약관이 체크됨
        isChecked = true
        updateCheckButtonImages()
    }
    
    func areNotAllTermsChecked() {
        // cell 버튼 개별 동작 시 전체 동의 버튼, 다음으로 버튼 개별 처리
        checkButton.setImage(UIImage(named: "check-off"), for: .normal)
        nextButton.backgroundColor = UIColor(named: "lightGray")
        nextButton.isEnabled = false
    }
    
    // 필수 항목 조건 검사
    func isEssentialTermsChecked() {
        var isFirstTermChecked = false
        var isSecondTermChecked = false

        for i in 0..<termsOfService.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = itemtableView.cellForRow(at: indexPath) as? ToSItemTableViewCell {
                if i == 0 && cell.checkButton.isSelected {
                    isFirstTermChecked = true
                } else if i == 1 && cell.checkButton.isSelected {
                    isSecondTermChecked = true
                }
            }
        }

        if isFirstTermChecked && isSecondTermChecked {
            nextButton.backgroundColor = UIColor(named: "textBlack")
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = UIColor(named: "lightGray")
            nextButton.isEnabled = false
        }
    }

    func indexPathForTag(_ tag: Int) -> IndexPath? {
        return IndexPath(row: tag, section: 0)
    }
}

extension ToSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsOfService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ToSItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: ToSItemTableViewCell.identifier, for: indexPath) as? ToSItemTableViewCell else {
            return UITableViewCell()
        }
        
        let toSItem = termsOfService[indexPath.row]
        cell.configure(with: toSItem, isChecked: isChecked)
        cell.checkButton.tag = indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}
