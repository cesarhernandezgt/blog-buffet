#! /bin/bash



let itemsCount=$(xmllint --xpath 'count(//blogs/blog)' planet.xml)

echo "# Auto Generated Blog aggregator" > blog.md

for (( i=1; i <= $itemsCount; i++ )); do 

    
    URL=$(xmllint --xpath '//blog['$i']/feed/text()' planet.xml)
    AUTHOR=$(xmllint --xpath '//blog['$i']/author/text()' planet.xml)
    echo "Procesing [$AUTHOR] [$URL]"
    
    #Downloading the RSS file
    wget -q "$URL" -O temp.xml
    
    
    let blogsCounter=$(xmllint --xpath 'count(//item)' temp.xml)
    echo $blogsCounter
    
    for (( j=1; j <= $blogsCounter; j++ )); do 
    
        TITLE=$(xmllint --xpath '//item['$j']/title/text()' temp.xml)
        DESCRIPTION=$(xmllint --xpath '//item['$j']/description/text()' temp.xml)
        LINK=$(xmllint --xpath '//item['$j']/link/text()' temp.xml)
        DATE=$(xmllint --xpath '//item['$j']/pubDate/text()' temp.xml) 
    

      # echo "## $TITLE"             >> blog.md
      echo "## [$TITLE]($LINK)"    >> blog.md        
      echo "  - Author: $AUTHOR"   >> blog.md
      # echo "  - $LINK "            >> blog.md
      echo "  - $DATE "            >> blog.md
      
    done
    
done

