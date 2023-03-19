#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#get username
echo "Enter your username:"
read USERNAME

#get username from db
USER_ID=$($PSQL "SELECT name FROM users WHERE name = '$USERNAME';")

#get games played
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(u_id) WHERE name = '$USERNAME';")

#get best game (guess)
BEST_GUESS=$($PSQL "SELECT MIN(guesses) FROM users INNER JOIN games USING(u_id) WHERE name = '$USERNAME';")

#if user present
if [[ -z $USER_ID ]]; 
  then
  #insert to users table
  INSERTED_TO_USERS=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME');")
  #if u_name not present in db
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  #get user_id
  # USER_ID=$($PSQL "SELECT u_id FROM users WHERE name = '$USERNAME';")
  # echo $USER_ID
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."
fi

#secret number
SECRET=$((1 + $RANDOM % 1000))

#count guesses
TRIES=1

#guess number
# GUESSED=0
echo "Guess the secret number between 1 and 1000:"
echo $SECRET
while read GUESS
do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
    echo "That is not an integer, guess again:"
    else 
    if [[ $GUESS -eq $SECRET ]]
      then
      break;
      else 
        if [[ $GUESS -gt $SECRET ]]
        then
        echo -e "\nIt's lower than that, guess again:"
        elif [[ $GUESS -lt $SECRET ]]
        then
        echo -n "It's higher than that, guess again:"
      fi
    fi
  fi
  TRIES=$(( $TRIES + 1 ))
done

if [[ $TRIES == 1 ]] 
  then
    echo "You guessed it in $TRIES tries. The secret number was $SECRET. Nice job!"
  else
    echo "You guessed it in $TRIES tries. The secret number was $SECRET. Nice job!"
fi

USER_ID=$($PSQL "SELECT u_id FROM users WHERE name = '$USERNAME';")
#insert into db
INSERTED_TO_GAMES=$($PSQL "INSERT INTO games(guesses, u_id) VALUES($TRIES, $USER_ID)")
GUESSED=1
