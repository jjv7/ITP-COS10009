require './input_functions'

# It is suggested that you put together code from your 
# previous tasks to start this. eg:
# 8.1T Read Album with Tracks

module Genre
    POP, CLASSIC, JAZZ, ROCK = 1..4
end


$genre_names = ["Null", "Pop", "Classic", "Jazz", "Rock"]


class Album
    attr_accessor :id, :title, :date, :artist, :genre, :tracks

    def initialize(id, title, date, artist, genre, tracks)
        @id = id
        @title = title
        @date = date
        @artist = artist
        @genre = genre
        @tracks = tracks
    end
end


class Track
    attr_accessor :name, :location

    def initialize(name, location)
        @name = name
        @location = location
    end
end


def read_track(albums_file)
    track_name = albums_file.gets()
    track_location = albums_file.gets()
    track = Track.new(track_name, track_location)
    return track
end


def read_tracks(albums_file)
    tracks_count = albums_file.gets().to_i
    tracks = Array.new()

    i = 0
    while (i < tracks_count)
        track = read_track(albums_file)
        tracks << track
        i += 1
    end

    return tracks
end




def read_album(albums_file, index)
    album_id = index
    album_artist = albums_file.gets()
    album_title = albums_file.gets()
    album_date = albums_file.gets()
    album_genre = albums_file.gets()
    tracks = read_tracks(albums_file)
    album = Album.new(album_id, album_title, album_date, album_artist, album_genre, tracks)
    return album
end


def read_albums(albums_file)
    albums_count = albums_file.gets().to_i
    albums = Array.new()
    
    i = 0
    while (i < albums_count)
        index = i + 1
        album = read_album(albums_file, index)
        albums << album
        i += 1
    end
    return albums
end


def read_albums_from_file()
    file_name = read_string("Please enter the file name:")
    begin
        albums_file = File.new(file_name, "r")
        albums = read_albums(albums_file)
        albums_file.close
        puts("Albums have been read!")
        sleep(2)
    rescue SystemCallError
        puts("File does not exist")
        sleep(2)
    end
    return albums
end


def print_tracks(tracks)
    count = tracks.length
    i = 0
    while (i < tracks.length)
        index = i + 1
        puts("Track #{index}. " + tracks[i].name)
        i += 1
    end
 
end



def print_album(album)
    puts("-----------------------")
    puts("Album ##{album.id.to_s}")
    puts("Title: " + album.title)
    puts("Artist: " + album.artist)
    puts("Release date: " + album.date)
    puts("Genre: " + $genre_names[album.genre.to_i])
    puts("Tracks:")
    print_tracks(album.tracks)
    puts("-----------------------")
end



def display_albums_all(albums)
    begin
        count = albums.length.to_i
        i = 0
        while (i < count)
            print_album(albums[i])
            i += 1
        end
    
    rescue NoMethodError
        puts("Please read in albums first")
        sleep(2)
    end
end


def search_for_genre(album, genre)
    index = -1
    if (album.genre.to_i == genre)
        index = album.id
    end
    return index
end



def display_albums_genre(albums, genre)
    begin
        count = albums.length
        albums_found = false
        i = 0
        while (i < count)
            index = search_for_genre(albums[i], genre)
            if (index > -1)
                print_album(albums[i])
                albums_found = true
            end
            i += 1
        end

        if (!albums_found)
            puts("No #{$genre_names[genre]} albums found")
        end
    rescue NoMethodError
        puts("Please read in albums first")
        sleep(2)
    end
end


def display_albums_genre_select(albums)
    puts("Genres:")
    i = 1
    count = $genre_names.length
    while (i < count)
        puts("#{i}. #{$genre_names[i]}")
        i += 1
    end
    choice = read_integer_in_range("Please enter your choice:", 1, $genre_names.length - 1)
    display_albums_genre(albums, choice)
end



def display_albums(albums)
    finished = false
    while (!finished)
        puts("Display Albums Menu:")
        puts("1. Display All Albums")
        puts("2. Display Albums by Genre")
        puts("3. Return to Main Menu")
        choice = read_integer_in_range("Please enter your choice:", 1, 3)
        case choice
        when 1
            display_albums_all(albums)
        when 2
            display_albums_genre_select(albums)
        when 3
            finished = true
        else
            puts("Please select again")
        end 
    end
end


def check_length(tracks)
    length = tracks.length
    return length
end


def play_track(track, album_title)
    puts("Playing track #{track.name.chomp} from album #{album_title}")
    sleep(5)
    puts("END OF TRACK")
    sleep(2)
end


def track_select(album)
    length = check_length(album.tracks)
    if (length == 0)
        puts("No tracks found in album")
        sleep(2)
        return
    else
        print_tracks(album.tracks)
    end
    choice = read_integer_in_range("Please select a track to play:", 1, length)
    play_track(album.tracks[choice-1], album.title)
end


def play_track_select(albums)
    begin
        number = albums.length
        choice = read_integer_in_range("Please enter the album number:", 1, number)
        track_select(albums[choice-1])
    rescue NoMethodError
        puts("Please read in albums first")
        sleep(2)
    end
end



def main()
    finished = false
    while (!finished)
        puts ("Main Menu:")
        puts ("1. Read in Albums")
        puts ("2. Display Albums")
        puts ("3. Select an Album to play")
        puts ("5. Exit the application")
        choice = read_integer_in_range("Please enter your choice:", 1, 5)
        case choice
        when 1
            albums = read_albums_from_file()
        when 2
            display_albums(albums)
        when 3
            play_track_select(albums)
        when 5
            finished = true   
        else
            puts("Please select again")
        end
    end
end

main
