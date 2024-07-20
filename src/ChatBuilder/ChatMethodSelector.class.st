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
		'removeButton',
		'saveButton'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
ChatMethodSelector class >> findAllProjects [

	^ IceRepository registry collect: [:repo | repo name]
]

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
    ^ SpBoxLayout newVertical
        add: (SpBoxLayout newHorizontal
            add: packageList;
            add: classList;
            yourself);
        add: methodList;
        add: saveButton expand: false;
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

{ #category : 'gui' }
ChatMethodSelector >> forceUpdateRemoveButtonState [
    self updateRemoveButtonState.
    Transcript show: 'Force update remove button state'; cr.
]

{ #category : 'gui' }
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

{ #category : 'initialization' }
ChatMethodSelector >> initialize [
    super initialize.
    selectedMethods := OrderedCollection new
]

{ #category : 'initialization' }
ChatMethodSelector >> initializePresenters [
    packageList := self newList.
    classList := self newList.
    methodList := self newTable.
    saveButton := self newButton.
    
    packageList
        items: RPackageOrganizer default packages sorted;
        display: [ :package | package name ];
        whenSelectionChangedDo: [ :selection | 
            selection selectedItem 
                ifNotNil: [ :package | self updateClassesFor: package ] ].
    
    classList
        display: [ :class | class name ];
        whenSelectionChangedDo: [ :selection |
            selection selectedItem
                ifNotNil: [ :class | self updateMethodsFor: class ] ].
    
    methodList
        addColumn: (SpCheckBoxTableColumn new
            evaluated: [ :method | selectedMethods includes: method ];
            onActivation: [ :method | 
                selectedMethods add: method.
                self updateSaveButtonState ];
            onDeactivation: [ :method | 
                selectedMethods remove: method.
                self updateSaveButtonState ];
            width: 20);
        addColumn: (SpStringTableColumn new
            title: 'Method';
            evaluated: [ :method | method selector ];
            yourself);
        addColumn: (SpStringTableColumn new
            title: 'Class';
            evaluated: [ :method | method methodClass name ];
            yourself).
    
    saveButton
        label: 'Save Selected Methods';
        action: [ self saveSelectedMethods ];
        enabled: false.
    
    self updateSaveButtonState
]

{ #category : 'gui' }
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

{ #category : 'gui' }
ChatMethodSelector >> saveSelectedMethods [
    | app |
    app := self application.
    app savedMethods: self selectedMethods.
    self inform: 'Selected methods saved.'.
    self application.
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
    ^ selectedMethods ifNil: [ selectedMethods := OrderedCollection new ]
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

{ #category : 'gui' }
ChatMethodSelector >> updateMethodsFor: class [
    | changedMethods |
    changedMethods := self getChangedMethodsFor: class.
    methodList items: changedMethods.
    Transcript show: 'Updated methods for class: ', class name, '. Changed methods: ', changedMethods size asString; cr.
]

{ #category : 'gui' }
ChatMethodSelector >> updatePackageList [
    | filteredPackages |
    filteredPackages := self allPackages select: [ :package | 
        packageSearchInput text isEmpty or: [ 
            package name asLowercase includesSubstring: packageSearchInput text asLowercase ] ].
    packageList items: filteredPackages
]

{ #category : 'gui' }
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

{ #category : 'gui' }
ChatMethodSelector >> updateSaveButtonState [
    saveButton ifNotNil: [
        saveButton enabled: (selectedMethods notNil and: [selectedMethods notEmpty])
    ]
]

{ #category : 'gui' }
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
