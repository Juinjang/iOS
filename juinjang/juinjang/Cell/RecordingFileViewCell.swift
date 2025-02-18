//
//  RecordingFileViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import SnapKit
import Then
import SkeletonView

final class RecordingFileViewCell: UITableViewCell {
    
    let recordingFileNameLabel = UILabel().then {
        $0.font = .pretendard(size: 18, weight: .semiBold)
        $0.textColor = ColorStyle.textBlack
    }
    
    let recordedDateLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = ColorStyle.gray1
    }
    
    var recordedTimeLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = ColorStyle.textBlack
        $0.textAlignment = .right
    }
    
    var playButton = UIButton().then {
        $0.setImage(ImageStyle.play, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [recordingFileNameLabel, recordedDateLabel, recordedTimeLabel, playButton].forEach {
            contentView.addSubview($0)
        }
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setData(fileItem: nil)
    }
    
    //데이터 넣기
    func setData(fileItem: RecordResponse?) {
        guard let fileItem = fileItem else { return }
        print(#function)
        recordingFileNameLabel.text = fileItem.recordName
        recordedDateLabel.text = DateFormatterManager.shared.formattedUpdatedDate(fileItem.updatedAt)
        recordedTimeLabel.text = String.formatSeconds(fileItem.recordTime)
    }
    
    private func setConstraints() {
        recordingFileNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(recordedDateLabel.snp.leading).offset(-12)
        }
        
        playButton.snp.makeConstraints {
            $0.trailing.equalTo(-24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        recordedTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(playButton.snp.leading).offset(-14)
            $0.centerY.equalToSuperview()
        }
        
        recordedDateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(recordedTimeLabel.snp.leading).offset(-12)
        }
    }

}
