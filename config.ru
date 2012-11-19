require 'pathname'

$root   = Pathname.new(::File.dirname(__FILE__))
$source = $root.join("source")
$site   = $root.join("site")

class Indexer
  def initialize(app)
    @app = app
  end

  def call(env)
    slash_at_the_end = %r{/$}
    @app.call(env.merge("PATH_INFO" => env.fetch("PATH_INFO").sub(slash_at_the_end, "/index.html")))
  end
end

class Rebuilder
  def initialize(app)
    @app = app
  end

  def call(env)
    if latest_modification_time_in($source) > latest_modification_time_in($site)
      system("cd #{$root}; jekyll")
    end

    @app.call(env)
  end

  private

  # This isn't safe for user-given values of directory.
  def latest_modification_time_in(directory)
    %x{find #{directory} -print0 | xargs -0 stat -f %m | sort -r | head -n1}.to_i
  end
end

use Indexer
use Rebuilder
run Rack::File.new($site)
