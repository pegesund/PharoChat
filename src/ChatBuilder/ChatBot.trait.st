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
ChatBot classSide >> chatCompileClass: sourceCode [ 
	"compiles a string a class"

	| builder newClass targetPackage className ast comment|
	comment := self chatExtractClassComment: sourceCode .
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

	| methodInfo source compObj |
	(self chatDetectIfClassOrMethod: str)
		ifTrue: [ "object"
			compObj := [ self chatCompileClass: str ]
				           on: Exception
				           do: [ :ex | ex asString ].
			^ compObj ]
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

{ #category : 'source' }
ChatBot classSide >> chatExtractClassComment: aString [
	"Extracts the comment from the class definition string."

	| linecomment |
	linecomment := aString lines second trimBoth .
	^ (linecomment withoutPrefix: '"') withoutSuffix: '"'
]

{ #category : 'source' }
ChatBot classSide >> chatExtractClassName: aString [
    | lines firstLine parts |
    lines := aString lines.
    firstLine := lines first trimBoth.
    parts := firstLine splitOn: ' << #'.
    parts size > 1 
        ifTrue: [ ^ parts second ]
        ifFalse: [ ^ nil ]
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
	"Extract class, signature, methodtype, and source from a method as a string"

	| partsDef className methodType signature source dict allLines firstLine sourceLines |
	dict := Dictionary new.
	"Split the input string into parts"
	allLines := inputString trimBoth lines.
	firstLine := allLines first.
	partsDef := firstLine splitOn: '>>'.
	"Extract class name and check for class method"
	className := partsDef first trimBoth.
	methodType := 'instance'.
	(className endsWith: ' class') ifTrue: [
		className := className allButLast: 6.
		methodType := 'class' ].
	dict at: 'className' put: className.
	dict at: 'methodType' put: methodType.
	"Extract method signature and source"
	sourceLines := allLines allButFirst .
	signature := partsDef second trimBoth.
	source := (sourceLines joinUsing: String cr) trimBoth.
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
