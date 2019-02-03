//
//  MentionControllerImpl.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2018 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class MentionControllerImpl: MentionController {
    
    private(set) var mentions: [Mention] = []
    
    var filterHandler: ((MentionInputFilter) -> Void)?
    var textUpdateHandler: ((String, [Mention]) -> Void)?
    var cursorUpdateHandler: ((Int) -> Void)?
    
    private var lastInputText: String?
    private var lastCursorPosition: Int?
    
    func setup(_ initialMentions: [Mention]) {
        reset()
        mentions = initialMentions
    }
    
    func reset() {
        lastInputText = nil
        lastCursorPosition = nil
        mentions.removeAll()
    }
    
    func hasMentions(in range: NSRange) -> Bool {
        let range = range.nativeRange
        return mentions.contains { $0.indices.intersects(range) }
    }
    
    
    // MARK: - Utils
    
    private func save(text: String, cursorPosition: Int?) {
        lastInputText = text
        lastCursorPosition = cursorPosition
    }
    
    private func handleUpdate(text: String, cursor: Int) {
        textUpdateHandler?(text, mentions)
        cursorUpdateHandler?(cursor)
    }
    
    private func startIndexOfMention(in text: String, cursorIndex: String.Index) -> String.Index? {
        return text
            .prefix(upTo: cursorIndex)
            .lastIndex(where: { $0 == "@" })
    }
    
    private func cursorIndex(for cursorPosition: Int, in text: String) -> String.Index {
        let cursorIndex = String.Index(encodedOffset: cursorPosition)
        
        if cursorIndex > text.startIndex {
            if cursorIndex < text.endIndex {
                return cursorIndex
            } else {
                return text.endIndex
            }
        } else {
            return text.startIndex
        }
    }
}

// MARK: - Text Input
extension MentionControllerImpl {
    
    func handleInputText(_ text: String, cursorPosition: Int) {
        defer { save(text: text, cursorPosition: cursorPosition) }
        
        if text.isEmpty {
            mentions.removeAll()
        }
        let cursorIndex = self.cursorIndex(for: cursorPosition, in: text)
        let canActivateFilter = cursorIndex == text.endIndex || text[cursorIndex] == " "
        
        guard canActivateFilter, let startIndex = startIndexOfMention(in: text, cursorIndex: cursorIndex) else {
            filterHandler?(.none)
            return
        }
        if startIndex != text.startIndex {
            // Must be a whitespace before '@'.
            guard case let previousIndex = text.index(before: startIndex), text[previousIndex] == " " else {
                filterHandler?(.none)
                return
            }
        }
        guard case let filter = text[text.index(after: startIndex)..<cursorIndex], !filter.isEmpty else {
            filterHandler?(.all)
            return
        }
        guard filter.split(separator: " ").count == 1 else {
            // If have a whitespace between '@' symbol and cursor position - don't handle it as a mention.
            filterHandler?(.none)
            return
        }
        filterHandler?(filter.isEmpty ? .all : .filter(String(filter)))
    }
    
    func handleReplacementText(_ replacementText: String, in replacementRange: NSRange, currentText: String) -> Bool {
        var mentionsToRemove: [Mention] = []
        let range = replacementRange.nativeRange
        
        for mention in mentions {
            
            if shouldRemove(mention, replacementText: replacementText, range: range, text: currentText) {
                mentionsToRemove.append(mention)
                
            } else if mention.indices.lowerBound >= range.lowerBound {
                let offset = replacementText.utf16.count - range.count
                mention.indices.shift(by: offset)
            }
        }
        mentions.removeAll { mention in mentionsToRemove.contains { $0 === mention } }

        let isAlongsideAfterMention = mentions.contains { $0.indices.upperBound == replacementRange.upperBound }
        
        guard !mentionsToRemove.isEmpty || isAlongsideAfterMention else {
            return true
        }
        replace(replacementText, in: replacementRange, currentText: currentText)
        
        return false
    }
    
    /*
     Mention should start:
     - from start of the text: '@alias ...'
     - after ' ': '... @alias ...'
     
     Mention should end:
     - at the end of the text: '... @alias'
     - before ' ': '@alias ...'
     */
    private func shouldRemove(_ mention: Mention, replacementText: String, range: Range<Int>, text: String) -> Bool {
        if mention.indices.isAlongside(before: range) {
            if replacementText.isEmpty {
                let nextIndex = String.Index(encodedOffset: range.upperBound)
                if nextIndex != text.endIndex, text[nextIndex] != " " {
                    return true
                }
            } else if !replacementText.starts(with: " ") {
                return true
            }
            
        } else if mention.indices.isAlongside(after: range) {
            if replacementText.isEmpty {
                let replacementIndex = String.Index(encodedOffset: range.lowerBound)
                let previousIndex = range.lowerBound > 0 ? text.index(before: replacementIndex) : replacementIndex
                
                if replacementIndex != text.startIndex, text[previousIndex] != " " {
                    return true
                }
            } else if !replacementText.ends(with: " ") {
                return true
            }
            
        } else if mention.indices.overlaps(range) || (range.isEmpty && mention.indices.contains(range.lowerBound)) {
            return true
        }
        
        return false
    }
    
    /// Manually replace text in output handler
    private func replace(_ replacementText: String, in replacementRange: NSRange, currentText text: String) {
        let updatedText = (text as NSString).replacingCharacters(in: replacementRange, with: replacementText) as String
        
        let newCursorPosition: Int
        if replacementRange.length > replacementText.utf16.count {
            // delete or replace
            newCursorPosition = replacementRange.upperBound - (replacementRange.length - replacementText.utf16.count)
        } else {
            // insert
            newCursorPosition = replacementRange.upperBound + (replacementText.utf16.count - replacementRange.length)
        }
        save(text: updatedText, cursorPosition: newCursorPosition)
        handleUpdate(text: updatedText, cursor: newCursorPosition)
    }
}

// MARK: - Insertion
extension MentionControllerImpl {
    
    func addMention(for member: Member) {
        guard let params = constructMentionParameters(for: member) else {
            return
        }
        let inputAlias = "@\(params.alias)"
        let insertionString = "\(inputAlias) "
        let cursorRange = params.startIndex..<params.cursorIndex
        
        var result = params.text
        result.removeSubrange(cursorRange)
        result.insert(contentsOf: insertionString, at: params.startIndex)
        
        let offset = insertionString.utf16.count - cursorRange.utf16Encoded.count
        shiftExistingMentions(by: offset, after: params.startIndex.encodedOffset)
        
        let mentionRange = params.startIndex..<result.index(params.startIndex, offsetBy: inputAlias.count)
        let mention = Mention(indices: mentionRange.utf16Encoded,
                              memberId: params.memberId,
                              accountId: params.accountId,
                              alias: params.alias)
        
        if !mentions.contains(where: { $0.indices.intersects(mention.indices) }) {
            mentions.append(mention)
        }
        
        filterHandler?(.none)
        
        // Move cursor after inserted '@alias '
        let nextCursorPosition = mentionRange.upperBound.encodedOffset + 1
        handleUpdate(text: result, cursor: nextCursorPosition)
    }
    
    private struct MentionConstructParams {
        let memberId: Int64
        let accountId: String
        let alias: String
        let text: String
        let startIndex: String.Index
        let cursorIndex: String.Index
    }
    
    private func constructMentionParameters(for member: Member) -> MentionConstructParams? {
        let memberId = member.id
        let accountId = member.accountId
        let alias = member.alias
        
        guard let text = lastInputText,
            let cursorPosition = lastCursorPosition,
            case let cursorIndex = String.Index(encodedOffset: cursorPosition),
            let startIndex = startIndexOfMention(in: text, cursorIndex: cursorIndex) else {
            return nil
        }

        return MentionConstructParams(
            memberId: memberId,
            accountId: accountId,
            alias: alias,
            text: text,
            startIndex: startIndex,
            cursorIndex: cursorIndex
        )
    }
    
    private func shiftExistingMentions(by offset: Int, after position: Int) {
        for mention in mentions {
            guard mention.indices.lowerBound > position else {
                continue
            }
            mention.indices.shift(by: offset)
        }
    }
}
