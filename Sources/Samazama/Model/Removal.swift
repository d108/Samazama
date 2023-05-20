/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

enum DigraphRemove
{
    case keepInitial
}

let digraphRemoves: [String: DigraphRemove] =
[
    "gh": .keepInitial
]

enum DigraphResponse
{
    case remove
    case keepFirst
    case keepSecond
    case none
}
