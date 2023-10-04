import Foundation
import UIKit
import Combine

struct Dependencies {
    let notificationCenter: NotificationCenter
}
actor MyStruct {
    private var cancellables: AnyCancellable?
    private let notificationCenter: NotificationCenter
    init(dependencies: Dependencies) {
        self.notificationCenter = dependencies.notificationCenter
        Task {
            await observeNotification()
        }
    }

    private func observeNotification() async {
        await notificationCenter.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in
            print("here`")
        }

        await cancellables = notificationCenter.publisher(for: UIApplication.willEnterForegroundNotification).sink { _ in
            print("here")
        }
    }
}


import XCTest
class MyTests: XCTestCase {
    func test() {
        let notificationCenter = NotificationCenter()
        let dependencies = Dependencies(notificationCenter: notificationCenter)
        let myStruct = MyStruct(dependencies: dependencies)
        notificationCenter.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        XCTAssertTrue(false)
    }
}
MyTests.defaultTestSuite.run()


