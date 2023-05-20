/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

/// Samazama errors:
/// - exceededRecursionLevel: Max recursion level went beyond the configuration limit.
public
enum SamazamaError: Error
{
    case exceededRecursionLevel
}
