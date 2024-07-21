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
action: [ self chatCompileEditor: newEditor ];
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
icon: (self iconNamed: #diffIcon);  "Placeholder for the diff icon"
help: 'Diff';
action: [ self showGraphicalDiff: newEditor ];
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

pair := { newToolbar. newEditor. statusLabel }.
codeEditorPairs add: pair.
self updateLayout.
]

{ #category : 'compiling' }
MultiCodePresenterWithToolbars >> chatCompileEditor: anEditor [

	| index content compileRes |
	index := codeEditorPairs
		         indexOf:
		         (codeEditorPairs detect: [ :pair | pair second == anEditor ])
		         ifAbsent: [ nil ].
	content := anEditor text.
	compileRes := ChatBot chatCompileString: content.
	(compileRes = #ok) ifFalse: [ "show comilation errors"
		ChatMainWindow chatShowErrorMsg: compileRes ].
	index
		ifNotNil: [
			self updateStatusAt: index with: 'Compiling...'.
			"Implement save logic for the specific editor"
			self inform: 'Saving editor content: ' , anEditor text.
			self updateStatusAt: index with: (compileRes = #ok
					 ifTrue: [ 'Compiled' ]
					 ifFalse: [ 'Error' ]) ]
		ifNil: [ self inform: 'Editor not found' ]
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

{ #category : 'compiling' }
MultiCodePresenterWithToolbars >> loadEditor: anEditor [

	| content methodInfo signatureAsSymbol theClassName |
	content := anEditor text.
	(ChatBot chatDetectIfClassOrMethod: content)
		ifTrue: [
			theClassName := ChatBot chatExtractClassName: content.
			Smalltalk tools browser openOnClass:
				(self class environment at: (theClassName asSymbol)) ]
		ifFalse: [ "it is a method"
			methodInfo := ChatBot chatExtractMethodInfo: content.
			signatureAsSymbol := ChatBot chatStringToMethodSymbol:
				                     (methodInfo at: 'signature').
			ChatBot
				chatOpenBrowserOn: (methodInfo at: 'className')
				selector: signatureAsSymbol ]
]

{ #category : 'initialization' }
MultiCodePresenterWithToolbars >> setExplanationText: text [

explanationEditor text: text.
]

{ #category : 'UI' }
MultiCodePresenterWithToolbars >> showGraphicalDiff: anEditor [
	"Shows a graphical diff between the text in the editor and the current source"

	| content currentSource methodInfo signatureAsSymbol theClassName diffPresenter |
	content := anEditor text.
	"Check if content is a method or a class using ChatBot"
	currentSource := 'Not able to find currentSource..'.
	(ChatBot chatDetectIfClassOrMethod: content)
		ifTrue: [ "It is a class"
			theClassName := ChatBot chatExtractClassName: content.
			currentSource := (Smalltalk at: theClassName asSymbol)
				                 definitionString ]
		ifFalse: [ "It is a method"
			methodInfo := ChatBot chatExtractMethodInfo: content.

			signatureAsSymbol := ChatBot chatStringToMethodSymbol:
				                     (methodInfo at: 'signature').
			currentSource := (Smalltalk at:
				                  (methodInfo at: 'className') asSymbol)
				                 sourceCodeAt: signatureAsSymbol.

			currentSource := (RBParser parseMethod: currentSource)
				                 formattedCode.
			currentSource := (methodInfo at: 'className') , ' >> '
			                 , currentSource.

			[
			| sourceWithSingatureOnly |
			sourceWithSingatureOnly := (methodInfo at: 'signature') , String cr
			                           , (methodInfo at: 'source').
			sourceWithSingatureOnly inspect.
			content := (RBParser parseMethod: sourceWithSingatureOnly )
				           formattedCode ]
				on: Exception
				do: [ :e |
					ChatMainWindow chatShowErrorMsg: 'Suggested code is not parsable'. e signal ].
			content := (methodInfo at: 'className') , ' >> ' , content ].

	diffPresenter := SpDiffPresenter new.
	diffPresenter
		leftLabel: 'Current';
		leftText: currentSource;
		rightLabel: 'Suggestion';
		rightText: content.
	diffPresenter open.
	diffPresenter window
		title: 'Differences';
		resize: 1300 @ 500
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
