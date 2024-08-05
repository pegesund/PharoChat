Extension { #name : 'WorldState' }

{ #category : '*ChatBuilder' }
WorldState class >> worldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Set OpenAI API Key')
		parent: #Library;
		order: 1000;
		help: 'Set the API key for OpenAI';
		icon: (self iconNamed: #configurationIcon);
		action: [ ChatMainWindow promptAndSetOpenAIAPIKey ].
		
	(aBuilder item: #'Chat with model')
		parent: #Library;
		order: 1001;
		help: 'Chat with bot';
		icon: (self iconNamed: #glamorousExample);
		action: [ ChatMainWindow new open ].
	
]
