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

{ #category : 'chat' }
OpenAi class >> simpleExample [

	| client url entity response json jsonObject |
	"Set up the WebClient"
	client := ZnClient new.

	"Set the URL"
	url := 'https://api.openai.com/v1/chat/completions' asZnUrl.

	"Set up the headers"
	client
		headerAt: 'Content-Type' put: 'application/json';
		headerAt: 'Authorization' put: 'Bearer ' , 'sk-proj-......'.

	"Prepare the JSON payload"
	json := STONJSON toString: {
			        ('model' -> 'gpt-3.5-turbo').
			        ('messages' -> {
				         {
					         ('role' -> 'system').
					         ('content'
					          ->
					          'You are a smalltalk programmer and coder, skilled in explaining complex programming concepts with creative flair. You use Pharo 12 as the base for the questions, please answer in json. The json should contain two fields, comment which is the comment and code which is the actuall code') }
					         asDictionary.
				         {
					         ('role' -> 'user').
					         ('content'
					          -> 'Create a method for getting the content of a url') }
					         asDictionary }) } asDictionary.

	"Set up the entity"
	entity := ZnEntity with: json type: ZnMimeType applicationJson.

	"Send the POST request"
	response := client
		            url: url;
		            entity: entity;
		            post.

	"Check the response"
	client isSuccess
		ifTrue: [ "Process the successful response"
			Transcript
				show: 'Response: ' , response contents;
				cr.
			jsonObject := STONJSON fromString: response contents.
			jsonObject inspect ]
		ifFalse: [ "Handle the error"
			Transcript
				show: 'Error: ' , response status asString;
				cr ].

	"Don't forget to close the client"
	client close
]

{ #category : 'initialization' }
OpenAi >> initialize [

	self url: 'https://api.openai.com/v1/chat/completions'.
]

{ #category : 'sending' }
OpenAi >> sendModel: modelName user: user system: system [

	| client urlZn entity response json jsonObject |
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
			Transcript
				show: 'Response: ' , response contents;
				cr.
			jsonObject := STONJSON fromString: response contents.
			 ]
		ifFalse: [ "Handle the error"
			Transcript
				show: 'Error: ' , response status asString;
				cr ].
	client close.
	^ jsonObject
]

{ #category : 'accessing' }
OpenAi >> url [

	^ url
]

{ #category : 'accessing' }
OpenAi >> url: theUrl [

	url := theUrl .
]
