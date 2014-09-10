#!/bin/sh
cp -r ./htdocs $1
cp -r ./src $1
if test -z $2
then
	echo 'oops:: you shuld define second args as APP_NAME'
else
	grep -lr "APP_NAME" $1 | grep -v '.svn' | xargs perl -pi -e "s/APP_NAME/$2/g"
	echo 'hey! okay!'
fi


