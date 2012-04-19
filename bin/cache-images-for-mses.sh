#!/bin/bash

basedir=`cd .. && pwd`
app=$basedir/bin/PolyExp.app/Contents/MacOS/visual 
im=$basedir/bin/PolyExp.app/Contents/Resources/resource.im
stimdir=$basedir/stimages

for msefile in `ls $basedir/mse/*.mse`
do
	echo "building image for ..." $msefile
	system=`basename $msefile .mse`
	if [ -e $stimdir/$system.im ]
	then
		echo $system is already cached
	else
		echo system is ... $system 
		command="[|an| 
			an := PolymorphismAnalyzer forFile: '$msefile'. 
			Snapshot new saveAs: '$stimdir/$system' thenQuit: false.
			] 
			on: Error do: [:e| '$msefile - error', e printString]."

		$app $im -evaluate "$command"
	fi
done


