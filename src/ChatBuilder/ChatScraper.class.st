"
Scrape som pages and add as context
"
Class {
	#name : 'ChatScraper',
	#superclass : 'SpPresenter',
	#instVars : [
		'urlPresenter',
		'addField',
		'addButon',
		'contentPane',
		'deleteButton'
	],
	#category : 'ChatBuilder-scrape',
	#package : 'ChatBuilder',
	#tag : 'scrape'
}

{ #category : 'scraper' }
ChatScraper class >> extractTextFromWebPage: urlString [ 
    | url content parser text |
    url := ZnUrl fromString: urlString.
    content := ZnClient new get: url.
    parser := XMLHTMLParser parse: content.
    text := String streamContents: [ :stream |
        parser root allElements do: [ :element |
            (element name asLowercase ~= 'script' and: [element name asLowercase ~= 'style']) ifTrue: [
                element nodes do: [ :node |
                    node isStringNode ifTrue: [
								"OMG, what a bad hack, fix later.. This is due to a bug in the this library, though"
							  | txt |
							  txt := node asString trimBoth.	
							  (txt beginsWith: '<') ifFalse: [ stream nextPutAll: txt; space ].
                        
                    ]
                ]
            ]
        ]
    ].
    ^ text trimBoth.
]

{ #category : 'layout' }
ChatScraper >> defaultLayout [

	| topPane res bottomLayout |
	topPane := SpBoxLayout newHorizontal
		           add: addField;
		           add: addButon;
					  add: deleteButton .
		
	topPane borderWidth: 1.
	bottomLayout := SpBoxLayout newHorizontal
		                add: urlPresenter width: 300;
		                add: contentPane.

	res := SpBoxLayout newVertical
		       add: topPane height: 35;
		       add: bottomLayout.

	^ res
]

{ #category : 'initialization' }
ChatScraper >> initializePresenters [

	addField := self newTextInput.
	addButon := self newButton label: 'Add'.
	urlPresenter := self newList items: application urlList.
	urlPresenter whenSelectedDo: [ :url |
		contentPane adapter widget color: Color lightYellow.
		contentPane text: (application getUrlContent: url) ].
	contentPane := self newText.
	contentPane
		editable: false;
		borderWidth: 1.
	deleteButton := self newButton label: 'Delete'.
	deleteButton action: [
		| url |
		url := urlPresenter selectedItem.
		application removeUrl: url.
		contentPane text: ''.
		urlPresenter items: application urlList ].
	   
	addButon action: [
		| url |
		url := addField text.
		(url beginsWith: 'http') ifTrue: [
			[
			| content |
			content := self class extractTextFromWebPage: url.
			application addUrl: url content: content.
			addField text: ''.
			contentPane text: content.
			contentPane adapter widget color: Color lightYellow.
			urlPresenter items: application urlList ]
				on: Exception
				do: [ contentPane text: 'Not able to scrape' ] ] ]
]
