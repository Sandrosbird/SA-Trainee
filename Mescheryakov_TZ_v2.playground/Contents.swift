import UIKit

extension String {
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
//         0              15 17                               50 52                                                                   121
var str = "First expression\nAnother expression with more words\nAnd third final expression with some punctuation marks at the end!?.."
let strWithMoreBreaks = "First expression\nAnother expression with more words\nAnd third final expression with some punctuation marks at the end!?..\nAnother expression with more words\nAnd third final expression with some punctuation marks at the end!?.."
let lineBreak: Character = "\n"
let strWithoutBreaks = "Something wrong here" // 20
str.count //121
strWithoutBreaks.count //20
strWithMoreBreaks.count //226

func findRangeOfSubstring(string: String, at position: Int) -> NSRange? {
    var finalRange: NSRange?
    var location: Int
    var length: Int
    
    //проверка, что позиция не выходит за количество символов в строке
    guard position <= string.count else {
        print("Error: Position out of index range")
        return nil
    }
    
    //получаем значение String.Index из аргумента (position: Int)
    let positionIndex: String.Index = string.index(string.startIndex, offsetBy: position)
    
    //    let firstSeparatorIndx: String.Index? = string.firstIndex(of: lineBreak)
    //    let lastSeparatorIndex: String.Index? = string.lastIndex(of: lineBreak)
    
    let lineBreakIndexes: [String.Index] = string.indexes(of: String(lineBreak))
    
    if lineBreakIndexes.isEmpty {
        location = string.startIndex.utf16Offset(in: string)
        length = string.endIndex.utf16Offset(in: string)
        finalRange = NSRange(location: location, length: length)
        return finalRange
    } else {
        var previousLineBreakIndex: String.Index? = nil
        var nextLineBreakIndex: String.Index? = nil
        var i = 0
        
        for index in lineBreakIndexes {
            
            if index != lineBreakIndexes.last! && positionIndex > index {
                i+=1
                previousLineBreakIndex = index
                continue
            } else if positionIndex <= index && previousLineBreakIndex == nil { //выполняется
                location = string.startIndex.utf16Offset(in: string)+1
                length = lineBreakIndexes.first!.utf16Offset(in: string) - location
                
                finalRange = NSRange(location: location, length: length)
                return finalRange
            } else if positionIndex <= index && previousLineBreakIndex != nil { //выполняется
                
                nextLineBreakIndex = index
                
                location = previousLineBreakIndex!.utf16Offset(in: string)+1
                length = nextLineBreakIndex!.utf16Offset(in: string)-1
                
                finalRange = NSRange(location: location, length: length)
                return finalRange
                
            } else if positionIndex > index && index == lineBreakIndexes.last! { // выполняется
                previousLineBreakIndex = lineBreakIndexes[i]
                nextLineBreakIndex = string.endIndex
                
                location = previousLineBreakIndex!.utf16Offset(in: string)+1
                length = nextLineBreakIndex!.utf16Offset(in: string)-1
                
                finalRange = NSRange(location: location, length: length)
                print("конечное условие")
                return finalRange
            }
        }
    }
    return finalRange
}


findRangeOfSubstring(string: str, at: 55) //работает
findRangeOfSubstring(string: strWithMoreBreaks, at: 130)
findRangeOfSubstring(string: strWithoutBreaks, at: 2)

//
//str.makeIterator()
//
//str.enumerated()
//
//let searchedIndex = str.index(str.startIndex, offsetBy: 6)
//print(searchedIndex)
//
//
////findRangeOfSubstring(string: str, at: 10)
//let some = str.indices
//
//let firstChar = str.first!
//let range = str.distance(from: str.firstIndex(of: firstChar)!, to: str.firstIndex(of: lineBreak)!) // String.IndexDistance
//
////findRangeOfSubstring(string: str, at: 10)
//
//print(str.split(separator: lineBreak))
//print(str.components(separatedBy: .newlines))
//
//NSRangeFromString(str)


//func firstTry(string: String, at position: Int) -> NSRange? {
//    var finalRange: NSRange?
//    var location: Int
//    var length: Int
//
//    //получаем значение String.Index из аргумента position: Int
//    let positionIndex: String.Index = string.index(string.startIndex, offsetBy: position)
//
//    //проверка, что позиция не выходит за количество символов в строке
//    guard position <= string.count else {
//        print("Error: Position out of index range")
//        return nil
//    }
//
//    let firstSeparatorIndex: String.Index? = string.firstIndex(of: lineBreak)
//    let lastSeparatorIndex: String.Index? = string.lastIndex(of: lineBreak)
//
//        if positionIndex <= firstSeparatorIndex  {
//            location = string.startIndex.utf16Offset(in: string)
//            length = firstSeparatorIndex.utf16Offset(in: string) // получается не длина, а индекс последнего элемента подстроки
//
//            finalRange = NSRange(location: location, length: length)
//            return finalRange
//        } else if positionIndex > firstSeparatorIndex && positionIndex <= lastSeparatorIndex {
//            location = firstSeparatorIndex.utf16Offset(in: string)+1
//            length = lastSeparatorIndex.utf16Offset(in: string)-1 // получается не длина, а индекс последнего элемента подстроки
//
//            finalRange = NSRange(location: location, length: length)
//            return finalRange
//        } else if positionIndex > lastSeparatorIndex && position <= string.count {
//            location = lastSeparatorIndex.utf16Offset(in: string)+1
//            length = string.endIndex.utf16Offset(in: string)-1 // получается не длина, а индекс последнего элемента подстроки
//
//            finalRange = NSRange(location: location, length: length)
//            return finalRange
//        }
//    return finalRange
//}

//                if previousLineBreakIndex == nil { // если position находится до первого переноса строки
//                    nextLineBreakIndex = lineBreakIndexes[i]
//                    location = string.startIndex.utf16Offset(in: string)
//                    length = (nextLineBreakIndex?.utf16Offset(in: string) ?? 0) - location // получается длина, а не индекс последнего элемента подстроки
//                    finalRange = NSRange(location: location, length: length)
//                    return finalRange
//                } else if previousLineBreakIndex != nil && index != lineBreakIndexes.last {
////                    i+=1
//
//                    nextLineBreakIndex = lineBreakIndexes[i]
//                    location = previousLineBreakIndex!.utf16Offset(in: string)
//                    length = nextLineBreakIndex!.utf16Offset(in: string) - location
//                    //                    string.endIndex.utf16Offset(in: string) - location
//
//                    finalRange = NSRange(location: location, length: length)
//                    return finalRange
//                } else if previousLineBreakIndex != nil && lineBreakIndexes.last == index {
////                    i+=1
//                    nextLineBreakIndex = lineBreakIndexes[i]
//                    location = index.utf16Offset(in: string)
//                    length = string.endIndex.utf16Offset(in: string) - location
//
//                    finalRange = NSRange(location: location, length: length)
//                    return finalRange
//                }
//            } else if positionIndex <= index && lineBreakIndexes.last != index {
//                nextLineBreakIndex = index
//                print("3")
//                location = previousLineBreakIndex!.utf16Offset(in: string)+1
//                length = nextLineBreakIndex!.utf16Offset(in: string) - location
//
//                finalRange = NSRange(location: location, length: length)
