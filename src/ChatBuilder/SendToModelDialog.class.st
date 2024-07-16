"
I am a class holding the dialog window which shows what to be sendt to chat and also the button for sending.
"
Class {
	#name : 'SendToModelDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'modelSelector',
		'selectedMethods'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'accessing' }
SendToModelDialog >> application: anApplication [
    application := anApplication.
    selectedMethods := application savedMethods .
]

{ #category : 'initialization' }
SendToModelDialog >> initialize [
    super initialize.
    self initializePresenters.
]

{ #category : 'initialization' }
SendToModelDialog >> initializePresenters [

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
			 add: (self newText
					  text: (application userConversation ifNil: [ '' ]);
					  enabled: false;
					  beNotEditable)
			 height: 200;
			 add: 'Selected Methods' expand: false;
			 add: (self newList
					  items: selectedMethods;
					  display: [ :method |
						  method
							  ifNil: [ 'No methods selected' ]
							  ifNotNil: [
								  method methodClass name , ' >> ' , method selector ] ];
					  enabled: false)
			 height: 200;
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
								self openCodeWindow: codeAsJson .
								 ])
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

	| codePresenter win methods theClasses i |
	codePresenter := MultiCodePresenterWithToolbars new.
	codePresenter setExplanationText:
		((codeAsJson at: 'source') at: 'explanation').

	i := 0.
	theClasses := (codeAsJson at: 'source') at: 'classes'.
	theClasses do: [ :each |
		i := i + 1.
		codePresenter addCodeEditorWithToolbar:
			(each at: 'createOrUpdate') = 'update'.
		codePresenter textAt: i put: (each at: 'source') ].

	methods := (codeAsJson at: 'source') at: 'methods'.
	methods do: [ :each |
		i := i + 1.
		codePresenter addCodeEditorWithToolbar:
			(each at: 'createOrUpdate') = 'update'.
		codePresenter textAt: i put: (each at: 'source') ].
	win := codePresenter open.
	win title: 'Suggested source code'.
	^ #ok
]
