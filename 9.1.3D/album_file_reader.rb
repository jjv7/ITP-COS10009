class Album
    attr_accessor :id, :title, :artist, :art, :tracks

    def initialize(id, title, artist, art, tracks)
        @id = id
        @title = title
        @artist = artist
		@art = art
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

def read_track(file)
    track_name = file.gets()
    track_location = file.gets()
    track = Track.new(track_name, track_location)
    return track
end

def read_tracks(file)
    tracks_count = file.gets().to_i
    tracks = Array.new()
    i = 0
    while (i < tracks_count)
        track = read_track(file)
        tracks << track
        i += 1
    end
    return tracks
end

def read_album(file, index)
    album_id = index
    album_title = file.gets()
    album_artist = file.gets()
    album_art = file.gets().chomp
    tracks = read_tracks(file)
    album = Album.new(album_id, album_title, album_artist, album_art, tracks)
    return album
end

def read_albums(file)
    albums_count = file.gets().to_i
    albums = Array.new()
    i = 0
    while i < albums_count
        index = i + 1
        album = read_album(file, index)
        albums << album
        i += 1
    end
    return albums
end