"
Chatbot trait

So far only OpenAi implements this but it should be easy to extend. Extend this object if you would like to support other chatbots.

Also contains some class helper methods which are common. Like compile, use like this to compile a method:


ChatBot compileMethod: 'Integer' source: 'triple\\n\\t^ self * 3' isClassSide: false

"
Trait {
	#name : 'ChatBot',
	#category : 'ChatBuilder-chat',
	#package : 'ChatBuilder',
	#tag : 'chat'
}

{ #category : 'compiling' }
ChatBot classSide >> chatCompileMethod: className source: methodSource isClassSide: isClassSide [
    | targetClass processedSource |
    
    processedSource := methodSource copyReplaceAll: '\n' with: String cr.
    processedSource := processedSource copyReplaceAll: '\t' with: String tab.
    
    ^ [
        targetClass := Smalltalk at: className asSymbol.
        isClassSide ifTrue: [ targetClass := targetClass class ].
        
        targetClass compile: processedSource.
        #ok
    ] on: Error do: [ :error |
        error messageText
    ]
]

{ #category : 'as yet unclassified' }
ChatBot classSide >> chatCompileMethodFromString: str [
	"comment stating purpose of class-side method"

]

{ #category : 'compiling' }
ChatBot classSide >> chatCompileString: str [
	(self chatDetectIfClassOrMethod: str) ifTrue: [ "object"
		
		 ] ifFalse: [ "method"
		
		 ]
]

{ #category : 'compiling' }
ChatBot classSide >> chatDetectIfClassOrMethod: str [
	"check if string contains definition on a class or method"
	^ (str lines first) includes: '<<'.

	
]

{ #category : 'result handling' }
ChatBot classSide >> chatExtractDictFromJsonResult: jsonString [
	"Extract data returned from the llm"
	| parsedJson source explanation methods classes |
	parsedJson := STON fromString: jsonString.

	source := parsedJson at: 'source'.
	explanation := source at: 'explanation'.
	methods := source at: 'methods'.
	classes := source at: 'classes'.

	^ Dictionary newFrom: {
			  (#parsedJson -> parsedJson).
			  (#explanation -> explanation).
			  (#methods -> methods).
			  (#classes -> classes) }
]

{ #category : 'compiling' }
ChatBot classSide >> chatExtractMethodInfo: inputString [
	"Extract class, signature, methodtype and source from a method as a string"

	| parts className methodType signature source dict |
	dict := Dictionary new.

	"Split the input string into parts"
	parts := inputString trimBoth splitOn: '>>'.

	"Extract class name and check for class method"
	className := parts first trimBoth.
	methodType := 'instance'.
	(className endsWith: ' class') ifTrue: [
		className := className allButLast: 6.
		methodType := 'class' ].

	dict at: 'className' put: className.
	dict at: 'methodType' put: methodType.

	"Extract method signature and source"
	parts := parts second trimBoth splitOn: '['.
	signature := parts first trimBoth.
	source := '[' , (parts allButFirst joinUsing: '[').

	dict at: 'signature' put: signature.
	dict at: 'source' put: source trimBoth.

	^ dict
]

{ #category : 'tests' }
ChatBot classSide >> testAddMethod [
	"comment stating purpose of class-side method"

	"scope: class-variables  &  class-instance-variables"
| sourceCode builder newClass targetPackage className ast |
sourceCode := 'Object << #MyClassPetter7
    "Add comment here also.."
    layout: FixedLayout;
    traits: {};
    slots: { #myVar100 . #myVar200 };
    sharedVariables: { #myShare1 };
    sharedPools: {};
    tag: '''';
    package: ''ChatBuilder'''.
ast := CDFluidClassDefinitionParser parse: sourceCode.


builder := ShiftClassBuilder new
    buildEnvironment: self class environment;
    buildFromAST: ast.
newClass := builder build.
newClass comment: 'Petter was here'.

className := newClass name.

"Check if class already exists and remove it"
(Smalltalk globals includesKey: className) ifTrue: [
    | existingClass |
    existingClass := Smalltalk globals at: className.
    existingClass package removeClassNamed: className.
    Smalltalk globals removeKey: className.
].

"Register the class in the global namespace"
Smalltalk globals at: newClass name put: newClass.

"Get the target package"
targetPackage := builder package.

"Move the class to the correct package"
newClass package: targetPackage.

^ newClass
]

{ #category : 'tests' }
ChatBot classSide >> testUsePetterTest [
	"comment stating purpose of class-side method"
	^ MyClassPetter7 new.
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
