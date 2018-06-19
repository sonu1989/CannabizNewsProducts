class RedisSetStateKeys
	
	# have to set state news
	# have to set state dispensaries
	# have to set state vendors
	
	
	def initialize()
	end
	
	def set_state_keys()
		State.all.each do |state|
			
			
			if state.product_state
				
				#set state vendors
				vendors = state.vendors.order("RANDOM()")
				$redis.set("#{state.name.downcase}_vendors", Marshal.dump(vendors))
				
				#set state dispensaries
				dispensaries = state.dispensaries.order("RANDOM()")
                $redis.set("#{state.name.downcase}_dispensaries", Marshal.dump(dispensaries))
            
            	#state products? - maybe for product index?
			end
			
			#state articles for all states
			
			#recent
			recents = state.articles.active_source.
                        includes(:source, :categories, :states).order("created_at DESC")
            $redis.set("#{state.name.downcase}_recent_articles", Marshal.dump(recents))
			
			#most views
			mostviews = state.articles.active_source.
                        includes(:source, :categories, :states).order("num_views DESC")
            $redis.set("#{state.name.downcase}_mostview_articles", Marshal.dump(mostviews))
		
		end
	end
end