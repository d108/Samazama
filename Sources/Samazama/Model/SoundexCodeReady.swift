/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

/// For preparation of Soundex codes.
public
struct SoundexCodeReady
{
    /// Keep the first character to start a Soundex code.
    var first: Character?
    /// Contains only characters convertible to non-zero Soundex groups.
    var nonzeroCoded: String?
}

/// Possible actions on units within a string for coding.
enum CodeReadyAction
{
    case keepSingle
    case removeDigraph
}
