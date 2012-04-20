#!/bin/bash
echo running method statistics...

basedir=`cd .. && pwd`
app=$basedir/bin/PolyExp.app/Contents/MacOS/visual 
im=$basedir/bin/PolyExp.app/Contents/Resources/resource.im
stimdir=$basedir/stimages

for imfile in `ls $stimdir/*$1*`
do
	system=`basename $imfile .im`
	echo "analyzing... $system"

		command="[|an| 
				Undeclared class superclass methodDictionary 
					at: #purgeUnusedBindings 
					put: (Undeclared class superclass methodDictionary at: #asString).

				Store.DbRegistry 
					connectTo: ((Store.ConnectionProfile new) name: 'bern'; 
					driverClassName: #PostgreSQLEXDIConnection; 
					environment: 'db.iam.unibe.ch:5432_scgStore'; 
					userName: 'storeguest'; 
					password: 'storeguest'; 
					tableOwner: 'BERN'; 
					yourself). 
				(Store.Bundle new name: 'Mircea-Experiments') mostRecentVersion loadSrc.
				an := PolymorphismAnalyzer forModelNamed: '$system'. 
				an visualizeInSnaut.
				self halt.
				
			] 
			on: Error do: [:e| '$msefile - error', e printString]."

		echo evaluating...
		$app $imfile -evaluate "$command"
done

