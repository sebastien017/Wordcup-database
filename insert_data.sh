#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams;")"
echo -e "Tables games and teams are empty.\n"

cat 'games.csv' | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then

    #Insert Teams names
    TEAM_WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"

    if [[ -z $TEAM_WINNER_ID  ]]
    then
      INSERT_WINNER_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"

      if [[ $INSERT_WINNER_TEAM == 'INSERT 0 1' ]]
      then
        echo "Insert into teams : $WINNER"
      fi
    fi

    TEAM_OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"

     if [[ -z $TEAM_OPPONENT_ID  ]]
    then
      INSERT_OPPONENT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"

      if [[ $INSERT_OPPONENT_TEAM == 'INSERT 0 1' ]]
      then
        echo "Insert into teams : $OPPONENT"
      fi
    fi

    #Insert into Games
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

    if [[ $WINNER_ID && $OPPONENT_ID ]]
    then
      INSERT_GAMES_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"

      if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
      then
        echo "Insert into games : $ROUND"
      fi
    fi

  fi
done
