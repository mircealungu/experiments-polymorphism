#!/bin/bash

basedir=`cd .. && pwd`
app=$basedir/bin/PolyExp.app/Contents/MacOS/visual 
im=$basedir/bin/PolyExp.app/Contents/MacOS/resource.im
stimdir=$basedir/bin/PolyExp.app/Contents/MacOS/visual 

for msefile in `ls $basedir/mse/*.mse`
do
	echo "building image for ..." $msefile
	system=`basename $msefile .mse`
	echo "will save new image in $stimdir/$system"
	command="[|an| an := PolymorphismAnalyzer forFile: '$msefile'. Snapshot new saveAs: '$stimdir/$system.im' thenQuit: true.] on: Error do: [:e| '$msefile - error', e printString]."
	#echo $command

	#$app $im -evaluate $command
done


