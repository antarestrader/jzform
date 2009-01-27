# run very flat apps with merb -I <app file>.

require "../lib/jzform"

# Uncomment for DataMapper ORM
# use_orm :datamapper

# Uncomment for ActiveRecord ORM
# use_orm :activerecord

# Uncomment for Sequel ORM
# use_orm :sequel


#
# ==== Pick what you test with
#

# This defines which test framework the generators will use.
# RSpec is turned on by default.
#
# To use Test::Unit, you need to install the merb_test_unit gem.
# To use RSpec, you don't have to install any additional gems, since
# merb-core provides support for RSpec.
#
# use_test :test_unit
use_test :rspec

#
# ==== Choose which template engine to use by default
#

# Merb can generate views for different template engines, choose your favourite as the default.

use_template_engine :erb
# use_template_engine :haml

Merb::Config.use { |c|
  c[:framework]           = { :public => [Merb.root / "public", nil] }
  c[:session_store]       = 'none'
  c[:exception_details]   = true
	c[:log_level]           = :debug # or error, warn, info or fatal
  #c[:log_stream]          = STDOUT
  # or use file for loggine:
   c[:log_file]          = Merb.root /  "merb.log"

	c[:reload_classes]   = true
	c[:reload_templates] = true
}



Merb::Router.prepare do
  match('/', :method=>:get).to(:controller => 'form_test', :action =>'index')
  match('/', :method=>:post).to(:controller => 'form_test', :action =>'test')
end

class FormTest < Merb::Controller
  def index
    "<html><head><title>Get Responce</title></head><body><h1>params</h1><pre>\n\n#{params.to_yaml}</pre>#{form.to_html}</body></html>"
  end

  def test
    ret = "<html><head><title>Post Responce</title></head><body><h1>params</h1><pre>#{params.to_yaml}</pre></body></html>"
  end

  def form
    form_1
  end

  def form_2
    f =JZForm.new({
      :name=>'registration',
      :title=>'New User Registration',
      :description=>'Use this form to create a new user',
      :instructions=>'Enter your user information into the fields provided',
    }) << :string << :integer
  end

  def form_1
    f =JZForm.new({
      :name=>'registration',
      :title=>'New User Registration',
      :description=>'Use this form to create a new user',
      :instructions=>'Enter your user information into the fields provided',
    })
    f.add_field([{:name=>:string}, {:quest=>:string}, {'favorite_color'=>['Blue','No, Yellooooww...']}])
    f
  end
end

