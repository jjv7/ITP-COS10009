# put your code here:
class Track
    attr_accessor :name, :location

    def initialize(n, l)
        @name = n
        @location = l
    end
end

def read_track(a_file)
    track_name = a_file.gets()
    track_location = a_file.gets()
    track = Track.new(track_name, track_location)
    return track
end

def print_track(track)
    puts("Track name: " + track.name)
    puts("Track location: " + track.location)
end

def main()
    a_file = File.new("track.txt", "r")
    track = read_track(a_file)
    a_file.close
    print_track(track)
end

main() if __FILE__ == $0 # leave this 
