#PSEUDOCODE
=begin
Program allows user create a database with their username as a title.
Database exist of the list of the liquor that user tried.
Allow user to: 
- add new liquor items to user's diary
- update existing item information
- view the whole diary log
- see all the liquor that user rated specific way
- view all the liquor that has the same grape, country, producer
- update a comment to the specific item in the library
=end

require 'sqlite3'

#BUSINESS LOGIC:

def create_database (username)
db = SQLite3::Database.new("#{username}.db")
db.results_as_hash = true
db
end

def match_liqour_type_to_diary(liquor_type, db)
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

  if liquor_type.downcase == "whiskey"
    db.execute(create_table_whiskey)
  elsif liquor_type.downcase == "wine"
    db.execute(create_table_wine)
  else puts "Sorry, we are working on expanding our liquor options for your diaries. Stay tunned!"
  end
end

def add_wine_to_diary(db)
  def insert_wine_to_diary(db, name, grape, year, producer, country, comments, rating)
    db.execute("INSERT INTO wines (name, grape, year, producer, country, comments, rating) VALUES (?, ?, ?, ?, ?, ?, ?)", [name, grape, year, producer, country, comments, rating])
  end
  puts "What is the name of the wine?"
  name = gets.chomp
  puts "What is the grape this wine is made of?"
  grape = gets.chomp
  puts "What is the vintage of this bottle of wine?"
  year = gets.chomp.to_i
  puts "Who is the producer of this wine?"
  producer = gets.chomp
  puts "What country this wine is from?"
  country = gets.chomp
  puts "Please, write the comment about this bottle of wine. Would you like to drink it again?"
  comments = gets.chomp
  puts "How would you rate this wine? From 1 to 10 where 10 means excellent bottle!"
  rating = gets.chomp.to_i
  insert_wine_to_diary(db, name, grape, year, producer, country, comments, rating)
end

def add_whiskey_to_diary(db)
  def insert_whiskey_to_diary(db, name, type, aged, producer, comments, rating)
  db.execute("INSERT INTO whiskeys (name, type, aged, producer, comments, rating) VALUES (?, ?, ?, ?, ?, ?)", [name, type, aged, producer, comments, rating])
  end
  puts "What is the name of this whiskey?"
  name = gets.chomp
  puts "What type is this whiskey? Bourbon, rye, single malt scotch?"
  type = gets.chomp
  puts "How many years this whiskey has been aged?"
  aged = gets.chomp.to_i
  puts "Who is the producer?"
  producer = gets.chomp
  puts "Please, write the comment about this bottle of whiskey. Would you like to drink it again?"
  comments = gets.chomp
  puts "How would you rate this whiskey? From 1 to 10 where 10 means excellent bottle!"
  rating = gets.chomp.to_i
  insert_whiskey_to_diary(db, name, type, aged, producer, comments, rating)
end

def view_wine_diary(db)
  wine_library = db.execute("SELECT * FROM wines")
  wine_library.each do |wine_bottle|
    puts "\n"
    puts "Name: #{wine_bottle['name']}"
    puts "Grape: #{wine_bottle['grape']}"
    puts "Year: #{wine_bottle['year']}"
    puts "Producer: #{wine_bottle['producer']}"
    puts "Country: #{wine_bottle['country']}"
    puts "Comment: #{wine_bottle['comments']}"
    puts "Rating: #{wine_bottle['rating']}"
    puts "\n"
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
#Match the liquor type with the database and create a table if it doesn't exist
  match_liqour_type_to_diary(liquor_type, user_db)

#Collect the data about the new entry in the diary and insert this data into the table
begin
puts "Do you want to add a new bottle of liquor to your diary? y/n"
add_new_liquor = gets.chomp
if add_new_liquor.downcase == "y"
  if liquor_type.downcase == "whiskey"
  add_whiskey_to_diary(user_db)
  elsif liquor_type.downcase == "wine"
  add_wine_to_diary(user_db)
  else puts "Sorry, we are working on expanding our liquor options for your diaries. Stay tunned!"
  end
elsif add_new_liquor.downcase == "n"
  puts "That's cool! Let's move on!"
else puts "Sorry, we didn't get it."
end
end until add_new_liquor.downcase == "n"

view_wine_diary(user_db)
#


# kittens = db.execute("SELECT * FROM kittens")
# kittens.each do |kitten|
#  puts "#{kitten['name']} is #{kitten['age']}"
# end

