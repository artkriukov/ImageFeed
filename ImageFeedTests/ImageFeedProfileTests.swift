//
//  ImageFeedProfileTests.swift
//  ImageFeedTests
//
//  Created by Artem Kriukov on 07.05.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    var sut: ProfileViewController!
    var presenterSpy: ProfilePresenterSpy!
    var profileServiceMock: ProfileServiceMock!
    var imageServiceMock: ProfileImageServiceMock!
    
    override func setUp() {
        super.setUp()
        
        profileServiceMock = ProfileServiceMock()
        imageServiceMock = ProfileImageServiceMock()
        
        sut = ProfileViewController()
        presenterSpy = ProfilePresenterSpy(
            profileService: profileServiceMock,
            profileImageService: imageServiceMock
        )
        sut.presenter = presenterSpy
        presenterSpy.view = sut
    }
    
    override func tearDown() {
        sut = nil
        presenterSpy = nil
        profileServiceMock = nil
        imageServiceMock = nil
        super.tearDown()
    }
    
    func testViewControllerCallsPresenterDidLoad() {
        // When
        _ = sut.view
        
        // Then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
        XCTAssertTrue(presenterSpy.updateProfileDetailsCalled)
        XCTAssertTrue(presenterSpy.updateAvatarCalled)
    }
    
    func testPresenterUpdatesProfileDetails() {
        // Given
        let viewSpy = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profileService: profileServiceMock)
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        // When
        presenter.updateProfileDetails()
        
        // Then
        XCTAssertTrue(viewSpy.setProfileDetailsCalled)
    }
    
    func testPresenterUpdatesAvatar() {
        // Given
        let viewSpy = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profileImageService: imageServiceMock)
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        // When
        presenter.updateAvatar()
        
        // Then
        XCTAssertTrue(viewSpy.showLoadingCalled)
        XCTAssertTrue(viewSpy.setAvatarCalled)
        XCTAssertTrue(viewSpy.hideLoadingCalled)
    }
    
    func testLogoutButtonTriggersPresenter() {
        // Given
        let viewSpy = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        // When
        viewSpy.didTapLogoutButton()
        
        // Then
        XCTAssertTrue(presenter.didTapLogoutCalled)
    }
}

// MARK: - Test Doubles
final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile? = Profile(
        username: "test",
        name: "Test Name",
        loginName: "@test",
        bio: "Test Bio"
    )
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        completion(.success(profile!))
    }
    
    func cleanProfile() {
        profile = nil
    }
}

final class ProfileImageServiceMock: ProfileImageServiceProtocol {
    var avatarURL: String? = "https://test.com/avatar.jpg"
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success(avatarURL!))
    }
    
    func cleanAvatarURL() {
        avatarURL = nil
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutCalled = false
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    
    init(
        profileService: ProfileServiceProtocol = ProfileServiceMock(),
        profileImageService: ProfileImageServiceProtocol = ProfileImageServiceMock()
    ) {}
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        updateProfileDetails()
        updateAvatar()
    }
    
    func didTapLogout() {
        didTapLogoutCalled = true
    }
    
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
        view?.setProfileDetails(name: "Test", loginName: "@test", bio: nil)
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
        view?.setAvatar(url: URL(string: "https://test.com/avatar.jpg")!)
    }
}

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var setProfileDetailsCalled = false
    var setAvatarCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    
    @objc func didTapLogoutButton() {
        presenter?.didTapLogout()
    }
    
    func setProfileDetails(name: String, loginName: String, bio: String?) {
        setProfileDetailsCalled = true
    }
    
    func setAvatar(url: URL) {
        setAvatarCalled = true
    }
    
    func showLoadingAnimation() {
        showLoadingCalled = true
    }
    
    func hideLoadingAnimation() {
        hideLoadingCalled = true
    }
    
    func showLogoutConfirmationAlert() {}
    func logout() {}
}
