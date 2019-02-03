//
//  MentionController.swift
//  Components
//
//  Created by Anton Poltoratskyi on 03.02.2019.
//  Copyright © 2019 Anton Poltoratskyi. All rights reserved.
//

struct Member {
    let id: Int64
    let accountId: String
    let alias: String
}

enum MentionInputFilter {
    case none
    case all
    case filter(String)
}

protocol MentionController: class {
    var mentions: [Mention] { get }
    
    var filterHandler: ((MentionInputFilter) -> Void)? { get set }
    var textUpdateHandler: ((String, [Mention]) -> Void)? { get set }
    var cursorUpdateHandler: ((Int) -> Void)? { get set }
    
    func setup(_ initialMentions: [Mention])
    
    func reset()
    
    func hasMentions(in range: NSRange) -> Bool
    
    func addMention(for member: Member)
    
    /// Handler for textViewDidChange(_:) and textViewDidChangeSelection(_:)
    func handleInputText(_ text: String, cursorPosition: Int)
    
    /// Handler for textView(_:shouldChangeTextIn:replacementText:)
    func handleReplacementText(_ replacementText: String, in range: NSRange, currentText: String) -> Bool
}
