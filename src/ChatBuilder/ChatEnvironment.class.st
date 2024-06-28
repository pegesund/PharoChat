"
Gui for environment
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

{ #category : 'adding' }
ChatEnvironment >> addOpenAIAPIKeyMenuItem [ 
    (self registry detect: [:each | each name = 'Library']) 
        ifNotNil: [:libraryMenu |
            libraryMenu addItem: [ :item |
                item
                    name: 'Set OpenAI API Key';
                    action: [self promptAndSetOpenAIAPIKey]
            ]
        ]
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

{ #category : 'as yet unclassified' }
ChatEnvironment >> menuItem [
    ^ #'library'
]

{ #category : 'executing' }
ChatEnvironment >> pexecute [

	| ak |
	ak := UIManager default
		          request: 'Enter your OpenAI API Key:'
		          initialAnswer: ''
		          title: 'OpenAI API Key'.

	ak ifNotNil: [
		ak
			ifNotEmpty: [
				(self class) setApiKey: ak.
				UIManager default inform: 'API Key has been set successfully.' ]
			ifEmpty: [ UIManager default inform: 'API Key cannot be empty.' ] ]
]

{ #category : 'as yet unclassified' }
ChatEnvironment >> promptAndSetOpenAIAPIKey [
        | apiKey |
        apiKey := UIManager default 
            request: 'Enter your OpenAI API Key:'
            initialAnswer: ''
            title: 'OpenAI API Key'.
        
        apiKey ifNotNil: [
            apiKey ifNotEmpty: [
                ChatEnvironment setApiKey: apiKey.
                UIManager default inform: 'API Key has been set successfully.'
            ] ifEmpty: [
                UIManager default inform: 'API Key cannot be empty.'
            ]
        ]
]
