"
Simple text input dialog
"
Class {
	#name : 'TextInputDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput',
		'acceptAction'
	],
	#category : 'ChatBuilder',
	#package : 'ChatBuilder'
}

{ #category : 'accessing' }
TextInputDialog >> acceptAction: aBlock [
    acceptAction := aBlock
]

{ #category : 'visiting' }
TextInputDialog >> acceptAndClose: dialogWindow [
    acceptAction value: textInput text.
    dialogWindow close
]

{ #category : 'actions' }
TextInputDialog >> cancel [
    self window close
]

{ #category : 'visiting' }
TextInputDialog >> defaultLayout [
    ^ SpBoxLayout newVertical
        add: textInput;
        yourself
]

{ #category : 'as yet unclassified' }
TextInputDialog >> initialText: aString [
    textInput text: aString
]

{ #category : 'initialization' }
TextInputDialog >> initialize [
    super initialize.
    self title: 'Input Dialog'
]

{ #category : 'initialization' }
TextInputDialog >> initializeDialogWindow: aDialogWindowPresenter [
    aDialogWindowPresenter
        initialExtent: 500@400;
        addButton: 'Save' do: [ :dialog | self acceptAndClose: dialog ];
        addButton: 'Cancel' do: [ :dialog | dialog close ]
]

{ #category : 'visiting' }
TextInputDialog >> initializePresenters [
    textInput := self newText.
    textInput text: ''.
    textInput withScrollBars
]

{ #category : 'showing' }
TextInputDialog >> open [
    ^ self openDialog
]

{ #category : 'accessing' }
TextInputDialog >> title: aString [
    self withWindowDo: [ :w | w title: aString ]
]
