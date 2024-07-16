"
I am a holder of multiple codeeditors with toolbars
"
Class {
	#name : 'MultiCodePresenterWithToolbars',
	#superclass : 'SpPresenter',
	#instVars : [
		'explanationEditor',
		'codeEditorPairs'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'adding' }
MultiCodePresenterWithToolbars >> addCodeEditorWithToolbar: isUpdate [

	| newEditor newToolbar pair statusLabel |
	newEditor := self instantiate: SpCodePresenter.
	newEditor beForScripting.
	statusLabel := self newLabel label: 'Ready'.
	newToolbar := self newToolbar
		              addItem: (SpToolbarButtonPresenter new
				               label: 'Compile';
				               icon: (self iconNamed: #smallSave);
				               help: 'Compile';
				               action: [ self saveEditor: newEditor ];
				               yourself);
		              addItem: (SpToolbarButtonPresenter new
				               label: 'Open';
				               icon: (self iconNamed: #openIcon);
				               help: 'Open';
				               action: [ self loadEditor: newEditor ];
				               yourself).

	isUpdate ifTrue: [
		newToolbar addItem: (SpToolbarButtonPresenter new
				 label: 'Diff';
				 icon: (self iconNamed: #openIcon);
				 help: 'Diff';
				 action: [  ];
				 yourself) ].
	newToolbar
		addItem: (SpToolbarButtonPresenter new
				 label: 'Status:';
				 help: 'Status';
				 yourself);
		addItem: (SpToolbarButtonPresenter new
				 label: 'Ready';
				 help: 'Current status';
				 yourself).
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

	explanationEditor := SpTextPresenter new
		                     text: 'Your large text block goes here...';
		                     beNotEditable;
		                     yourself
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

{ #category : 'initialization' }
MultiCodePresenterWithToolbars >> setExplanationText: text [

explanationEditor text: text.
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
    | mainLayout codeEditorsLayout contentLayout |
    codeEditorsLayout := SpBoxLayout newTopToBottom
        spacing: 0;
        yourself.
    codeEditorPairs do: [ :pair |
        codeEditorsLayout add: (SpBoxLayout newTopToBottom
            spacing: 0;
            add: pair first expand: false;
            add: pair second height: 150 
            yourself) ].
    
    contentLayout := SpBoxLayout newTopToBottom
        add: (SpScrollableLayout with: explanationEditor) height: 100;
        add: 'Code Editors' expand: false;
        add: codeEditorsLayout expand: true;
        yourself.
    
    mainLayout := SpScrollableLayout new
        child: contentLayout;
        yourself.
    
    self layout: mainLayout
]

{ #category : 'accessing' }
MultiCodePresenterWithToolbars >> updateStatusAt: index with: aString [
    | toolbar |
    toolbar := (codeEditorPairs at: index) first.
    (toolbar items at: 4) label: aString
]
