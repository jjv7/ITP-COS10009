require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    super(640, 400, false)
  end

  def draw
    # see www.rubydoc.info/github/gosu/gosu/Gosu/Color for colours
    
    # Draw base of boat
    draw_quad(100, 225, Gosu::Color::rgb(102, 51, 0), 540, 225, Gosu::Color::rgb(102, 51, 0), 120, 275, Gosu::Color::rgb(102, 51, 0), 520, 275, Gosu::Color::rgb(102, 51, 0), ZOrder::MIDDLE) # Draws base
    Gosu.draw_rect(305, 50, 30, 175, Gosu::Color::rgb(204, 102, 0), ZOrder::MIDDLE, mode=:default) # Draws flagpost
    draw_triangle(335, 50, Gosu::Color::WHITE, 490, 200, Gosu::Color::WHITE, 335, 200, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default) # Draws flag
    draw_line(110, 250, Gosu::Color::BLACK, 530, 250, Gosu::Color::BLACK, ZOrder::TOP, mode=:default) # Draws line on boat

    # Draw sea
    draw_quad(0, 250, Gosu::Color::BLUE, 640, 250, Gosu::Color::rgb(204, 229, 255), 0, 400, Gosu::Color::rgb(0, 0, 153), 640, 400, Gosu::Color::BLUE, ZOrder::BACKGROUND)
    
    # Draw sky
    Gosu.draw_rect(0, 0, 640, 250, Gosu::Color::AQUA, ZOrder::BACKGROUND, mode=:default)

    # Circle parameter - Radius
    # Image draw parameters - x, y, z, horizontal scale (use for ovals), vertical scale (use for ovals), colour
    # Colour - use Gosu::Image::{Colour name} or .rgb({red},{green},{blue}) or .rgba({alpha}{red},{green},{blue},)
    # Note - alpha is used for transparency.
    
    # Draws Sun
    img3 = Gosu::Image.new(Circle.new(30))
    img3.draw(550, 30, ZOrder::TOP, 1.0, 1.0, Gosu::Color::YELLOW)

  end
end

DemoWindow.new.show

