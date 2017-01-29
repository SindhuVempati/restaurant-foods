require 'restaurant'
require 'support/string_extend'

class Guide
    class Config # class inside a class
      @@actions = ['list','find','add','quit']
      def self.actions; @@actions; end #reader method
    end

  def initialize(path=nil)
    # locate the restaurant text file at path
    # or create a new file
    # exit if create fails

    Restaurant.filepath = path

    if Restaurant.file_usable?
      puts "Found Restaurant File\n"
    elsif Restaurant.create_file
      puts "Created Restaurant file\n"
    else
      puts "Exiting!\n"
      exit!
    end

  end

  def launch! #strong method
  introduction  #Intro
  #Action Loop
  #   What can yo do? (list,find,add,quit)
  result=nil
  until result == :quit
    action, args = get_action                                            #   do that Action
    result = do_action(action, args)
  end                                          # repeat until user quits
                                              #break if result == :quit use unless instead of loop
  conclusion #conclusion

  end

  def get_action
    action = nil
    #keep asking for input until we get the valid action
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(",") if action
      print ">"
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action,args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift
      find(keyword)
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "Wrong Command!!\n"
    end

  end

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ['name','cuisine','price'].include?(sort_order)

    output_action_header("Listing Restaurants")

    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1,r2|
      case sort_order
      when 'name'
      r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
      r1.cuisine.downcase <=> r2.cuisine.downcase
      when 'price'
      r1.price.to_i <=> r2.price.to_i

      end
    end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine/price' or 'list by cuisine/price'\n\n"
  #  restaurants.each do |rest|
  #  puts rest.name + "|" +rest.cuisine + "|" + rest.formatted_price
    end
  end

  def add
    output_action_header("Add a Restaurant")
    restaurant = Restaurant.build_using_questions

    if restaurant.save
      puts "\n Restaurant Added\n\n"
    else
      puts "\n\ Save Error: Restaurant not added\n\n"
    end

  end

  def introduction
    puts "\n\n...<<<Welcome to the Food Finder!>>>...\n\n"
    puts "This is an interactive guide to help you the find the food.\n\n"
  end


  def conclusion
    puts "...<<<Thank you!! Have a great day!!>>>...\n\n"
  end

  private

  def output_action_header(text)
    puts "\n #{text.upcase.center(60)}\n\n"
  end

  def find (keyword="")
    output_action_header("Find a Restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key phrase to search the restaurant list."
      puts "Examples: 'find Chipotle', 'find mexican' \n\n"
    end

  end

  def output_restaurant_table (restaurants=[])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".ljust(6) + "\n"
    puts "_"* 60
    restaurants.each do |rest|
      line = " " << rest.name.titelize.ljust(30)
      line << " " + rest.cuisine.titelize.ljust(20)
      line << " " + rest.formatted_price.rjust(6)
      puts line
    end
    puts "No listings found" if restaurants.empty?
    puts "_"* 60
  end
