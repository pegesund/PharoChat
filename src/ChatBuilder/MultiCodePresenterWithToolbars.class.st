"
I am a holder of multiple codeeditors with toolbars
"
Class {
	#name : 'MultiCodePresenterWithToolbars',
	#superclass : 'SpPresenter',
	#instVars : [
		'codeEditorPairs'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'adding' }
MultiCodePresenterWithToolbars >> addCodeEditorWithToolbar [
    | newEditor newToolbar pair statusLabel |
    newEditor := self instantiate: SpCodePresenter.
    statusLabel := self newLabel label: 'Ready'.
    newToolbar := self newToolbar
        addItem: (SpToolbarButtonPresenter new
            label: '';
            icon: (self iconNamed: #smallSave);
            help: 'Save';
            action: [ self saveEditor: newEditor ];
            yourself);
        addItem: (SpToolbarButtonPresenter new
            label: '';
            icon: (self iconNamed: #openIcon);
            help: 'Load';
            action: [ self loadEditor: newEditor ];
            yourself);
        addItem: (SpToolbarButtonPresenter new
            label: 'Status:';
            help: 'Status';
            yourself);
        addItem: (SpToolbarButtonPresenter new
            label: 'Ready';
            help: 'Current status';
            yourself);
        yourself.
    pair := {
        newToolbar.
        newEditor.
        statusLabel }.
    codeEditorPairs add: pair.
    self updateLayout
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> codeEditorAt: index [
    ^ (codeEditorPairs at: index) second

]

{ #category : 'TOREMOVE' }
MultiCodePresenterWithToolbars >> initialExtent [

	^ 1000 @ 600
]

{ #category : 'initialization' }
MultiCodePresenterWithToolbars >> initializePresenters [

	super initializePresenters.

	codeEditorPairs := OrderedCollection new.
	 
]

{ #category : 'as yet unclassified' }
MultiCodePresenterWithToolbars >> loadEditor: anEditor [
    | index |
    index := codeEditorPairs indexOf: (codeEditorPairs detect: [:pair | pair second == anEditor]) ifAbsent: [nil].
    index ifNotNil: [
        self updateStatusAt: index with: 'Loading...'.
        "Implement load logic for the specific editor"
        self inform: 'Loading content for editor'.
        self updateStatusAt: index with: 'Loaded'
    ] ifNil: [
        self inform: 'Editor not found'
    ]
]

{ #category : 'as yet unclassified' }
MultiCodePresenterWithToolbars >> saveEditor: anEditor [
    | index |
    index := codeEditorPairs indexOf: (codeEditorPairs detect: [:pair | pair second == anEditor]) ifAbsent: [nil].
    index ifNotNil: [
        self updateStatusAt: index with: 'Saving...'.
        "Implement save logic for the specific editor"
        self inform: 'Saving editor content: ' , anEditor text.
        self updateStatusAt: index with: 'Saved'
    ] ifNil: [
        self inform: 'Editor not found'
    ]
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> statusLabelAt: index [
    ^ (codeEditorPairs at: index) third
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> textAt: index [
    ^ (self codeEditorAt: index) text
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> textAt: index put: aString [
    (self codeEditorAt: index) text: aString
]

{ #category : 'private' }
MultiCodePresenterWithToolbars >> updateLayout [
    | mainLayout scrollableLayout |
    scrollableLayout := SpBoxLayout newTopToBottom
        spacing: 10;  "Spacing between editor pairs"
        yourself.
    
    codeEditorPairs do: [ :pair |
        scrollableLayout 
            add: (SpBoxLayout newTopToBottom
                spacing: 2;
                add: pair first expand: false;  "Toolbar"
                add: pair second height: 150;  "Set a fixed height for the editor"
                yourself).
    ].
    
    mainLayout := SpBoxLayout newTopToBottom
        spacing: 5;
        add: 'Code Editors' expand: false;
        add: (SpScrollableLayout new
            child: scrollableLayout;
            yourself) expand: true fill: true padding: 5;
        yourself.
    
    self layout: mainLayout.
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> updateStatusAt: index with: aString [
    | toolbar |
    toolbar := (codeEditorPairs at: index) first.
    (toolbar items at: 4) label: aString
]
