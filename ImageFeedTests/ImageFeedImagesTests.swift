//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Artem Kriukov on 08.05.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    // MARK: - ImagesListPresenter Tests
    
    func testPresenterConvertDate() {
        // given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(service: service)
        let date = DateFormatter.iso8601Formatter.date(from: "2024-05-09T12:00:00Z")!
        let photo = Photo(
            id: "test",
            size: CGSize(width: 100, height: 100),
            createdAt: date,
            welcomeDescription: "Test",
            thumbImageURL: "test_thumb",
            largeImageURL: "test_large",
            isLiked: false
        )
        
        // when
        let dateString = presenter.convertDate(photo: photo)
        
        // then
        XCTAssertEqual(dateString, "9 мая 2024 г.")
    }
}


// MARK: - Test Doubles

class ImagesListServiceSpy: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
    }
}


// MARK: - Helpers

extension DateFormatter {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
