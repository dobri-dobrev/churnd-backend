#!/usr/bin/env ruby
require 'sinatra/base'

class User < Sinatra::Base
	#initialize user, options are for additional info we have about him/her
	def initialize(parentId, name, email, options = {})  
	    puts parentId
		
	end 
	
end
