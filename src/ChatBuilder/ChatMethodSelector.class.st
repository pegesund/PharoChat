"
Gui to select methods
"
Class {
	#name : 'ChatMethodSelector',
	#superclass : 'SpPresenter',
	#instVars : [
		'methodListPresenter',
		'textPresenter',
		'classListPresenter',
		'packageListPresenter',
		'methodSelectButton'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'specs' }
ChatMethodSelector class >> title [
 ^ 'Select methods'
]

{ #category : 'api' }
ChatMethodSelector >> classes: aList [
	classListPresenter items = aList ifTrue: [ ^ self ].

	classListPresenter
		items: aList
]

{ #category : 'initialization' }
ChatMethodSelector >> connectPresenters [

	packageListPresenter
		transmitTo: classListPresenter
		transform: [ :package |
			package
				ifNil: [ #(  ) ]
				ifNotNil: [ package asPackage definedClasses asOrderedCollection ] ]
		postTransmission: [ :destination | destination selectIndex: 1 ].

	classListPresenter
		transmitTo: methodListPresenter
		transform: [ :class |
			class
				ifNil: [ #(  ) ]
				ifNotNil: [ class methods sort: #selector descending ] ]
		postTransmission: [ :destination | destination selectIndex: 1 ].

	methodListPresenter
		transmitTo: textPresenter
		transform: [ :method | method ifNil: [ '' ] ifNotNil: #sourceCode ]
		postTransmission: [ :destination :origin :transmited |
			transmited ifNotNil: [ destination beForMethod: transmited ] ]
]

{ #category : 'layout' }
ChatMethodSelector >> defaultLayout [


	methodSelectButton label: 'Add method'.
	^ (SpBoxLayout newVertical spacing: 5)
		  add: (SpBoxLayout newVertical
				   spacing: 5;
				   add: packageListPresenter;
				   yourself);
		  add: (SpPanedLayout newLeftToRight
				   add: classListPresenter;
				   add: methodListPresenter;
				   yourself);
		  add: (SpBoxLayout newHorizontal
				   spacing: 5;
				   add: textPresenter;
				   add: methodSelectButton height: 40;
				   yourself);
		  yourself.

]

{ #category : 'initialization' }
ChatMethodSelector >> initializePresenters [

	methodSelectButton := self newButton.
	packageListPresenter := self newFilteringList.
	self packages:
		((self packageOrganizer packages sorted: [ :a :b | a name <= b name ])
			 collect: [ :i | i name ]).
	classListPresenter := self newList.
	methodListPresenter := self newList.
	textPresenter := self newCode.
	textPresenter whenSubmitDo: [ :text |
		self systemNavigation inspect: methodListPresenter selectedItem ].
	methodListPresenter display: #selector.
	self focusOrder
		add: packageListPresenter;
		add: classListPresenter;
		add: methodListPresenter;
		add: textPresenter;
		add: methodSelectButton
]

{ #category : 'api' }
ChatMethodSelector >> packages: aList [

	packageListPresenter items = aList ifTrue: [ ^ self ].

	packageListPresenter items: aList
]
