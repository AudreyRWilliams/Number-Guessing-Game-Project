#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"


SECRET_NUMBER=$((RANDOM%999))
#echo $SECRET_NUMBER
NUM_OF_TRIES=1


echo "Enter your username:"
read USERNAME

#check if username in the user_data database
IN_DATABASE=$($PSQL "select username from user_data where username='$USERNAME'")
#echo "In database?" $IN_DATABASE
if [[ -z $IN_DATABASE ]]
then
echo "Welcome, $USERNAME! It looks like this is your first time here."

else
GAMES_PLAYED=$($PSQL "select count(*) from user_data where username='$USERNAME'")
BEST_GAME=$($PSQL "select min(number_tries) from user_data where username='$USERNAME'")
#echo "Games played:" $GAMES_PLAYED
#echo "Best game:" $BEST_GAME
echo "Welcome back," $USERNAME"! You have played" $GAMES_PLAYED "games, and your best game took"$BEST_GAME "guesses."
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS



while [ $GUESS != $SECRET_NUMBER ]
  do
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    if (( $GUESS > $SECRET_NUMBER ))
    then
    NUM_OF_TRIES=$((++NUM_OF_TRIES))
    echo "It's lower than that, guess again:" 
    read GUESS
    else    
      NUM_OF_TRIES=$((++NUM_OF_TRIES))
      echo "It's higher than that, guess again:"
      read GUESS
      fi
    else
      NUM_OF_TRIES=$((++NUM_OF_TRIES))
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  
  done

if (( $GUESS == $SECRET_NUMBER ))
   then
  echo "You guessed it in $NUM_OF_TRIES tries. The secret number was" $SECRET_NUMBER. Nice job!
  
  GAMES_PLAYED=$($PSQL "select count(*) from user_data where username='$USERNAME'")
  GAMES_PLAYED=$((++GAMES_PLAYED))
  INSERT_USER=$($PSQL "insert into user_data(username,games_played,number_tries) values('$USERNAME',$GAMES_PLAYED,$NUM_OF_TRIES)")
fi
