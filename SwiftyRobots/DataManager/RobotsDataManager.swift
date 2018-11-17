/*
 * Created by Grzegorz Wikiera on 05.02.2018.
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

import Foundation

typealias CompletionBlock = (Robot) -> Void
typealias FailureBlock = (RobotsDataManager.Error) -> Void

class RobotsDataManager {
    enum Error: Swift.Error {
        case badURL
        case connection(error: Swift.Error?)
        case copying(error: Swift.Error?)
    }
    
    static let robohashURL = URL(string: "https://robohash.org/")
    
    private(set) var robots: [Robot] = []
    
    func fetchRobot(for name: String, completion: @escaping CompletionBlock, failure: @escaping FailureBlock) {
        let session = URLSession.shared
        guard let url = RobotsDataManager.robohashURL?.appendingPathComponent(name) else {
            failure(Error.badURL)
            return
        }
        
        let task = session.downloadTask(with: url) { [weak self] (tempLocation, response, error) in
            guard let tempLocation = tempLocation else {
                DispatchQueue.main.sync {
                    failure(Error.connection(error: error))
                }
                return
            }
            
            let fileManager = FileManager.default
            let destination = URL(fileURLWithPath:NSTemporaryDirectory().appending("/" + UUID().uuidString))
            do {
                try fileManager.copyItem(at: tempLocation, to: destination)
            } catch {
                DispatchQueue.main.sync {
                    failure(Error.copying(error: error))
                }
                return
            }
            let robot = Robot(name: name, imagePath: destination.path)
            DispatchQueue.main.sync {
                self?.robots.append(robot)
                completion(robot)
            }
        }
        task.resume()
    }
    
    func removeRobot(_ robot: Robot) {
        robots = robots.filter { $0 != robot }
    }
}
