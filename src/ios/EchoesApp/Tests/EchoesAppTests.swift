import XCTest
@testable import Echoes

@MainActor
final class EchoesAppTests: XCTestCase {
    func testTimeLockEchoStartsLocked() {
        let store = AppStore()
        let locked = store.echoes.first(where: { $0.timeLockDate != nil })
        XCTAssertNotNil(locked)
        XCTAssertEqual(locked?.isTimeLocked, true)
    }

    func testPasscodeValidation() {
        let store = AppStore()
        guard let secureEcho = store.echoes.first(where: { $0.visibility == .private }) else {
            XCTFail("Missing private echo")
            return
        }
        XCTAssertFalse(store.validatePasscode("0000", for: secureEcho.id))
        XCTAssertTrue(store.validatePasscode("1024", for: secureEcho.id))
    }

    func testWitnessFlowAddsFootprint() {
        let store = AppStore()
        let initial = store.footprints.count
        guard let echo = store.echoes.first else {
            XCTFail("Missing echo")
            return
        }
        store.markWitnessed(echo.id)
        XCTAssertEqual(store.footprints.count, initial + 1)
    }

    func testSOSLifecycle() {
        let store = AppStore()
        store.startSOS()
        store.updateSOS(seconds: 10)
        XCTAssertNotNil(store.currentSOS)
        XCTAssertEqual(store.currentSOS?.durationSeconds, 10)
        store.completeSOS()
        XCTAssertNil(store.currentSOS)
    }

    func testDeepLinkForcesMainPhase() {
        let store = AppStore()
        XCTAssertEqual(store.phase, .launch)
        store.handleDeepLink(URL(string: "echoes://drop")!)
        XCTAssertEqual(store.phase, .main)
        XCTAssertEqual(store.selectedTab, .drop)
    }

    func testPrivateEchoOpensPasscodeRoute() {
        let store = AppStore()
        guard let privateEcho = store.echoes.first(where: { $0.visibility == .private }) else {
            XCTFail("Missing private echo")
            return
        }
        store.tapEcho(privateEcho)
        if case .passcode(let id) = store.modalRoute {
            XCTAssertEqual(id, privateEcho.id)
        } else {
            XCTFail("Expected passcode route")
        }
    }
}
