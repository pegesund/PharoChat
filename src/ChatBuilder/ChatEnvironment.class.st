"
Gui for environment. With this class one can currently only set api keys.
"
Class {
	#name : 'ChatEnvironment',
	#superclass : 'Object',
	#classVars : [
		'ApiKey'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'as yet unclassified' }
ChatEnvironment class >> getApiKey [
  ^ ApiKey 
]

{ #category : 'initialization' }
ChatEnvironment class >> setApiKey: key [

	ApiKey := key
]

{ #category : 'accessing' }
ChatEnvironment >> commandName [
    ^ 'Set OpenAI API Key'
]

{ #category : 'executing' }
ChatEnvironment >> execute [

	| ak |
	ak := UIManager default
		          request: 'Enter your OpenAI API Key:'
		          initialAnswer: ''
		          title: 'OpenAI API Key'.

	ak ifNotNil: [
		ak
			ifNotEmpty: [
				self class setApiKey: ak.
				UIManager default inform: 'API Key has been set successfully.' ]
			ifEmpty: [ UIManager default inform: 'API Key cannot be empty.' ] ]
]

{ #category : 'gui' }
ChatEnvironment >> menuItem [
    ^ #'library'
]

{ #category : 'gui' }
ChatEnvironment >> promptAndSetOpenAIAPIKey [

	| apiKey |
	apiKey := UIManager default
		          request: 'Enter your OpenAI API Key:'
		          initialAnswer: ''
		          title: 'OpenAI API Key'.

	apiKey ifNotNil: [
		apiKey
			ifNotEmpty: [
				self class setApiKey: apiKey.
				UIManager default inform: 'API Key has been set successfully.' ]
			ifEmpty: [ UIManager default inform: 'API Key cannot be empty.' ] ]
]
