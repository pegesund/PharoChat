"
Main window for gui
"
Class {
	#name : 'ChatModelApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'userConversation',
		'systemConversation'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

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
