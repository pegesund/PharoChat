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
		'textInput',
		'userConversationDialog',
		'systemConversationDialog',
		'sendConversationDialog',
		'modelSelector',
		'chatMethodSelector'
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

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> getSelectedMethods [
    ^ self application savedMethods
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> getSelectedMethodsText [
    "This is a placeholder. Implement the actual logic to get selected methods"
    ^ 'Selected methods will be shown here'
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
    
    "Initialize dialog instances"
    userConversationDialog := nil.
    systemConversationDialog := nil.
    sendConversationDialog := nil.
]

{ #category : 'ui' }
ChatModelMainWindow >> openClassSelector [
    chatMethodSelector := ChatMethodSelector new.
    chatMethodSelector application: self application.
    chatMethodSelector open
]

{ #category : 'initialization' }
ChatModelMainWindow >> openSendConversationDialog [

	| presenter window selectedMethods |
	presenter := SpPresenter new.
	selectedMethods := self getSelectedMethods.

	presenter layout: (SpBoxLayout newVertical
			 spacing: 10;
			 add: 'System Conversation' expand: false;
			 add: (presenter newText
					  text: (self application systemConversation ifNil: [ '' ]);
					  enabled: false;
					  beNotEditable)
			 height: 200;
			 add: 'User Conversation' expand: false;
			 add: (presenter newText
					  text: (self application userConversation ifNil: [ '' ]);
					  enabled: false;
					  beNotEditable)
			 height: 200;
			 add: 'Selected Methods' expand: false;
			 add: (presenter newList
					  items: selectedMethods;
					  display: [ :method |
						  method
							  ifNil: [ 'No methods selected' ]
							  ifNotNil: [
								  method methodClass name , ' >> ' , method selector ] ];
					  enabled: false)
			 height: 200;
			 add: 'Select Model' expand: false;
			 add: (modelSelector := presenter newDropList
					                   items: #( 'chatgpt4' 'chatgpt3-turbo' );
					                   selectIndex: 1)
			 height: 30;
			 add: (presenter newButton
					  label: 'Send';
					  action: [ self sendConversationToModel ])
			 height: 40;
			 yourself).
 	

	window := presenter open.
	window title: 'Send to Model'.
	window initialExtent: 1000 @ 1000.

	^ presenter
]

{ #category : 'initialization' }
ChatModelMainWindow >> openSystemConversation [
    systemConversationDialog ifNotNil: [ :dialog | dialog window ifNotNil: #close ].
    systemConversationDialog := self openTextDialog: 'Open System Conversation' initialText: self application systemConversation onAccept: [ :text | self application systemConversation: text ]
]

{ #category : 'initialization' }
ChatModelMainWindow >> openTextDialog: title initialText: initialText onAccept: acceptBlock [
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
ChatModelMainWindow >> openUserConversation [
    userConversationDialog ifNotNil: [ :dialog | dialog window ifNotNil: #close ].
    userConversationDialog := self openTextDialog: 'Open User Conversation' initialText: self application userConversation onAccept: [ :text | self application userConversation: text ]
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> sendConversation [
	"initialization"

	sendConversationDialog ifNotNil: [ :dialog |
		dialog window ifNotNil: #close ].
	sendConversationDialog := self openSendConversationDialog.
	
	
]

{ #category : 'as yet unclassified' }
ChatModelMainWindow >> sendConversationToModel [
    | responseDialog |
    responseDialog := SpWindowPresenter new.
    responseDialog
        title: 'Model Response';
        initialExtent: 400@300;
        presenter: (SpPresenter new
            layout: (SpBoxLayout newVertical
                add: (self newText 
                    text: 'This is a dummy response from the model. Implement actual API call here.';
                    enabled: false) expand: true;
                yourself)).
    
    responseDialog open.
]
