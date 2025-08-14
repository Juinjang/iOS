# <img width="40" height="40" alt="주인장앱아이콘" src="https://github.com/user-attachments/assets/dc9d8904-c2ca-4236-afdf-b42c86f0b4d9" /> 주인장 iOS - 부동산 매물 기록

<img width="500" alt="썸네일" src="https://github.com/user-attachments/assets/c4f9ce2e-5007-429c-bc4a-e39576f4c30f"/>


주인장은 부동산 임장 정보를 사진, 음성, 체크리스트 등으로 손쉽게 기록하고 관리할 수 있는 앱입니다. 임장 점수 비교와 기록 공유 기능을 통해 개인 메모를 넘어 임장 정보를 함께 나누는 커뮤니티를 제공합니다. 

> #### **💡 주인장에서 임장이란?**
>  집을 직접 보러 가서 사진 찍고, 상태 체크하고, 비교·기록하는 활동

<br>

📢 **2.0 버전 출시** (2025.08) — 대규모 UI 개편과 신규 기능 추가  
👉 [App Store에서 바로 보기](https://apps.apple.com/kr/app/%EC%A3%BC%EC%9D%B8%EC%9E%A5-%EB%B6%80%EB%8F%99%EC%82%B0-%EB%A7%A4%EB%AC%BC-%EA%B8%B0%EB%A1%9D/id6605941969)


<br>

## 주인장 TEAM
### iOS 2명
| 김동우 | 조유진 |
|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/542d2856-f13d-4146-bd06-863bbd6d5b62" width="150" height="150"><br>[ornwoo96](https://github.com/ornwoo96)|<img src="이미지URL" width="150" height="150"><br>[yuzzin0121](https://github.com/yuzzin0121)|

### Server 3명


### Design 2명


### PM 2명


<br>


## 주요 기능
| 임장 페이지 생성 | 사진, 녹음, 메모 추가 | 맞춤형 체크리스트 작성 |
|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/e4194f25-dcdd-45b4-b0a7-a0edb336c7a7" width="175" >|<img src="https://github.com/user-attachments/assets/0e2cbca6-33c4-4490-9f5f-533d94b63fde" width="175">|<img src="https://github.com/user-attachments/assets/f880272f-506b-4f22-bf6a-7e663214b90b" width="175" >|

| 임장 정보 커뮤니티 | 공유된 임장 정보 상세보기 | 나의 임장 정보 공유 | 
|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/6b2c446a-15b8-4056-b2b5-ce0c71f4252f" width="175" >|<img src="https://github.com/user-attachments/assets/cb573496-802e-4ef1-8758-075aaa8b1be4" width="175" >|<img src="https://github.com/user-attachments/assets/f0901223-f60a-40ed-ab94-32b9fc7b187c" width="175" >|



<br>


## 개발 환경
- Swift 5.0
- iOS 16.0 +
- Xcode 16.0.0


<br>

## 사용 기술 및 라이브러리
- `UIKit` `SnapKit` `Then`
- `ReactorKit` `RxSwift`
- `Alamofire` `Firebase`
- `Realm`
- `Tuist`

<br>


## 폴더 구조
```
📂 Project
├── 📂 juinjang
│   └── 📂 Project
│       ├── 📂 Application : AppDelegate, SceneDelegate 등 앱 생명주기 관리
│       ├── 📂 Common : 공통으로 사용하는 Enum, Extensions, Protocol
│       ├── 📂 Components : 재사용 가능한 View 컴포넌트 모음
│       ├── 📂 Manager : 인앱결제, 녹음·재생, Firebase 연동 등 주요 서비스 로직 관리
│       ├── 📂 Model : Request/Response 구조체 (Decodable, Encodable)
│       ├── 📂 Network : 네트워크 관련 클래스 (BaseURL, APIManager, NetworkMonitor, TargetType 등)
│       ├── 📂 Repository : 레포지토리 패턴 기반 데이터 접근 계층
│       ├── 📂 Storage : 로컬 데이터 저장소 (UserDefaultsManager 등)
│       └── 📂 UserInterface : UI Scene 모음
│           ├── 📂 View : ViewController, 메인 뷰, 서브뷰 관리
│           └── 📂 Reactor : ReactorKit에서 사용하는 Reactor 클래스
└── 📂 Core
    └── 📂 Project
        └── 📂 Common
            └── 📂 AnalyticsManager
                ├── AnalyticsEvent
                └── AnalyticsManager
```

<br>

## 아키텍처 및 사용 기술



<br>

## 🔗 App Store
[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/kr/app/%EC%A3%BC%EC%9D%B8%EC%9E%A5-%EB%B6%80%EB%8F%99%EC%82%B0-%EB%A7%A4%EB%AC%BC-%EA%B8%B0%EB%A1%9D/id6605941969) 

<br>

## WiKi 바로가기
### [주인장 위키](https://github.com/Juinjang/Juinjang_iOS/wiki)
☝️ 이 외에 궁금한점이 있다면 클릭해주세요.

<br>

## 🔗 추가 링크  
- [공식 홈페이지](https://juinjang-official.framer.website/?fbclid=PAQ0xDSwMIHRNleHRuA2FlbQIxMQABpyE1s-q9JcrXD3Smu4SqoIHAs6yXSE1JQYeiNLYCsY7FuaCYqZFv8bl8qilD_aem_drubxYLHApzeFxtVskzdzQ)  
- [팀 개발 블로그](https://juinjang-history.tistory.com/m/category/iOS%20Developer)  
- [인스타그램](https://www.instagram.com/official_juinjang?igsh=MWg2amNnZ3ZxeWM3Ng==)  
- [Threads](https://www.threads.com/@official_juinjang?igshid=NTc4MTIwNjQ2YQ==)
