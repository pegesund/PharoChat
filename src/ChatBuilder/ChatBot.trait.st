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

{ #category : 'result handling' }
ChatBot classSide >> extractDictFromJsonResult: jsonString [
    | parsedJson source explanation methods classes |
parsedJson := STON fromString: jsonString.
    
    source := parsedJson at: 'source'.
    explanation := source at: 'explanation'.
    methods := source at: 'methods'.
    classes := source at: 'classes'.
    
    ^ Dictionary newFrom: {
        #parsedJson -> parsedJson.
        #explanation -> explanation.
        #methods -> methods.
        #classes -> classes
    }
]

{ #category : 'sending' }
ChatBot >> sendModel: modelName user: user system: system [

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
