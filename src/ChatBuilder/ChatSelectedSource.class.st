"
Keeps info on selected source.

Keeps info on method, class and package. If f.ex. type is method all of method, class and package-name is set (not nil).
"
Class {
	#name : 'ChatSelectedSource',
	#superclass : 'Object',
	#instVars : [
		'selectedClassName',
		'selectedMethodName',
		'selectedPackageName'
	],
	#category : 'ChatBuilder-code',
	#package : 'ChatBuilder',
	#tag : 'code'
}

{ #category : 'converting' }
ChatSelectedSource >> asString [

	selectedMethodName ifNotNil: [ ^ selectedMethodName name ].
	selectedClassName ifNotNil: [ ^ selectedClassName asString ].
	^ ('#' , selectedPackageName) asString.
]

{ #category : 'accessing' }
ChatSelectedSource >> name [

	selectedMethodName ifNotNil: [ ^ selectedMethodName name ].
	selectedClassName ifNotNil: [ ^ selectedClassName ].
	^ '#', selectedPackageName .
]

{ #category : 'accessing' }
ChatSelectedSource >> selectedClassName [

	^ selectedClassName
]

{ #category : 'accessing' }
ChatSelectedSource >> selectedClassName: anObject [

	selectedClassName := anObject
]

{ #category : 'accessing' }
ChatSelectedSource >> selectedMethodName [

	^ selectedMethodName
]

{ #category : 'accessing' }
ChatSelectedSource >> selectedMethodName: anObject [

	selectedMethodName := anObject
]

{ #category : 'accessing' }
ChatSelectedSource >> selectedPackageName [

	^ selectedPackageName
]

{ #category : 'accessing' }
ChatSelectedSource >> selectedPackageName: anObject [

	selectedPackageName := anObject
]
