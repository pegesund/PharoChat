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
	#category : 'ChatBuilder',
	#package : 'ChatBuilder'
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

{ #category : 'as yet unclassified' }
SendToModelDialog >> endConversationToModel [
    self application sendConversationToModel: modelSelector selectedItem.
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
            items: #( 'chatgpt4' 'chatgpt3-turbo' );
            selectIndex: 1)
        height: 30;
        add: (self newButton
            label: 'Send';
            action: [ self sendConversationToModel ])
        height: 40;
        yourself).
]

{ #category : 'initialization' }
SendToModelDialog >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 800 @ 900.

]
