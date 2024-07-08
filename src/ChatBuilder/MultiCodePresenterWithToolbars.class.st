"
I am a holder of multiple codeeditors with toolbars
"
Class {
	#name : 'MultiCodePresenterWithToolbars',
	#superclass : 'SpPresenter',
	#instVars : [
		'codeEditorPairs'
	],
	#category : 'ChatBuilder',
	#package : 'ChatBuilder'
}

{ #category : 'adding' }
MultiCodePresenterWithToolbars >> addCodeEditorWithToolbar [
    | newEditor newToolbar pair |
    newEditor := self instantiate: SpCodePresenter.
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
        yourself.
    
    pair := {newToolbar. newEditor}.
    codeEditorPairs add: pair.
    self updateLayout.
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> codeEditorAt: index [
    ^ (codeEditorPairs at: index) second

]

{ #category : 'as yet unclassified' }
MultiCodePresenterWithToolbars >> createSeparator [
    ^ self newLabel
        label: '';
        color: Color green ;
        yourself
]

{ #category : 'initialization' }
MultiCodePresenterWithToolbars >> initializePresenters [
    super initializePresenters.
    
    codeEditorPairs := OrderedCollection new.
    self addCodeEditorWithToolbar.
    self addCodeEditorWithToolbar.
]

{ #category : 'as yet unclassified' }
MultiCodePresenterWithToolbars >> loadEditor: anEditor [
    "Implement load logic for the specific editor"
    self inform: 'Loading content for editor'
]

{ #category : 'as yet unclassified' }
MultiCodePresenterWithToolbars >> saveEditor: anEditor [
    "Implement save logic for the specific editor"
    self inform: 'Saving editor content: ', anEditor text
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
        spacing: 2;  "Reduced overall spacing"
        yourself.
    
    codeEditorPairs doWithIndex: [ :pair :index |
        scrollableLayout 
            add: (SpBoxLayout newTopToBottom
                spacing: 0;  "No spacing between toolbar and editor"
                add: pair first expand: false fill: false padding: 1;  "Minimal padding for toolbar"
                add: pair second;
                yourself).
        
        "Add a separator after each pair except the last one"
        index < codeEditorPairs size ifTrue: [
            scrollableLayout add: (self createSeparator) height: 1
        ].
    ].
    
    mainLayout := SpBoxLayout newTopToBottom
        spacing: 2;  "Reduced spacing"
        add: 'Code Editors' expand: false;
        add: (SpScrollableLayout new
            child: scrollableLayout;
            yourself);
        yourself.
    
    self layout: mainLayout.
]
