/* 
 * SPDX-FileCopyrightText: © 2023 Daniel Zhang <https://github.com/d108/>
 * SPDX-License-Identifier: MIT License
 */

import Foundation

public var maxRecursionLevel = 8
public var qos: DispatchQoS.QoSClass = .utility
public var shouldChangeToLowercase = true
public var shouldNormalizeInput = true
public var soundexCodeLength = 4

var zerocode = "0"
var removeCode = "-1"
