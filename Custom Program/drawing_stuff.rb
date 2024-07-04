# Draws the zombies. .each cycles through each zombie in the @zombies array. Parentheses basically replace the 'do' required
def draw_zombies
    @zombies.each { |zombie| zombie.image.draw(zombie.x - zombie.image.width / 2, zombie.y - zombie.image.height / 2, ZOrder::ZOMBIE) }
end

# Draws the bullets. .each cycles through each bullet in the array. Parentheses basically replace the 'do' required
def draw_bullets
    @bullets.each { |bullet| bullet.image.draw(bullet.x - bullet.image.width / 2, bullet.y - bullet.image.height / 2, ZOrder::ZOMBIE) }
end

# Draws the player
def draw_player
    @player.image.draw(@player.x - @player.image.width / 2, @player.y - @player.image.height / 2, ZOrder::PLAYER)
end

# Draws the barricades. .each cycles through each barricade in the array. Parentheses basically replace the 'do' required
def draw_barricades
    # This is not perfectly placed, as the quotient of the screen wdith and the number of lanes is not a whole number. Barricades are drawn in the background so speedy zombies look like they climb over them.
    @barricades.each { |barricade| draw_rect(barricade.x - LANE_WIDTH / 2, barricade.y, LANE_WIDTH, 10, Gosu::Color::rgb(102, 51, 0), ZOrder::BACKGROUND) } 
end

# Draws the background of the game
def draw_background
    draw_rect(0, 0, 800, 700, Gosu::Color::GREEN, ZOrder::BACKGROUND) # Draws a green rectangle for the 7 lanes
    draw_rect(0, 700, 800, 100, Gosu::Color::RED, ZOrder::PLAYER) # Draws the roof as a red rectangle. Z value is set to player, so zombies go under it. Separate space to put in UI elements.
    draw_rect(0, 700, 800, 3, Gosu::Color::BLACK, ZOrder::UI) # Draws a line for the roof to act as a border for the roof
end

# 1 Line procedure to draw out UI elements, it saves a slight bit of typing.
def draw_UI (font_size, text, x, y)
    Gosu::Font.new(font_size).draw_text(text, x, y, ZOrder::UI)
end

# Displays all the UI elements on the "roof" during gameplay
def display_UI
    draw_UI(20, "Score: #{@player.score}", 10, 725) # Draws the current score
    draw_UI(20, "Lives: #{@player.lives}", 700, 725) # Draws the current lives
    draw_UI(20, "Coins: #{@player.coins}", 700, 750) # Draws the current coins
    draw_UI(20, "Hi-score: #{@player.hiscore}", 10, 750) # Draws the high score
    draw_UI(20, "Barricades: #{@player.barricades}", 500, 740) # Draws the currently held barricades
    draw_UI(20, "Score multiplier: x#{@player.multiplier}", 200, 743) # Draws the current score multiplier
end

# Draws the main menu
def draw_mainmenu
    draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, Gosu::Color::BLACK, ZOrder::UI) # Makes a black background for a simple main menu

    title_text = "Zombie Home Defender"
    title_font = Gosu::Font.new(50)
    title_width = title_font.text_width(title_text) # Gets the width of the title
    x = (WINDOW_WIDTH - title_width) / 2 # Puts the title in the middle of the width of the screen
    y = WINDOW_HEIGHT / 2 - title_font.height / 2 # y-pos of the title defines the y-pos of the other elements on the main menu
    title_font.draw_text(title_text, x, y, ZOrder::UI, 1, 1, Gosu::Color::WHITE)

    start_text = "Press ENTER to start"
    start_font = Gosu::Font.new(30)
    start_width = start_font.text_width(start_text) # gets the width of the prompt
    start_x = (WINDOW_WIDTH - start_width) / 2 # Puts the prompt in the middle of the width of the screen
    start_y = y + title_font.height + 20 # Moves the y-pos of the prompt to 20 pixels below the y-pos of the title
    start_font.draw_text(start_text, start_x, start_y, ZOrder::UI, 1, 1, Gosu::Color::WHITE)
end

#Draws the death screen
def draw_game_over_screen
    draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, Gosu::Color::BLACK, ZOrder::UI) # Makes a black background for a simple death screen

    game_over_text = "YOU DIED!"
    game_over_font = Gosu::Font.new(50)
    game_over_width = game_over_font.text_width(game_over_text) # gets the width of the 'Game Over'
    x = (WINDOW_WIDTH - game_over_width) / 2 # Puts the 'Game Over' in the middle of the wdith of the screen
    y = WINDOW_HEIGHT / 2 - game_over_font.height / 2 # y-pos of the game over text defines the y-pos of the other elements of the death screen
    game_over_font.draw_text(game_over_text, x, y, ZOrder::UI, 1, 1, Gosu::Color::RED)
    
    score_text = "Score: #{@player.score}"
    score_font = Gosu::Font.new(30)
    score_width = score_font.text_width(score_text) # Gets the width of the score text to be displayed
    score_x = (WINDOW_WIDTH - score_width) / 2 # Puts the final score in the middle of the width of the screen
    score_y = y + game_over_font.height + 20 # Puts the final score 20 pixels below the game over text
    score_font.draw_text(score_text, score_x, score_y, ZOrder::UI, 1, 1, Gosu::Color::RED)

    hiscore_text = "Hi-score: #{@player.hiscore}"
    hiscore_font = Gosu::Font.new(30)
    hiscore_width = hiscore_font.text_width(hiscore_text) # Gets the width of the hiscore text to be displayed
    hiscore_x = (WINDOW_WIDTH - hiscore_width) / 2 # Puts the hiscore in the middle of the width of the screen
    hiscore_y = score_y + score_font.height + 10 # Puts the hiscore 10 pixels below the final score text
    hiscore_font.draw_text(hiscore_text, hiscore_x, hiscore_y, ZOrder::UI, 1, 1, Gosu::Color::RED)
end

# Draws the shop menu
def draw_shop_menu
    draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT- 100, Gosu::Color::BLACK, ZOrder::UI)

    title = "Shop Menu"
    title_font = Gosu::Font.new(50)
    title_width = title_font.text_width(title) # Gets the width of the title
    title_x = (WINDOW_WIDTH - title_width) / 2 # Puts the title in the middle of the width of the screen
    title_y = 50 # y-pos of the title defines tge y-pos of the other elements of the shop menu
    title_font.draw_text(title, title_x, title_y, ZOrder::UI, 1, 1, Gosu::Color::WHITE)

    item_font = Gosu::Font.new(25)
    item_y = title_y + 100 # puts the first item in the shop menu 100 pixels below the title

    # Cycles through every item in the @shop_items array
    @shop_items.each do |item|
      item_text = "#{item.name} (#{item.cost} coins)" # text for the item number with its name and its price
      item_width = item_font.text_width(item_text) # Gets the width pf the item name and price 
      item_x = (WINDOW_WIDTH - item_width) / 2 # Puts the item text in the middle of the width of the screen
      item_font.draw_text(item_text, item_x, item_y, ZOrder::UI, 1, 1, Gosu::Color::WHITE)
      item_y += 50 # Moves the next item to be displayed down by 50 pixels
    end

    exit_prompt = "Press 'X' to exit the shop"
    exit_font = Gosu::Font.new(20)
    exit_width = exit_font.text_width(exit_prompt) # Gets the prompt's width
    exit_prompt_x = (WINDOW_WIDTH - exit_width) / 2 # Puts the prompt in the middle of the width of the screen
    exit_prompt_y = WINDOW_HEIGHT - 125 # Puts the prompt 125 pixels above the bottom of the screen
    exit_font.draw_text(exit_prompt, exit_prompt_x, exit_prompt_y, ZOrder::UI, 1, 1, Gosu::Color::WHITE)
end