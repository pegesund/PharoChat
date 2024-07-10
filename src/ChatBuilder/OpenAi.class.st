"
I am a class implementing the ChatBot trait on OpenAi
"
Class {
	#name : 'OpenAi',
	#superclass : 'Object',
	#traits : 'ChatBot',
	#classTraits : 'ChatBot classTrait',
	#instVars : [
		'url'
	],
	#category : 'ChatBuilder-chat',
	#package : 'ChatBuilder',
	#tag : 'chat'
}

{ #category : 'removing' }
OpenAi class >> removeFirstAndLastLines: aString [
    | lines |
    lines := aString lines.
    ^ (lines size > 2
        ifTrue: [ (lines copyFrom: 2 to: lines size - 1) ]
        ifFalse: [ #() ])
        joinUsing: String cr
]

{ #category : 'initialization' }
OpenAi >> initialize [

	self url: 'https://api.openai.com/v1/chat/completions'.
]

{ #category : 'sending' }
OpenAi >> sendModel: modelName user: user system: system [

	| client urlZn entity response json jsonObject content |
	"Set up the WebClient"
	client := ZnClient new.

	"Set the URL"
	urlZn := 'https://api.openai.com/v1/chat/completions' asZnUrl.

	"Set up the headers"
	client
		headerAt: 'Content-Type' put: 'application/json';
		headerAt: 'Authorization'
		put: 'Bearer ' , ChatEnvironment getApiKey.

	"Prepare the JSON payload"
	json := STONJSON toString: {
			        ('model' -> modelName).
			        ('messages' -> {
				         {
					         ('role' -> 'system').
					         ('content' -> system) } asDictionary.
				         {
					         ('role' -> 'user').
					         ('content' -> user) } asDictionary }) } asDictionary.

	"Set up the entity"
	entity := ZnEntity with: json type: ZnMimeType applicationJson.

	"Send the POST request"
	response := client
		            url: urlZn;
		            entity: entity;
		            post.

	jsonObject := nil.
	"Check the response"
	client isSuccess
		ifTrue: [ "Process the successful response"
			jsonObject := STONJSON fromString: response contents.
			client close ]
		ifFalse: [
			client close.
			self error: response status asString ].

	content := STONJSON fromString: (self class removeFirstAndLastLines:
			            (((jsonObject at: 'choices') first at: 'message') at:
				             'content')).
				
	content isAssociation
		                  ifTrue: [
		                  ^ { (content key -> content value) }
			                  asDictionary ]
		                  ifFalse: [ ^ content ].

]

{ #category : 'accessing' }
OpenAi >> url [

	^ url
]

{ #category : 'accessing' }
OpenAi >> url: theUrl [

	url := theUrl .
]
