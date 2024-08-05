Extension { #name : 'WorldState' }

{ #category : '*ChatBuilder' }
WorldState class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'ChatBuilder')
		order: 1000;
		with: [ 			
			(aBuilder item: #'Set open-ai token')
					help: 'Set the API key for OpenAI';		icon: (self iconNamed: #configurationIcon);
		action: [ ChatMainWindow promptAndSetOpenAIAPIKey ].
	(aBuilder item: #'Chat with model')
		help: 'Chat with bot';
		icon: (self iconNamed: #glamorousExample);
		action: [ ChatMainWindow new open ]
 ]


]
