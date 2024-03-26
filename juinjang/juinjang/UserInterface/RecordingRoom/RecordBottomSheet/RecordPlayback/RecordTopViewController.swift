//
//  RecordTopViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit

class RecordTopViewController: UIViewController {
    
    weak var bottomSheetViewController: BottomSheetViewController?
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "cancel-white"), for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    var titleLabel = UILabel().then {
        $0.text = "녹음_001"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    lazy var recordTextView = UITextView().then {
        $0.textColor = UIColor(named: "textWhite")
        $0.backgroundColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-Medium", size: 18)
        $0.isEditable = false
    }
    
    lazy var sttLabel = UILabel().then {
        $0.text = "Speech to text"
        $0.textColor = UIColor(named: "textGray")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var copyButton = UIButton().then {
        $0.setImage(UIImage(named: "record-copy"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(copyButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage(named: "record-edit"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "normalText")
        addSubViews()
        setupLayout()
    }
    
    func addSubViews() {
        [cancelButton,
         titleLabel,
         recordTextView,
         sttLabel,
         copyButton,
         editButton].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(12)
//            $0.leading.equalTo(bottomSheetView.snp.leading).offset(354)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(view.snp.top).offset(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.snp.top).offset(24)
        }
        
        recordTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(sttLabel.snp.top)
        }
        
        sttLabel.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.bottom.equalTo(view.snp.bottom).offset(-24)
        }
        
        copyButton.snp.makeConstraints {
            $0.trailing.equalTo(editButton.snp.leading).offset(-12)
            $0.bottom.equalTo(view.snp.bottom).offset(-24)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.bottom.equalTo(view.snp.bottom).offset(-24)
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        bottomSheetViewController?.hideBottomSheetAndGoBack()
    }
    
    @objc func copyButtonTapped(_ sender: UIButton) {
        // recordTextView에 있는 문자열 복사
        UIPasteboard.general.string = recordTextView.text
        
        let alertController = UIAlertController(title: "", message: "복사되었습니다", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            editButton.setImage(UIImage(named: "record-edit-activate"), for: .normal)
            recordTextView.isEditable = true
        } else {
            editButton.setImage(UIImage(named: "record-edit"), for: .normal)
            recordTextView.isEditable = false
        }
    }
    
    func updateTitle(_ newTitle: String?) {
        if let title = newTitle {
            print("녹음 파일 제목: \(title)")
            titleLabel.text = title
        }
    }
}
