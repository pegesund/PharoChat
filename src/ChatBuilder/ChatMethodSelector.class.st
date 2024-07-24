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
		'methodSelectButton',
		'classSelectButton',
		'packageSelectButton',
		'selectButtons',
		'completePane',
		'doneButton',
		'removeButton',
		'selectedAllTable'
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

	| leftSide rightSide downRight |
	selectButtons
		add: packageSelectButton;
		add: classSelectButton;
		add: methodSelectButton.

	methodSelectButton label: 'Add method'.
	classSelectButton label: 'Add class'.
	packageSelectButton label: 'Add package'.
	doneButton label: 'Done'.
	removeButton label: 'Remove'.

	downRight := (SpBoxLayout newHorizontal spacing: 5) add: removeButton ; add: doneButton ; yourself .

	leftSide := (SpBoxLayout newVertical spacing: 5)
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
				             add: selectButtons height: 40;
				             yourself);
		            yourself.

	rightSide := (SpBoxLayout newVertical spacing: 2)
		             add: selectedAllTable;
		             add: downRight height: 40;
		             yourself.

	completePane := (SpBoxLayout newHorizontal spacing: 2)
		                add: leftSide;
		                add: rightSide;
		                yourself.

	^ completePane
]

{ #category : 'initialization' }
ChatMethodSelector >> initializeAddButtons [

	packageSelectButton action: [
		| s |
		s := ChatSelectedSource new.
		s selectedPackageName: packageListPresenter selectedItem.
		self application addSelectedSource: s.
		self refreshSelectedItems ].

	classSelectButton action: [
		| s |
		s := ChatSelectedSource new.
		s selectedPackageName: packageListPresenter selectedItem.
		s selectedClassName: classListPresenter selectedItem.
		self application addSelectedSource: s.
		self refreshSelectedItems ].

	methodSelectButton action: [
		| s |
		s := ChatSelectedSource new.
		s selectedMethodName: methodListPresenter selectedItem.
		s selectedClassName: classListPresenter selectedItem.
		s selectedPackageName: packageListPresenter selectedItem.
		self application addSelectedSource: s.
		self refreshSelectedItems ].
	
   removeButton action:  [ 

	     "selectedAllTable selectedIndex "
	 ]
]

{ #category : 'initialization' }
ChatMethodSelector >> initializePresenters [

	methodSelectButton := self newButton.
	classSelectButton := self newButton.
	packageSelectButton := self newButton.
	

	doneButton := self newButton.
	removeButton := self newButton.

	selectButtons := SpBoxLayout newVertical spacing: 5.
	selectedAllTable := self newTable.

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
		add: methodSelectButton.
	self initializeAddButtons .		
	
]

{ #category : 'api' }
ChatMethodSelector >> packages: aList [

	packageListPresenter items = aList ifTrue: [ ^ self ].

	packageListPresenter items: aList
]

{ #category : 'ui' }
ChatMethodSelector >> refreshSelectedItems [

	| names |
	names := self application selectedSource collect: [ :item |
		         item name ].


	selectedAllTable items: names
]
