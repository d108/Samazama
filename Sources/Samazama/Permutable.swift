/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

public
protocol Permutable: TextProcessable
{
    // Intentionally empty.
}

extension Permutable
{
    /// 1. Generate unique variants of a string where repeated characters get successively removed one
    /// at a time such that at least one occurrence remains in the string. This method preserves the
    /// order of the remaining characters.
    ///
    /// 2. Recursively generate the same results for each lesser string by performing (1) until no
    /// more repeating characters exist.
    ///
    /// For example, "carry pizza over" contains two repeated letters resulting in a set of ten unique,
    /// ordered arrangements after the above process is run:
    ///
    /// ["crpzv", "cpzvr", "crrpzv", "crpzvr", "crpzzv", "cpzzvr", "crrpzvr", "crrpzzv", "crpzzvr", "crrpzzvr"]
    ///
    /// These variants allow matching any of the shorter input sequences to the original term, saving
    /// keystrokes.
    ///
    /// - parameter input: String containing input to be processed.
    /// - returns: An array of permutations.
    func makeRepeatCharacterVariants(input: String) throws -> Permutations
    {
        var result = [input]
        let repeated = uniqueCharacters(input: input)

        if repeated.count < 1 {
            return result
        }
        
        var recursionLevel = 0
        
        for rpt in repeated
        {
            var offset = 0
            for chr in input
            {
                // Recursively remove repeated characters for each position in which they appear.
                if chr == rpt {
                    recursionLevel += 1
                    if recursionLevel > maxRecursionLevel { throw SamazamaError.exceededRecursionLevel }
                    let rmv = characterRemove(input: input, atOffset: offset)
                    result.append(rmv)
                    result.append(contentsOf: try makeRepeatCharacterVariants(input: rmv))
                }
                offset += 1
            }
        }
        
        return finalizeResult(permutations: result)
    }
}
