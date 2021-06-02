# install.packages("RPostgres")
require("RPostgres")
library(tidyverse)

# create a connection

# keep the password in another script
pw <- {
  "new_user_password"
}

# loads the Postgres driver
drv <- dbDriver("Postgres")

# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "projekt1",
                 host = "localhost", port = 5432,
                 user = "postgres", password = pw)

# check for the specific table
dbExistsTable(con, "film_actor")
# TRUE   - we are expecting true if it appears

# below you can type Postgres commands to get data from database
df_postgres <- dbGetQuery(con, 
"select
  actor2.actor_id,
  count(film_actor.film_id) as ilosc_filmow
from film_actor 	
  join(
   select
    actor.actor_id
  from actor) actor2
    on film_actor.actor_id = actor2.actor_id 
group by 1")

df_postgres 

# how to add table to our data base, for example like this

df_postgres %>%  mutate(extra= actor_id * 10) -> new_table


# writes df to the Postgre database "postgres", table "new_table_db" 
dbWriteTable(con, "new_table_db", 
             value = new_table, append = TRUE, row.names = FALSE)

#let's check if it works
df_postgres <- dbGetQuery(con, "SELECT * from new_table_db")

#at the end, we should close our connection and unload driver
dbDisconnect(con)
dbUnloadDriver(drv)
