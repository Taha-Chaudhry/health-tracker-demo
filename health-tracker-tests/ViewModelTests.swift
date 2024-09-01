//
//  ViewModelTests.swift
//  health-tracker-tests
//
//  Created by Taha Chaudhry on 01/09/2024.
//

import XCTest
@testable import health_tracker
import CoreData

final class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    var testPersistenceController: TestPersistenceController!

    override func setUp() {
        super.setUp()
        testPersistenceController = TestPersistenceController()
        viewModel = ViewModel(testContext: testPersistenceController.viewContext)
    }

    override func tearDown() {
        viewModel = nil
        testPersistenceController = nil
        super.tearDown()
    }
    
    func testCorrectViewContext() {
        XCTAssertEqual(viewModel.testContext, viewModel.viewContext)
    }
    
    func testUsersIsEmptyInitially() {
        XCTAssertTrue(viewModel.users.isEmpty, "Users should be empty initially")
    }

    func testFoodLogsIsEmptyInitially() {
        XCTAssertTrue(viewModel.foodLogs.isEmpty, "Food logs should be empty initially")
    }

    func testActivitiesIsEmptyInitially() {
        XCTAssertTrue(viewModel.activities.isEmpty, "Activities should be empty initially")
    }

    func testUsersFetched() {
        viewModel.fetchData()
//        print(viewModel.user.vitals?.caloriesBurned ?? "No data")
//        print(viewModel.testContext)
//        XCTAssertNil(viewModel.user.id)
    }
}

class TestPersistenceController {
    static let shared = TestPersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "health_tracker")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}
