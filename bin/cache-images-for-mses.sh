#!/bin/bash

if [ $# -eq 0 ] ; then
    echo Usage: $0 images-subfolder
    exit 0
fi


basedir=`cd .. && pwd`
app=$basedir/bin/PolyExp.app/Contents/MacOS/visual 
im=$basedir/bin/PolyExp.app/Contents/Resources/resource.im
stimdir=$basedir/stimages/$1

for msefile in `ls $basedir/mse/$1/*.mse`
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


