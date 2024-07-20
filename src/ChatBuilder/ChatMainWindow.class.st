"
Open main menu
"
Class {
	#name : 'ChatMainWindow',
	#superclass : 'SpPresenter',
	#instVars : [
		'openClassSelectorButton',
		'openUserConversationButton',
		'openSystemConversationButton',
		'sendConversationButton',
		'userConversationDialog',
		'systemConversationDialog',
		'chatMethodSelector'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'gui' }
ChatMainWindow class >> chatShowErrorMsg: msg [

| presenter window |

window := nil.

"Create a new subclass of SpPresenter"
presenter := SpPresenter new
    layout: (SpBoxLayout newTopToBottom
        spacing: 10;
        add: (SpMorphPresenter new
            morph: (Morph new
                color: (Color r: 1 g: 0.9 b: 0.9);
                addMorph: (StringMorph new
                    contents: msg;
                    yourself) asMorph;
                layoutPolicy: TableLayout new;
                listDirection: #center;
                listCentering: #center;
                vResizing: #spaceFill;
                hResizing: #spaceFill;
                yourself);
            yourself);
        add: (SpButtonPresenter new
            label: 'Close';
            action: [ window close ];
            yourself) expand: false;
        yourself);
    yourself.

"Create a new window and set its content"
window := presenter open.

"Set window properties"
window
    title: 'Errors in code';
    initialExtent: 250@120;
    centered.
]

{ #category : 'instance creation' }
ChatMainWindow class >> open [
    | app window |
    app := ChatApplication new.
    window := self new.
    window application: app.
    ^ window open
]

{ #category : 'layout' }
ChatMainWindow >> defaultLayout [
    ^ SpBoxLayout newVertical
        add: openClassSelectorButton;
        add: openUserConversationButton;
        add: openSystemConversationButton;
        add: sendConversationButton;
        yourself
]

{ #category : 'ui' }
ChatMainWindow >> getSelectedMethods [
    ^ self application savedMethods
]

{ #category : 'ui' }
ChatMainWindow >> getSelectedMethodsText [
    "This is a placeholder. Implement the actual logic to get selected methods"
    ^ 'Selected methods will be shown here'
]

{ #category : 'initialization' }
ChatMainWindow >> initializePresenters [
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
        action: [ self openSendConversationDialog ].
    
    "Initialize dialog instances"
    userConversationDialog := nil.
    systemConversationDialog := nil.
]

{ #category : 'ui' }
ChatMainWindow >> openClassSelector [
    chatMethodSelector := ChatMethodSelector new.
    chatMethodSelector application: self application.
    chatMethodSelector open
]

{ #category : 'ui' }
ChatMainWindow >> openSendConversationDialog [
    ^ SendToModelDialog openWithApplication: (self application)
]

{ #category : 'initialization' }
ChatMainWindow >> openSystemConversation [

	systemConversationDialog ifNotNil: [ :dialog |
		dialog window ifNotNil: #close ].
	systemConversationDialog := self
		                            openTextDialog:
		                            'Open System Conversation'
		                            initialText:
		                            self application systemConversation
		                            onAccept: [ :text |
		                            self application systemConversation:
			                            text ].
	systemConversationDialog title: 'Enter system text'
]

{ #category : 'initialization' }
ChatMainWindow >> openTextDialog: title initialText: initialText onAccept: acceptBlock [
    | dialog |
    dialog := TextInputDialog new.
    dialog
        title: title;
        initialText: (initialText ifNil: ['']);
        acceptAction: [ :text | 
            acceptBlock value: text.
            dialog := nil ].
    dialog open.
    ^ dialog
]

{ #category : 'initialization' }
ChatMainWindow >> openUserConversation [

	userConversationDialog ifNotNil: [ :dialog |
		dialog window ifNotNil: #close ].
	userConversationDialog := self
		                          openTextDialog: 'Open User Conversation'
		                          initialText:
		                          self application userConversation
		                          onAccept: [ :text |
		                          self application userConversation: text ].
	userConversationDialog title: 'Enter user conversation text'
]

{ #category : 'ui' }
ChatMainWindow >> sendConversationToModel: modelName [
    "Implement the logic to send the conversation to the selected model"
    self inform: 'Sending conversation to ', modelName.
]

{ #category : 'TOREMOVE' }
ChatMainWindow >> title [ 

 ^ 'Code generator'
]