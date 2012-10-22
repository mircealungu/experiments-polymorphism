'From VisualWorks® NonCommercial, 7.7.1 of July 26, 2010 on October 22, 2012 at 3:00:37 PM'!
"Bundle Mircea-Experiments*"!


CodeComponent create: #package named: 'Polymorphism-EmpiricalStudy'!"Package Polymorphism-EmpiricalStudy*"!


CodeComponent type: #package named: 'Polymorphism-EmpiricalStudy' property: #disregardedPrerequisites value: #()!

CodeComponent type: #package named: 'Polymorphism-EmpiricalStudy' property: #packageName value: 'Polymorphism-EmpiricalStudy'!

TestCase subclass: #PolymorphismAnalyzerTest
	instanceVariableNames: 'analyzer hotDrawAnalyzer jHotDrawAnalyzer jFreeChart '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PolyExp'!

PolymorphismAnalyzerTest class
	instanceVariableNames: ''!

OrderedCollection variableSubclass: #Hierarchy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PolyExp'!

Hierarchy class
	instanceVariableNames: ''!

Hierarchy comment:
'models a class hierarchy'!

OrderedCollection variableSubclass: #PolymorphicMethodChain
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PolyExp'!

PolymorphicMethodChain class
	instanceVariableNames: ''!

PolymorphicMethodChain comment:
'PolymorphicChain represents a series of messages that override each other.'!

Object subclass: #PolymorphismAnalyzer
	instanceVariableNames: 'model polymorphicMessagesDict modelMethods rootPolymorphicMethods polymorphicMethods methodsCallingPolymorphicMethods polymorphicMethodSignatures allPolymorphicCalls '
	classVariableNames: ''
	poolDictionaries: 'SCG.Moose '
	category: 'PolyExp'!

PolymorphismAnalyzer class
	instanceVariableNames: ''!

PolymorphismAnalyzer comment:
'analyzer for polymorphism!!'!

OrderedCollection variableSubclass: #PolymorphicChain
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PolyExp'!

PolymorphicChain class
	instanceVariableNames: ''!

PolymorphicChain comment:
'PolymorphicChain represents a series of messages that override each other.'!

!PolymorphismAnalyzerTest class methodsFor: 'instance creation'!

new
	"Answer a newly created and initialized instance."

	^super new initialize! !


!PolymorphismAnalyzerTest methodsFor: 'testing - jHotDraw'!

jhd_InterfacesDefiningRootPolyMethods
	<test>

	self assert: (jHotDrawAnalyzer rootPolyMethods select: [:e| e belongsTo isInterface]) notEmpty.!

jhd_allHierarchies
	<test>

	"very weak test: there are many more hierarchies than 12..."
	self assert: (jHotDrawAnalyzer allHierarchies size > 12)! !

!PolymorphismAnalyzerTest methodsFor: 'evaluating'!

complexityResults
	PolymorphismAnalyzer forJHotDraw complexityResultsCSV inspect.!

hd_startSnautAndHighlightStuff
	
	PolymorphismAnalyzer forHotDraw visualizeInSnaut.!

methodStats
	PolymorphismAnalyzer forJHotDraw methodStatistics inspect.!

stats
	PolymorphismAnalyzer forJHotDraw implUseResultsCSV inspect.
	PolymorphismAnalyzer forJHotDraw methodStatistics inspect.!

hd_visualizeRootPolyMethods
	PolymorphismAnalyzer forHotDraw methodHighlight: #allPolyMethods!

hd_visualizePolymorphicClasses
	PolymorphismAnalyzer forHotDraw visualizePolymorphicClasses!

hd_visualizeAllPolyMethods
	PolymorphismAnalyzer forHotDraw visualizeAllPolyMethods!

hd_visualizeBigGapsMethods
	| bigGaps |
	bigGaps := (hotDrawAnalyzer rootPolyMethods select: [:e| (hotDrawAnalyzer maxGapFor: e) = 3]).

	PolymorphismAnalyzer forHotDraw methodHighlightMethods: (bigGaps).!

runningTheThing
	jHotDrawAnalyzer implUseResultsCSV inspect.! !

!PolymorphismAnalyzerTest methodsFor: 'testing - jFreeChart'!

jfc_onlyThrowingExceptionMethods
	<test>
	(jFreeChart allPolyMethods select: [:e| e onlyThrowsException ]) inspect.!

testAbstractPolymorphicMethods
	| rootAbstract allAbstract |
	rootAbstract := (jFreeChart rootPolyMethods select: [:e| e isAbstract]).
	allAbstract := (jFreeChart allPolyMethods select: [:e| e isAbstract]).
	self assert: (allAbstract size > rootAbstract size).

	self assert: ((jFreeChart allPolyMethods select: [:e| e isAbstract]) isEmpty not)!

jfc_NOPMethods
	<test>
	| refreshTicksHorizontal  |
	refreshTicksHorizontal := (jFreeChart allPolyMethods select: [:e| e belongsTo name = #LogarithmicAxis and: [e name = #refreshTicksHorizontal]]) first.
	self assert: ((jFreeChart allPolyMethods select: [:e| e isNOP]) includes: refreshTicksHorizontal ).!

jfc_noSuperMethods
	<test>
	| callersWithSuperInBody |
	callersWithSuperInBody := ((jFreeChart allPolyMethods select: [:e| e isCallingSuper ]) reject: [:e| ('*super.', e name asString, '*') match: e sourceText]).
	self assert: (callersWithSuperInBody size <  (jFreeChart allPolyMethods select: [:e| e isCallingSuper not]) size).! !

!PolymorphismAnalyzerTest methodsFor: 'testing protocol'!

initialize
	super initialize.
	analyzer := PolymorphismAnalyzer forHotDraw.
	hotDrawAnalyzer :=  PolymorphismAnalyzer forHotDraw.
	jHotDrawAnalyzer :=  PolymorphismAnalyzer forFile: '../testing/jhotdraw7_20090906.mse'.
	jFreeChart := PolymorphismAnalyzer forFile: '../testing/jfreechart-mod.mse'.! !

!PolymorphismAnalyzerTest methodsFor: 'testing - Hotdraw'!

hd_methodCountLargerThanMessageCount
	<test>

	self assert: (hotDrawAnalyzer rootPolyMethods size < hotDrawAnalyzer allPolyMethods size)!

hd_allPolymorphicCalls
	<test>

	self assert: (hotDrawAnalyzer allPolymorphicCalls size > 300).!

hd_polymorphicClasses
	<test>

	self assert: (hotDrawAnalyzer polymorphicClasses size >= 39).
	self assert: (hotDrawAnalyzer polymorphicClasses contains: [:e| e name = #ToolState]).!

hd_allIndependentClasses
	<test>

	self assert: (hotDrawAnalyzer independentClasses size = 36).!

hd_callingSuper
	<test>

	self assert: ((hotDrawAnalyzer allPolyMethods select: [:e| e isCallingSuper]) contains: [:met| met name = #initialize])!

hd_parentHierarchy
	<test>
	| cfigure  hcfigure m1  hfigure figure |
	figure  := (hotDrawAnalyzer polymorphicHierarchies detect: [:e| e root name =  #Figure]) root.
	hcfigure  := Hierarchy new.
	cfigure := hotDrawAnalyzer model allClasses detect: [:e| e name =  #CompositeFigure].
	hcfigure add: cfigure.
	hcfigure addAll: cfigure subclassHierarchyGroupModel.

	m1 := hotDrawAnalyzer rootPolyMethods detect: [:e| e name = #drawing and: [e belongsTo name = #Figure]].
	hfigure := (hotDrawAnalyzer getHierarchyOfRoot: m1) parentHierarchy.

	self assert: (hfigure parentHierarchy root = figure).
	self assert: (hcfigure parentHierarchy root = figure).!

hd_hierarchyLeaves
	<test>
	| figureHierarchy |
	figureHierarchy := hotDrawAnalyzer polymorphicHierarchies detect: [:e| e root name =  #Figure].
	self assert: (figureHierarchy leaves size = 17)!

hd_NOPMethods
	<test>

"	(hotDrawAnalyzer model allMethods select: [:e| #empty = e name ])  inspect"!

hd_polymorphicHierarchies
	<test>
	"this test counts  on the model being built without merging the class and meta-class together"
	self assert: (hotDrawAnalyzer polymorphicHierarchies size > 8).!

hd_allPolymorphicChains
	<test>
	| bigChains bigGaps |
	bigChains := (hotDrawAnalyzer rootPolyMethods select: [:e| (hotDrawAnalyzer maxPolymorphicChainsSizeFor: e) = 4]).
	self assert: (bigChains contains: [:e| e name = #initialize]).
	self assert: (bigChains contains: [:e| e name = #add:]).
	self assert: (bigChains contains: [:e| e name = #remove:]).

	bigGaps := (hotDrawAnalyzer rootPolyMethods select: [:e| (hotDrawAnalyzer maxGapFor: e) = 3]).!

hd_hierarchies
	<test>
	| figure drawingEditor hier m2 m1 m3 |
	figure := hotDrawAnalyzer polymorphicHierarchies detect: [:e| e root name =  #Figure].
	drawingEditor := hotDrawAnalyzer polymorphicHierarchies detect: [:e| e root name =  #DrawingEditor].
	self assert: (figure height = 5).
	self assert: (drawingEditor height = 2).
	self assert: (figure hsize = 31).
	self assert: (drawingEditor hsize = 7).

	self assert: (figure allMethodsInHierarchy size > 300).
	self assert: (figure allPolyMethodRoots size > 35).

	m1 := hotDrawAnalyzer rootPolyMethods detect: [:e| e name = #drawing and: [e belongsTo name = #Figure]].
	m3 := hotDrawAnalyzer rootPolyMethods detect: [:e| e name = #initialize and: [e belongsTo name = #Figure]].
	hier := hotDrawAnalyzer getHierarchyOfRoot: m1.
	self assert: (hier size = 31).
	self assert: (hier height = 5).

	self assert: ((hier implementorsOf:  #'drawing()') size = 2).
	self assert: ((hier implementorsOf:  #'initialize()') size = 14).
	self assert: m3 withOverriderMethods size = 14.

	m2 := jHotDrawAnalyzer rootPolyMethods detect: [:e| e name = #getDefaultDisclosureState].
	self assert: (m2 belongsTo name = #AbstractToolBar).
	hier := jHotDrawAnalyzer getHierarchyOfRoot: m2.	
	self assert: (hier height = 2).!

hd_allHierarchies
	<test>

	self assert: (hotDrawAnalyzer allHierarchies size = 12)!

hd_callSites
	<test>
	| classes |
	classes := (hotDrawAnalyzer callSites_methods collect: [:e| e belongsTo]).

	"a very weak test: not all classes have polymorphic call sites"
	self assert: classes size < hotDrawAnalyzer modelClasses size.! !


!Hierarchy class methodsFor: 'instance creation'!

new
	"Answer a newly created and initialized instance."

	^super new initialize! !


!Hierarchy methodsFor: 'accessing'!

parentHierarchy
	| p rez |
	p := self root.
	[p superclass notNil and:[p superclass isStub not and: [p superclass notNil]]] whileTrue: [ p := p superclass].
	rez := Hierarchy with: p.
	rez addAll: p subclassHierarchyGroupModel.
	^rez!

root
	^self first!

hsize
	^ self nonStub size!

leaves
	^(self select: [:e| e incomingInheritances size = 0]) select: [:e| e isStub not].!

height: rootNode
	| children  |
	children := (rootNode incomingInheritances collect: [:e| e subclass]) select: [:e| e isStub not].
	children isEmpty ifTrue: [^1].
	^ 1 + ((children collect: [:e| self height: e]) asSortedCollection last).! !

!Hierarchy methodsFor: 'metrics'!

height

	^self height: self root! !

!Hierarchy methodsFor: 'utils'!

nonStub
	^self reject: [:e| e isStub]!

allMethodsInHierarchy

	^self nonStub flatCollect: [:cls | cls methods]!

implementorsOf: signature
	^(self select: [:e| e implements: signature])!

allPolyMethodRoots
	^(self allMethodsInHierarchy select: [:e| e isOverriden]) select: [:e| e isOverriding not]! !

!Hierarchy methodsFor: 'initialize-release'!

initialize
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Replace this comment with the appropriate initialization code *** "
	^self! !


!PolymorphismAnalyzer class methodsFor: 'testing'!

forHotDraw
	^self forModel: (SN.HotDrawModel fromSmalltalk).!

forJHotDraw
	^(PolymorphismAnalyzer forFile: 'models/Paparazzo/mse/jhotdraw7_20090906.mse')!

forDerby
	^(PolymorphismAnalyzer forFile: 'models/Paparazzo/mse/apache-derby_r817075_20090920.mse')!

forJFreeChart
	^(PolymorphismAnalyzer forFile: 'models/jFreeChart.mse')! !

!PolymorphismAnalyzer class methodsFor: 'instance creation'!

forModel: aModel

	^self new
		model: aModel;
		yourself.!

new
	"Answer a newly created and initialized instance."

	^super new initialize!

forFile: fileName

	| moosemodel loader modelName |
	modelName := fileName asFilename tail removeSuffix: '.mse'.

	moosemodel := MooseModel root 
		entityNamed: modelName asSymbol
		ifAbsent: [nil].

	moosemodel isNil ifTrue: [
		fileName asFilename exists ifFalse: [^'file not found'].
		loader := MooseImporter withActiveMetamodel.
		loader stream: fileName asFilename readStream.
		moosemodel := loader asTask runWithProgress.
		loader resolveDanglingReferences .
		moosemodel name: modelName.
		MooseModel root addEntity: moosemodel.
		].
	^self new
		model: moosemodel;
		yourself.!

forModelNamed: modelName

	| moosemodel |
	

	moosemodel := MooseModel root 
		entityNamed: modelName asSymbol
		ifAbsent: [nil].

	^self new
		model: moosemodel;
		yourself.! !


!PolymorphismAnalyzer methodsFor: 'analysis scripts - messages'!

messageMeasurements
	| res |
	res := OrderedCollection new.

	self rootPolyMethods do: [:met :overs |
		| hierRoot messStats |
		messStats := OrderedCollection new.
		hierRoot := (self getHierarchyRootOf: overs first) .

		messStats add: hierRoot subclassHierarchyGroup size.
		messStats add: (self hierarchyDepthOf: hierRoot).
		messStats add: (overs size).
		messStats add: 0.


		res add: messStats.
	].
	^res!

respondersFor: mes andMethods: implementingMethods
	| responders |
	responders := Set new.
	implementingMethods do: [:met|
		responders add: met belongsTo.
		responders addAll: met belongsTo subclassHierarchyGroup.
	].
	^responders!

respondersForMethods: implementingMethods
	| responders |
	responders := Set new.
	implementingMethods do: [:met|
		responders add: met belongsTo.
		responders addAll: met belongsTo subclassHierarchyGroup.
	].
	^responders! !

!PolymorphismAnalyzer methodsFor: 'accessing'!

model
	^model!

model: anObject
	model := anObject! !

!PolymorphismAnalyzer methodsFor: 'analsis scripts'!

polymorphicChains
	^self rootPolyMethods collect: [:e| PolymorphicMethodChain new addAll: e withOverriderMethods]!

independentClasses
	^((model allModelClasses 
		reject: [:e| e subclassHierarchyGroup notEmpty])
		reject: [:e| e superclass isNil not and: [e superclass isStub not]])!

modelClasses

	^ model allClasses select: [: e| e isStub not]!

polyMessages
	^self rootPolyMethods!

callSites_classes
	^(self callSites_methods collect: [:e| e belongsTo]) asSet!

polymorphicHierarchies
	
	^self allHierarchies select: [:hier|
		hier contains: [:cl| self polymorphicClasses includes: cl].
	].!

polymorphicMethods_computer
	^(self rootPolyMethods flatCollect: [:met| met withOverriderMethods]) "asSet asOrderedCollection"!

rootPolyMethods
	rootPolymorphicMethods isNil ifTrue: [
		rootPolymorphicMethods := (self modelMethods select: [:met| met isOverriden and: [met isOverriding not]]) asSet asOrderedCollection
	].
	^rootPolymorphicMethods!

allPolymorphicCalls_computer

	^model allInvocations
		select: [ : invocation | 
			invocation candidateList notNil 
			and: [invocation candidateList contains: [:met | self allPolyMethods includes: met]]]!

maxGapFor: rootMethod
	| gaps |
	gaps := (self polymorphicChainsFor: rootMethod) collect: 
		[:e| 
			(e reject: [:cls| cls implements: rootMethod signature]) size].
	^gaps asSortedCollection last.!

allPolyMethods

	polymorphicMethods isNil
		ifTrue: [polymorphicMethods := self polymorphicMethods_computer asSet asOrderedCollection].
	^polymorphicMethods!

allPolymorphicCalls

	allPolymorphicCalls isNil ifTrue: [allPolymorphicCalls := self allPolymorphicCalls_computer].
	^allPolymorphicCalls!

allHierarchies
	
	^self allHierarchyRoots collect: [:e| | rez |
		rez := Hierarchy with: e.
		rez addAll: (e subclassHierarchyGroup select: [:f | f isStub not]).
		rez].!

allCalls

	^model allInvocations select: [:inv | inv candidateList notNil and: [inv candidateList contains: [:met | met notNil and: [met isStub not]]]]!

polymorphicChainsFor: rootMethod
	^rootMethod withOverriderMethods collect: [:e|
		|ch|
		ch := OrderedCollection new.
		ch addAll: e belongsTo superclassHierarchyGroupModel.
		ch addLast: e belongsTo.
		[ch first implements: rootMethod signature] whileFalse: [ch removeFirst].
		ch
	].!

callSites_methods
	^(self allPolymorphicCalls collect: [:e| e invokedBy]) asSet.!

polymorphicClasses

	^(self allPolyMethods collect: [:e | e belongsTo]) asSet!

maxPolymorphicChainsSizeFor: rootMethod
	^((self polymorphicChainsFor: rootMethod) collect: [:e| e size]) asSortedCollection last!

allHierarchyRoots
	"initially i was thinking abou this: 
((self allModelClasses select: [:e| e superclass mooseName = #'java::lang::Object']) select: [:e| e subclassHierarchyGroup size > 1])
	but exceptions are not subclasses of object. and also the superclass might be a stub, so that does not work. both those two cases
	are detected with superclass superclass"

	^((model allModelClasses select: [:e | e superclass isStub ])
		select: [:e | e subclassHierarchyGroup notEmpty])! !

!PolymorphismAnalyzer methodsFor: 'As yet unclassified'!

polymorphicMethodSignatures
	polymorphicMethodSignatures isNil ifTrue: [
		polymorphicMethodSignatures := self allPolyMethods collect: [:e| e signature].
	].
	
	^polymorphicMethodSignatures! !

!PolymorphismAnalyzer methodsFor: 'initialize-release'!

initialize
	"Initialize a newly created instance. This method must answer the receiver."

	super initialize.
	" *** Replace this comment with the appropriate initialization code *** "
	^self! !

!PolymorphismAnalyzer methodsFor: 'analys - support'!

getHierarchyRootOf: met
	| root |
	root := met belongsTo.
	[root superclass notNil and: [root superclass isModel]] whileTrue: [root := root superclass].
	^ root!

modelMethods
	modelMethods isNil ifTrue: [
	 modelMethods := model allMethods select: [:e| e isStub not].
	].
	^modelMethods!

polymorphicHierarchyHeightFor: mets
	| sortedDepths |

	sortedDepths := (mets collect: [:met| self distanceFromTopFor: met belongsTo]) asSortedCollection.
	^sortedDepths last - sortedDepths first.!

distanceFromTopFor: cls

	| root dist |
	dist := 0.
	root := cls.
	[root superclass notNil] whileTrue: 
			[root := root superclass.
			dist := dist + 1].
	^dist!

hierarchyDepthOf: node

	node incomingInheritances isEmpty ifTrue: [^0].
	^(node incomingInheritances collect: [:inh | self hierarchyDepthOf: inh subclass])
		asSortedCollection last
		+ 1!

getHierarchyOfRoot: rootMet

	| rootClass hier |
	rootClass := rootMet belongsTo.
	hier := Hierarchy with: rootClass.
	hier addAll: rootClass subclassHierarchyGroupModel.
	^hier!

getHierarchyOf: met

	| root |
	root := met belongsTo.
	[root superclass notNil and: [root superclass isModel]] whileTrue: [root := root superclass].
	^root subclassHierarchyGroup add: root; yourself! !

!PolymorphismAnalyzer methodsFor: 'visualization'!

visualizePolymorphicClasses
	self classHighlight: #polymorphicClasses!

classHighlight: method 

	| view unhighlighted |
	view := Mondrian.ViewRenderer new.
	unhighlighted := self model allModelClasses reject: [:e | (self perform: method) includes: e].
	
	view
		nodes: unhighlighted 
		using: Mondrian.Shape forFamixClass.
	view
		nodes: (self perform: method)
		using: (Mondrian.Shape forFamixClass fillColor: [:a | ColorValue red])."
		using: view newShape rectangle; withBorder; lineColor: Color white; withLabel; text: [:e | e name]."

	view treeLayout.
	view interaction popupText: #displayString.
	view
		edges: self model allInheritanceDefinitions
		from: #superclass
		to: #subclass.
	view open!

visualizeAllPolyMethods
	self methodHighlight: #allPolyMethods!

methodHighlightMethods: methods

	| view  |
	view := Mondrian.ViewRenderer new.
	
	
	view box: [
		view nodes: self modelClasses using: (Mondrian.Shape new add: Mondrian.RectangleShape new; add: Mondrian.BorderShape new; add: (Mondrian.LabelShape label: [:anEntity | anEntity name])) 
			forEach: [:eachNode | 
				view interaction onClick: [:method | Mondrian.EventHandler new 
													popupSourceForClass: (MSEUtilities smalltalkClassFromFamixClassName: method belongsTo mooseUniqueName) 
													method: method name].
				view 
					nodes: (eachNode methods reject: [:e| methods includes: e])
					using: Mondrian.RectangleShape withBorder.
				view 
					nodes: (eachNode methods select: [:e| methods includes: e])
					using: (Mondrian.RectangleShape withBorder fillColor: [:a | Color allColors at: (a signature size) ]).

				view layout: (Mondrian.GridLayout withGap: 1)
			].
		view
		edges: self model allInheritanceDefinitions
		from: #superclass
		to: #subclass.
			view treeLayout.
	].
	view open!

classHighlight: method old: yes

	| view unhighlighted |
	view := Mondrian.ViewRenderer new.
	unhighlighted := self model allModelClasses reject: [:e | (self perform: method) includes: e].
	
	view
		nodes: unhighlighted 
		using: Mondrian.Shape forFamixClass.
	view
		nodes: (self perform: method)
		using: (Mondrian.Shape forFamixClass fillColor: [:a | ColorValue green])."
		using: view newShape rectangle; withBorder; lineColor: Color white; withLabel; text: [:e | e name]."

	view treeLayout.
	view interaction popupText: #displayString.
	view
		edges: self model allInheritanceDefinitions
		from: #superclass
		to: #subclass.
	view open!

methodHighlight: methodName 

	| view highMethods |
	view := Mondrian.ViewRenderer new.
	highMethods := self perform: methodName.
	
	view box: [
		view nodes: self modelClasses using: (Mondrian.Shape new add: Mondrian.RectangleShape new; add: Mondrian.BorderShape new; add: (Mondrian.LabelShape label: [:anEntity | anEntity name])) 
			forEach: [:eachNode | 
				view interaction onClick: [:method | Mondrian.EventHandler new 
													popupSourceForClass: (MSEUtilities smalltalkClassFromFamixClassName: method belongsTo mooseUniqueName) 
													method: method name].
				view 
					nodes: (eachNode methods asSortedCollection: [:a :b| a numberOfLinesOfCode > b numberOfLinesOfCode])
					using: (Mondrian.RectangleShape withBorder fillColor: [:a | (highMethods includes: a) ifTrue: [CodeFoo.Color allColors at: (a signature size \\ 140)] ifFalse:[ColorValue white]]; height: [:e| e numberOfLinesOfCode]).

				view layout: (Mondrian.GridLayout withGap: 1)
				
			].
		view
		edges: (self model allInheritanceDefinitions reject: [:inh| inh superclass isInterface])
		from: #superclass
		to: #subclass.
			view treeLayout.
	].
	view open!

visualizeInSnaut
	| snaut |	
	snaut := SN.Softwarenaut onHigraph: (SN.Higraph on:  model).

	snaut 
		open;
		resetHighlighters;
		addHighlighterForClassesContainingMethods: (self allPolyMethods) color: ColorValue red name: 'Defining polymorphism';
		addHighlighterForClassesContainingMethods: (self callSites_methods) color: ColorValue yellow name: 'Polymorphic call sites'.!

classHighlight: method color: cv

	| view unhighlighted |
	view := Mondrian.ViewRenderer new.
	unhighlighted := self model allModelClasses reject: [:e | (self perform: method) includes: e].
	
	view
		nodes: unhighlighted 
		using: Mondrian.Shape forFamixClass.
	view
		nodes: (self perform: method)
		using: (Mondrian.Shape forFamixClass fillColor: [:a | cv])."
		using: view newShape rectangle; withBorder; lineColor: Color white; withLabel; text: [:e | e name]."

	view treeLayout.
	view interaction popupText: #displayString.
	view
		edges: self model allInheritanceDefinitions
		from: #superclass
		to: #subclass.
	view open! !

!PolymorphismAnalyzer methodsFor: 'public api'!

appendMethodStatisticsToStream: stream

	| count array sampledMethods sampleSize   |
	sampleSize := 150.
	self modelMethods size < sampleSize
		ifTrue: [sampledMethods := self modelMethods]
		ifFalse: 
			[array := self modelMethods asArray.
			count := self modelMethods size // sampleSize.
			sampledMethods := OrderedCollection new.
			1 to: sampleSize do: [:i | sampledMethods add: (array at: i * count)]].

	stream position = 0 ifTrue: [
		stream 
			nextPutAll: 'name,isPoly,callsPoly,nsends,loc'; cr.
	].
	
	sampledMethods do: 
			[:met |
			stream
				nextPutAll: met mooseModel name, '-', met belongsTo name, '-', met name;
				nextPutAll: ',';
				nextPutAll: (self allPolyMethods includes: met) printString;
				nextPutAll: ',';
				nextPutAll: (self callSites_methods includes: met) printString;
				nextPutAll: ',';
				nextPutAll: (met outgoingInvocations size) printString;				
				nextPutAll: ',';
				nextPutAll: met numberOfLinesOfCode asInteger printString;
				cr	"nsends"].
	stream close.
	^nil!

independentClassesCSV
	| result stream |
	stream := WriteStream on: String new.
	result := OrderedCollection new.
	[
	result 
		add: self independentClasses size.
	] on: Error
	do: [:e|
		stream nextPutAll: model name, ' ', e printString.
	].
	stream nextPutAll: '[', model name, '] '.
	result  do: [:each| stream nextPutAll: ', ', each printString.].
	stream cr.
	^stream contents!

appendMethodStatisticsToFile: fn
	self appendMethodStatisticsToStream: fn asFilename appendStream.
	^''.!

appendImplUseResultsToStream: stream
	| result  |
	stream position = 0 ifTrue: [
		stream nextPutAll: 'systemname,allMethods,polyMethods,messages,hierarchies,hierarchies,polyHierarchies,classes,polyClasses,methodsCallingPoly,classesCallingPoly,polyCalls,allCalls,implementsPolymorphism,usesPolymorphism'; cr.
	].

	result := OrderedCollection new.
	[
	result 
		add: self modelMethods size;
		add: self allPolyMethods size;
		add: self rootPolyMethods size;
		add: self allHierarchies size;
		add: self allHierarchies size;
		add: self polymorphicHierarchies size;
		add: model allModelClasses size;
		add: self polymorphicClasses size;
		add: self callSites_methods size;
		add: self callSites_classes size;
		add: self allPolymorphicCalls size;
		add: self allCalls size;		
		add: self allPolyMethods size > 0;
		add: self callSites_methods size > 0.
	] on: Error
	do: [:e|
		stream nextPutAll: model name, ' ', e printString.
	].
	stream nextPutAll: model name, ''.
	result  do: [:each| stream nextPutAll: ',', each printString.].
	stream cr.
	stream close.
	^nil!

appendComplexityResultsToStream: stream
	stream position = 0 ifTrue: [
		stream 
			nextPutAll: 'systemname,methodname,hsize,hdepth,msize,mdepth,responders,maxSuperChain,noSuper,nop,errs'; cr.
	].
	[	
	self rootPolyMethods do: [:met|
		| polyh bigh |
		polyh := self getHierarchyOfRoot: met.
		bigh := polyh parentHierarchy.

		stream 
			nextPutAll: model name, ',';
			nextPutAll: met belongsTo name, '-', met name printString, ',';
			nextPutAll: bigh size printString, ','; "hsize"
			nextPutAll: bigh height printString, ','; "hdepth"
			nextPutAll: (polyh implementorsOf: met signature) size printString, ','; "msize = implementors"
			nextPutAll: (self maxPolymorphicChainsSizeFor: met) printString, ','; "mdepth"
			nextPutAll: polyh size printString, ','; "responders"
			nextPutAll: 0 printString, ','; "max super chain"
			nextPutAll: met overriderMethods_noSuper size printString, ','; "no super"
			nextPutAll: met overriderMethods_nop size printString, ','; "nop"
			nextPutAll: met overriderMethods_onlyThrowingExceptions size printString "err".
			stream cr.
		].
	]
	 on: Error
	do: [:e|
		stream nextPutAll: model name, ' ', e printString.
	].
	stream close.
	
	^nil!

appendImplUseResultsToFile: fn
	self appendImplUseResultsToStream: fn asFilename appendStream.
	^''.!

complexityResultsCSV
	| stream |
	stream := WriteStream on: String new.
	OrderedCollection new.

	[	
	self rootPolyMethods do: [:met|
		| polyh bigh |
		polyh := self getHierarchyOfRoot: met.
		bigh := polyh parentHierarchy.

		"hsize,hdepth,msize,mdepth,responders,maxGap,maxSpan,maxSuperChain,noSuper,diffSuper,nop,errs"

		stream 
			nextPutAll: model name, '-', met belongsTo name, '-', met name printString, ', ';
			nextPutAll: bigh size printString, ','; "hsize"
			nextPutAll: bigh height printString, ','; "hdepth"
			nextPutAll: (polyh implementorsOf: met signature) size printString, ','; "msize = implementors"
			nextPutAll: (self maxPolymorphicChainsSizeFor: met) printString, ','; "mdepth"
			nextPutAll: polyh size printString, ', '; "responders"
			nextPutAll: 0 printString, ', '; "max super chain"
			nextPutAll: met overriderMethods_noSuper size printString, ', '; "no super"
			nextPutAll: met overriderMethods_nop size printString, ', '; "nop"
			nextPutAll: met overriderMethods_onlyThrowingExceptions size printString "err".
			stream cr.
		].
	]
	 on: Error
	do: [:e|
		stream nextPutAll: model name, ' ', e printString.
	].
	
	^stream contents!

appendComplexityResultsToFile: fn

	self appendComplexityResultsToStream: fn asFilename appendStream.
	^''.!

implUseResultsCSV
	| result stream |
	stream := WriteStream on: String new.
	result := OrderedCollection new.
	[
	result 
		add: self modelMethods size;
		add: self allPolyMethods size;
		add: self rootPolyMethods size;
		add: self allHierarchies size;
		add: self allHierarchies size;
		add: self polymorphicHierarchies size;
		add: model allModelClasses size;
		add: self polymorphicClasses size;
		add: self callSites_methods size;
		add: self callSites_classes size;
		add: self allPolymorphicCalls size;
		add: self allCalls size;		
		add: self allPolyMethods size > 0;
		add: self callSites_methods size > 0.
	] on: Error
	do: [:e|
		stream nextPutAll: model name, ' ', e printString.
	].
	stream nextPutAll: '[', model name, '] '.
	result  do: [:each| stream nextPutAll: ', ', each printString.].
	stream cr.
	^stream contents!

methodStatistics

	| count array sampledMethods sampleSize result |
	sampleSize := 150.
	self modelMethods size < sampleSize
		ifTrue: [sampledMethods := self modelMethods]
		ifFalse: 
			[array := self modelMethods asArray.
			count := self modelMethods size // sampleSize.
			sampledMethods := OrderedCollection new.
			1 to: sampleSize do: [:i | sampledMethods add: (array at: i * count)]].
	result := WriteStream on: String new.
	sampledMethods do: 
			[:met |
			result
				nextPutAll: met mooseModel name, '-', met belongsTo name, '-', met name;
				nextPutAll: ', ';
				nextPutAll: (self allPolyMethods includes: met) printString;
				nextPutAll: ', ';
				nextPutAll: (self callSites_methods includes: met) printString;
				nextPutAll: ', ';
				nextPutAll: (met outgoingInvocations size) printString;				
				nextPutAll: ', ';
				nextPutAll: met numberOfLinesOfCode asInteger printString;
				cr	"nsends"].
	^result contents! !


!FAMIXClass methodsFor: 'polymorphism study'!

subclassHierarchyGroupModel
	<navigation: 'Subclasses'>

	^self subclassHierarchyGroup reject: [:e| e isStub].!

sourceText
	| filename separator source file |
	self sourceAnchor notNil ifTrue: [
		source := ''.
		separator := Filename separator asSymbol asString.
		 
		file := ((Filename defaultDirectoryName, separator, '..', separator, 'src'), separator , self mooseModel name , separator, 'src', separator, self sourceAnchor).
		file  := file copyReplaceAll: '\' with: separator.
		file := file copyReplaceAll: '/' with: separator.
		filename := file asFilename.
		filename exists ifTrue: [source := filename readStream contents.].
		^source
	].
	self mooseModel isJava ifTrue: [ 
		source := ''.
		separator := Filename separator asSymbol asString.
		self sourceAnchor isNil ifFalse: [
			filename := ('src', separator , self mooseModel name , separator, self sourceAnchor) asFilename.
		] ifTrue: [
			filename := ('src' , separator , self mooseModel name , separator, ((self mooseName copyReplaceAll: '::' with: separator) copyUpTo: $$), '.java') asFilename.
		].
		filename exists ifTrue: [source := filename readStream contents.].
		^source
	].
	self mooseModel isSmalltalk ifTrue: [
		^self mooseName, 
			Character cr asSymbol asString, 
			((self attributes collect: #name) join: Character cr asSymbol asString), 
			Character cr asSymbol asString, 
			((self methods collect: #sourceText) join: Character cr asSymbol asString).
	].
	self mooseModel isPython ifTrue:[
		^self pythonASTNode sourceText
	].
	^''!

superclassHierarchyGroupModel
	<navigation: 'Superclasses'>

	^self superclassHierarchyGroup reject: [:e| e isStub].! !


!FAMIXMethod methodsFor: 'Polymorphism-EmpiricalStudy'!

isCallingSuper
	^self outgoingInvocations anySatisfy: [:inv| 
			inv candidateList notNil and: [
			inv candidateList contains: [:met|
				met notNil and: [
				met belongsTo = self belongsTo superclass
					and: [met name = self name]]]]].!

onlyThrowsException

	^self thrownExceptions notEmpty and: [self localVariables isEmpty and: [self accesses isEmpty ]]!

overriderMethods

	| overs |
	overs := OrderedCollection new.
	self belongsTo subclassHierarchyGroupModel 
		do: [:cls | overs addAll: (cls methods select: [:met | met name = self name])].
	^overs!

overriderMethods_nop
	^self overriderMethods select: [:e| e isNOP].!

overriderMethods_onlyThrowingExceptions
	^self overriderMethods select: [:e| e onlyThrowsException].!

isNOP
	^self outgoingInvocations isEmpty 
		and: [self thrownExceptions isEmpty 	
			and: [self localVariables isEmpty 
			and: [self accesses isEmpty 
			and: [self isAbstract not and: 
			[self numberOfLinesOfCode <= 2]]]]]!

overriderMethods_noSuper
	^self overriderMethods reject: [:e| e isCallingSuper].!

sourceText
	| text stream |
	self mooseModel isJava ifTrue: [
		| readstream |
		text := String new.

		stream := text writeStream.
		readstream := self belongsTo sourceText readStream.
		(self propertyNamed: #startLine) timesRepeat: [readstream upTo: Character cr. readstream next.].
		((self propertyNamed: #endLine) - (self propertyNamed: #startLine)) timesRepeat: [
			stream nextPutAll: (readstream upTo: Character cr). readstream next.
			stream cr.
		].
		^ stream contents
	].
	self mooseModel isSmalltalk ifTrue: [^((MSEUtilities smalltalkClassFromFamixClassName: self belongsTo mooseName) sourceCodeAt: self name) asString].
	^''!

throwsException
	^self thrownExceptions notEmpty
	"
	^self outgoingInvocations anySatisfy: [:inv| 
			inv candidateList notNil and: [
			inv candidateList contains: [:met|
				met notNil and: [
				'*Exception' match: met belongsTo name asString ]]]]."!

isOverriding
	<property: #overriding
		longName: 'Overriding method'
		description: 'The method is overrinding a method defined in a super class'
	>
	^self belongsTo directSuperclasses anySatisfy: [ :each | (each understands: self signature)].!

isOverriden
	<property: #overriden
		longName: 'Method overriden'
		description: 'The method is overrinded in a sub class'
	>

	^self belongsTo subclassHierarchyGroup anySatisfy: [ :each | each hasMethodWithSignature: self signature].!

withOverriderMethods
	| all |
	all := OrderedCollection new.
	all add: self.
	all addAll: self overriderMethods.
	^all.! !

