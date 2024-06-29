"
Main window for gui
"
Class {
	#name : 'ChatModelApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'userConversation',
		'systemConversation',
		'savedMethods'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

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
