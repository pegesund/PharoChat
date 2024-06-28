"
Select methods and classes from this gui compoment.
"
Class {
	#name : 'ChatMethodSelector',
	#superclass : 'SpPresenter',
	#instVars : [
		'packageList',
		'classList',
		'methodList',
		'selectedMethods',
		'selectedMethodsList',
		'repository',
		'packageSearchInput',
		'removeButton'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'instance creation' }
ChatMethodSelector class >> open [
    ^ self new open
]

{ #category : 'accessing' }
ChatMethodSelector >> allPackages [
    ^ RPackageOrganizer default packages sorted: [ :a :b | a name <= b name ]
]

{ #category : 'layout' }
ChatMethodSelector >> defaultLayout [
    ^ SpPanedLayout newHorizontal
        add: (SpPanedLayout newHorizontal
            add: (SpBoxLayout newVertical
                add: 'Packages' expand: false;
                add: packageSearchInput expand: false;
                add: packageList;
                add: 'Classes' expand: false;
                add: classList;
                yourself);
            add: (SpBoxLayout newVertical
                add: 'Changed Methods' expand: false;
                add: methodList;
                yourself);
            yourself);
        add: (SpBoxLayout newVertical
            add: 'Selected Methods' expand: false;
            add: selectedMethodsList;
            add: removeButton expand: false;
            yourself);
        yourself
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> deselectMethodInSelectedList: aMethod [
    | index |
    index := selectedMethodsList items indexOf: aMethod.
    index > 0 ifTrue: [
        selectedMethodsList unselectIndex: index.
        self updateRemoveButtonState.
        Transcript show: 'Deselected method in list: ', aMethod selector; cr ].
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> forceUpdateRemoveButtonState [
    self updateRemoveButtonState.
    Transcript show: 'Force update remove button state'; cr.
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> getChangedMethodsFor: class [
    | changedMethods currentMethods commitMethods |
    currentMethods := (class methods, class class methods) asSet.
    commitMethods := Set new.
    
    [((repository headCommit packageNamed: class package name)
        classNamed: class name) methods
        do: [:m | commitMethods add: m]]
    on: Error 
    do: [:e | "Ignore errors if the class or package doesn't exist in the commit"].
    
    changedMethods := OrderedCollection new.
    currentMethods do: [:method |
        (commitMethods anySatisfy: [:m | m selector = method selector]) 
            ifFalse: [changedMethods add: method]
            ifTrue: [(commitMethods detect: [:m | m selector = method selector]) sourceCode ~= method sourceCode
                ifTrue: [changedMethods add: method]]].
    commitMethods do: [:method |
        (currentMethods anySatisfy: [:m | m selector = method selector]) 
            ifFalse: [changedMethods add: method]].
    
    ^ changedMethods sorted: [:a :b | a selector <= b selector]
]

{ #category : 'accessing' }
ChatMethodSelector >> initialExtent [
    ^ 1000@600
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> initialize [
    super initialize.
    selectedMethods := Set new.
    repository := IceRepository registry detect: [ :repo | 
        repo includesPackageNamed: self class package name ]
]

{ #category : 'initialization' }
ChatMethodSelector >> initializePresenters [

	packageSearchInput := self newTextInput.
	packageList := self newList.
	classList := self newList.
	methodList := self newTable.
	selectedMethodsList := self newTable.
	removeButton := self newButton.
	selectedMethods := Set new.

	packageSearchInput
		placeholder: 'Search packages...';
		whenTextChangedDo: [ :text | self updatePackageList ].

	packageList
		items: self allPackages;
		display: [ :package | package name ];
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ :package |
					self updateClassesFor: package ] ].

	classList
		display: [ :class | class name ];
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ :class |
					self updateMethodsFor: class ] ].


	methodList
		addColumn: (SpCheckBoxTableColumn new
				 evaluated: [ :method | selectedMethods includes: method ];
				 onActivation: [ :method |
					 Transcript
						 show: 'Method activated: ' , method selector;
						 cr.
					 selectedMethods add: method.
					 self updateSelectedMethodsList ];
				 onDeactivation: [ :method |
					 Transcript
						 show: 'Method deactivated: ' , method selector;
						 cr.
					 selectedMethods remove: method.
					 self updateSelectedMethodsList ];
				 width: 20);
		addColumn: (SpStringTableColumn new
				 title: 'Method';
				 evaluated: [ :method | method selector ];
				 width: 200);
		addColumn: (SpStringTableColumn new
				 title: 'Type';
				 evaluated: [ :method |
					 method methodClass isMeta
						 ifTrue: [ 'Class' ]
						 ifFalse: [ 'Instance' ] ];
				 width: 100).
	selectedMethodsList
		addColumn: (SpCheckBoxTableColumn new
				 evaluated: [ :method | true ];
				 onActivation: [ :method | self updateRemoveButtonState ];
				 onDeactivation: [ :method | self updateRemoveButtonState ];
				 width: 20);
		addColumn: (SpStringTableColumn new
				 title: 'Method';
				 evaluated: [ :method |
					 method methodClass name , ' >> ' , method selector ];
				 yourself);
		whenSelectionChangedDo: [ :selection |
			Transcript
				show: 'Selection changed in selectedMethodsList';
				cr.
			self updateRemoveButtonState ].

	removeButton
		label: 'Remove Selected';
		action: [ self removeSelectedMethods ];
		enabled: false.

	self updatePackageList
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> removeSelectedMethods [
    | methodsToRemove currentClass |
    Transcript show: 'Remove button clicked'; cr.
    
    methodsToRemove := selectedMethodsList selection selectedItems.
    Transcript show: 'Methods to remove: ', methodsToRemove size asString; cr.
    
    selectedMethods removeAllFoundIn: methodsToRemove.
    Transcript show: 'Selected methods after removal: ', selectedMethods size asString; cr.
    
    self updateSelectedMethodsList.
    
    currentClass := classList selection selectedItem.
    currentClass ifNotNil: [
        self updateMethodsFor: currentClass.
        Transcript show: 'Updated Changed Methods list for class: ', currentClass name; cr. ].
    
    self updateRemoveButtonState.
    
    Transcript show: 'Remove operation completed'; cr.
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> selectMethodInSelectedList: aMethod [
    | index |
    index := selectedMethodsList items indexOf: aMethod.
    index > 0 ifTrue: [
        selectedMethodsList selectIndex: index.
        Transcript show: 'Selected method in list: ', aMethod selector, ' at index: ', index asString; cr.
        self updateRemoveButtonState ].
]

{ #category : 'accessing' }
ChatMethodSelector >> selectedMethods [
    ^ selectedMethods
]

{ #category : 'TOREMOVE' }
ChatMethodSelector >> title [
    ^ 'Method Selector'
]

{ #category : 'initialization' }
ChatMethodSelector >> updateClassesFor: package [
    classList items: (package definedClasses sorted: [ :a :b | a name <= b name ])
]

{ #category : 'updating - presenters' }
ChatMethodSelector >> updateMethodList [
    | currentClass |
    currentClass := classList selection selectedItem.
    currentClass ifNotNil: [ 
        self updateMethodsFor: currentClass.
        Transcript show: 'Updated Changed Methods list'; cr. ]
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> updateMethodsFor: class [
    | changedMethods |
    changedMethods := self getChangedMethodsFor: class.
    methodList items: changedMethods.
    Transcript show: 'Updated methods for class: ', class name, '. Changed methods: ', changedMethods size asString; cr.
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> updatePackageList [
    | filteredPackages |
    filteredPackages := self allPackages select: [ :package | 
        packageSearchInput text isEmpty or: [ 
            package name asLowercase includesSubstring: packageSearchInput text asLowercase ] ].
    packageList items: filteredPackages
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> updateRemoveButtonState [
    | isEnabled selectedIndexes |
    selectedIndexes := selectedMethodsList selection selectedIndexes.
    isEnabled := selectedIndexes notEmpty.
    removeButton enabled: isEnabled.
    Transcript 
        show: 'Remove button enabled: ', isEnabled asString; 
        show: ' Selected indexes: ', selectedIndexes asString;
        show: ' Selected items: ', selectedMethodsList selection selectedItems size asString;
        show: ' Total items: ', selectedMethodsList items size asString;
        cr.
]

{ #category : 'as yet unclassified' }
ChatMethodSelector >> updateSelectedMethodsList [
    | newItems |
    Transcript show: 'Updating selected methods list. Current size: ', selectedMethods size asString; cr.
    
    newItems := selectedMethods asOrderedCollection.
    selectedMethodsList items: newItems.
    
    Transcript show: 'New list size: ', selectedMethodsList items size asString; cr.
    
    newItems doWithIndex: [ :method :index |
        selectedMethodsList selectIndex: index ].
    
    Transcript show: 'New selection: ', selectedMethodsList selection selectedIndexes asString; cr.
    
    self updateRemoveButtonState.
    
    Transcript show: 'Selected methods list updated'; cr.
]
