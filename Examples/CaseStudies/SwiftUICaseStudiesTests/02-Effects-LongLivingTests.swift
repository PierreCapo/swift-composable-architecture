import Combine
import ComposableArchitecture
import XCTest

@testable import SwiftUICaseStudies

class LongLivingEffectsTests: XCTestCase {
//  func testReducer() {
//    // A passthrough subject to simulate the screenshot notification
//    let screenshotTaken = PassthroughSubject<Void, Never>()
//
//    let store = TestStore(
//      initialState: .init(),
//      reducer: longLivingEffectsReducer,
//      environment: .init(
//        userDidTakeScreenshot: Effect(screenshotTaken)
//      )
//    )
//
//    store.send(.onAppear)
//
//    // Simulate a screenshot being taken
//    screenshotTaken.send()
//    store.receive(.userDidTakeScreenshotNotification) {
//      $0.screenshotCount = 1
//    }
//
//    store.send(.onDisappear)
//
//    // Simulate a screenshot being taken to show no effects
//    // are executed.
//    screenshotTaken.send()
//  }

  @MainActor
  func testNew() async throws {
    // A passthrough subject to simulate the screenshot notification
    let screenshotTaken = PassthroughSubject<Void, Never>()

    let store = MainActorTestStore(
      initialState: .init(),
      reducer: longLivingEffectsReducer,
      environment: .init(
        userDidTakeScreenshot: Effect(screenshotTaken)
      )
    )

    let task = store.send(.onAppear)

    // Simulate a screenshot being taken
    screenshotTaken.send()
    await store.receive(.userDidTakeScreenshotNotification) {
      $0.screenshotCount = 1
    }

//    store.send(.onDisappear)

    // Simulate a screenshot being taken to show no effects
    // are executed.
//    screenshotTaken.send()


    task.cancel()
    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
  }
}
