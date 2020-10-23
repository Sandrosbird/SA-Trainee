import UIKit



extension String {
        
    func findRange(at position: Int) -> ClosedRange<Int>? {
        
        guard position >= 0, position < endIndex.utf16Offset(in: self) else { print("Index out of strings range"); return nil }
        var startOfSubstring = 0
        var endOfSubstring = 0
        var mutablePosition = position
        var anotherMutablePosition = position
        var firstFlag = true
        var secondFlag = true
        
        while (index(startIndex, offsetBy: mutablePosition) >= startIndex || index(startIndex, offsetBy: anotherMutablePosition) < endIndex) && (firstFlag || secondFlag) {
            print("1")
            //проверка на наличие хотя бы одного \n в строке, если нет, то выведет 0..<endIndex
            if contains("\n") {
                print("2")
                //Поиск вниз от position: если поиск дошел до начала строки или до \n, то starOFSubstring = текущая позиция и флаг для меньшей границы переключается, если поиск не завершился и флаг не равен false, то переходит в следующему элементу
                if (index(startIndex, offsetBy: mutablePosition) == startIndex || self[index(startIndex, offsetBy: mutablePosition)] == "\n" || self[index(startIndex, offsetBy: mutablePosition)] == first) && firstFlag {
                    print("3")
                    startOfSubstring = mutablePosition
                    firstFlag = false
                } else if index(startIndex, offsetBy: mutablePosition) >= startIndex && firstFlag{
                    print("4")
                    mutablePosition -= 1
                }
                //Поиск вверх от position.
                if (index(startIndex, offsetBy: anotherMutablePosition) == index(before: endIndex) || self[index(startIndex, offsetBy: anotherMutablePosition)] == "\n" || self[index(startIndex, offsetBy: mutablePosition)] == last) && secondFlag {
                    print("5")
                    endOfSubstring = anotherMutablePosition
                    secondFlag = false
                } else if index(startIndex, offsetBy: anotherMutablePosition) < endIndex && secondFlag {
                    print("6")
                    anotherMutablePosition += 1
                }
                //если position указывает на символ переноса строки, то подстрокой считается то, что находится слева от position
                if mutablePosition == anotherMutablePosition {
                    print("7")
                    mutablePosition = position - 1
                    firstFlag = true
                    secondFlag = true
                }
                //Если в строке нет \n
            } else {
                print("7")
                startOfSubstring = startIndex.utf16Offset(in: self)
                endOfSubstring = index(before: endIndex).utf16Offset(in: self)
                firstFlag = false
                secondFlag = false
            }
        }
        //проверка для корректного вывода диапазона, в который не входят разделители строк
        if (mutablePosition <= position && mutablePosition != startIndex.utf16Offset(in: self) && self[index(startIndex, offsetBy: mutablePosition)] == "\n") && (anotherMutablePosition >= position && anotherMutablePosition != index(before: endIndex).utf16Offset(in: self) && self[index(startIndex, offsetBy: anotherMutablePosition)] == "\n") {
            print("Between two line breakers")
            return startOfSubstring+1...endOfSubstring-1
        } else if self[index(startIndex, offsetBy: anotherMutablePosition)] != last && self[index(startIndex, offsetBy: anotherMutablePosition)] == "\n" {
            print("LIne breaker after position")
            return startOfSubstring...endOfSubstring-1
        } else if self[index(startIndex, offsetBy: mutablePosition)] != first && self[index(startIndex, offsetBy: mutablePosition)] == "\n" {
            print("LIne breaker before position")
            return startOfSubstring+1...endOfSubstring
        } else {
            return startOfSubstring...endOfSubstring
        }
    }
}

let s = "12\n345678\n90"
let i = 8


s.findRange(at: i)
