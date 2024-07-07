"
Main window for gui
"
Class {
	#name : 'ChatModelApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'userConversation',
		'systemConversation',
		'savedMethods',
		'apiContent'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'builder' }
ChatModelApplication >> concatenateInfoForAPI [
    | json methodsInfo classesInfo res |
    
    methodsInfo := self savedMethods collect: [ :method |
        | class |
        class := method methodClass.
        {
            'name' -> method selector.
            'type' -> (method isClassSide ifTrue: ['class'] ifFalse: ['instance']).
            'sourceCode' -> method sourceCode.
            'class' -> class name
        } asDictionary
    ].
    
    classesInfo := (self savedMethods collect: [:method | method methodClass]) asSet collect: [ :class |
        {
            'name' -> class name.
            'definition' -> class definitionString.
            'comment' -> class comment
        } asDictionary
    ].
    
    json := {
        'methods' -> methodsInfo asArray.
        'classes' -> classesInfo asArray.
        'userConversation' -> self userConversation.
        'systemConversation' -> self systemConversation
    } asDictionary.
    res := STONJSON toStringPretty: json.
    res inspect.
   
    
    ^ res.
]

{ #category : 'initialization' }
ChatModelApplication >> initialize [
    super initialize.
    savedMethods := OrderedCollection new.
]

{ #category : 'accessing' }
ChatModelApplication >> savedMethods [
    ^ savedMethods
]

{ #category : 'accessing' }
ChatModelApplication >> savedMethods: aCollection [
    savedMethods := aCollection asOrderedCollection
]

{ #category : 'accessing' }
ChatModelApplication >> systemConversation [
    ^ systemConversation
]

{ #category : 'accessing' }
ChatModelApplication >> systemConversation: aString [
    systemConversation := aString
]

{ #category : 'accessing' }
ChatModelApplication >> userConversation [
    ^ userConversation
]

{ #category : 'accessing' }
ChatModelApplication >> userConversation: aString [
    userConversation := aString
]
