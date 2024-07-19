Class {
	#name : 'ChatBuilderTest',
	#superclass : 'TestCase',
	#category : 'ChatBuilder-Tests-unit',
	#package : 'ChatBuilder-Tests',
	#tag : 'unit'
}

{ #category : 'tests' }
ChatBuilderTest >> testExtractMethodInfo [
    | results |
    
    "Test case 1: Class method with one argument"
    results := ChatBot chatExtractMethodInfo: 'TestClass class >> singleArgument: arg [ ^ arg * 2 ]'.
    self assert: (results at: 'className') equals: 'TestClass'.
    self assert: (results at: 'methodType') equals: 'class'.
    self assert: (results at: 'signature') equals: 'singleArgument: arg'.
    self assert: (results at: 'source') equals: '[ ^ arg * 2 ]'.
    
    "Test case 2: Instance method with no arguments"
    results := ChatBot chatExtractMethodInfo: 'TestClass >> noArguments [ ^ ''Hello'' ]'.
    self assert: (results at: 'className') equals: 'TestClass'.
    self assert: (results at: 'methodType') equals: 'instance'.
    self assert: (results at: 'signature') equals: 'noArguments'.
    self assert: (results at: 'source') equals: '[ ^ ''Hello'' ]'.
    
    "Test case 3: Instance method with multiple arguments"
    results := ChatBot chatExtractMethodInfo: 'TestClass >> multipleArguments: arg1 with: arg2 and: arg3 [ ^ arg1 + arg2 + arg3 ]'.
    self assert: (results at: 'className') equals: 'TestClass'.
    self assert: (results at: 'methodType') equals: 'instance'.
    self assert: (results at: 'signature') equals: 'multipleArguments: arg1 with: arg2 and: arg3'.
    self assert: (results at: 'source') equals: '[ ^ arg1 + arg2 + arg3 ]'.
    
    "Test case 4: Class method with complex signature and multi-line source"
    results := ChatBot chatExtractMethodInfo: 'ComplexClass class >> doSomething: arg1 with: arg2 [
        | temp |
        temp := arg1 + arg2.
        ^ temp * 2
    ]'.
    self assert: (results at: 'className') equals: 'ComplexClass'.
    self assert: (results at: 'methodType') equals: 'class'.
    self assert: (results at: 'signature') equals: 'doSomething: arg1 with: arg2'.
    self assert: (results at: 'source') equals: '[
        | temp |
        temp := arg1 + arg2.
        ^ temp * 2
    ]'.
    
    "Test case 5: Instance method with brackets in the source"
    results := ChatBot chatExtractMethodInfo: 'TestClass >> methodWithBrackets [ ^ Array with: [ :each | each * 2 ] ]'.
    self assert: (results at: 'className') equals: 'TestClass'.
    self assert: (results at: 'methodType') equals: 'instance'.
    self assert: (results at: 'signature') equals: 'methodWithBrackets'.
    self assert: (results at: 'source') equals: '[ ^ Array with: [ :each | each * 2 ] ]'.
]
