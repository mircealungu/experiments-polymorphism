#!/bin/bash
echo running method statistics...

basedir=`cd .. && pwd`
app=$basedir/bin/PolyExp.app/Contents/MacOS/visual 
im=$basedir/bin/PolyExp.app/Contents/Resources/resource.im
stimdir=$basedir/stimages

metstatfile=$basedir/results/method-statistics.csv

for imfile in `ls $basedir/stimages/*.im`
do
	system=`basename $imfile .im`
	echo "analyzing... $system"

	if cat $metstatfile | grep -q $system
	then
		echo $system is already analyzed
	else
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
				an methodStatistics.
			] 
			on: Error do: [:e| '$msefile - error', e printString]."

		$app $imfile -evaluate "$command"
	fi
done
