"
I am a class which transforms code between the temporary and the current package.

While sending code to the chatbot I collect all code from temporary package and add, as well as selected code from the current package.
"
Class {
	#name : 'ChatCodeBuilder',
	#superclass : 'Object',
	#instVars : [
		'application'
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
			nextPutAll: ast formattedCode;
			cr ]
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
				nextPutAll: '"', c comment, '"';
				cr.
			stream
				nextPutAll: code;
				cr.		
			(c methods) ifNotEmpty: [ stream nextPutAll: 'Instance methods: '; cr ].					
			self collectMethodsFromTemporaryClass: c stream: stream.
			(c class methods) ifNotEmpty: [ stream nextPutAll: 'Instance methods: '; cr ].					
			self collectMethodsFromTemporaryClass: c class stream: stream ] ].
	^ stream contents
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
