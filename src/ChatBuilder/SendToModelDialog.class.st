"
I am a class holding the dialog window which shows what to be sendt to chat and also the button for sending.
"
Class {
	#name : 'SendToModelDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'modelSelector',
		'sendCode'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'initialize' }
SendToModelDialog class >> openWithApplication: anApplication [
    | dialog window |
    dialog := self newApplication: anApplication .
    window := dialog open.
    window title: 'Send to Model'.
    window initialExtent: 1000 @ 1000.
    ^ dialog
]

{ #category : 'accessing' }
SendToModelDialog >> application [
    ^ application
]

{ #category : 'initialization' }
SendToModelDialog >> initialize [

	super initialize.
	self initializePresenters
]

{ #category : 'initialization' }
SendToModelDialog >> initializePresenters [
	"Configure the dialog elements and make User Conversation clickable"

	self extent: 500 @ 800.
	self layout: (SpBoxLayout newVertical
			 spacing: 10;
			 add: 'System Conversation' expand: false;
			 add: (self newText
					  text: (application systemConversation ifNil: [ '' ]);
					  enabled: false;
					  beNotEditable)
			 height: 200;
			 add: 'User Conversation' expand: false;
			 add: ((self newText
					   text: application concatenateInfoForAPI;
					   enabled: false;
					   beNotEditable)
					  when: #mouseClick
					  send: #openUserConversationDialog
					  to: self)
			 height: 200;
			 add: 'Selected Methods' expand: false;
			 add: self newText height: 200;
			 add: 'Select Model' expand: false;
			 add: (modelSelector := self newDropList
					                   items:
						                   #( 'gpt-4o' 'gpt-3.5-turbo' 'gpt-4-turbo' );
					                   selectIndex: 1)
			 height: 30;
			 add: (self newButton
					  label: 'Send';
					  action: [
						  | codeAsJson |
						  codeAsJson := self application sendToChatModel:
								                modelSelector selectedItem.
						  [
						  self openCodeWindow: codeAsJson ]
							  on: Exception
							  do: [
								  | dialog |
								  codeAsJson inspect.
								  dialog := SpAlertDialog new.
								  dialog
									  title: 'Error in chat communcation';
									  label: 'Check inspect of result for debugging';
									  acceptLabel: 'Close';
									  openModal ] ])
			 height: 40;
			 yourself)
]

{ #category : 'initialization' }
SendToModelDialog >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 800 @ 900.

]

{ #category : 'codeUI' }
SendToModelDialog >> openCodeWindow: codeAsJson [
	"Opens window which suggested code changes from api"

	| codePresenter win methods theClasses i source cb |
	codeAsJson = #done ifTrue: [ ^ #done ].
	codePresenter := MultiCodePresenterWithToolbars new.
	i := 0.

	(codeAsJson includesKey: 'source')
		ifTrue: [
			source := codeAsJson at: 'source'.
			codePresenter setExplanationText: (source at: 'explanation').

			cb := ChatCodeBuilder new.
			cb application: application.
			cb setCurrentClasses.
			(source includesKey: 'classes') ifTrue: [
				theClasses := source at: 'classes'.
				theClasses do: [ :each |
					| classSource |
					i := i + 1.
					codePresenter addCodeEditorWithToolbar:
						(each at: 'createOrUpdate') = 'update'.
					classSource := cb transformIncomingClass: (each at: 'source').
					codePresenter textAt: i put: classSource ] ].

			(source includesKey: 'methods') ifTrue: [
				methods := source at: 'methods'.
				methods do: [ :each |
					| methodSource |
					i := i + 1.
					methodSource := cb transformIncomingMethod: (each at: 'source').
					codePresenter addCodeEditorWithToolbar:
						(each at: 'createOrUpdate') = 'update'.
					codePresenter textAt: i put: methodSource ] ] ]
		ifFalse: [
			codePresenter setExplanationText:
				((codeAsJson includesKey: 'result')
					 ifTrue: [ codeAsJson at: 'result' ]
					 ifFalse: [ 'No result from chatbot' ]) ].

	i = 0 ifTrue: [ codePresenter updateLayout ].
	win := codePresenter open.
	^ #ok
]

{ #category : 'codeUI' }
SendToModelDialog >> openUserConversationDialog [
	"Handle the user conversation text click event to open the 'Open User conversation' dialog."
	self application openUserConversation
]
