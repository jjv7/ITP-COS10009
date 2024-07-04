require 'rubygems'
require 'gosu'
require './album_file_reader.rb'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end

end

# Put your record definitions here




class MusicPlayerMain < Gosu::Window


	def initialize
	    super 810, 600
	    self.caption = "Music Player"
		@track_font = Gosu::Font.new(25)
		@albums = read_file()
		@album_selected = 0
		@album_id = 0
    	@album = @albums[@album_selected]
		@track_selected = -1
		@location = @album.tracks[@track_selected].location.chomp
		@song_playing = false
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		
	end

	  # Put in your code here to load albums and tracks
	def read_file()
		albums_file = File.new("albums.txt", "r")
		albums = read_albums(albums_file)
		albums_file.close
		return albums
	end


  # Draws the artwork on the screen for all the albums

  def draw_albums(albums)
    album1_art = ArtWork.new(albums[0].art)
	album1_art.bmp.draw(10, 10, z = ZOrder::PLAYER)
	album1_art.bmp = nil
	
	album2_art = ArtWork.new(albums[1].art)
	album2_art.bmp.draw(10, 285, z = ZOrder::PLAYER)
	album2_art.bmp = nil

	album3_art = ArtWork.new(albums[2].art)
	album3_art.bmp.draw(285, 10, z = ZOrder::PLAYER)
	album3_art.bmp = nil

	album4_art = ArtWork.new(albums[3].art)
	album4_art.bmp.draw(285, 285, z = ZOrder::PLAYER)
	album4_art.bmp = nil
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track.

  def area_clicked(mouse_x, mouse_y)
     # complete this code
		if (mouse_x > 10 && mouse_x < 260) && (mouse_y > 10 && mouse_y < 260)
			return 0
		end
		if (mouse_x > 10 && mouse_x < 260) && (mouse_y > 285 && mouse_y < 535)
			return 1
		end
		if (mouse_x > 285 && mouse_x < 535) && (mouse_y > 10 && mouse_y < 260)
			return 2
		end
		if (mouse_x > 285 && mouse_x < 535) && (mouse_y > 285 && mouse_y < 535)
			return 3
		end

		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 10 && mouse_y < 35) && (@albums[@album_id].tracks.length >= 1)
			return 4
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 35 && mouse_y < 60) && (@albums[@album_id].tracks.length >= 2)
			return 5
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 60 && mouse_y < 85) && (@albums[@album_id].tracks.length >= 3)
			return 6
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 85 && mouse_y < 110) && (@albums[@album_id].tracks.length >= 4)
			return 7
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 110 && mouse_y < 135) && (@albums[@album_id].tracks.length >= 5)
			return 8
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 135 && mouse_y < 160) && (@albums[@album_id].tracks.length >= 6)
			return 9
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 160 && mouse_y < 185) && (@albums[@album_id].tracks.length >= 7)
			return 10
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 185 && mouse_y < 210) && (@albums[@album_id].tracks.length >= 8)
			return 11
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 210 && mouse_y < 235) && (@albums[@album_id].tracks.length >= 9)
			return 12
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 235 && mouse_y < 260) && (@albums[@album_id].tracks.length >= 10)
			return 13
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 260 && mouse_y < 285) && (@albums[@album_id].tracks.length >= 11)
			return 14
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 285 && mouse_y < 310) && (@albums[@album_id].tracks.length >= 12)
			return 15
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 310 && mouse_y < 335) && (@albums[@album_id].tracks.length >= 13)
			return 16
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 335 && mouse_y < 360) && (@albums[@album_id].tracks.length >= 14)
			return 17
		end
		if (mouse_x > 545 && mouse_x < 805) && (mouse_y > 360 && mouse_y < 385) && (@albums[@album_id].tracks.length >= 15)
			return 18
		end
	end



  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos)
  		@track_font.draw_text(title, 545, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def display_tracks(album_id)
	count = @albums[album_id].tracks.length
	i = 0
	ypos = 10
	while i < count
		display_track(@albums[album_id].tracks[i].name, ypos)
		ypos += 25
		i += 1
	end
  end

  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track_number, album_selected)
  		@song = Gosu::Song.new(@albums[album_selected].tracks[track_number].location.chomp)
		@song.play(false)
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		draw_quad(0, 0, TOP_COLOR, 810, 0, TOP_COLOR, 810, 600, BOTTOM_COLOR, 0, 600, BOTTOM_COLOR, ZOrder::BACKGROUND)
		draw_albums(@albums)
		@track_font.draw_text("Now playing:", 545, 475, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end

# Not used? Everything depends on mouse actions.

	def update
	end

 # Draws the album images and the track list for the selected album


	def draw
		# Complete the missing code
		draw_background
		display_tracks(@album_id)
		if Gosu::Song.current_song == nil
			@track_font.draw_text("NOTHING", 545, 500, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
		else
			display_track(@albums[@album_selected].tracks[@track_selected].name, 500)
		end
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# What should happen here?
			action = area_clicked(mouse_x, mouse_y)
			case action
			when 0..3
				@album_id = action
			when 4..18
				if @album_selected != @album_id
					@album_selected = @album_id
				end
				
				if action - 3 <= @albums[@album_id].tracks.length
					@track_selected = action - 4
					playTrack(@track_selected, @album_selected)
				end
			else
				puts("non-interactive")
			end
	    end
	end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
