"
I am a class who does all the actions on the suggested code, like compilation and open in browser.

Use like this:

ChatTools new openBrowserOn: 'ChatTools' selector: 'openBrowserOn:selector:'
"
Class {
	#name : 'ChatTools',
	#superclass : 'Object',
	#category : 'ChatBuilder',
	#package : 'ChatBuilder'
}

{ #category : 'tools' }
ChatTools >> openBrowserOn: className selector: methodName [
    | class method selectorSymbol |
    class := Smalltalk at: className asSymbol ifAbsent: [^ self error: 'Class not found'].
    selectorSymbol := methodName asSymbol.
    method := class methodDictionary 
        at: selectorSymbol 
        ifAbsent: [
            "Try replacing spaces with colons for multi-keyword selectors"
            selectorSymbol := (methodName replaceAll: ' ' with: ':') asSymbol.
            class methodDictionary 
                at: selectorSymbol 
                ifAbsent: [^ self error: 'Method not found']
        ].
    Smalltalk tools browser openOnMethod: class >> selectorSymbol
]
