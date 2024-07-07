"
Main window for gui
"
Class {
	#name : 'ChatModelApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'userConversation',
		'systemConversation',
		'savedMethods',
		'apiContent'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'builder' }
ChatModelApplication >> concatenateInfoForAPI [

	| result methodInfo classInfo |
	result := WriteStream on: String new.

	result
		nextPutAll: 'User Conversation: ';
		nextPutAll: self userConversation;
		cr;
		cr;
		nextPutAll: 'System Conversation: ';
		nextPutAll: self systemConversation;
		cr;
		cr;
		nextPutAll: 'Saved Methods:';
		cr.

	methodInfo := OrderedCollection new.
	classInfo := Set new.

	self savedMethods do: [ :method |
		| class |
		class := method methodClass.
		methodInfo add:
			'Method Name: ' , method selector , String cr , 'Method Type: '
			, (method isClassSide
					 ifTrue: [ 'class' ]
					 ifFalse: [ 'instance' ]) , String cr , 'Source Code:'
			, String cr , method sourceCode , String cr , 'Class: '
			, class name , String cr , String cr.
		classInfo add: class ].

	result nextPutAll: (String cr join: methodInfo).

	result
		nextPutAll: 'Class Definitions and Comments:';
		cr.
	classInfo do: [ :class |
		result
			nextPutAll: 'Class: ';
			nextPutAll: class name;
			cr;
			nextPutAll: 'Definition:';
			cr;
			nextPutAll: class definitionString;
			cr;
			nextPutAll: 'Comment:';
			cr;
			nextPutAll: class comment;
			cr;
			cr ].

	^ result contents
]

{ #category : 'initialization' }
ChatModelApplication >> initialize [
    super initialize.
    savedMethods := OrderedCollection new.
]

{ #category : 'accessing' }
ChatModelApplication >> savedMethods [
    ^ savedMethods
]

{ #category : 'accessing' }
ChatModelApplication >> savedMethods: aCollection [
    savedMethods := aCollection asOrderedCollection
]

{ #category : 'accessing' }
ChatModelApplication >> systemConversation [
    ^ systemConversation
]

{ #category : 'accessing' }
ChatModelApplication >> systemConversation: aString [
    systemConversation := aString
]

{ #category : 'accessing' }
ChatModelApplication >> userConversation [
    ^ userConversation
]

{ #category : 'accessing' }
ChatModelApplication >> userConversation: aString [
    userConversation := aString
]
