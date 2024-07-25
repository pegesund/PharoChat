"
I am a transformer of the chat generated gode into a tmp-package and back again.
"
Class {
	#name : 'ChatCodeTransformer',
	#superclass : 'Object',
	#instVars : [
		'application'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'transform' }
ChatCodeTransformer >> ensureCurrentTempPackage [
	"Creates temporary package if needed!"

	| organizer basePackage testPackage packageNameString |
	packageNameString := application currentPackage.
	organizer := SystemDictionary new organization.

	"Create base package if it doesn't exist"
	basePackage := organizer
		               packageNamed: packageNameString
		               ifAbsent: [
		               organizer createPackageNamed: packageNameString ].

	"Create test package if it doesn't exist"
	testPackage := organizer
		               packageNamed: packageNameString , '-Tests'
		               ifAbsent: [
		               organizer createPackageNamed:
			               packageNameString , '-Tests' ].

	^ Array with: basePackage with: testPackage
]
