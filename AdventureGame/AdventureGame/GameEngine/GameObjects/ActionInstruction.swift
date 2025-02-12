//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

public class ActionInstruction {

    /*
     * Defines the instructions that the specific action is capable of performing.
     *
     * This is an int value between 52 and 89.
     *
     * How irrirtating, instructions are not in this range after all! A value of
     * 51 or less is a message request and a value of 102 or more is also a message
     * display request.
     */
    public enum Instruction: Int {
        case get = 52               // Param = item
        case drop = 53              // param = item
        case goto = 54              // param = room
        case destroy = 55           // param = item
        case set_dark = 56
        case clear_dark = 57
        case set_flag = 58          // param = flag number
        case destroy2 = 59          // param = item
        case clear_flag = 60        // param = flag number
        case die = 61
        case put = 62               // Param = item room
        case game_over = 63
        case look = 64
        case score = 65
        case inventory = 66
        case set_flag0 = 67
        case clear_flag0 = 68
        case refil_lamp = 69
        case clear = 70
        case save_game = 71
        case swap = 72              // Param = item and item
        case cont = 73                /* Should be continue */
        case superget = 74          // param = item
        case put_with = 75          // param = item, item
        case look2 = 76
        case dec_counter = 77
        case print_counter = 78
        case set_counter = 79       // param = number
        case swap_room = 80
        case select_counter = 81    // param = number
        case add_to_counter = 82    // param = number
        case subtract_from_counter = 83 // param = number
        case print_noun = 84
        case println_noun = 85
        case swap_specific_room = 86    // param = number
        case pause = 87
        case draw = 88              // param = number
    }

    public var instruction : Int = 0
    private let game: Adventure

    init(forGame: Adventure, withId: Int) {
        game = forGame
        instruction = withId
    }
}

extension ActionInstruction {

    convenience init(forGame: Adventure, withId: String) {

        guard let numericId = Int(withId) else {
            fatalError("Invalid instruction encountered with id \(withId)")
        }

        self.init(forGame: forGame, withId: numericId)
    }
}

extension ActionInstruction: CustomStringConvertible {
    public var description: String {
        return "Instruction id: \(instruction)"
    }
}

extension ActionInstruction {

    public func execute(_ args: inout [Int]) -> Bool {

        // Should never happen, but who knows.
        if instruction == 0 {
            return false
        }

        // Number below 52 is a message request
        if instruction <= 51 {
            game.display(message: game.messages[instruction] )
            return false
        }

        if instruction >= 102 {
            // Number > 101 is also a message
            game.display(message: game.messages[instruction - 50] )
            return false
        }

        switch instruction {

        case 52:        // Get
            if game.carriedCount() == game.gameHeader.MaximumCarryItems   {
                // Display a message again!
                game.display(message: "I've too much to carry already")
            } else {
                let itemIndex = args.removeFirst()
                game.items[itemIndex].Location = game.ROOM_CARRIED
            }

        case 53:        // Drop
            let itemIndex = args.removeFirst()
            game.items[itemIndex].Location = game.location

        case 54:        // Goto
            let itemIndex = args.removeFirst()
            game.location = itemIndex

        case 55:        // Destroy
            let itemIndex = args.removeFirst()
            game.items[itemIndex].Location = game.ROOM_NOWHERE

        case 56:        // set_dark
            game.flags.dark_flag = true

        case 57:        // clear_dark
            game.flags.dark_flag = false

        case 58:        // set_flag = param = flag number
            let itemIndex = args.removeFirst()
            game.flags[itemIndex] = true

        case 59:        // destroy2 = param = item
            let itemIndex = args.removeFirst()
            game.items[itemIndex].Location = game.ROOM_NOWHERE

        case 60:        // clear_flag = param = flag number
            let itemIndex = args.removeFirst()
            game.flags[itemIndex] = false

        case 61:        // die =
            game.display(message: "I am dead")
            game.flags.dark_flag = true
            game.location = game.rooms.count - 1
            game.needToLook = true
            game.finish(3)

        case 62:        // put = Param = item room
            let itemIndex = args.removeFirst()
            let newLocation = args.removeFirst()

            game.items[itemIndex].Location = newLocation

        case 63:        // game_over
            game.finish(0)

        case 64:        // look =
//            game.needToLook = true
            game.actuallyLook()

        case 65:        // score =
            game.score()

        case 66:        // inventory =
            game.inventory()

        case 67:        // set_flag0 =
            game.flags[0] = true

        case 68:        // clear_flag0 =
            game.flags[0] = false

        case 69:        // refil_lamp =
            game.items[game.ITEM_LAMP].Location = game.ROOM_CARRIED
            game.lampLeft = game.gameHeader.LightTime
            game.flags.lamp_dead = false

//        case clear = 70       // Do nothing

//        case 71:        // save_game =
//            game.promptAndSave()

        case 72:        // swap = Param = item and item
            let item1Index = args.removeFirst()
            let item1Location = game.items[item1Index].Location

            let item2Index = args.removeFirst()
            let item2Location = game.items[item2Index].Location

            game.items[item1Index].Location = item2Location
            game.items[item2Index].Location = item1Location

        case 73:        // cont =
            return true

        case 74:        // superget = param = item
            let itemIndex = args.removeFirst()
            game.items[itemIndex].Location = game.ROOM_CARRIED

        case 75:        // put_with = param = item, item
            let itemIndex = args.removeFirst()
            let item2Index = args.removeFirst()

            game.items[itemIndex].Location = game.items[item2Index].Location

        case 76:        // look2 =
            game.actuallyLook()

        case 77:        // dec_counter =
            game.counter -= 1

        case 78:        // print_counter =
            game.display(message: "\(game.counter) ")

        case 79:        // set_counter = param = number
            let itemIndex = args.removeFirst()
            game.counter = itemIndex

        case 80:        // swap_room =
            let currentLocation = game.location
            game.location = game.savedRoom
            game.savedRoom = currentLocation

        case 81:        // select_counter = param = number
            let which = args.removeFirst()
            let currentCounter = game.counter

            game.counter = game.counters[which]
            game.counters[which] = currentCounter

        case 82:        // add_to_counter = param = number
            let increment = args.removeFirst()
            game.counter += increment

        case 83:        // subtract_from_counter = param = number
            let decrement = args.removeFirst()
            game.counter -= decrement

        case 84:        // print_noun =
            game.display(message: "\(game.noun) ")

        case 85:        // println_noun =
            game.display(message: "\(game.noun) ")

        case 86:        // swap_specific_room = param = number
            game.display(message: "")

        case 87:        // pause =
            let which = args.removeFirst()
            let currentLocation = game.location

            game.location = game.savedRooms[which]
            game.savedRooms[which] = currentLocation

        // case 88:        // draw = param = number
        // Usage varies, but this is  pause and we don't do that.

        default:
            // Nothing to do here, should never happen
            return false
        }

        return false
    }
}

