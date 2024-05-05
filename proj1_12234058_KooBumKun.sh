#! /bin/bash
id=12234058
name='BumKun Koo'
menu[0]="Get the data of Heung-Min Son\'s Current Club, Appearances, Goals, Assists in players.csv"
menu[1]="Get the team data to enter a league position in teams.csv"
menu[2]="Get the Top-3 Attendance matches in mateches.csv"
menu[3]="Get the team\'s league position and team\'s top scorer in teams.csv & players.csv"
menu[4]="Get the modified format of date_GMT in matches.csv"
menu[5]="Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
menu[6]="Exit"
function menu1() {
        read -p "Do you want to get the Heung-Min Son's data? (y/n) : " answer
        if [ $answer == "y" ]
        then
                echo ""
                cat $1 | awk -F"," '$1~"Heung-Min"{printf("Team:%s, Appearance:%d, Goal:%d, Assist:%d\n", $4, $6, $7, $8)}'
                echo ""
        else
                echo ""
        fi
}
function menu2() {
        read -p "What do you want to get the team data of league_position[1-20] : " answer
        echo ""
        cat $1 | awk -F"," -v a=$answer '$6==a{printf("%d %s %f\n", $6, $1, $2/($2+$3+$4))}'
        echo ""
}
function menu3() {
        read -p "Do you want to know Top-3 attendance data and avarage attendance? (y/n) : " answer
        if [ $answer == "y" ]
        then
                echo ""
                echo "***Top-3 Attendance Match***"
                echo ""
                cat $1 | sort -n -r -t"," -k 2 | head -n 3 | awk -F"," '{printf("%s vs %s (%s)\n%d %s\n\n",$3,$4,$1,$2,$7)}'
        else
                echo ""
        fi
}
function menu4() {
        read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " answer
        if [ $answer == "y" ]
        then
                IFS=$'\n'
                count=0
                for team in $(cat $1 | sort -n -t"," -k 6 | awk -F"," '{printf("%s\n",$1)}' | tail -n 20)
                do
                        let count=count+1
                        echo ""
                        cat $2 | tail -n 570 | awk -F"," -v t=$team '$4==t{printf("%s,%d\n", $1, $7)}' | sort -t"," -n -r -k 2 | head -n 1 | awk -F"," -v team=$team -v position=$count '{printf("%d %s\n%s %d\n",position, team, $1, $2)}'
                done
                echo ""
        else
                echo ""
        fi

}
function menu5() {
        read -p "Do you want to modify the format of date? (y/n) : " answer
        if [ $answer == "y" ]
        then
                IFS=$'\n'
                echo ""
                for date in $(cat $1 | tail -n 380 | head -n 10 | awk -F"," '{print $1}')
                do
                        echo $date | awk '{printf("%d/%s/%d %s\n", $3, $1, $2, $5)}' | sed 's/Aug/08/g' | sed 's/Sep/09/g' | sed 's/Oct/10/g' | sed 's/Nov/11/g' | sed 's/Dec/12/g' | sed 's/Jan/01/g' | sed 's/Feb/02/g' | sed 's/Mar/03/g' | sed 's/Apr/04/g' | sed 's/May/05/g'
                done
                echo ""
        else
                echo ""
        fi
}
function menu6() {
        IFS=$'\n'
        PS3="Enter your team number : "
        select team in $(cat $1 | tail -n 20 | awk -F"," '{print $1}')
        do
                max=0
                for score in $(cat $2 |  awk -F"," -v home=$team '$3==home{printf("%d\n", $5-$6)}')
                do
                        if [ $score -gt $max ]
                        then
                                max=$score
                        fi
                done
                echo ""
                cat $2 | awk -F"," -v home=$team -v dif=$max '$3==home && dif==$5-$6{printf("%s\n%s %d vs %d %s\n", $1, $3, $5, $6, $4)}'
                echo ""
                break
        done
}
function menu7() {
        echo "Bye!"
        echo ""
        exit 0
}
if [ $# -ne 3 ]
then
        echo "usage: $0 file1 file2 file3"
        exit 1
else
        echo "************OSS1 - Project1************"
        echo "*     StudentID : $id            *"
        echo "*     Name : $name               *"
        echo "***************************************"
        echo
fi
while true
do
echo "[MENU]"
for choice in $(seq 0 6)
do
        echo $((choice+1)). ${menu[$choice]}
done
read -p "Enter your CHOICE (1~7) : " answer
        if [ $answer == "1" ]
        then
                menu1 $2
        elif [ $answer == "2" ]
        then
                menu2 $1
        elif [ $answer == "3" ]
        then
                menu3 $3
        elif [ $answer == "4" ]
        then
                menu4 $1 $2
        elif [ $answer == "5" ]
        then
                menu5 $3
        elif [ $answer == "6" ]
        then
                menu6 $1 $3
        elif [ $answer == "7" ]
        then
                menu7
        fi
done
