// Copyright (c) 2020 ikiApps LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public typealias Permutation = String
public typealias Permutations = [Permutation]

/// Generate the following products:
///
/// 1. Soundex-based codes.
/// 2. Linearly ordered arrangements (permutations) of strings with configurable parameters.
public
class Samazama:
    Permutable,
    Soundexable,
    Tokenizable,
    TextProcessable
{
    var generate: ((String, Bool) throws -> Permutations)!
    var finalize: ((Permutations) -> Permutations)!

    public
    init()
    {
        generate = { input, onlyUnique in
            try self.repeatCharacterVariants(input: input, onlyUnique: onlyUnique)
        }
        finalize = { permutations in
            self.finalizeResult(permutations: permutations)
        }
    }

    func repeatCharacterCounts(input: String) -> [Character:Int]
    {
        var counts = [Character:Int]()
        
        for chr in input {
            if counts[chr] == nil {
                counts[chr] = 1
            } else {
                counts[chr]? += 1
            }
        }
        
        return counts
    }
    
    public
    func repeatCharacterVariants(input: String,
                                 onlyUnique: Bool = true) throws -> Permutations
    {
        var newInput: String!
        
        if shouldNormalizeInput {
            newInput = normalizeInput(input: input)
        } else {
            newInput = input
        }
        
        if onlyUnique {
            return Array(uniqueStrings(strings: try makeRepeatCharacterVariants(input: newInput)))
        } else {
            return try makeRepeatCharacterVariants(input: newInput)
        }
    }

    /// Asynchronously generate variants to allow other operations to run. If a Samazama instance is
    /// marked for deallocation, the closures retain it before it will deinit allowing the completion
    /// handler to receive finalized permutations.
    ///
    /// - parameters:
    ///   - input: A string, usually user input.
    ///   - onlyUnique: If true, return unique variants only.
    ///   - completion: Result of permutations or an error.
    public
    func generateVariants(input: String,
                          onlyUnique: Bool,
                          completion: @escaping (Result<Permutations, Error>) -> Void)
    {
        DispatchQueue.global(qos: qos).async { [weak self] in
            var variants: Permutations? = [Permutation]()
            do {
                variants = try self?.generate(input, onlyUnique)
            } catch let err { completion(.failure(err)) }
            DispatchQueue.main.async {
                completion(.success(self?.finalize(variants ?? []) ?? []))
            }
        }
    }
}
