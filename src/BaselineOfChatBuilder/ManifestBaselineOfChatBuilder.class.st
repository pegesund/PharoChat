"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestBaselineOfChatBuilder',
	#superclass : 'PackageManifest',
	#category : 'BaselineOfChatBuilder-Manifest',
	#package : 'BaselineOfChatBuilder',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestBaselineOfChatBuilder class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#BaselineOfChatBuilder)) #'2024-08-06T10:16:02.517988+02:00') )
]
