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
ChatCodeBuilder >> collectTemporaryClasses [

	| tempClasses stream currentPackage tempPackage |
	stream := WriteStream on: String new.
	currentPackage := application currentPackage.
	tempPackage := currentPackage , 'Temp'.
	tempClasses := tempPackage asPackage classes.
	tempClasses do: [ :c |
		| code |
		"add class info and class code"
		stream
			nextPutAll: c comment;
			cr.
		code := self removeTempFromFirstAndLastLine: c definitionString.
		stream
			nextPutAll: code;
			cr ].

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
