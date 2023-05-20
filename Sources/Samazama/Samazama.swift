/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

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
        
        for chr in input
        {
            if counts[chr] == nil
            {
                counts[chr] = 1
            } else
            {
                counts[chr]? += 1
            }
        }
        
        return counts
    }
    
    public
    func repeatCharacterVariants(
        input: String,
        onlyUnique: Bool = true) throws -> Permutations
    {
        var newInput: String!
        
        if shouldNormalizeInput
        {
            newInput = normalizeInput(input: input)
        } else
        {
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
    func generateVariants(
        input: String,
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
