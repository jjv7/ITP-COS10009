# Moves the zombies down the lane, contains collision logic between the barricades and zombies
def update_zombies
    # Loops through each zombie in the array
    @zombies.each do |zombie|
      zombie.y += zombie.speed * @player.enemy_speed_increase # distance zombie moves is determined by its base speed and if the player has bought the speed increase item

      # Deletes offscreen zombies and takes away one life from the player
      if zombie.y > WINDOW_HEIGHT
        @zombies.delete(zombie)
        @player.lives -= 1

        # Changes the gamestate to DEAD if the player has no more lives
        if @player.lives == 0
          @player.gamestate = Game_state::DEAD
        end
      end

      # Collision logic between each barricade and the current zombie. Honestly, this can be its own procedure
      @barricades.each do |barricade|
        if Gosu.distance(barricade.x, barricade.y, zombie.x, zombie.y) < 20 # Checks if the x and y coordinates of the objects are within 20 pixels of each other
          if zombie.break_speed != 0 && barricade.health > 0 # The zombie break speed is checked here to see if the zombie is a speedy type, as speedy types just climb over the barricade
            barricade.health -= zombie.break_speed * @player.break_speed_increase # subtracts from the barricade health based on the base break speed and its multiplier
            if barricade.health > 0
              zombie.y -= zombie.speed * @player.enemy_speed_increase + 0.1  # Stops the zombie at the barricade if it exists and provides a bit of visual feedback for the zombie breaking the barricade
            end
          end
        end
      end
    end
end

# Spawns zombies randomly
def spawn_zombies_random
    # This sets the zombie spawn limits randomly based on the current score
    if @player.score >= 0 && @player.score < 500 
      zombie_spawn_limit = 5
    elsif @player.score >= 500 && @player.score < 5000
      zombie_spawn_limit = 10
    else
      zombie_spawn_limit = 20
    end

    # Spawns a random zombie in a delayed time interval if the current zombies in the array is less than the limit
    if @zombies.size < zombie_spawn_limit && rand(50) < 2
      lane = rand(NUM_LANES)
      # Spawns either a normal, speedy or tanky zombie based on a random number from 0 to 99. Allows for percentage based spawning to occur.
      # The stats for each zombie class could have been defined by a separate class for each type
      case rand(100)
      when 0..88 # 88% chance to spawn normal zombie
        zombie_speed = 2
        zombie_health = 5 * @player.enemy_health_increase
        break_speed = 1
        zombie_image = Gosu::Image.new('sprites/normal.png')
        coins_given = 1
        score_given = 10
        zombie = Zombie.new((lane + 0.5) * LANE_WIDTH, 0, zombie_speed, zombie_health, break_speed, zombie_image, coins_given, score_given)
        @zombies << zombie
      when 89..98 # 10% chance to spawn speedy zombie
        zombie_speed = 4
        zombie_health = 2 * @player.enemy_health_increase
        break_speed = 0
        zombie_image = Gosu::Image.new('sprites/speedy.png')
        coins_given = 5
        score_given = 20
        zombie = Zombie.new((lane + 0.5) * LANE_WIDTH, 0, zombie_speed, zombie_health, break_speed, zombie_image, coins_given, score_given)
        @zombies << zombie
      when 98..99 # 2% chance to spawn tanky zombie
        zombie_speed = 1
        zombie_health = 15 * @player.enemy_health_increase
        break_speed = 10
        zombie_image = Gosu::Image.new('sprites/tanky.png')
        coins_given = 10
        score_given = 50
        zombie = Zombie.new((lane + 0.5) * LANE_WIDTH, 0, zombie_speed, zombie_health, break_speed, zombie_image, coins_given, score_given)
        @zombies << zombie
      end
    end
end

# Makes a new bullet
def shoot_bullet
    bullet_image = Gosu::Image.new('sprites/bullet.png')
    bullet = Bullet.new(@player.x, @player.y, -30, bullet_image)
    @bullets << bullet
end

# Moves each bullet in the array up the screen
def update_bullets
    @bullets.each { |bullet| bullet.y += bullet.speed }
end

# Places a barricade in the middle of the screen across the player's current lane
def place_barricade
    # Checks if the player has a barricade and if the barricade placement limit of 5 has not been reached
    if @player.barricades > 0 && @barricades.size < 5
      lane = (@player.x / LANE_WIDTH).to_i # Gets the player's current lane
      
      # Places a barricade if there is no barricade in the player's current lane
      if @barricades.none? { |barricade| barricade.x == (lane + 0.5) * LANE_WIDTH } && @player.barricades > 0
        barricade = Barricade.new((lane + 0.5) * LANE_WIDTH, WINDOW_HEIGHT / 2, 200)
        @barricades << barricade
        @player.barricades -= 1
      end
    end
end

# Collision logic between zombies and the player, since it would look awkward for the player to just move through the zombie
def check_zombie_player_collision
    # Cycles through each zombie in the array
    @zombies.each do |zombie|
        # Checks if the zombie's coordinates are within 25 pixels of the player's coordinates
        if Gosu.distance(@player.x, @player.y, zombie.x, zombie.y) < 25 
        @zombies.delete(zombie)
        @player.lives -= 1

        # Changes the gamestate to dead if the player has no lives left
        if @player.lives == 0
          @player.gamestate = Game_state::DEAD
        end

        break
      end
    end
end

# Collision logic between the bullets and zombies
def check_bullet_zombie_collision
    # Cycles through each zombie in the array
    @zombies.each do |zombie|
      # Cycles through each bullet in the array
      @bullets.each do |bullet|
        if Gosu.distance(bullet.x, bullet.y, zombie.x, zombie.y) < 20 # Checks if the bullet's coordinates and within 20 pixels of the zombie's coordinates
          @bullets.delete(bullet)
          zombie.health -= 1

          # Removes the zombie if the zombie has no health, gives the player score depending on the type of zombie killed
          if zombie.health <= 0
            @zombies.delete(zombie)
            @player.score += zombie.score_given * @player.multiplier # Score the player gains depends on the zombie type and the current score multiplier
            @player.coins += zombie.coins_given
          end

          break
        end
      end
    end
end

# Removes the offscreen zombies and bullets to save resources. Removes barricades once they have no more health
def remove_entities
    @zombies.reject! { |zombie| zombie.y > WINDOW_HEIGHT } # removes zombies once they pass the roof
    @bullets.reject! { |bullet| bullet.y < 0 } # remove bullets once they pass the top of the screen
    @barricades.reject! { |barricade| barricade.health <= 0 } # removes barricades once they have no more health
end