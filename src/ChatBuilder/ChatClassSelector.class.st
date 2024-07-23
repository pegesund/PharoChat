"
Petter was here
"
Class {
	#name : 'ChatClassSelector',
	#superclass : 'SpPresenter',
	#instVars : [
		'classList',
		'classSearchPresenter'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'layout' }
ChatClassSelector >> defaultLayout [
	"Define the layout of the GUI"

	| selectionClasses |
	selectionClasses := self application allAndSelectedClassess.

	classSearchPresenter
		sourceItems: selectionClasses second;
		defaultChosenItems: selectionClasses first.

	^ SpBoxLayout newVertical
		  add: classSearchPresenter;
		  add: (SpButtonPresenter new
				   label: 'Done';
				   action: [
					   self selectClasses.
					   self window close ];
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatClassSelector >> initializePresenters [
	"Initialize the presenters"

	super initializePresenters.
	classSearchPresenter := SpChooserPresenter new.

]

{ #category : 'state' }
ChatClassSelector >> selectClasses [
	"Action to handle the class selection button click event."

	classList := classSearchPresenter chosenItems.
	self application selectedClasses: classList
]
