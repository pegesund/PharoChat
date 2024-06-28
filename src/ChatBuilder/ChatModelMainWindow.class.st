"
Open main menu
"
Class {
	#name : 'ChatModelMainWindow',
	#superclass : 'SpPresenter',
	#instVars : [
		'openClassSelectorButton',
		'openUserConversationButton',
		'openSystemConversationButton',
		'sendConversationButton',
		'textInput'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'instance creation' }
ChatModelMainWindow class >> open [
    | app window |
    app := ChatModelApplication new.
    window := self new.
    window application: app.
    ^ window open
]

{ #category : 'initialization' }
ChatModelMainWindow >> defaultLayout [
    ^ SpBoxLayout newVertical
        add: openClassSelectorButton;
        add: openUserConversationButton;
        add: openSystemConversationButton;
        add: sendConversationButton;
        yourself
]

{ #category : 'initialization' }
ChatModelMainWindow >> initializePresenters [
    openClassSelectorButton := self newButton
        label: 'Open Class Selector';
        action: [ self openClassSelector ].
    
    openUserConversationButton := self newButton
        label: 'Open User Conversation';
        action: [ self openUserConversation ].
    
    openSystemConversationButton := self newButton
        label: 'Open System Conversation';
        action: [ self openSystemConversation ].
    
    sendConversationButton := self newButton
        label: 'Send Conversation';
        action: [ self sendConversation ].
]

{ #category : 'ui' }
ChatModelMainWindow >> openClassSelector [
    ChatMethodSelector open
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> openSystemConversation [
    self openTextDialog: 'Open System Conversation' initialText: self application systemConversation onAccept: [ :text | self application systemConversation: text ]
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> openTextDialog: title initialText: initialText onAccept: acceptBlock [
    | dialog |
    dialog := TextInputDialog new.
    dialog
        title: title;
        initialText: (initialText ifNil: ['']);
        acceptAction: acceptBlock.
    dialog open
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> openUserConversation [
    self openTextDialog: 'Open User Conversation' initialText: self application userConversation onAccept: [ :text | self application userConversation: text ]
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> sendConversation [
    self openTextDialog: 'Send Conversation' initialText: self application userConversation onAccept: [ :text | "Implement send logic here" ]
]

{ #category : 'accessing' }
ChatModelMainWindow >> title [
    ^ 'Chat Model Interface'
]
