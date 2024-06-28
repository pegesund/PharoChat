"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestChatBuilder',
	#superclass : 'PackageManifest',
	#category : 'ChatBuilder-Manifest',
	#package : 'ChatBuilder',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleCascadedNextPutAllsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#HB)) #'2024-06-25T14:23:03.157015+02:00') #(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:02:00.981827+02:00') #(#(#RGPackageDefinition #(#ChatBuilder)) #'2024-06-27T15:20:56.337366+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#HB)) #'2024-06-25T13:18:07.189785+02:00') #(#(#RGClassDefinition #(#HBGenerator)) #'2024-06-25T15:04:54.32549+02:00') #(#(#RGPackageDefinition #(#ChatBuilder)) #'2024-06-27T15:19:56.778354+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:10:09.632169+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleExcessiveArgumentsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#HB)) #'2024-06-25T14:40:29.901731+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:02:06.214074+02:00') #(#(#RGPackageDefinition #(#ChatBuilder)) #'2024-06-27T12:51:35.763958+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:01:42.737775+02:00') )
]
