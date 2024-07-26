"
I am a transformer of the chat generated gode into a tmp-package and back again.
"
Class {
	#name : 'ChatCodeTransformer',
	#superclass : 'Object',
	#instVars : [
		'application',
		'suggestedElements'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'parsing' }
ChatCodeTransformer class >> extractClassNamesFromMethod: aMethodString [
    | classNames regex |
    classNames := Set new.
    
    "Regex to match potential class names"
    regex := '\b([A-Z]\w*)\b' asRegex.
    
    regex matchesIn: aMethodString do: [:each |
        "Ignore 'class' keyword"
        (each ~= 'class') ifTrue: [
            classNames add: each
        ]
    ].
    
    ^ classNames asArray sort
]

{ #category : 'parsing' }
ChatCodeTransformer class >> extractClassNamesFromMethodAST: aMethodString [

	| ast literals classNames |
	classNames := Set new.

	"Parse the method string into an AST"
	ast := RBParser parseMethod: aMethodString.

	"Get literals from the AST"
	literals := ast allChildren select: [ :node |
		            node isKindOf: RBVariableNode ].
	literals := literals select: [ :node |
		            Smalltalk globals hasClassNamed: node name ].

	literals do: [ :node | node name: 'Petters' ].
	^ ast formattedCode .
]

{ #category : 'accessing' }
ChatCodeTransformer >> application [

	^ application
]

{ #category : 'accessing' }
ChatCodeTransformer >> application: anObject [

	application := anObject
]

{ #category : 'transform' }
ChatCodeTransformer >> ensureCurrentTempPackage [
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

{ #category : 'transform' }
ChatCodeTransformer >> getAllMethodsAndClassesFromTempPackage: packageNameString [

	| package classes result |
	result := OrderedCollection new.
	package := self packageOrganizer 
		           packageNamed: packageNameString
		           ifAbsent: [ ^ result ].
	classes := package definedClasses asOrderedCollection.

	classes do: [ :class |
		result add: class.
		result addAll: class methodDict values.
		result addAll: class class methodDict values ].

	^ result
]

{ #category : 'initialization' }
ChatCodeTransformer >> initialize [

	super initialize.
	suggestedElements := OrderedCollection new.
	
]

{ #category : 'accessing' }
ChatCodeTransformer >> suggestedElements [

	^ suggestedElements
]

{ #category : 'accessing' }
ChatCodeTransformer >> suggestedElements: anObject [

	suggestedElements := anObject
]
