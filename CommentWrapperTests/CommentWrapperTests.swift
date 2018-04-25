//
//  CommentWrapperTests.swift
//  CommentWrapperTests
//
//  Created by Steve Barnegren on 06/04/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import Comment_Wrapper

/*
 ant
 bear
 cat
 dog
 emu
 fox
 gecko
 heron
 iguana
 jellyfish
 koala
 lion
 monkey
 newt
 octopus
 parrot
 quail
 rabbit
 sheep
 tiger
 uakari
 vole
 walrus
 xenopus
 yak
 zebra
 */

class CommentWrapperTests: XCTestCase {
    
    // MARK: - Wrapping
    
    func testWrapsLines() {
        
        let input = TestStrings.alphabeticalAnimals
        
        //////////////////////////////////////// <-- Guide (40 chars)
        let expected = """
        ant bear cat dog emu fox gecko heron
        iguana jellyfish koala lion monkey newt
        octopus parrot quail rabbit sheep tiger
        uakari vole walrus xenopus yak zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        
        XCTAssertEqual(output, expected)
    }
    
    func testWrapsLinesWithMultipleSpaces() {
        
        let input = TestStrings.alphabeticalAnimals.replacingOccurrences(of: " ", with: "  ")
        
        //////////////////////////////////////// <-- Guide (40 chars)
        let expected = """
        ant  bear  cat  dog  emu  fox  gecko
        heron  iguana  jellyfish  koala  lion
        monkey  newt  octopus  parrot  quail
        rabbit  sheep  tiger  uakari  vole
        walrus  xenopus  yak  zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        
        XCTAssertEqual(output, expected)
    }
    
    func testHandlesEmptyPrefixedLines() {
        
        let input = """
        /// First line
        ///
        /// Second line
        """
        
        let expected = """
        /// First line
        ///
        /// Second line
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        XCTAssertEqual(output, expected)
    }
    
    // MARK: - Comment prefixes
    
    func testInsertsPrefixWithDoubleForwardSlashAndSpace() {
        
        let input = "// ".appending(TestStrings.alphabeticalAnimals)
        
        ////////////////////////////////////////*** <-- Guide (40 chars + 3 prefix)
        let expected = """
        // ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        
        XCTAssertEqual(output, expected)
    }
    
    func testInsertsPrefixWithTripleForwardSlash() {
        
        let input = "///".appending(TestStrings.alphabeticalAnimals)
        
        ////////////////////////////////////////*** <-- Guide (40 chars + 3 prefix)
        let expected = """
        ///ant bear cat dog emu fox gecko heron
        ///iguana jellyfish koala lion monkey newt
        ///octopus parrot quail rabbit sheep tiger
        ///uakari vole walrus xenopus yak zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        
        XCTAssertEqual(output, expected)
    }
    
    // MARK: - Paragraphs
    
    func testHandlesParagraphs() {
    
        let input = "// " + TestStrings.alphabeticalAnimals + "\n\n" + "// " + TestStrings.alphabeticalAnimals
        
        ////////////////////////////////////////*** <-- Guide (40 chars + 3 prefix)
        let expected = """
        // ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        //
        // ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        
        XCTAssertEqual(output, expected)
    }
    
    // MARK: - Code
    
    func testHandlesCode() {
        
        let input =
            "// " + TestStrings.alphabeticalAnimals + "\n" +
            "\n" +
            "//     this.is.some.code.that.runs.longer.than.40.chars()" + "\n" +
            "\n" +
            "// " + TestStrings.alphabeticalAnimals

        let expected = """
        // ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        //
        //     this.is.some.code.that.runs.longer.than.40.chars()
        //
        // ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        XCTAssertEqual(output, expected)
    }
    
    // MARK: - Bulleted lists
    
    func testHandlesBulletedLists() {
        
        let input =
            "// - " + TestStrings.alphabeticalAnimals + "\n" +
            "// - " + TestStrings.alphabeticalAnimals
        
        let expected = """
        // - ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        // - ant bear cat dog emu fox gecko heron
        // iguana jellyfish koala lion monkey newt
        // octopus parrot quail rabbit sheep tiger
        // uakari vole walrus xenopus yak zebra
        """
        
        let output = CommentWrapper.wrap(string: input, lineLength: 40)
        XCTAssertEqual(output, expected)
    }
}
