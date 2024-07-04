# Loads in the shop_items into the @shop_items array
def load_shop_items
    @shop_items << ShopItem.new("1. Barricade", 10) # Relatively cheap as zombies can easily break through it after some time
    @shop_items << ShopItem.new("2. Extra life", 100) # Slightly more expensive as it lets you play for much longer
    @shop_items << ShopItem.new("3. Score multiplier increase", 500) # Most expensive item as it increases the amount of score you get with no downsides
    @shop_items << ShopItem.new("4. Enemy speed increase (x2 score)", 50) # Increases enemy speed in exchange for x2 score
    @shop_items << ShopItem.new("5. Enemy health increase (x2 score)", 50) # Increases enemy health in exchange for x2 score
    @shop_items << ShopItem.new("6. Enemy barricade break speed increase (x2 score)", 50) # Increases the speed at which zombies can break through barricades in exchange for x2 score
end

# Handles the number keys pressed on the keyboard in exchange for shop items
def handle_shop_input
    # checks for last button, so it doesn't just instantly drain all the coins
    if button_down?(Gosu::Kb1) && @last_button != Gosu::Kb1 && @player.coins >= @shop_items[0].cost 
      @player.coins -= @shop_items[0].cost
      @player.barricades += 1
      @last_button = Gosu::Kb1
    end

    # checks for last button, so it doesn't just instantly drain all the coins, restricts buying limit to 2
    if button_down?(Gosu::Kb2) && @last_button != Gosu::Kb2 && @player.coins >= @shop_items[1].cost && @player.lives > 0 && @player.livesbought < 2
      @player.coins -= @shop_items[1].cost
      @player.lives += 1
      @player.livesbought += 1 # increases progress towards threshold by 1. This separate counter is needed or else the program can't tell if the threshold has been reached
      @last_button = Gosu::Kb2

      # Checks if threshold has been reached, then changes the text
      if @player.livesbought >= 2
        @shop_items[1].name = "MAX BOUGHT"
      end
    end

    # checks for last button, so it doesn't just instantly drain all the coins
    if button_down?(Gosu::Kb3) && @last_button != Gosu::Kb3 && @player.coins >= @shop_items[2].cost
      @player.coins -= @shop_items[2].cost
      @player.multiplier *= 2 # multiplies the current score multiplier by 2
      @last_button = Gosu::Kb3
    end

    # The threshold definition means this can only be bought once
    if button_down?(Gosu::Kb4) && @player.coins >= @shop_items[3].cost && @player.enemy_speed_increase == 1
      @player.coins -= @shop_items[3].cost
      @player.enemy_speed_increase += 0.5 # Zombie speed increases to 150% of base
      @player.multiplier *= 2 # multiplies the current score multiplier by 2

      # Checks if threshold has been reached, then changes the text
      if @player.enemy_speed_increase >= 1
        @shop_items[3].name = "MAX BOUGHT"
      end
    end

    # The threshold definition means this can only be bought once
    if button_down?(Gosu::Kb5) && @player.coins >= @shop_items[4].cost && @player.enemy_health_increase == 1
      @player.coins -= @shop_items[4].cost
      @player.enemy_health_increase += 0.5 # Zombie health increases to 150% of base
      @player.multiplier *= 2 # multiplies the current score multiplier by 2

      # Checks if threshold has been reached, then changes the text
      if @player.enemy_health_increase >= 1
        @shop_items[4].name = "MAX BOUGHT"
      end
    end

    # The threshold definition means this can only be bought once
    if button_down?(Gosu::Kb6) && @player.coins >= @shop_items[5].cost && @player.break_speed_increase == 1
      @player.coins -= @shop_items[5].cost
      @player.break_speed_increase += 1 # Zombie barricade break speed doubles
      @player.multiplier *= 2 # multiplies the current score multiplier by 2

      # Checks if threshold has been reached, then changes the text
      if @player.break_speed_increase >= 1
        @shop_items[5].name = "MAX BOUGHT"
      end
    end   

    @last_button = nil unless button_down?(Gosu::Kb1) || button_down?(Gosu::Kb2) || button_down?(Gosu::Kb3) # makes it so you have to release the key first before you can buy the same item again
end