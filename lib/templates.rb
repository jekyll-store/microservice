require 'erubis'
require 'tilt'
require 'roadie'

module Templates
  class << self
    def render(template, *args)
      send(template).render(*args)
    end

    def html_render(template, *args)
      html = layout.render { send(template).render(*args) }
      Roadie::Document.new(html).transform
    end

    private

    def template_file(name)
      File.expand_path("../templates/#{name}.erb", __FILE__)
    end

    def template(name)
      Tilt::ErubisTemplate.new(template_file(name))
    end

    def record
      @record ||= template('record.txt')
    end

    def layout
      @layout ||= template('layout.html')
    end

    def confirm
      @confirm ||= template('confirm.html')
    end

    def error
      @error ||= template('error.txt')
    end
  end
end
