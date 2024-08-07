"
Baseline of ChatBuilder
"
Class {
	#name : 'BaselineOfChatBuilder',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfChatBuilder-baseline',
	#package : 'BaselineOfChatBuilder',
	#tag : 'baseline'
}

{ #category : 'baselines' }
BaselineOfChatBuilder >> baselineOf: spec [

	<baseline>
	spec for: #common do: [
		spec package: 'ChatBuilder' with: [ spec requires: #( ) ].
		spec
			package: 'ChatBuilder-Tests'
			with: [ spec requires: #( 'ChatBuilder' ) ].
		spec group: 'default' with: #( 'ChatBuilder' 'ChatBuilder-Tests' ).
		spec group: 'core' with: #( 'ChatBuilder' ) ]
]
