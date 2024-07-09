Class {
	#name : 'ChatCodeViewer',
	#superclass : 'SpPresenter',
	#instVars : [
		'button',
		'label',
		'textModel',
		'toolbar',
		'scrolledText',
		'codePresenter'
	],
	#category : 'ChatBuilder',
	#package : 'ChatBuilder'
}

{ #category : 'initialization' }
ChatCodeViewer >> initializePresenters [

	super initializePresenters.
	button := self newButton label: 'Click me'.
	label := self newLabel label: 'Hello, Pharo!'.
	textModel := RubScrolledTextModel new.
	textModel setText: 'MyClass >> myMethod
    ^ self doSomething'.

	codePresenter := self newCode
		                 beForScripting;
		                 text: 'OpenAi >> myMethod
    ^ self doSomething';
		                 yourself.
	codePresenter inspect.

	toolbar := self newToolbar
		           addItem: (SpToolbarButtonPresenter new
				            label: 'Format';
				            icon: (self iconNamed: #open);
				            action: [ codePresenter doBrowseClass ];
				            yourself);
		           addItem: (SpToolbarButtonPresenter new
				            label: 'Save';
				            icon: (self iconNamed: #save);
				            action: [  ];
				            yourself);
		           yourself
]

{ #category : 'accessing' }
ChatCodeViewer >> layout [


	^ SpBoxLayout newVertical
		  add: button;
		  add: label;

		  add: toolbar expand: false;
				  add: codePresenter;
		  yourself
]
