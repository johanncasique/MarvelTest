//
//  CharactersTest.swift
//  MarvelTestUITests
//
//  Created by johann casique on 27/10/20.
//
@testable import MarvelTest
@testable import MarvelData
import Foundation
import XCTest

class CharactersModelTest: XCTestCase {
    

    func testBuilDomainModel_WithData_ShouldCaptureNotNil() {
        
        let model = map(to: CharactersDomainModel.self, from: loadMock())
        XCTAssertNotNil(model?.data)
    }
    
    func testBuildCharacters_WithData_ShouldCaptureNotNil() {
        let model = map(to: CharactersDomainModel.self, from: loadMock())
        XCTAssertNotNil(model?.data.results)
    }
    
    func testBuildCharacters_WithData_ShouldCaptureNotEmpty() {
        guard let model = map(to: CharactersDomainModel.self, from: loadMock()) else {
            XCTFail("Expected a model from Decoder")
            return
        }
        
        XCTAssertFalse(model.data.results.isEmpty)
    }
    
    func tesBuildCharacters_WithData_ShouldCaptureOneCharacterInBuilder() {
        guard let model = map(to: CharactersDomainModel.self, from: loadMock()) else {
            XCTFail("Expected a model from Decoder")
            return
        }
        
        XCTAssertEqual(model.data.results.count, 1)
    }
    
    func testBuildCharacters_WithData_ShouldCapturePagination() {
        guard let model = map(to: CharactersDomainModel.self, from: loadMock()) else {
            XCTFail("Expected a model from Decoder")
            return
        }
        
        XCTAssertNotNil(model.data.pagination)
        XCTAssertEqual(model.data.offset, 0)
        XCTAssertEqual(model.data.limit, 20)
        XCTAssertEqual(model.data.total, 1)
        XCTAssertEqual(model.data.count, 1)
    }
    
    func testBuildCharacters_WithData_ShouldCaptureCharacterNotNil() {
        guard let model = map(to: CharactersDomainModel.self, from: loadMock()) else {
            XCTFail("Expected a model from Decoder")
            return
        }
        
        XCTAssertNotNil(model.data.results[0])
    }
    
    func testBuildCharacters_WithData_ShouldGetCharacterImageURL() {
        guard let model = map(to: CharactersDomainModel.self, from: loadMock()) else {
            XCTFail("Expected a model from Decoder")
            return
        }
        
        XCTAssertNotNil(model.data.results[0].imageURL)
    }
    
    func testBuildCharacters_WithData_ShouldCaptureValidImageURL() {
        guard let model = map(to: CharactersDomainModel.self, from: loadMock()) else {
            XCTFail("Expected a model from Decoder")
            return
        }
        
        XCTAssertTrue(verifyUrl(model.data.results[0].imageURL))
    }
    
    func testBuildCharacters_WithNotValidData_ShouldExpectFailDecoding() {
        guard let data = loadNotValidMock() else {
            XCTFail("Expected data")
            return
        }
        AssertThrowsKeyNotFound("offset", decoding: CharactersDomainModel.self, from: data)
    }
    
    private func map<D: Decodable>(to type: D.Type, decoder: JSONDecoder = JSONDecoder(), from data: Data?) -> D? {
        guard let data = data else {
            XCTFail("Failed with nil data")
            return nil
        }
        
        do {
            return try decoder.decode(type, from: data)
        } catch let error {
            XCTFail("Failed decoded with error: \(error)")
            return nil
        }
    }
    
    
    private func loadMock() -> Data? {
        return loadJSONFile(name: "marvelDataMock")
    }
    
    private func loadNotValidMock() -> Data? {
        return loadJSONFile(name: "marvelNotValidMock")
    }
    
    private func loadJSONFile(name: String) -> Data? {
        if let filepath = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents.data(using: .utf8)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func verifyUrl(_ url: URL?) -> Bool {
        guard let notNilURL = url else { return false }
        return UIApplication.shared.canOpenURL(notNilURL)
    }
    
    private func AssertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data), file: file, line: line) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.", file: file, line: line)
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)", file: file, line: line)
            }
        }
    }

}
