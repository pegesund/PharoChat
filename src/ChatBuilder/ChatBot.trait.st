"
Chatbot trait

So far only OpenAi implements this but it should be easy to extend.
"
Trait {
	#name : 'ChatBot',
	#category : 'ChatBuilder-chat',
	#package : 'ChatBuilder',
	#tag : 'chat'
}

{ #category : 'sending' }
ChatBot >> sendContent: content user: user system: system model: model [

	self subclassResponsibility
]

{ #category : 'accessing' }
ChatBot >> url [

	self subclassResponsibility
]

{ #category : 'accessing' }
ChatBot >> url: theUrl [
  self subclassResponsibility 
]
