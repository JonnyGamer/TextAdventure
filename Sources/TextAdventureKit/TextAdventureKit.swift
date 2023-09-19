import Foundation

public typealias Options = Help.Options

/// Access all the useful documentation from this prohect!
public struct Help {
    
    private init() {}
    
    /// Access the options to the game
    public struct Options {
        /// The number of seconds stalled between words in the `printSlowly` function
        static var printSlowly: Double = 0.1
        private init() {}
    }
    
    /// Print some text slowly, a puase is put in between each word.
    public static func printSlowly(_ string: String) {
        let gotchas = string.split(separator: " ", omittingEmptySubsequences: false)
        for (i, character) in gotchas.enumerated() {
            print(character, terminator: "")
            if i < gotchas.count - 1 {
                print(" ", terminator: "")
            }
            wait(Options.printSlowly)
        }
        print("")
    }
    
    /// Cause the Thread to sleep for a given number of seconds.
    public static func wait(_ seconds: Double) {
        usleep(UInt32(seconds * 1_000_000))
    }
    
    /// Pause the game for the user to catch up and read.
    public static func pause() {
        print("(Press enter)", terminator: "")
        _ = readLine()
    }
    
    
    /// Retrieve input from the user! `let response = input()`
    public static func input() -> String {
        print(" :", terminator: "")
        return readLine() ?? input()
    }

    /// The user must input a valid option. `let response = input(["a", "b", "c"])`
    public static func input(_ options: [String]) -> String {
        let result = input()
        if options.contains(result) {
            return result
        }
        print("You must choose one of the following: \(options.map({String($0)}).joined(separator: ", "))")
        return input(options)
    }
    
    /// The user must input a valid option. `let response = input("a", "b", "c")`
    public static func input(_ options: String...) -> String {
        return Help.input(options)
    }

    /// The user must input an Int. `let response: Int = inputInt()`
    public static func inputInt() -> Int {
        return input_i()
    }
    private static func input_i(retry: Bool = false) -> Int {
        if retry { print("(Please input an Int i.e. 0, 999, -1)") }
        return Int(Help.input()) ?? input_i(retry: true)
    }
    
    /// The user must input an Int between a range. `let response: Int = inputInt(between: 1, and: 10)`
    public static func inputInt(between: Int, and: Int) -> Int {
        return input_i_range(between: between...and)
    }
    /// The user must input an Int between a range. `let response: Int = inputInt(1...10)`
    public static func inputIntRange(_ between: ClosedRange<Int>) -> Int {
        return input_i_range(between: between)
    }
    private static func input_i_range(between: ClosedRange<Int>, retry: Bool = false) -> Int {
        if retry { print("(Please input a number between \(between.lowerBound) and \(between.upperBound)") }
        let r = Help.inputInt()
        return between.contains(r) ? r : input_i_range(between: between, retry: true)
    }
    
    /// The user must input a Double. `let response: Double = inputDouble()`
    public static func inputDouble() -> Double {
        return input_d()
    }
    private static func input_d(retry: Bool = false) -> Double {
        if retry { print("(Please input an Double i.e. 3.1415)") }
        return Double(Help.input()) ?? input_d(retry: true)
    }

    /// The user must input a Double between a range. `let response: Double = inputDouble(between: 1.0, and: 10.0)`
    public static func inputDouble(between: Double, and: Double) -> Double {
        return input_d_range(between: between...and)
    }
    /// The user must input a Double between a range. `let response: Int = inputInt(1.0...10.0)`
    public static func inputDoubleRange(_ between: ClosedRange<Double>) -> Double {
        return input_d_range(between: between)
    }
    private static func input_d_range(between: ClosedRange<Double>, retry: Bool = false) -> Double {
        if retry { print("(Please input a number between \(between.lowerBound) and \(between.upperBound)") }
        let r = Help.inputDouble()
        return between.contains(r) ? r : input_d_range(between: between, retry: true)
    }
    
    /// Force the user to input either Yes or No
    public static func inputYN() -> YesOrNo {
        return input_yn()
    }
    // public static var yes: YesOrNo = .yes
    // public static var no: YesOrNo = .no
    private static  func input_yn(retry: Bool = false) -> YesOrNo {
        if retry { print("(Please input either yes or no)") }
        return YesOrNo.init(rawValue: input().lowercased()) ?? input_yn(retry: true)
    }
    
    private static var _askAgain: [Bool] = []
    /// Ask a question via `ask { /* Question */ }` if you don't like the response, insert `return askAgain()`
    public static func ask(_ question: () -> ()) {
        _askAgain.append(false)
        question()
        while _askAgain.last == true {
            _askAgain[_askAgain.count - 1] = false
            question()
        }
        _askAgain.removeLast()
    }
    /// Implement the `askAgain()` function to revisit a question, if you didn't like the user's answer.
    public static var askAgain: Void {
        if _askAgain.isEmpty { return }
        _askAgain[_askAgain.count - 1] = true
    }
    
    
    /// Play a fantastic game in which a computer reads your mind in twenty guesses!
    public static func twentyQuestions() {
        printSlowly("Welcome to 20 Questions!")
        printSlowly("Pick a number between 1 and 1000.")
        printSlowly("Are you ready?")
        _ = input()
        printSlowly("Well... Here we go!")
        
        var min = 1
        var max = 1000
        for guess in 1...20 {
            let guessedNum = (min + max)/2
            printSlowly("Guess \(guess). Is it \(guessedNum)?")
            if guess < 20 {
                printSlowly(" a. My number is higher.")
                printSlowly(" b. My number is lower.")
                printSlowly(" c. Correct!")
                let answer = input("a", "b", "c")
                if answer == "a" {
                    min = guessedNum
                } else if answer == "b" {
                    max = guessedNum
                } else if answer == "c" {
                    printSlowly("Hooray!")
                    break
                }
            } else {
                printSlowly(" a. Correct!")
                _ = input("a")
                printSlowly("Hooray!")
            }
        }
        printSlowly("Good Game!")
        printSlowly("Play Again? Yes or No?")
        let repeatGame = inputYN()
        if repeatGame == .yes {
            twentyQuestions()
        } else {
            printSlowly("Thanks for playing!")
            printSlowly("(Press enter to quit)")
            _ = input()
        }
    }
    
    /// Play a fantastic game and try to read the computer's mind in twenty questions!
    public static func twentyQuestionsReverse() {
        printSlowly("Welcome to 20 Questions!")
        printSlowly("I picked a number between 1 and 1000.")
        printSlowly("Can you guess it in 20 Questions?")
        printSlowly("Are you ready?")
        _ = input()
        printSlowly("Well... Here we go!")
        
        var guesses: [Int] = []
        let answer = Int.random(in: 1...1000)
        for guess in 1...20 {
            printSlowly("This is your Guess number \(guess).")
            let number = inputInt(between: 1, and: 1000)
            if number == answer {
                printSlowly("You won in \(guess) Guesses!")
                printSlowly("Not half bad!")
                break
            } else {
                if guesses.contains(number) {
                    printSlowly("You... Already guessed this before?")
                    printSlowly("Interesting... strategy?")
                }
                if guess < 20 {
                    if answer < number {
                        printSlowly("The number I am thinking of is smaller!")
                    }
                    if answer > number {
                        printSlowly("The number I am thinking of is larger!")
                    }
                } else {
                    printSlowly("Oh... Wrong answer!")
                    printSlowly("Oops! Game Over!")
                    printSlowly("My number was \(answer).")
                }
            }
            guesses.append(number)
        }
        
        printSlowly("Good Game!")
        printSlowly("Play Again? Yes or No?")
        let repeatGame = inputYN()
        if repeatGame == .yes {
            twentyQuestions()
        } else {
            printSlowly("Thanks for playing!")
            printSlowly("(Press enter to quit)")
            _ = input()
        }
    }
    
}

/// Print some text slowly, a puase is put in between each word.
public func printSlowly(_ string: String) {
    Help.printSlowly(string)
}

/// Cause the Thread to sleep for a given number of seconds.
public func wait(_ seconds: Double) {
    Help.wait(seconds)
}

/// Pause the game for the user to catch up and read.
public func pause() {
    Help.pause()
}

/// Retrieve input from the user!
public func input() -> String {
    Help.input()
}

/// The user must input a valid option.
public func input(_ options: [String]) -> String {
    Help.input(options)
}

/// The user must input a valid option.
public func input(_ options: String...) -> String {
    return input(options)
}

/// The user must input an Int.
public func inputInt() -> Int {
    return Help.inputInt()
}
/// The user must input an Int between a range. `let response: Int = inputInt(between: 1, and: 10)`
public func inputInt(between: Int, and: Int) -> Int {
    return Help.inputInt(between: between, and: and)
}
/// The user must input an Int between a range. `let response: Int = inputInt(1...10)`
public func inputIntRange(_ between: ClosedRange<Int>) -> Int {
    return Help.inputIntRange(between)
}

/// The user must input a Double.
public func inputDouble() -> Double {
    return Help.inputDouble()
}
/// The user must input a Double between a range. `let response: Double = inputDouble(between: 1.0, and: 10.0)`
public func inputDouble(between: Double, and: Double) -> Double {
    return Help.inputDouble(between: between, and: and)
}
/// The user must input a Double between a range. `let response: Int = inputInt(1.0...10.0)`
public func inputDoubleRange(_ between: ClosedRange<Double>) -> Double {
    return Help.inputDoubleRange(between)
}

/// Force the user to input either Yes or No
public func inputYN() -> YesOrNo {
    return Help.inputYN()
}
/// A Yes or No type. Equivalent to the Boolean!
public enum YesOrNo: String { case yes, no }
/// yes
public var yes: YesOrNo = .yes
/// no
public var no: YesOrNo = .no

/// Ask a question via `ask { /* Question */ }` if you don't like the response, insert `return askAgain()`
public func ask(_ question: () -> ()) {
    Help.ask(question)
}
/// Implement the `askAgain()` function to revisit a question, if you didn't like the user's answer.
public var askAgain: Void {
    Help.askAgain
}

public func twentyQuestions() {
    Help.twentyQuestions()
}

public func twentyQuestionsReverse() {
    Help.twentyQuestionsReverse()
}


public extension Int {
    /// Add an s to the end if the noun is plural
    var s: String {
        return self == 1 ? "" : "s"
    }
}
