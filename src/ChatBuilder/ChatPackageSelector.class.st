"
Petter was here
"
Class {
	#name : 'ChatPackageSelector',
	#superclass : 'SpPresenter',
	#instVars : [
		'packageList',
		'packageSearchInput'
	],
	#category : 'ChatBuilder-UI',
	#package : 'ChatBuilder',
	#tag : 'UI'
}

{ #category : 'state' }
ChatPackageSelector >> packageSelected: aPackage [
	"Handles the package selection and updates the current package in the application"
	self application currentPackage: aPackage name.
]

{ #category : 'UI' }
ChatPackageSelector >> selectPackage [
	"Action to handle the package selection button click event"
	| selectedPackage |
	selectedPackage := packageList selection selectedItem.
	selectedPackage ifNotNil: [
		self application currentPackage: selectedPackage name.
		self packageSelected: selectedPackage.
		self window close ].
]

{ #category : 'TOREMOVE' }
ChatPackageSelector >> title [

	^ 'Packages'
]

{ #category : 'state' }
ChatPackageSelector >> updatePackageList [
	| filteredPackages |
	filteredPackages := self packageOrganizer packages select: [:package |
		(package name asLowercase includesSubstring: packageSearchInput text asLowercase)].
	packageList items: (filteredPackages sorted: [:a :b | a name <= b name]).
]
