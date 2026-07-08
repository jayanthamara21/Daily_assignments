#!/bin/bash
 
FILE="books.txt"
 
###########################################
# Display all books
###########################################
display_records() {
 
    echo "=========== Avaiable books ==========="
 
    cat "$FILE"
 
}
 
###########################################
# Search books
###########################################
search_books() {
 
    echo "Enter book Name:"
    read name
 
    if grep -i "$name" "$FILE"
    then
        echo "book Found"
    else
        echo "book Not Found"
    fi
 
}
 
###########################################
# Count books out of stocks
###########################################
count_books() {
 
    count=$(grep -c "book" "$FILE")
 
    echo "books out of stocks : $count"
 
}
 
###########################################
# Updating the stock status
###########################################
update_books() {
 
    echo "Enter book ID:"
    read id
 
    sed -i "/^$id,/ s/OutOfStock/Avaiable/" "$FILE"
 
    echo "updating the stock status"
 
}
 
###########################################
# Calculate the total inventory value
###########################################
calculate_value() {
 
    total=$(awk -F',' '$4=="Avaiable" {sum+=$5} END {print sum}' "$FILE")
 
    echo "Total inventory value : Rs.$total"
 
}
 
###########################################
# Display books by category
###########################################
category_records() {
 
    echo "Enter category:"
    read category
 
    awk -F',' -v category="$cate" '
 
    BEGIN{
        print "Display books by category:",cat
    }
 
    $3==cate{
        print $0
    }
 
    ' "$FILE"
 
}
 
###########################################
# Find the costliest book
###########################################
highest_book() {
 
    awk -F',' '
 
    BEGIN{
        max=0
    }
 
    {
        if($5>max)
        {
            max=$5
            emp=$2
        }
    }
 
    END{
        print "Find the costliest book :",emp
        print "book :",max
    }
 
    ' "$FILE"
 
}
 
###########################################
# Menu
###########################################
 
while true
do
 
echo
echo "====================================="
echo " View all books"
echo "====================================="
echo "1.Display books"
echo "2.Search books"
echo "3.Count Avaiable books"
echo "4.Update books"
echo "5.Calcualte total inventory value"
echo "6.Display book by category"
echo "7.find the costliest books"
echo "8.Exit"
 
echo "Enter Choice:"
read choice
 
case $choice in
 
1)
display_records
;;
 
2)
search_books
;;
 
3)
count_books
;;
 
4)
update_books
;;
 
5)
calculate_salary
;;
 
6)
category_records
;;
 
7)
highest_book
;;
 
8)
echo "Thank You"
break
;;
 
*)
echo "Invalid Choice"
 
esac
 
done
