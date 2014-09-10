require 'compass-h5bp'
require 'html5-boilerplate'
# Require any additional compass plugins here.
require 'susy'

# Set this to the root of your project when deployed:
environment = :product
firesass = false
project_type = :stand_alone
http_path = "/"
sass_dir = "sass"
# extensions_dir  = "sass-extensions"
css_dir = "../htdocs/assets/stylesheets"
images_dir = "../htdocs/assets/images"
javascripts_dir = "../htdocs/assets/javascripts"
fonts_dir = "../htdocs/assets/fonts"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style = (environment == :development) ? :expanded : :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
sass_options = (environment == :development && firesass == true) ? {:debug_info => true} : {}