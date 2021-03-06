/*
 * Created by Grzegorz Wikiera on 09.02.2018.
 * Copyright (c) 2018 Grzegorz Wikiera <gwikiera@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import XCTest

class TextInputRobot: Robot {
    static let textInputTypes: [XCUIElement.ElementType] = [.textField, .textView, .secureTextField, .searchField]

    required init(query: XCUIElementQuery, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(TextInputRobot.textInputTypes.contains(query.element.elementType), "Wrong element type.", file: file, line: line)
        super.init(query: query, file: file, line: line)
    }

    func type(text: String, file: StaticString = #file, line: UInt = #line) {
        query.element.typeText(text)
        XCTAssert((query.element.value as? String)?.contains(text) ?? false, "Text \"\(text)\" was not typed.", file: file, line: line)
    }
}
