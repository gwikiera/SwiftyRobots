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

class Robot {
    let query: XCUIElementQuery

    required init(query: XCUIElementQuery, file: StaticString = #file, line: UInt = #line) {
        self.query = query
        XCTAssert(query.element.exists, "Cannot create \(type(of: self)) robot.", file: file, line: line)
    }
}

extension Robot {
    func tap(file: StaticString = #file, line: UInt = #line) {
        let element = query.element
        XCTAssert(element.isHittable, "Element \(element.identifier) is not tappable.", file: file, line: line)
        element.tap()
    }

    func swipeLeft(file: StaticString = #file, line: UInt = #line) {
        let element = query.element
        XCTAssert(element.isHittable, "Element \(element.identifier) is not tappable.", file: file, line: line)
        element.swipeLeft()
    }
}

extension Robot {
    func button(_ label: String, file: StaticString = #file, line: UInt = #line) -> Robot {
        return Robot(query: XCUIApplication().buttons.matching(NSPredicate(format: "label = \"\(label)\"")), file: file, line: line)
    }

    func textInput(_ identifier: String, file: StaticString = #file, line: UInt = #line) -> TextInputRobot {
        return TextInputRobot(query: query.children(matching: .any).matching(identifier: identifier))
    }
}
