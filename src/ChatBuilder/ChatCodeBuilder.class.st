"
I am a class which transforms code between the temporary and the current package.

While sending code to the chatbot I collect all code from temporary package and add, as well as selected code from the current package.
"
Class {
	#name : 'ChatCodeBuilder',
	#superclass : 'Object',
	#instVars : [
		'application',
		'exportedClasses',
		'classesInTempPackage',
		'classesInOrigPackage'
	],
	#category : 'ChatBuilder-code',
	#package : 'ChatBuilder',
	#tag : 'code'
}

{ #category : 'initialization' }
ChatCodeBuilder >> application: app [

application := app.
self ensureCurrentTempPackage .
self setCurrentClasses .

]

{ #category : 'selectedSource' }
ChatCodeBuilder >> collectAllCode [

	| stream |
	stream := WriteStream on: String new.
	"Collect code from temp package"
	self collectTemporaryClasses: stream.

	"Collect code from origial package"
	application selectedSource do: [ :s |
		s selectedMethodName isNil & s selectedClassName isNil
			ifTrue: [ "It is a package"
				self collectPlainPackage: (s selectedPackageName asPackage) stream: stream ]
			ifFalse: [
				s selectedMethodName
					ifNil: [ "It is a class"
						self collectPlainClass: s selectedClassName stream: stream ]
					ifNotNil: [ "It is a method"
						self collectPlainMethod: s selectedMethodName stream: stream ] ] ].
			(stream contents) inspect.

	^ stream contents
]

{ #category : 'private' }
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

{ #category : 'private' }
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

{ #category : 'private' }
ChatCodeBuilder >> collectPlainMethod: method stream: stream [
		(exportedClasses includes: (method methodClass name)) ifTrue: [ ^ #allreadyExists ].
	stream
		nextPutAll: method methodClass asString;
		nextPutAll: ' >> ';
		nextPutAll: method sourceCode;
		cr
]

{ #category : 'private' }
ChatCodeBuilder >> collectPlainPackage: aPackage stream: stream [
	aPackage classes do: [ :c | self collectPlainClass: c stream: stream ].
]

{ #category : 'private' }
ChatCodeBuilder >> collectTemporaryClasses: stream [

	| tempClasses currentPackage tempPackage |
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
	^ #ok.
]

{ #category : 'copying' }
ChatCodeBuilder >> copyClassesFromOrigToTemp [

	| className tempClass tempPackage allChangeClasses |
	tempPackage := (application currentPackage , 'Temp') asPackage.
	application selectedClasses do: [ :c |
		className := c , 'Temp'.
		tempClass := self class environment at: className ifAbsent: [
			             | newClass |
			             newClass := (self class environment at: c)
				                         duplicateClassWithNewName:
				                         className asSymbol.
			             (self class environment at: className) package:
				             tempPackage ] ].
	"Fix methods so they point to copied classes"
	allChangeClasses := application selectedClasses asSet.
	tempPackage classes do: [ :c |
		c methods do: [ :m |
			| ast literals iisUpdated |
			"Iterate all methods and make sure it point to temp class"
			ast := m parseTree.
			iisUpdated := false.
			literals := ast allChildren select: [ :node |
				            node isKindOf: RBVariableNode ].
			literals do: [ :node |
				(allChangeClasses includes: node name) ifTrue: [
					node name: node name , 'Temp'.
					iisUpdated := true ]].
			iisUpdated ifTrue: [
				
				(m isClassSide ifTrue: [ c classSide  ] ifFalse: [ c instanceSide ]) 
				 compile: ast formattedCode ] ] ]
]

{ #category : 'transform' }
ChatCodeBuilder >> ensureCurrentTempPackage [
	"Creates temporary package if needed!!"

	| organizer basePackage testPackage packageNameString |
	packageNameString := application currentPackage , 'Temp'.
	organizer := self packageOrganizer .

	"Create base package if it doesn't exist"
	basePackage := organizer
		               packageNamed: packageNameString
		               ifAbsent: [ organizer addPackage: packageNameString ].

	"Create test package if it doesn't exist"
	testPackage := organizer
		               packageNamed: packageNameString , '-Tests'
		               ifAbsent: [
		               organizer addPackage: packageNameString , '-Tests' ].

	^ Array with: basePackage with: testPackage
]

{ #category : 'initialization' }
ChatCodeBuilder >> initialize [

	super initialize.

	"Keeps track of exported class, contains class names as strings"
	exportedClasses := Set new
]

{ #category : 'private' }
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

{ #category : 'initialization' }
ChatCodeBuilder >> setCurrentClasses [

	classesInTempPackage := application currentPackage asPackage classes.
	classesInOrigPackage := (application currentPackage
	                        , 'Temp') asPackage classes
]

{ #category : 'incomingSource' }
ChatCodeBuilder >> transformIncomingClass: classStr [
	"Make sure class does not reference classes in original package, unless non existent in temp package. New classes should be created in the temp package"

	| def cName |
	def := CDFluidClassDefinitionParser parse: classStr.
	cName := def className.
	"Class allready exist in orig"
	(classesInOrigPackage includes: cName)
	& (classesInTempPackage includes: cName , 'Temp') not ifTrue: [
		^ 'Error, tries to redfine this class:' , classStr ].
	^ classStr
]
