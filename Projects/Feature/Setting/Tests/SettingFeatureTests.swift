import ComposableArchitecture
import Dependency
import Model
import Testing

@testable import Setting

@MainActor
struct SettingFeatureTests {

    // MARK: - onAppear

    @Test
    func onAppear_프로필_로드_성공시_상태반영() async {
        let profile = UserProfile(
            nickname: "짱구",
            introduction: "안녕하세요",
            email: "jjang@juinjang.com",
            imageURL: nil,
            provider: .kakao
        )

        let store = TestStore(initialState: SettingFeature.State()) {
            SettingFeature()
        } withDependencies: {
            $0.mainQueue = .immediate
            $0.userClient.fetchMyProfile = { profile }
        }

        await store.send(.onAppear)
        await store.receive(\.profileLoaded) {
            $0.nickname = "짱구"
            $0.email = "jjang@juinjang.com"
            $0.oneLineIntroduction = "안녕하세요"
            $0.provider = .kakao
        }
    }

    // MARK: - 닉네임 편집 (효과 없는 순수 로직)

    @Test
    func 닉네임_변경버튼_탭하면_편집모드로_진입() async {
        let store = TestStore(initialState: SettingFeature.State(nickname: "짱구")) {
            SettingFeature()
        }

        await store.send(.nicknameFieldButtonTapped) {
            $0.nicknameField.input = "짱구"
            $0.nicknameField.mode = .editing
        }
    }

    @Test
    func 닉네임_길이초과시_validationFailed() async {
        var state = SettingFeature.State(nickname: "짱구")
        state.nicknameField = SettingFeature.FieldEditState(mode: .editing, input: "짱구")

        let store = TestStore(initialState: state) { SettingFeature() }

        await store.send(.nicknameTextChanged("123456789")) {
            $0.nicknameField.input = "123456789"
            $0.nicknameField.mode = .validationFailed
        }
    }

    @Test
    func 닉네임_공백만_입력시_저장불가_editing() async {
        var state = SettingFeature.State(nickname: "짱구")
        state.nicknameField = SettingFeature.FieldEditState(mode: .completed, input: "철수")

        let store = TestStore(initialState: state) { SettingFeature() }

        await store.send(.nicknameTextChanged("   ")) {
            $0.nicknameField.input = "   "
            $0.nicknameField.mode = .editing
        }
    }

    @Test
    func 닉네임_중복응답시_duplicate모드() async {
        var state = SettingFeature.State(nickname: "짱구")
        state.nicknameField = SettingFeature.FieldEditState(mode: .completed, input: "철수")

        let store = TestStore(initialState: state) { SettingFeature() }

        await store.send(.nicknameSaveResponse(.failure(.unknown(code: "NICKNAME4002", message: nil)))) {
            $0.nicknameField.mode = .duplicate
        }
    }

    @Test
    func 닉네임_저장성공시_상태갱신_및_편집종료() async {
        var state = SettingFeature.State(nickname: "짱구")
        state.nicknameField = SettingFeature.FieldEditState(mode: .completed, input: "철수")

        let store = TestStore(initialState: state) { SettingFeature() }

        await store.send(.nicknameSaveResponse(.success("철수"))) {
            $0.nickname = "철수"
            $0.nicknameField.mode = .beforeEdit
            $0.nicknameField.input = ""
        }
    }
}
