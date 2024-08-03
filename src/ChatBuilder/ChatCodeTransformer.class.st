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

{ #category : 'nil' }
ChatCodeTransformer class >> addSlot: slotName to: aClass [
    | newSlots builder |
    newSlots := aClass slots copyWith: (InstanceVariableSlot named: slotName).
    builder := ShiftClassBuilder new
        name: aClass name;
        superclass: aClass superclass;
        slots: newSlots;
        sharedVariables: aClass classVariables;
        sharedPools: aClass sharedPools;
        category: aClass category;
        environment: aClass environment.
    builder build.
  
	 builder install.
    ^ SystemAnnouncer uniqueInstance classDefinitionChangedFrom: (builder oldClass) to: (builder newClass).
 
]

{ #category : 'refactoring' }
ChatCodeTransformer class >> chatMoveClass: className from: sourcePackageName to: destinationPackageName [
	"Move a class from one package to another.
    className, sourcePackageName, and destinationPackageName should be strings."

	| class sourcePackage destPackage |
	sourcePackage := sourcePackageName asPackage.
	destPackage := destinationPackageName asPackage.

	class := className asClassInEnvironment: self class environment.
	class package == sourcePackage ifFalse: [
		^ self error: 'Class not found in source package' ].

	class package: destPackage.
	"Smalltalk organization classify: class name under: destinationPackageName."

	"Optionally, you can add a save here:"
	"Smalltalk snapshot: true andQuit: false."

	^ class "Return the moved class"
]

{ #category : 'as yet unclassified' }
ChatCodeTransformer class >> deleteSlot: slotName from: aClass [

	| newSlots builder |
	newSlots := aClass slots reject: [ :slot |
		            slot name = slotName asSymbol ].
	builder := ShiftClassBuilder new
		           name: aClass name;
		           superclass: aClass superclass;
		           slots: newSlots;
		           sharedVariables: aClass classVariables;
		           sharedPools: aClass sharedPools;
		           category: aClass category;
		           package: aClass package;
		           environment: aClass environment.

	builder build.
	builder install.
	^ SystemAnnouncer uniqueInstance
		  classDefinitionChangedFrom: builder oldClass
		  to: builder newClass
]

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
