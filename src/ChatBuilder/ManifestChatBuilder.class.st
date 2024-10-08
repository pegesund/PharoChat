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
ManifestChatBuilder class >> ruleBadMessageRule2V1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ChatCodeTransformer class' #extractClassNamesFromMethodAST: #true)) #'2024-07-26T15:07:21.357291+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #collectMethodsFromTemporaryClass: #false)) #'2024-07-30T12:05:07.508569+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #collectMethodsFromTemporaryClass:stream: #false)) #'2024-07-30T12:10:03.266698+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #copyClassesFromOrigToTemp #false)) #'2024-07-31T14:33:14.190574+02:00') #(#(#RGClassDefinition #(#ChatCodeBuilder)) #'2024-08-03T18:25:28.365528+02:00') )
]

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
	^ #(#(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:10:09.632169+02:00') #(#(#RGMethodDefinition #(#ChatBot #sendToModel: #false)) #'2024-06-30T20:53:26.513799+02:00') #(#(#RGMethodDefinition #(#OpenAi #sendContent:user:system:model: #false)) #'2024-07-07T14:33:55.595863+02:00') #(#(#RGMethodDefinition #(#ChatMethodSelector #initializePresenters #false)) #'2024-07-24T13:39:27.211361+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleCollectionMessagesToExternalObjectRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatMethodSelector #defaultLayout #false)) #'2024-07-24T11:04:21.924161+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatApplication #concatenateInfoForAPI #false)) #'2024-07-07T10:34:10.489976+02:00') #(#(#RGMethodDefinition #(#MultiCodePresenterWithToolbars #updateLayout #false)) #'2024-07-10T11:37:34.889695+02:00') #(#(#RGMethodDefinition #(#ChatMethodSelector #getChangedMethodsFor: #false)) #'2024-07-20T13:05:15.496715+02:00') #(#(#RGMethodDefinition #(#ChatCodeTransformer #getAllMethodsAndClassesFromTempPackage #false)) #'2024-07-26T13:08:44.166784+02:00') #(#(#RGMethodDefinition #(#ChatCodeTransformer #getAllMethodsAndClassesFromTempPackage: #false)) #'2024-07-26T13:51:29.56473+02:00') #(#(#RGMethodDefinition #(#'ChatCodeTransformer class' #extractClassNamesFromMethod: #true)) #'2024-07-26T14:38:15.159315+02:00') #(#(#RGMethodDefinition #(#MultiCodePresenterWithToolbars #defaultLayout #false)) #'2024-08-03T19:29:20.154007+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleEmptyExceptionHandlerRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatMethodSelector #getChangedMethodsFor: #false)) #'2024-07-20T13:05:45.76585+02:00') #(#(#RGMethodDefinition #(#MultiCodePresenterWithToolbars #showGraphicalDiff: #false)) #'2024-07-21T14:47:30.076152+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleExcessiveArgumentsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#HB)) #'2024-06-25T14:40:29.901731+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleExcessiveVariablesRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#ChatMainWindow)) #'2024-06-29T19:00:47.063567+02:00') #(#(#RGClassDefinition #(#ChatMethodSelector)) #'2024-07-24T14:11:25.21885+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:02:06.214074+02:00') #(#(#RGPackageDefinition #(#ChatBuilder)) #'2024-06-27T12:51:35.763958+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleNobodyShouldSendMethodDictV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatCodeTransformer #getAllMethodsAndClassesFromTempPackage #false)) #'2024-07-26T13:08:21.090427+02:00') #(#(#RGMethodDefinition #(#ChatCodeTransformer #getAllMethodsAndClassesFromTempPackage: #false)) #'2024-07-26T13:51:55.751364+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleReNotOptimizedIfNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatMainWindow #openSystemConversation #false)) #'2024-06-29T20:32:28.30194+02:00') #(#(#RGMethodDefinition #(#ChatMainWindow #openUserConversation #false)) #'2024-07-07T13:55:25.126206+02:00') #(#(#RGMethodDefinition #(#ChatMethodSelector #connectPresenters #false)) #'2024-07-24T10:38:51.927327+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleReNotOptimizedIfRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChatCodeBuilder #transformIncomingMethod: #false)) #'2024-08-09T16:17:17.680195+02:00') )
]

{ #category : 'code-critics' }
ManifestChatBuilder class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'HBGenerator class' #generateHtmlTagMethod:attributes:isVoid:in: #true)) #'2024-06-26T13:01:42.737775+02:00') #(#(#RGMethodDefinition #(#ChatApplication #concatenateInfoForAPI #false)) #'2024-06-30T20:48:40.58333+02:00') #(#(#RGMethodDefinition #(#'ChatCodeTransformer class' #extractClassNamesFromMethod: #true)) #'2024-07-26T14:37:20.605099+02:00') #(#(#RGMethodDefinition #(#'ChatCodeTransformer class' #extractClassNamesFromMethod: #true)) #'2024-07-26T14:37:59.253336+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #collectTemporaryClasses #false)) #'2024-07-30T12:42:29.795181+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #copyClassesFromOrigToTemp #false)) #'2024-07-31T13:48:44.786676+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #collectTemporaryClasses: #false)) #'2024-08-02T14:01:45.522509+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #transformIncomingMethod: #false)) #'2024-08-03T18:25:20.906874+02:00') #(#(#RGMethodDefinition #(#ChatCodeBuilder #transformOutgoingClasses #false)) #'2024-08-05T15:39:50.327838+02:00') )
]
