"
I am a class which transforms code between the temporary and the current package.

While sending code to the chatbot I collect all code from temporary package and add, as well as selected code from the current package.
"
Class {
	#name : 'ChatCodeBuilder',
	#superclass : 'Object',
	#instVars : [
		'application',
		'exportedClasses'
	],
	#category : 'ChatBuilder-code',
	#package : 'ChatBuilder',
	#tag : 'code'
}

{ #category : 'initialization' }
ChatCodeBuilder >> application: app [

application := app.
]

{ #category : 'tempCollector' }
ChatCodeBuilder >> collectMethodsFromTemporaryClass: c stream: stream [
	"Iterates over methods in temporary package. Any method having references to the temp-objects will be changed before sending to the chatbot"

	| ast literals |
	c methods do: [ :m | "Parse the method string into an AST"
		ast := RBParser parseMethod: m asString.
		"Get literals from the AST"
		literals := ast allChildren select: [ :node |
			            node isKindOf: RBVariableNode ].
		literals := literals select: [ :node |
			            Smalltalk globals hasClassNamed: node name ].
		literals do: [ :node |
			(node name endsWith: 'Temp') ifTrue: [
				node name: (node name copyReplaceAll: 'Temp' with: '') ] ].
		stream
			nextPutAll: (m methodClass asString copyReplaceAll: 'Temp' with: '');
			nextPutAll: ' >> ';
			nextPutAll: ast formattedCode;
			cr ]
]

{ #category : 'selectedSource' }
ChatCodeBuilder >> collectPlainClass: theClass stream: stream [

	| code |
	(exportedClasses includes: theClass name) ifTrue: [ ^ #allreadyExists ].
	code := theClass definitionString.
	stream
		nextPutAll: '"' , theClass comment , '"';
		cr.
	stream
		nextPutAll: code;
		cr.
	theClass methods do: [ :m |
		self collectPlainMethod: m stream: stream ]
]

{ #category : 'selectedSource' }
ChatCodeBuilder >> collectPlainMethod: method stream: stream [
		(exportedClasses includes: (method methodClass name)) ifTrue: [ ^ #allreadyExists ].
	stream
		nextPutAll: method methodClass asString;
		nextPutAll: ' >> ';
		nextPutAll: method sourceCode;
		cr
]

{ #category : 'selectedSource' }
ChatCodeBuilder >> collectPlainPackage: aPackage stream: stream [
	aPackage classes do: [ :c | self collectPlainClass: c stream: stream ].
]

{ #category : 'tempCollector' }
ChatCodeBuilder >> collectTemporaryClasses [

	| tempClasses stream currentPackage tempPackage |
	stream := WriteStream on: String new.
	currentPackage := application currentPackage.
	tempPackage := currentPackage , 'Temp'.
	tempClasses := tempPackage asPackage classes.
	tempClasses do: [ :c |
		| code |
		"add class info and class code"
		code := self removeTempFromFirstAndLastLine: c definitionString.
		(code includesSubstring: 'Manifest') ifFalse: [
			stream
				nextPutAll: '"' , c comment , '"';
				cr.
			stream
				nextPutAll: code;
				cr.
			exportedClasses add: (c name copyReplaceAll: 'Temp' with: '').	
			self collectMethodsFromTemporaryClass: c stream: stream.
			self collectMethodsFromTemporaryClass: c class stream: stream ] ].
	^ stream contents
]

{ #category : 'initialization' }
ChatCodeBuilder >> initialize [

	super initialize.

	"Keeps track of exported class, contains class names as strings"
	exportedClasses := Set new
]

{ #category : 'removing' }
ChatCodeBuilder >> removeTempFromFirstAndLastLine: inputString [
    | lines |
    lines := inputString lines.
    
    lines ifNotEmpty: [
        "Process first line"
        lines at: 1 put: ((lines first) copyReplaceAll: 'Temp' with: '').
        
        "Process last line"
        lines size > 1 ifTrue: [
            lines at: lines size put: ((lines last) copyReplaceAll: 'Temp' with: '')
        ]
    ].
    
    ^ String cr join: lines
]
