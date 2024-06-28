Extension { #name : 'WorldState' }

{ #category : '*ChatBuilder' }
WorldState class >> installOpenAIMenuItem [
    <script>
    (self class>>#openAIMenuItemCommand) 
        ifNil: [
            self class compile: 'openAIMenuItemCommand
    <worldMenu>
    (aBuilder item: #''Set OpenAI API Key'')
        parent: #Library;
        order: 1000;
        help: ''Set the API key for OpenAI'';
        icon: (self iconNamed: #configurationIcon);
        action: [self promptAndSetOpenAIAPIKey]'
        classified: 'menu commands'].
    self inform: 'OpenAI menu item installed. Please restart Pharo to see the changes.'
]

{ #category : '*ChatBuilder' }
WorldState class >> promptAndSetOpenAIAPIKey [
    | apiKey |
    apiKey := UIManager default 
        request: 'Enter your OpenAI API Key:'
        initialAnswer: ''
        title: 'OpenAI API Key'.
    
    apiKey ifNotNil: [
        apiKey ifNotEmpty: [
            ChatEnvironment setApiKey: apiKey.
            UIManager default inform: 'API Key has been set successfully.'
        ] ifEmpty: [
            UIManager default inform: 'API Key cannot be empty.'
        ]
    ]
]

{ #category : '*ChatBuilder' }
WorldState class >> worldMenuOn: aBuilder [
    <worldMenu>
    (aBuilder item: #'Set OpenAI API Key')
        parent: #Library;
        order: 1000;
        help: 'Set the API key for OpenAI';
        icon: (self iconNamed: #configurationIcon);
        action: [self promptAndSetOpenAIAPIKey]
]
