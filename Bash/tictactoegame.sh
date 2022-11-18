#!/bin/bash

firstPlayer=O
secondPlayer=X
turns=1
pattern='^[1-9]$'
board=([1]=1 [2]=2 [3]=3 
       [4]=4 [5]=5 [6]=6 
       [7]=7 [8]=8 [9]=9)

drawBoard() {
    clear
    for i in 1 4 7; do
        j=$(($i+1))
        k=$(($i+2))
        echo " ${board[$i]}   ${board[$j]}   ${board[$k]} "
    done
}

turn() {
    echo "Wybierz pole (1 - 9): "
    read choice
    if ! [[ $choice =~ $pattern ]]; then
        echo "Nieprawdiłowe pole, wybierz jeszcze raz"
        turn
    elif ! [[ ${board[$choice]} =~ $pattern ]]; then
        echo "Zajęte pole, wybierz jeszcze raz"
        turn
    fi
    if [[ $((turns%2)) == 1 ]]; then
        board[$choice]=$firstPlayer
    else
        board[$choice]=$secondPlayer
    fi
    checkBoard
}

checkBoard() {
    if [[ $((turns%2)) == 1 ]]; then
        winner="Gracz 1"
    else
        winner="Gracz 2"
    fi
    for i in 1 4 7; do
        j=$(($i+1))
        k=$(($i+2))
        if [[ ${board[$i]} == ${board[$j]} ]] && [[ ${board[$j]} == ${board[$k]} ]]; then
            drawBoard
            echo "$winner wygrywa grę"
            exit 0
        fi
    done
    for i in 1 2 3; do
        j=$(($i+3))
        k=$(($i+6))
        if [[ ${board[$i]} == ${board[$j]} ]] && [[ ${board[$j]} == ${board[$k]} ]]; then
            drawBoard
            echo "$winner wygrywa grę"
            exit 0
        fi
    done
    if [[ ${board[1]} == ${board[5]} ]] && [[ ${board[5]} == ${board[9]} ]]; then 
        drawBoard
        echo "$winner wygrywa grę"
        exit 0
    elif [[ ${board[3]} == ${board[5]} ]] && [[ ${board[5]} == ${board[7]} ]]; then
        drawBoard
        echo "$winner wygrywa grę"
        exit 0
    fi
}

drawBoard
for i in {1..9}
do
    turn
    turns=$((turns+1))
    drawBoard
done
echo "Mamy remis"
