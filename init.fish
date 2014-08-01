#!/usr/bin/fish

cd players
set -l pl "../playerlist.txt"

echo "Compiling files"
for i in * 
    if test -e $i/$i.java 
        echo -n "$i: Compiling Java.."
        gcj --main=$i -o $i/$i $i/$i.java
	
	if not grep -q $i $pl
	   echo -n "Adding to playlist..." 
	   echo players/$i/$i >> $pl 
	end
	echo
    else if test -e $i/$i.cs
        echo -n "$i: Compiling .NET.."
        mcs $i/$i.cs

	if not grep -q $i $pl
	   echo -n "Adding to playlist..." 
	   echo players/$i/$i.exe >> $pl 
	end
	echo
    else if not grep -q $i $pl -a 
         if test -r $i/$i.list
	    echo "$i: Adding to playlist..."
	    cat $i/$i.list >> $pl
	 else if not test -z (ls $i)
	    echo "WARNING  $i doesn't exist in playlist"
	 end 
    end
end
