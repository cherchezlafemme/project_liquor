#PSEUDOCODE
=begin
Program allows user create a database with their username as a title.
Database exist of the list of the liquor that user tried.
Allow user to: 
- add new liquor items to user's diary
- view the whole diary log
- see all the liquor that user rated excellent
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
    keep_using_program = false
    return keep_using_program
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
    puts "Wine name: #{wine_bottle['name']}"
    puts "Grape: #{wine_bottle['grape']}"
    puts "Year: #{wine_bottle['year']}"
    puts "Producer: #{wine_bottle['producer']}"
    puts "Country: #{wine_bottle['country']}"
    puts "Comment: #{wine_bottle['comments']}"
    puts "Rating: #{wine_bottle['rating']}"
    puts "\n"
end
end

def view_whiskey_diary(db)
  whiskey_library = db.execute("SELECT * FROM whiskeys")
  whiskey_library.each do |whiskey_bottle|
    puts "\n"
    puts "Whiskey name: #{whiskey_bottle['name']}"
    puts "Type: #{whiskey_bottle['type']}"
    puts "Years this whiskey was aged: #{whiskey_bottle['aged']}"
    puts "Producer: #{whiskey_bottle['producer']}"
    puts "Comment: #{whiskey_bottle['comments']}"
    puts "Rating: #{whiskey_bottle['rating']}"
    puts "\n"
end
end

def wine_great_rating(db)
  wine_library = db.execute("SELECT * FROM wines")
  puts "Wine you gave rating 8 and up:"
  wine_library.each do |wine_bottle| 
    if wine_bottle['rating'] >= 8
    puts "Wine name: #{wine_bottle['name']}; Vintage: #{wine_bottle['year']}"
    else
    end
  end
end

def whiskey_great_rating(db)
  whiskey_library = db.execute("SELECT * FROM whiskeys")
  puts "Whiskey you gave rating 8 and up:"
  whiskey_library.each do |whiskey_bottle| 
    if whiskey_bottle['rating'] >= 8
    puts "Whiskey name: #{whiskey_bottle['name']}; Type: #{whiskey_bottle['type']}"
    else 
    end
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

if match_liqour_type_to_diary(liquor_type, user_db) == false
else
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

  #See all the items you have in your liquor diary
  end_looking = false
  begin
  puts "Do you want to see your liquor diary log? y/n"
  see_diary_log = gets.chomp
    if see_diary_log.downcase == "y"
      if liquor_type.downcase == "wine"
      view_wine_diary(user_db)
      end_looking = true
      elsif liquor_type.downcase == "whiskey"
      view_whiskey_diary(user_db)
      end_looking = true
      else  puts "Sorry, we are working on expanding our liquor options for your diaries. Stay tunned!"
      end_looking = true
      end
    elsif see_diary_log.downcase == "n"
      end_looking = true
    else puts "Sorry, there must be an error. Let's try one more time!"
    end
  end until end_looking == true

  puts "Do you want to see the liquor you rated as excellent? y/n"
  see_excellent_rating = gets.chomp
  if see_excellent_rating == "y"
    if liquor_type.downcase == "wine"
    wine_great_rating(user_db)
    elsif liquor_type.downcase == "whiskey"
    whiskey_great_rating(user_db)
    else puts "Sorry, we are working on expanding our liquor options for your diaries. Stay tunned!"
    end
  else puts "Hope you will find some great bottles soon!"
  end
end
puts "Thank you for using our program!"

