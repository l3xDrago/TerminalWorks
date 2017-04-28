//
//  main.swift
//  GitLogRenderer
//
//  Created by admin on 15/11/2016.
//  Copyright © 2016 Alex Stanciu. All rights reserved.
//

import Foundation

for argument in CommandLine.arguments {
}

func input() -> String {
    let keyboard = FileHandle.standardInput
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:String.Encoding.utf8.rawValue) as! String
}

print("input " + input())




