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
		'openPackageSelectorButton',
		'addSourceButton',
		'moveCodeToOrigButton',
		'urlButton'
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

{ #category : 'gui' }
ChatMainWindow class >> promptAndSetOpenAIAPIKey [
    | apiKey |
    apiKey := UIManager default 
        request: 'Enter your OpenAI API Key:'
        initialAnswer: ''
        title: 'OpenAI API Key'.
    
    apiKey ifNotNil: [
        apiKey ifNotEmpty: [
            ChatEnvironment setApiKey: apiKey.
            UIManager default inform: 'API Key has been set successfully.'
        ] ifEmpty: [
            UIManager default inform: 'API Key cannot be empty.'
        ]
    ]
]

{ #category : 'layout' }
ChatMainWindow >> defaultLayout [

	application mainWindow: self.

	^ SpBoxLayout newVertical
		  add: moveCodeToOrigButton;
		  add: addSourceButton;
		  add: openClassSelectorButton;
		  add: openUserConversationButton;
		  add: openSystemConversationButton;
		  add: urlButton ;
		  add: openPackageSelectorButton;
		  add: sendConversationButton;
		  yourself
]

{ #category : 'ui' }
ChatMainWindow >> getSelectedMethods [
    ^ self application savedMethods
]

{ #category : 'initialization' }
ChatMainWindow >> initialize [ 
   super initialize .
   application := ChatApplication new.
]

{ #category : 'initialization' }
ChatMainWindow >> initializePresenters [
	"Initialize the main window components and add a checkbox"

	super initializePresenters.

	addSourceButton := self newButton
		                   label: 'Add source';
		                   action: [
			                   | w |
			                   w := ChatMethodSelector new application:
					                        self application.
			                   w open.
			                   w refreshSelectedItems.
			                   w window resize: 1000 @ 600 ].

	openClassSelectorButton := self newButton
		                           label: 'Select Class';
		                           action: [ self openClassSelector ].

	openPackageSelectorButton := self newButton
		                             label: 'Open Package Selector';
		                             action: [ self openPackageSelector ].

	sendConversationButton := self newButton
		                          label: 'Send Conversation';
		                          action: [ self openSendConversationDialog ].
	urlButton := self newButton label: 'Add url'; action: [ self openUrls  ].	

	openUserConversationButton := self newButton
		                              label: 'Open User Conversation';
		                              action: [ self openUserConversation ].

	openSystemConversationButton := self newButton
		                                label: 'Open System Conversation';
		                                action: [
			                                self openSystemConversation ].


	moveCodeToOrigButton := self newButton
		                        label: 'Realize temporay package';
		                        action: [
			                        | dialog |
			                        dialog := SpConfirmDialog new.
			                        dialog
				                        title:
					                        'Will replace old classe in orig package';
				                        label: 'Are you sure?';
				                        acceptLabel: 'Sure!';
				                        cancelLabel: 'No, forget it';
				                        onAccept: [
					                        | ccb |
					                        ccb := ChatCodeBuilder new.
					                        ccb application: application.
					                        ccb transformOutgoingClasses ];
				                        onCancel: [ dialog inform: 'No!' ];
				                        openDialog ].


	"Initialize dialog instances"
	userConversationDialog := nil.
	systemConversationDialog := nil
]

{ #category : 'ui' }
ChatMainWindow >> openClassSelector [

	| dialog |
	dialog := ChatClassSelector new application: self application.
	dialog open.
	dialog window title: 'Select classes'
]

{ #category : 'ui' }
ChatMainWindow >> openPackageSelector [
	"Opens the new package selector dialog"
	ChatPackageSelector new
		          application: self application;
		          open
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

{ #category : 'ui' }
ChatMainWindow >> openUrls [

	| dialog |
	dialog := ChatScraper newApplication: application.
	dialog open.
	dialog window title: 'Add urls'.
	dialog window resize: 1000 @ 500.
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

{ #category : 'TOREMOVE' }
ChatMainWindow >> title [ 

 ^ 'Code generator'
]
