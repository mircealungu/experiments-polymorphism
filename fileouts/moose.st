"Preparations"
MCCacheRepository instVarNamed: 'default' put: nil.
Deprecation raiseWarning: false.
!
"Moose"
Gofer new
	squeaksource: 'Moose'; 
	package: 'ConfigurationOfMoose';
	load.

(Smalltalk at: #ConfigurationOfMoose) perform: #loadDefault.
!
GLMUITheme defaultSettings: nil.
GLMUITheme beCurrent.
GLMUITheme setPreferredShoutColors.
!
| file morph |

"Cleanup Environment"
World backgroundMorph: nil.
World color: Color white.
World submorphs do: [ :each |
        (each isKindOf: ImageMorph)
                ifTrue: [ each delete ] ].
file := (FileStream readOnlyFileNamed: '/srv/moosetechnology.org/web/res/media/logo100x240.png') binary.
morph := (ImageMorph fromStream: file) openInWorld.
World doOneCycleNow.
morph extension sticky: true.

StandardWindow allSubInstancesDo: #delete.
SystemWindow allInstancesDo: #delete.

Gofer new squeaksource: 'setup'; package: 'Setup'; load.
(Smalltalk at: #ImageSetup) new girbaDejaVuFonts.

HostWindowProxy new
	instVarNamed: #windowHandle put: 1;
	windowPosition: 0 @ 0;
	windowSize: 1024 @ 640.
!
Gofer new
	squeaksource: 'glamoroust';
	package: 'ConfigurationOfGlamoroust';
	load.
!
ConfigurationOfGlamoroust loadDefault.
GTInspector registerToolsOn: Smalltalk tools.
!
ScriptLoader new cleanUpForRelease.
!
"Clear Author"
Author reset.
!
"Clear Monticello Caches"
MCCacheRepository instVarNamed: 'default' put: nil.
MCFileBasedRepository flushAllCaches.
MCMethodDefinition shutDown.
MCDefinition clearInstances.
!
"Cleanup Smalltalk"
Smalltalk flushClassNameCache.
Smalltalk organization removeEmptyCategories.
Smalltalk allClassesAndTraitsDo: [ :each |
	each organization removeEmptyCategories; sortCategories.
	each class organization removeEmptyCategories; sortCategories ].
!
"Cleanup System Memory"
Smalltalk garbageCollect.
Symbol compactSymbolTable.
Deprecation raiseWarning: true.
!
"Save and Quit"
WorldState addDeferredUIMessage: [
	SmalltalkImage current snapshot: true andQuit: true ].
!
