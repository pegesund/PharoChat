"
Main window for gui
"
Class {
	#name : 'ChatApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'userConversation',
		'systemConversation',
		'savedMethods',
		'apiContent',
		'currentPackage',
		'selectedClasses',
		'mainWindow'
	],
	#category : 'ChatBuilder-chat',
	#package : 'ChatBuilder',
	#tag : 'chat'
}

{ #category : 'accessing' }
ChatApplication >> apiContent [

	^ apiContent
]

{ #category : 'accessing' }
ChatApplication >> apiContent: anObject [

	apiContent := anObject
]

{ #category : 'builder' }
ChatApplication >> concatenateInfoForAPI [

	| pkg stream |
	pkg := currentPackage
		       ifNil: [ 'NopacageSpecified' ]
		       ifNotNil: [ currentPackage ].
	stream := WriteStream on: String new.

	userConversation ifNil: [ ^ '' ].
	stream
		nextPutAll: userConversation;
		cr.
	stream
		nextPutAll:
			'Important: Unless specified otherwise create all new classes and methods in this package: '
			, pkg;
		cr;
		cr.
	currentPackage ifNil: [ ^ stream contents ].
	stream nextPutAll:
		'Relevant source code in current project is found here. Suggest changes in this codebase also if needed to formulate the reply. Current source: '.
	stream
		nextPutAll: (ChatBot chatSourceCodeForPackage: currentPackage);
		cr.
	^ stream contents
]

{ #category : 'accessing' }
ChatApplication >> currentPackage [

	^ currentPackage
]

{ #category : 'accessing' }
ChatApplication >> currentPackage: anObject [

	currentPackage := anObject
]

{ #category : 'initialization' }
ChatApplication >> initialize [

	super initialize.
	currentPackage := 'ChatBuilder'.
	savedMethods := OrderedCollection new.
	self systemConversation: '
		
		You are a Smalltalk programmer using Pharo 12. Relevant code is added in the json naming both methods and relevant classes for the question. If question contains information about creating source, please answer with a json containing a field named methods. This field contains an array of all the methods to create or update. Each method should have a name field, a source field and a field named createOrUpdate describing if the code should be created or updated. One field should contain the field explanation on the main changes. Make sure the json follows this format, the data here is just randomly created. Make sure the field "source" is the top tag if the answer contains code, this is important. If the answer suggests new classes/updated to classes this is to be found in the class tag. Make sure class source code is in the new format like, described in the example below. If the answer contains code it should always contain an explantation on what is done. Make sure to comment methods and classes. Make sure the answer contains only the json content, no loose text before or after the generated json.  Do not generate an explanation field without adding methods and/or classes.
		
Important: Always have source as top tag when writing source. Never, never have source without methods and classes fields. 
		
When generating methods, please include class name in the method source, like in this method declaration example: 

Utilities class >> hasDuplicatesIn: aCollection

If not a class method it should look like this:

Utilities  >> hasDuplicatesIn: aCollection

When creating/updating classes make sure to include slots (variables) used in new methods or method updates.

Correct json on result is like this:
		
		"source" = { 
		   explanation = "Introduces two fixes on methods and one update. This changes make sure the http-request contains auth headers.. "
			methods = [
				{ "class" = "MyClass1,
				  "name" = "verifyHttpHeaders",
				  "source" = ^ headers..",
				  "createOrUpdate" = "create",
				  "type" = "instance"
				 },
				{ "class" = "MyClass2,
				  "name" = "sendToAuthPage",
				  "source" = ^ self redirect: authPage..",
				  "createOrUpdate" = "update",
				  "type" = "class"
				 },
				...
				  ],
			classes = [ 
				{ "class" = "TheClassName",
				  "comment" = "I am a class which.."
				  "souce" = "Object << #MyClass
				                                             "Put class comment here too.."
									layout: FixedLayout;
									traits: {};
									slots: { #myslot . #anotherSlot};
									sharedVariables: {};
									sharedPools: {};
									tag: '''' ;
									package: ''SpecifiedPackage''",
				  "createOrUpdate" = "create"
				 }
				 ]
		 }
		
While creating/updating a class it should be on this form:

Object << #MyClass
        "Add comment here also.."
	layout: FixedLayout;
	traits: {};
	slots: { #myVar1 . #myVar2 };
	sharedVariables: {};
	sharedPools: {};
	tag: '''' ;
	package: ''SpecifiedPackage''		
		
		If not asked to create code just answer like this:
		
		{ "result" = "here comes the content.." }
		
While creating classes and/or methods, make sure that classes which are bases for other new classes comes first in listing. Same goes for methods: Methods which are used by other new methods should be listed first.
		
	'
]

{ #category : 'accessing' }
ChatApplication >> mainWindow [

	^ mainWindow
]

{ #category : 'accessing' }
ChatApplication >> mainWindow: anObject [

	mainWindow := anObject
]

{ #category : 'accessing' }
ChatApplication >> savedMethods [
    ^ savedMethods
]

{ #category : 'accessing' }
ChatApplication >> savedMethods: aCollection [
    savedMethods := aCollection asOrderedCollection
]

{ #category : 'chat' }
ChatApplication >> selectedClasses [
	^ selectedClasses
]

{ #category : 'accessing' }
ChatApplication >> selectedClasses: anObject [

	selectedClasses := anObject
]

{ #category : 'chat' }
ChatApplication >> sendToChatModel: modelName [

	| model res |
	model := nil.
	modelName = 'gpt-3.5-turbo' ifTrue: [ model := OpenAi new ].
	modelName = 'gpt-4o' ifTrue: [ model := OpenAi new ].
	modelName = 'gpt-4-turbo' ifTrue: [ model := OpenAi new ].

	res := model
		       sendModel: modelName
		       user: self concatenateInfoForAPI 
		       system: systemConversation.
	res inspect.
	^ res
]

{ #category : 'accessing' }
ChatApplication >> systemConversation [
    ^ systemConversation
]

{ #category : 'accessing' }
ChatApplication >> systemConversation: aString [
    systemConversation := aString
]

{ #category : 'accessing' }
ChatApplication >> userConversation [


^ userConversation .

]

{ #category : 'accessing' }
ChatApplication >> userConversation: aString [
    userConversation := aString
]
