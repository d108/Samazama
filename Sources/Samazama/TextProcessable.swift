/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

public
protocol TextProcessable:
    Soundexable
{
    // Intentionally empty.
}

extension TextProcessable
{
    /// Remove a character at a given offset.
    func characterRemove(
        input: String,
        atOffset: Int) -> String
    {
        var offSet = 0
        var result = ""
        
        for char in input
        {
            if offSet != atOffset
            {
                result.append(char)
            }
            offSet += 1
        }
        
        return result
    }
    
    /// - parameter input: A string, usually user input.
    /// - returns: Set containing unique characters in a string.
    func uniqueCharacters(input: String) -> Set<Character>
    {
        var counts = [Character:Int]()
        
        for chr in input
        {
            if counts[chr] == nil
            {
                counts[chr] = 1
            } else
            {
                counts[chr]! += 1
            }
        }
        
        var result = Set<Character>()
        
        for (chr, cnt) in counts
        {
            if cnt > 1
            {
                result.insert(chr)
            }
        }
        
        return result
    }
    
    /// Remove repeat characters within a string such that one occurrence of the original character
    /// remains in the relative starting position where the characters were originally repeated.
    ///
    /// ## Example:
    ///
    /// "0001111000" becomes "010", or with removeAtMost = 1, "00111000".
    ///
    /// Each character removed reduces the recursion level by 1, corresponding to a factor of ~10 in
    /// compute operations. The operation counts increases from around 36 K to 3.6 M going from
    /// "00111000" to "0001111000", 10^2 for two additional characters.
    ///
    /// - parameters:
    ///   - input: String containing input to be processed.
    ///   - removeAtMost: For all repeating characters, if set, will remove the specified number of
    ///                   occurrences for each character.
    /// - returns: String with repeating characters removed.
    func removeRepeats(
        input: String,
        removeAtMost: Int? = nil) -> String
    {
        var mutable = input
        let repeated = uniqueCharacters(input: input)
        var removed = [Character:Int]()
        
        for rpt in repeated
        {
            var offset = 0
            
            for chr in mutable
            {
                if chr == rpt {
                    if removed[chr] == nil
                    {
                        removed[chr] = 1
                    } else
                    {
                        removed[chr]! += 1
                    }
                    if let level = removeAtMost, let removedCount = removed[chr], removedCount > level
                    {
                        continue
                    }
                    mutable = characterRemove(input: mutable, atOffset: offset)
                }
                offset += 1
            }
        }
        
        return mutable
    }
    
    /// - parameter: Permutation array.
    /// - returns: Unique strings as a Set for a given array of Permutations.
    public
    func uniqueStrings(strings: Permutations) -> Set<String>
    {
        var total = 0
        var unique = Set<String>()
        for str in strings
        {
            total += 1
            unique.insert(str)
        }
        
        return unique
    }
    
    /// Perform any final actions on Permutations.
    /// - returns: Array of Permutations.
    func finalizeResult(permutations: Permutations) -> Permutations
    {
        if shouldChangeToLowercase
        {
            return permutations.map { $0.lowercased() }
        }
        
        return permutations
    }
    
    /// Intended to run before permutation generation.
    ///
    /// * Changes case.
    /// * Removes silent digraphs.
    /// * Removes spaces and noncoded characters.
    ///
    /// - parameter input: A string, usually user input.
    /// - returns: The normalized string or the original input, lowercased, if parsing fails.
    func normalizeInput(input: String) -> String
    {
        var newInput = input
        
        if shouldChangeToLowercase
        {
            newInput = newInput.lowercased()
        }        
        
        if let coded = keepCoded(input: newInput).nonzeroCoded
        {
            return coded
        }
                
        return newInput
    }
}
