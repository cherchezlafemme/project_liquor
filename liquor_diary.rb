require 'sqlite3'

#BUSINESS LOGIC:

def create_database (username)
db = SQLite3::Database.new("#{username}.db")
db.results_as_hash = true
db
end

#Table creators:
create_table_whiskey = <<-SQL
  CREATE TABLE IF NOT EXISTS whiskeys(
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255),
    aged INT,
    producer VARCHAR(255),
    comments VARCHAR(255),
    rating INT
  )
SQL

create_table_wine = <<-SQL
  CREATE TABLE IF NOT EXISTS wines(
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    grape VARCHAR(255),
    year INT,
    producer VARCHAR(255),
    country VARCHAR(255),
    comments VARCHAR(255),
    rating INT
  )
SQL

def match_liqour_type_to_diary(liquor_type, db)
  if liquor_type.downcase == "whiskey"
    db.execute(create_table_whiskey)
  elsif liquor_type.downcase == "wine"
    db.execute(create_table_wine)
  else puts "Sorry, we are working on expanding our liquor options for your diaries. Stay tunned!"
  end
end

#USER INTERACTION:
#Ask for the users name
  puts "What is your username?"
  username = gets.chomp
#Ask for the liquor type
  puts "What diary do you want to create or access? Wine or whiskey?"
  liquor_type = gets.chomp
#Create a database for the user
  create_database(username)
  user_db = create_database(username)
#Match the liquor type with the database
  match_liqour_type_to_diary(liquor_type, user_db)



