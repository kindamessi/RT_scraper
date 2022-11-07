#!/bin/bash

###################################################################################
## Fix the stuff we scraped from Rotten Tomatoes                                 ##
## Takes a long time to run                                                      ##
## If you'd like, rewrite this with something that does a better job with regex, ##
## or only pull the things you need with the python                              ##
##                                                                               ##
## Nick Plank                                                                    ##
## St. Norbert College                                                           ##
## 11/7/2022                                                                     ##
###################################################################################

#set -x

myUser=$(whoami)

echo -ne "Name of movie: "
read movie
echo $movie

curDir=$(pwd)

if [ ! -d "/tmp/$movie" ];then
    echo "I can't find that movie.  These are the folders in /tmp you could choose from"
    cd /tmp
    echo ""
    ls -l -d */ | grep -v "com.apple" | grep -v "com.google" | grep -v "powerlog" | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print$0}' | sed 's/        //g' | sed 's|/||g'
    echo ""
    cd "$curDir"
    echo "What's the name of your movie? "
    read movie
else
    echo "We'll start processing the files!"
fi

revFile="/tmp/$movie/reviews.txt"
starFile="/tmp/$movie/starFile.txt"
userFile="/tmp/$movie/userFile.txt"
dateFile="/tmp/$movie/dateFile.txt"

touch "/tmp/$movie/stars.txt"
touch "/tmp/$movie/rev_clean.txt"
touch "/tmp/$movie/dates_clean.txt"
touch "/tmp/$movie/Ratings.txt"


cat "$revFile" | sed 's/<p class/\n/g' | sed 's/<\/p>/\n\n/g' | sed 's/="audience-reviews__review js-review-text clamp clamp-8 js-clamp" data-qa="review-text">//g' | sed 's/,//g' | sed 's/\n//g' | sed 's/="audience-reviews__review js-review-text clamp clamp-8 js-clamp" data-clamp="true" data-qa="review-text">//' | tr '\n' ' ' | sed 's/revNum/\nReview/g' >> "/tmp/$movie/rev_clean.txt"
cat "$starFile" | sed 's/<span class="/ /g' | sed 's/" data-qa="star-display">/\n/g' | sed 's/"><\/span> /\n/g' | sed 's/"><\/span><\/span>/\n/g' | sed 's/ //g' | sed 's/star-display/ star-display/g' | sed 's/"> /\n/g' >> "/tmp/$movie/stars.txt"
cat "$dateFile" | sed 's/<\/span>/\n/g' | sed 's/<span class="audience-reviews__duration" data-qa="review-duration">/ review /g' | sed 's/,//g' >> "/tmp/$movie/dates_clean.txt"


##accommodate commenters without accounts or verified users
totalNum=$(cat "/tmp/$movie/userFile.txt" | grep "audience-reviews__user-wrap" | tail -1 | sed 's/<\/div>//' | sed 's/<div class="audience-reviews__user-wrap">//' )

echo "Working on users..."
echo ""
touch "/tmp/$movie/author_num.txt"

num=1
while read line;
do
echo -ne "Working on $num/$totalNum\r"
namedUser=$(cat "/tmp/$movie/userFile.txt" | grep -A2 "$num<div class" | head -2 | grep "href" )
verifiedUser=$(cat "/tmp/$movie/userFile.txt" | grep -A4 "$num<div class" | head -4 | tail -1 | grep "data-qa" )

if [ -n "$namedUser" ]; then
    writeUser=$(cat "/tmp/$movie/userFile.txt" | grep "$num<div class" -A7  | head -7 | grep -A1 "audience-reviews__name" | sed 's/<a class="audience-reviews__name" data-qa="review-name" href="/User ID: /g' | sed 's/">//g' | sed 's/<div class="audience-reviews__name-wrap//g' )
    testUser=$(echo "$writeUser" | grep "user" )
    if [ -n "$testUser" ]; then
        echo "Review $num $testUser" >> "/tmp/$movie/author_num.txt"
    else
        writeUser=$(echo "$namedUser" | tail -1 | sed 's/<a href="/User ID: /' | sed 's/">//' ) 
        echo "Review $num $writeUser" >> "/tmp/$movie/author_num.txt"
    fi
    num=$(( $num + 1 ))
elif [ -n "$verifiedUser" ]; then
    userName=$(echo $verifiedUser | sed 's/<span class="audience-reviews__name" data-qa="review-name">/Verified User: /' | sed 's/<\/span>//' )
    echo "Review $num $userName" >> "/tmp/$movie/author_num.txt"
    num=$(( $num + 1 ))
elif [ $num -gt $totalNum ]; then
    break
else
    emptyUser=$(cat "/tmp/$movie/userFile.txt" | grep -A2 "$num<div class" | head -2 | grep "span" )
    if [ -n "$emptyUser" ]; then
        echo "Review $num User ID: Unregistered User" >> "/tmp/$movie/author_num.txt"
       num=$(( $num + 1 ))
    fi
fi
done < "/tmp/$movie/userFile.txt"

echo "Done working on $num/$totalNum"
echo "Done with users!"

##starRatings
echo "Working on ratings..."
echo ""

num=1
while read line;
do
echo -ne "Working on $num/$totalNum\r"
numTest=$(echo $line | grep "$num")
# echo $pos
if [ -n "$numTest" ]; then
    rating=0
    starNum=$(cat "/tmp/$movie/stars.txt" | grep -A6 "$num star-display" | head -6) 
    for opt in $starNum; do 
        #echo $opt
        full=$(echo $opt | grep "filled")
        #echo $full
        half=$(echo $opt | grep "half")
        #echo $half
        if [ -n "$full" ]; then
            rating=$(( $rating + 1 ))
        elif [ -n "$half" ]; then
            rating=$(echo "$rating" + ".5" | bc)
            break
        else
            rating="$rating"
        fi
    done
    echo "$num Rating: $rating" >> "/tmp/$movie/Ratings.txt"
    num=$(( $num + 1 )) 
elif [ $num -gt $totalNum ]; then
    break
fi



done < "/tmp/$movie/stars.txt"

echo ""
echo "Done working on $num/$totalNum"
echo "Done with Ratings!"

touch "/Users/$myUser/Desktop/$movie-Reviews.csv"

num=1

#not doing display name anymore
echo "Making your CSV"
echo ""
echo "Number,Author,Date,Rating,Review" >> "/Users/$myUser/Desktop/$movie-Reviews.csv"
while read line; 
do
    echo -ne "Working on $num/$totalNum\r"

    line_Test=$(cat "/tmp/$movie/rev_clean.txt" | grep "Review $num" | head -1)
    grab_auth=$(cat "/tmp/$movie/author_num.txt" | grep "Review $num" | head -1 | awk '{$1=$2=$3=$4=""; print$0}' )
    grab_date=$(cat "/tmp/$movie/dates_clean.txt" | grep "$num review" | head -1 | awk '{$1=$2=""; print$0}' )
    #grab_disp=$(cat $author | grep -A1 "Review $num" | head -2 | tail -1 | awk '{$1=$2=""; print$0}')
    grab_rate=$(cat "/tmp/$movie/Ratings.txt" | grep "$num Rating" | head -1 | awk '{ print $3 }')
    grab_rev=$(cat "/tmp/$movie/rev_clean.txt" | grep "Review $num" | awk '{$1=$2=""; print$0}' | head -1 )
    
 
    echo "$num","$grab_auth","$grab_date","$grab_rate","$grab_rev" >> "/Users/$myUser/Desktop/$movie-Reviews.csv"
    num=$(( $num + 1 ))
    if [ $num -gt $totalNum ]; then
        break
    fi

done < "/tmp/$movie/rev_clean.txt"
echo ""
echo "All done!"

#cleanup

#rm /tmp/stars.txt
#rm /tmp/Ratings.txt
#rm /tmp/rev_clean.txt