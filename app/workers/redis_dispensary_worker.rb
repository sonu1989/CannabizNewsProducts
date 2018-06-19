class RedisDispensaryWorker
    include Sidekiq::Worker
    
    def perform()
        logger.info "Redis Dispensary Worker is Running"
        setDispensaryKeys()
    end    
    
    def setDispensaryKeys()
        RedisSetDispensaryKeys.set_dispensary_keys()
    end  
end