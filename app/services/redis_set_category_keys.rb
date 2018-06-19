class RedisSetCategoryKeys
	
	def initialize()
	end
	
	def set_category_keys()
		Category.news.active do |category|
			
			#recent
			recents = category.articles.active_source.
                        includes(:source, :categories, :states).order("created_at DESC")
            $redis.set("#{category.name.downcase}_recent_articles", Marshal.dump(recents))
			
			#most views
			mostviews = category.articles.active_source.
                        includes(:source, :categories, :states).order("num_views DESC")
            $redis.set("#{category.name.downcase}_mostview_articles", Marshal.dump(mostviews))
		end
	end
end