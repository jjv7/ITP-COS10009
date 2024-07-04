require 'gosu'
require './entity_handling.rb'
require './drawing_stuff.rb'
require './shop.rb'

#---------------------------Zombie Home Defender--------------------------#
# Jayden Kong
# 104547242
#
#
# Instructions:
#
# Use the left and right arrow keys to switch lanes
#
# Press the spacebar to shoot
#
# Press the Z button to bring up the shop menu
#
# Press the X button to close the shop menu
#
# Use the number keys (not the numpad) to buy the items listed in the shop
#
# Press escape to exit the program
#
#-------------------------------------------------------------------------#


# constants
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 800
NUM_LANES = 7
LANE_WIDTH = WINDOW_WIDTH / NUM_LANES

# Enums for the z-values of objects
module ZOrder
  BACKGROUND, ZOMBIE, PLAYER, UI = *0..3
end

# Enums for the game state
module Game_state
  MAINMENU, GAME, DEAD, SHOP = *0..3
end

# Structs for the player, bullets, zombies, barricades and shop items. They act similar to classes with an initialize method.
Player = Struct.new(:x, :y, :image, :score, :hiscore, :multiplier, :lives, :coins, :barricades, :livesbought, :gamestate, :enemy_speed_increase, :enemy_health_increase, :break_speed_increase)
Bullet = Struct.new(:x, :y, :speed, :image)
Zombie = Struct.new(:x, :y, :speed, :health, :break_speed, :image, :coins_given, :score_given)
Barricade = Struct.new(:x, :y, :health)
ShopItem = Struct.new(:name, :cost)

# Loads in the hiscore from a file
def load_hiscore
  if File.exist?("hiscore.txt") # Checks if the hiscore file exists
    hiscore_file = File.new("hiscore.txt", "r") # Opens hiscore file in read mode
    hi_score = hiscore_file.gets().to_i # Reads in hiscore and changes it to an integer
    hiscore_file.close # Closes file to save resources during gameplay
    return hi_score # Hiscore is set to the value obtained from file
  else
    return 0 # Hiscore is set to 0 if the file does not exist
  end
end

# Updates the displayed hiscore
def update_hiscore
  # Makes the hiscore equal to the current score if it the current score is higher than the hiscore
  if @player.score > @player.hiscore
    @player.hiscore = @player.score
  end
end

# Saves the current hiscore to the hiscore file when the player dies
def save_hiscore
  hiscore_file = File.new("hiscore.txt", "w") # Opens hiscore file in write mode to delete the previous hiscore. If there is no file, creates a new one.
  hiscore_file.write(@player.hiscore) # Writes in the current hiscore
  hiscore_file.close
end



class GameWindow < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = 'Zombie Home Defender'

    # Creates an array for shop items and fills the array with shop items
    @shop_items = []
    load_shop_items

    # Loads the hiscore from a file and the player image. Creates an instance of the player struct.
    hiscore = load_hiscore
    player_image = Gosu::Image.new('sprites/pistol.png')
    @player = Player.new(WINDOW_WIDTH / 2, WINDOW_HEIGHT - 150, player_image, 0, hiscore, 1, 5, 0, 3, 0, Game_state::MAINMENU, 1, 1, 1)

    # Creates arrays to store instances of the bullets, zombies and barricades during gameplay
    @bullets = []
    @zombies = []
    @barricades = []

  end

  def update
    # Case for gamestate is used to separate the update looping for different states
    case @player.gamestate
    when Game_state::MAINMENU
      if button_down?(Gosu::KbEnter) || button_down?(Gosu::KbReturn) # Pressing enter starts the game. On some keyboards, this is apparently the return key.
        @player.gamestate = Game_state::GAME
      end
    when Game_state::GAME
      if button_down?(Gosu::KbZ) # Originally used KbS for this which caused the shop to sometimes open and close quickly since the same key was used to exit the shop
        @player.gamestate = Game_state::SHOP
      end
      # See entity_handling for more information on these
      update_bullets # Moves all the bullets in the array up the screen
      spawn_zombies_random # Spawns in zombies
      update_zombies # Moves all zombies down, also checks for collision with a barricade
      check_bullet_zombie_collision #checks for a collision between a bullet and a zombie
      check_zombie_player_collision #checks for a collision between a zombie and a player
      remove_entities # Removes all offscreen entities to save resources
      update_hiscore # Replaces old hiscore with current hiscore if it is higher
    when Game_state::DEAD
      save_hiscore
    when Game_state::SHOP
      # Nothing in game is updated due to the case for gamestate separating the update loops. This effectively pauses the game.
      if button_down?(Gosu::KbX)
        @player.gamestate = Game_state::GAME
      end
      handle_shop_input # See shop.rb
    end
  end

  def draw
    # Case for gamestate is used to separate the draw looping for different states
    case @player.gamestate
    when Game_state::MAINMENU
      draw_mainmenu # Draws the name of the game and a prompt for the player to press 'enter'
    when Game_state::GAME
      # See drawing_stuff.rb for more information on these
      draw_background # Draws the 7 lanes the zombies will go down and the roof of the house
      draw_player # Draws the player
      draw_bullets # Draws the bullets currently in the array
      draw_zombies # Draws the zombies currently in the array
      draw_barricades # Draws the barricades currently in the array in the middle of its lane
      display_UI # Draws all the UI elements such as the number of coins the current score
    when Game_state::DEAD
      draw_game_over_screen # Shows a black game over screen and displays the players current score and hiscore.
    when Game_state::SHOP
      # The player should still see the amount of things such as coins they have to purchase the items, so the game background and UI still needs to be drawn here
      draw_background
      display_UI
      draw_shop_menu
    end
  end

  def button_down(id)
    close if id == Gosu::KbEscape # Closes the program if the escape key is pressed

    if button_down?(Gosu::KbLeft) && @player.x > LANE_WIDTH && @last_button != Gosu::KbLeft
      @player.x -= LANE_WIDTH # Moves the player across two halves of a lane, so 1 lane width
    end

    # Checks that the player is not on the rightmost lane and that they are not holding down the right arrow key from a previous lane change
    if button_down?(Gosu::KbRight) && @player.x < WINDOW_WIDTH - LANE_WIDTH && @last_button != Gosu::KbRight
      @player.x += LANE_WIDTH # Moves the player across two halves of a lane, so 1 lane width
    end

    # Checks if the gamestate is in GAME to prevent prefiring zombies from the MAINMENU. There is no cooldown for firing, but you need to reinitiate the keypress for this
    if id == Gosu::KbSpace && @player.gamestate == Game_state::GAME
      shoot_bullet # see entity_handling.rb for this
    end

    # Checks if the gamestate is in GAME to prevent preplacing barricades from the MAINMENU
    if id == Gosu::KbB && @player.gamestate == Game_state::GAME
      place_barricade # see entity_handling.rb for this
    end


  end
end

window = GameWindow.new
window.show