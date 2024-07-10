"
I am a class which holds standarized, extracted information from the chatbot.
"
Class {
	#name : 'ExtractedChatInfo',
	#superclass : 'Object',
	#instVars : [
		'methods',
		'classes',
		'explanation',
		'general'
	],
	#category : 'ChatBuilder-chat',
	#package : 'ChatBuilder',
	#tag : 'chat'
}

{ #category : 'accessing' }
ExtractedChatInfo >> classes [

	^ classes
]

{ #category : 'accessing' }
ExtractedChatInfo >> classes: anObject [

	classes := anObject
]

{ #category : 'accessing' }
ExtractedChatInfo >> explanation [

	^ explanation
]

{ #category : 'accessing' }
ExtractedChatInfo >> explanation: anObject [

	explanation := anObject
]

{ #category : 'accessing' }
ExtractedChatInfo >> general [

	^ general
]

{ #category : 'accessing' }
ExtractedChatInfo >> general: anObject [

	general := anObject
]

{ #category : 'accessing' }
ExtractedChatInfo >> methods [

	^ methods
]

{ #category : 'accessing' }
ExtractedChatInfo >> methods: anObject [

	methods := anObject
]
