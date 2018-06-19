class RedisCategoryWorker
    include Sidekiq::Worker
    
    def perform()
        logger.info "Redis Category Worker is Running"
        setCategoryKeys()
    end    
    
    def setCategoryKeys()
        RedisSetCategoryKeys.set_category_keys()
    end  
end