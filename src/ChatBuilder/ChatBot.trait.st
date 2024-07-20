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

{ #category : 'tests' }
ChatBot classSide >> chatCompileClass: sourceCode comment: comment [
	"compiles a string a class"

	| builder newClass targetPackage className ast |
	ast := CDFluidClassDefinitionParser parse: sourceCode.
	builder := ShiftClassBuilder new
		           buildEnvironment: self class environment;
		           buildFromAST: ast.
	newClass := builder build.
	newClass comment: comment.
	className := newClass name.

	"Check if class already exists and remove it"
	(Smalltalk globals includesKey: className) ifTrue: [
		| existingClass |
		existingClass := Smalltalk globals at: className.
		existingClass package removeClassNamed: className.
		Smalltalk globals removeKey: className ].

	"Register the class in the global namespace"
	Smalltalk globals at: newClass name put: newClass.

	"Move the class to the correct package"
	targetPackage := builder package.
	newClass package: targetPackage.

	^ #ok
]

{ #category : 'compiling' }
ChatBot classSide >> chatCompileMethod: className source: methodSource isClassSide: isClassSide [

	| targetClass processedSource res |
	processedSource := methodSource copyReplaceAll: '\n' with: String cr.
	processedSource := processedSource
		                   copyReplaceAll: '\t'
		                   with: String tab.

	^ [
	  targetClass := Smalltalk at: className asSymbol.
	  isClassSide ifTrue: [ targetClass := targetClass class ].

	  res:= targetClass compile: processedSource.
	  #ok ]
		  on: Error
		  do: [ :error | error messageText ]
]

{ #category : 'compiling' }
ChatBot classSide >> chatCompileString: str [
	"Check if class or method and compile"

	| methodInfo source |
	(self chatDetectIfClassOrMethod: str)
		ifTrue: [ "object"
		^ self chatCompileClass: str comment: 'Petter was here' ]
		ifFalse: [ "method"
			methodInfo := self chatExtractMethodInfo: str.
			source := WriteStream on: String new.
			source
				nextPutAll: (methodInfo at: 'signature');
				cr;
				tab;
				nextPutAll: (methodInfo at: 'source').
			^ self
				  chatCompileMethod: (methodInfo at: 'className')
				  source: source contents
				  isClassSide: (methodInfo at: 'methodType') = 'class' ]
]

{ #category : 'compiling' }
ChatBot classSide >> chatDetectIfClassOrMethod: str [
	"check if string contains definition on a class or method"

	^ (str lines first) includesSubstring: '<<'
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
    | parts className methodType signature source dict lines |
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
    lines := parts second trimBoth lines.
    signature := lines first trimBoth.
    source := (lines allButFirst joinUsing: String cr) trimBoth.
    
    dict at: 'signature' put: signature.
    dict at: 'source' put: source.
    ^ dict
]

{ #category : 'tools' }
ChatBot classSide >> chatOpenBrowserOn: className selector: methodName [
	"Both params are strings"
	| class method selectorSymbol |
	class := Smalltalk
		         at: className asSymbol
		         ifAbsent: [ ^ self error: 'Class not found' ].
	selectorSymbol := methodName asSymbol.
	method := class methodDictionary
		          at: selectorSymbol
		          ifAbsent: [ "Try replacing spaces with colons for multi-keyword selectors"
			          selectorSymbol := (methodName replaceAll: ' ' with: ':')
				                            asSymbol.
			          class methodDictionary
				          at: selectorSymbol
				          ifAbsent: [ ^ self error: 'Method not found' ] ].
	Smalltalk tools browser openOnMethod: class >> selectorSymbol
]

{ #category : 'source' }
ChatBot classSide >> chatSourceCodeForPackage: aPackageName [

	| package classes sourceCode |
	package := self packageOrganizer packageNamed: aPackageName.
	classes := package definedClasses.
	sourceCode := String streamContents: [ :stream |
		              classes do: [ :class |
			              stream
				              nextPutAll: class definitionString;
				              nextPut: Character cr;
				              nextPut: Character cr.

			              "Add class comment"
			              stream
				              nextPutAll: '"';
				              nextPutAll: (class comment ifNil: [ '' ]);
				              nextPutAll: '"';
				              nextPut: Character cr;
				              nextPut: Character cr.

			              "Instance methods"
			              stream
				              nextPutAll: '!Instance methods!';
				              nextPut: Character cr;
				              nextPut: Character cr.
			              class methods do: [ :method |
				              stream
					              nextPutAll: method sourceCode;
					              nextPut: Character cr;
					              nextPut: Character cr ].

			              "Class methods"
			              stream
				              nextPutAll: '!Class methods!';
				              nextPut: Character cr;
				              nextPut: Character cr.
			              class class methods do: [ :method |
				              stream
					              nextPutAll: method sourceCode;
					              nextPut: Character cr;
					              nextPut: Character cr ] ] ].
	^ sourceCode
]

{ #category : 'source' }
ChatBot classSide >> chatStringToMethodSymbol: aString [
	"Converts a string of method signatur type to a symbol"
    | parts selector |
    parts := aString splitOn: Character space.
    selector := String streamContents: [ :stream |
        parts withIndexDo: [ :part :index |
            (index odd) ifTrue: [
                stream nextPutAll: part.
            ]
        ].
    ].
    ^ selector asSymbol
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
