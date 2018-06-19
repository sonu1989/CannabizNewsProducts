class RedisSetSourceKeys
	
	def initialize()
	end
	
	def set_category_keys()
		Source.where(:active => true).order("name ASC").each do |source|
			
			#recent
			source = source.articles.active_source.
                        includes(:source, :categories, :states).order("created_at DESC")
            $redis.set("#{source.name.downcase}_recent_articles", Marshal.dump(recents))
			
			#most views
			mostviews = source.articles.active_source.
                        includes(:source, :categories, :states).order("num_views DESC")
            $redis.set("#{source.name.downcase}_mostview_articles", Marshal.dump(mostviews))
		end
	end
end