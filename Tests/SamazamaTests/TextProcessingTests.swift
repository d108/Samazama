/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

@testable import Samazama

import XCTest

struct DigraphTestSource
{
    var word: String
    var expected: String
}

/// Only keep coded characters.
struct KeepCodedSource
{
    var word: String
    var expected: String
}

private
var digraphSource =
[
    DigraphTestSource(word: "dining hall", expected: "dining hall"),
    DigraphTestSource(word: "dininghall", expected: "dininall"),
    DigraphTestSource(word: "ghost", expected: "ghost"),
    DigraphTestSource(word: "night", expected: "nit"),
]

private
var keepCodedSource =
[
    KeepCodedSource(word: "dining hall", expected: "dnngll"),
    KeepCodedSource(word: "kun'yomi", expected: "knm"),
    KeepCodedSource(word: "neighborhood", expected: "nbrd"),
]

final
class TextProcessingTests: XCTestCase
{
    let timeout: TimeInterval = 5
    var smzm: Samazama!
    
    static var allTests =
    [
        ("test_remove_digraph", test_remove_digraph)
    ]
    
    override
    func setUp()
    {
        smzm = Samazama()
    }
    
    /// Vowels not removed.
    func test_remove_digraph()
    {
        for source in digraphSource
        {
            let newSource = smzm.keepCoded(input: source.word, perform: [.removeDigraph])
            XCTAssert(newSource.nonzeroCoded == source.expected, "❌ Result \(newSource.nonzeroCoded as String?) is not \(source.expected)")
        }
    }
    
    func test_keep_coded()
    {
        for source in keepCodedSource
        {
            let newSource = smzm.keepCoded(input: source.word)
            XCTAssert(newSource.nonzeroCoded == source.expected, "❌ Result \(newSource ) is not \(source.expected)")
        }
    }    
}
