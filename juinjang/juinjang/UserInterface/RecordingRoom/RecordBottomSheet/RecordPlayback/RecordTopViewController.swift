//
//  RecordTopViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit

final class RecordTopViewController: BaseViewController {
    
    weak var bottomSheetViewController: BottomSheetViewController?
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage.Recording.cancelWhite, for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .mainWhite
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    lazy var recordTextView = UITextView().then {
        $0.textColor = .mainWhite
        $0.backgroundColor = .gray600
        $0.font = UIFont(name: "Pretendard-Medium", size: 18)
        $0.isEditable = false
    }
    
    lazy var sttLabel = UILabel().then {
        $0.text = "Speech to text"
        $0.textColor = .gray400
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var copyButton = UIButton().then {
        $0.setImage(UIImage.Recording.copy, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(copyButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var editButton = UIButton().then {
        $0.setImage(UIImage.Recording.edit, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }
    
    var recordResponse: RecordResponse
    
    init(recordResponse: RecordResponse) {
        self.recordResponse = recordResponse
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(String(describing: self), "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray600
        addSubViews()
        setupLayout()
        setRecordData()
        setDelegate()
    }
    
    private func setDelegate() {
        recordTextView.delegate = self
    }
    
    private func setRecordData() {
        titleLabel.text = recordResponse.recordName
        recordTextView.text = recordResponse.recordScript
    }
    
    func editTitle(_ editedRecordName: String) {
        recordResponse.recordName = editedRecordName
        titleLabel.text = editedRecordName
    }
    
    // X 버튼 클릭 시
    @objc func cancelButtonTapped(_ sender: UIButton) {
        bottomSheetViewController?.hideBottomSheetAndGoBack()
    }
    
    // 복사버튼 클릭 시
    @objc func copyButtonTapped(_ sender: UIButton) {
        // recordTextView에 있는 문자열 복사
        UIPasteboard.general.string = recordTextView.text
        
        let alertController = UIAlertController(title: "", message: "복사되었습니다", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 편집버튼 클릭 시
    @objc func editButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            editButton.setImage(UIImage.Recording.editActivate, for: .normal)
            recordTextView.isEditable = true
        } else {
            editRecordScript()
            editButton.setImage(UIImage.Recording.edit, for: .normal)
            recordTextView.isEditable = false
        }
    }
    
    private func editRecordScript() {
        let content = recordTextView.text.trimmingCharacters(in: [" "])
        if recordResponse.recordScript == content {
            return
        } else {
            recordResponse.recordScript = content
            editRecordScript(content)
        }
    }
    
    private func editRecordScript(_ editedRecordScript: String) {
        let parameter = ["recordScript": editedRecordScript]
        JuinjangAPIManager.shared.postData(type: BaseResponse<RecordResponse?>.self, api: .editRecordContent(recordId: recordResponse.recordId, content: editedRecordScript), parameter: parameter) { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self else { return }
            NotificationCenter.default.post(name: .editRecordScript, object: recordResponse)
        }
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
}

extension RecordTopViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        editRecordScript()
    }
}
