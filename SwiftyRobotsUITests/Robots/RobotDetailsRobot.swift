/*
 * Created by Grzegorz Wikiera on 07.02.2018.
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

func robotDetails(_ closure: (RobotDetailsRobot) -> Void) {
    let robot = RobotDetailsRobot(query: XCUIApplication().otherElements.matching(identifier: "details"))
    closure(robot)
}

class RobotDetailsRobot: Robot {
    func hasTitle(_ title: String) {
        XCTAssert(XCUIApplication().navigationBars.matching(identifier: title).element.exists)
    }
    
    func hasRobotImage(_ title: String) {
        XCTAssert(query.images.element.identifier.count > 10)
    }
    
    func tapBackButton() {
        XCUIApplication().navigationBars.buttons.element(boundBy: 0).tap()
    }
}
